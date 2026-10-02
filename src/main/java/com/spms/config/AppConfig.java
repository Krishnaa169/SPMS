package com.spms.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.hibernate5.HibernateTransactionManager;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import javax.sql.DataSource;
import java.io.File;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.Properties;
import java.util.logging.Logger;

@Configuration
@EnableWebMvc
@EnableTransactionManagement
@ComponentScan(basePackages = "com.spms")
public class AppConfig implements WebMvcConfigurer {

    private static final Logger LOGGER = Logger.getLogger(AppConfig.class.getName());

    public enum DatabaseType { ORACLE, MYSQL, H2 }
    private static DatabaseType detectedDbType = null;

    private static synchronized DatabaseType getDatabaseType() {
        if (detectedDbType != null) {
            return detectedDbType;
        }

        // Fast check with 400ms timeout
        if (isPortOpen("localhost", 1521, 400)) {
            detectedDbType = DatabaseType.ORACLE;
        } else if (isPortOpen("localhost", 3306, 400)) {
            detectedDbType = DatabaseType.MYSQL;
        } else {
            detectedDbType = DatabaseType.H2;
        }
        return detectedDbType;
    }

    private static boolean isPortOpen(String host, int port, int timeoutMs) {
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(host, port), timeoutMs);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        DatabaseType type = getDatabaseType();

        if (type == DatabaseType.ORACLE) {
            String url = System.getProperty("oracle.url", System.getenv().getOrDefault("ORACLE_URL", "jdbc:oracle:thin:@localhost:1521:xe"));
            String username = System.getProperty("oracle.user", System.getenv().getOrDefault("ORACLE_USER", "system"));
            String password = System.getProperty("oracle.password", System.getenv().getOrDefault("ORACLE_PASSWORD", "system"));

            LOGGER.info(">> Oracle Database Listener detected on port 1521. Connecting via Oracle JDBC Driver: " + url);
            dataSource.setDriverClassName("oracle.jdbc.OracleDriver");
            dataSource.setUrl(url);
            dataSource.setUsername(username);
            dataSource.setPassword(password);
        } else if (type == DatabaseType.MYSQL) {
            LOGGER.info(">> MySQL server detected on port 3306. Connecting to MySQL database...");
            dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
            dataSource.setUrl("jdbc:mysql://localhost:3306/spms_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true");
            dataSource.setUsername("root");
            dataSource.setPassword("root");
        } else {
            File dbDir = new File(System.getProperty("user.dir"), ".spms_db");
            String dbPath = dbDir.getAbsolutePath().replace("\\", "/");
            String h2Url = "jdbc:h2:file:" + dbPath + ";AUTO_SERVER=TRUE;DB_CLOSE_DELAY=-1;MODE=MySQL;DATABASE_TO_LOWER=TRUE";

            LOGGER.info(">> Neither Oracle (1521) nor MySQL (3306) detected. Using persistent file-based H2 Database.");
            LOGGER.info(">> Database file location: " + dbPath + ".mv.db");
            LOGGER.info(">> Database Console URL: http://localhost:8080/SPMS/h2-console");

            dataSource.setDriverClassName("org.h2.Driver");
            dataSource.setUrl(h2Url);
            dataSource.setUsername("sa");
            dataSource.setPassword("");
        }

        return dataSource;
    }

    @Bean
    public LocalSessionFactoryBean sessionFactory() {
        LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
        sessionFactory.setDataSource(dataSource());
        sessionFactory.setPackagesToScan("com.spms.model");

        Properties hibernateProperties = new Properties();
        DatabaseType type = getDatabaseType();

        if (type == DatabaseType.ORACLE) {
            hibernateProperties.put("hibernate.dialect", "org.hibernate.dialect.Oracle10gDialect");
        } else if (type == DatabaseType.MYSQL) {
            hibernateProperties.put("hibernate.dialect", "org.hibernate.dialect.MySQL8Dialect");
        } else {
            hibernateProperties.put("hibernate.dialect", "org.hibernate.dialect.H2Dialect");
        }

        hibernateProperties.put("hibernate.show_sql", "true");
        hibernateProperties.put("hibernate.format_sql", "true");
        hibernateProperties.put("hibernate.hbm2ddl.auto", "update");

        sessionFactory.setHibernateProperties(hibernateProperties);
        return sessionFactory;
    }

    @Bean
    public PlatformTransactionManager hibernateTransactionManager() {
        HibernateTransactionManager transactionManager = new HibernateTransactionManager();
        transactionManager.setSessionFactory(sessionFactory().getObject());
        return transactionManager;
    }

    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setViewClass(JstlView.class);
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");
        return viewResolver;
    }

    @Bean(name = "multipartResolver")
    public org.springframework.web.multipart.commons.CommonsMultipartResolver multipartResolver() {
        org.springframework.web.multipart.commons.CommonsMultipartResolver resolver =
                new org.springframework.web.multipart.commons.CommonsMultipartResolver();
        resolver.setMaxUploadSize(20 * 1024 * 1024); // 20 MB
        resolver.setMaxInMemorySize(1024 * 1024); // 1 MB
        resolver.setDefaultEncoding("UTF-8");
        return resolver;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + System.getProperty("user.dir").replace("\\", "/") + "/uploads/", "/uploads/");
    }
}
