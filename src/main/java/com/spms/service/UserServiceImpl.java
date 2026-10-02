package com.spms.service;

import com.spms.dao.UserDAO;
import com.spms.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDAO userDAO;

    @Override
    public User findByEmail(String email) {
        if (email == null) return null;
        return userDAO.findByEmail(email.trim().toLowerCase());
    }

    @Override
    public User findById(Long id) {
        return userDAO.findById(id);
    }

    @Override
    public void save(User user) {
        if (user.getEmail() != null) {
            user.setEmail(user.getEmail().trim().toLowerCase());
        }
        userDAO.save(user);
    }

    @Override
    public User authenticate(String email, String password) {
        if (email == null || password == null) {
            return null;
        }
        User user = findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    @Override
    public void seedInitialUsersIfEmpty() {
        if (userDAO.count() == 0) {
            User teacher = new User(
                    "Prof. A. K. Sharma",
                    "admin@spms.com",
                    "admin123",
                    "ROLE_TEACHER"
            );
            userDAO.save(teacher);

            User student = new User(
                    "Rahul Verma",
                    "student@spms.com",
                    "student123",
                    "ROLE_STUDENT"
            );
            userDAO.save(student);
        } else {
            // Ensure demo users exist even if count > 0
            if (userDAO.findByEmail("admin@spms.com") == null) {
                userDAO.save(new User(
                        "Prof. A. K. Sharma",
                        "admin@spms.com",
                        "admin123",
                        "ROLE_TEACHER"
                ));
            }
            if (userDAO.findByEmail("student@spms.com") == null) {
                userDAO.save(new User(
                        "Rahul Verma",
                        "student@spms.com",
                        "student123",
                        "ROLE_STUDENT"
                ));
            }
        }
    }

    @Override
    public List<User> findAll() {
        return userDAO.findAll();
    }
}
