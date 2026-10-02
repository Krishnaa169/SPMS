package com.spms;

import org.apache.catalina.Context;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;
import org.apache.tomcat.util.scan.StandardJarScanner;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

public class Main {

    public static void main(String[] args) throws Exception {
        int port = 8080;
        String portEnv = System.getenv("PORT");
        if (portEnv != null && !portEnv.trim().isEmpty()) {
            try {
                port = Integer.parseInt(portEnv.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        File baseDir = new File("target/tomcat-embed");
        if (!baseDir.exists()) {
            baseDir.mkdirs();
        }

        File uploadsDir = new File("uploads");
        if (!uploadsDir.exists()) {
            uploadsDir.mkdirs();
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.setBaseDir(baseDir.getAbsolutePath());
        tomcat.setHostname("0.0.0.0");
        tomcat.getConnector().setProperty("address", "0.0.0.0");

        File webappDir = new File("src/main/webapp");
        if (!webappDir.exists() || !new File(webappDir, "WEB-INF").exists()) {
            File alt = new File("target/SPMS");
            if (alt.exists()) {
                webappDir = alt;
            } else {
                alt = new File("SPMS/src/main/webapp");
                if (alt.exists()) {
                    webappDir = alt;
                } else {
                    webappDir.mkdirs();
                }
            }
        }

        // Mount SPMS web application at /SPMS
        StandardContext spmsCtx = (StandardContext) tomcat.addWebapp("/SPMS", webappDir.getAbsolutePath());
        spmsCtx.setParentClassLoader(Main.class.getClassLoader());

        // Delegate to parent class loader first so classes and drivers on Main's classpath are loaded directly
        spmsCtx.setDelegate(true);

        // Suppress NoSuchFileException warnings by preventing scanner from following invalid manifest Class-Path entries
        if (spmsCtx.getJarScanner() instanceof StandardJarScanner) {
            StandardJarScanner scanner = (StandardJarScanner) spmsCtx.getJarScanner();
            scanner.setScanManifest(false);
        }

        // Add pre-resources for compiled classes (works with Maven target/classes or IDE target/classes)
        File classesDir = new File("target/classes");
        try {
            File codeSourceDir = new File(Main.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            if (codeSourceDir.exists() && codeSourceDir.isDirectory()) {
                classesDir = codeSourceDir;
            }
        } catch (Exception ignored) {
        }

        if (classesDir.exists()) {
            WebResourceRoot resources = new StandardRoot(spmsCtx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    classesDir.getAbsolutePath(), "/"));
            spmsCtx.setResources(resources);
        }

        // Dynamically register H2 Web Console if H2 is present on runtime classpath
        try {
            Class<?> webServletClass = Class.forName("org.h2.server.web.WebServlet");
            Servlet h2Servlet = (Servlet) webServletClass.getDeclaredConstructor().newInstance();
            Tomcat.addServlet(spmsCtx, "h2ConsoleServlet", h2Servlet);
            spmsCtx.addServletMappingDecoded("/h2-console/*", "h2ConsoleServlet");
        } catch (Throwable ignored) {
        }

        // Add root redirector context so http://localhost:8080/ redirects to /SPMS/login
        Context rootCtx = tomcat.addContext("", baseDir.getAbsolutePath());
        rootCtx.setParentClassLoader(Main.class.getClassLoader());
        Tomcat.addServlet(rootCtx, "rootRedirectServlet", new HttpServlet() {
            @Override
            protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                resp.sendRedirect("/SPMS/login");
            }
        });
        rootCtx.addServletMappingDecoded("/*", "rootRedirectServlet");

        System.out.println("============================================================================");
        System.out.println("   Student Project Management System (SPMS) Server Starting...");
        System.out.println("----------------------------------------------------------------------------");
        System.out.println("   Web Portal URL:        http://localhost:" + port + "/SPMS/login");
        System.out.println("   Root Shortcut URL:     http://localhost:" + port + "/");
        System.out.println("   H2 Database Console:   http://localhost:" + port + "/SPMS/h2-console");
        System.out.println("----------------------------------------------------------------------------");
        System.out.println("   Pre-seeded Login Accounts:");
        System.out.println("     1) Teacher / Evaluator:  admin@spms.com   (Password: admin123)");
        System.out.println("     2) Student Account:      student@spms.com (Password: student123)");
        System.out.println("============================================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
