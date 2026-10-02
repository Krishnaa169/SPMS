package com.spms.dao;

import com.spms.model.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UserDAOImpl implements UserDAO {

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public User findByEmail(String email) {
        Query<User> query = getSession().createQuery("FROM User WHERE email = :email", User.class);
        query.setParameter("email", email);
        return query.uniqueResultOptional().orElse(null);
    }

    @Override
    public User findById(Long id) {
        return getSession().get(User.class, id);
    }

    @Override
    public void save(User user) {
        getSession().saveOrUpdate(user);
    }

    @Override
    public List<User> findAll() {
        return getSession().createQuery("FROM User", User.class).list();
    }

    @Override
    public long count() {
        Query<Long> query = getSession().createQuery("SELECT COUNT(u.id) FROM User u", Long.class);
        Long count = query.uniqueResult();
        return count != null ? count : 0L;
    }
}
