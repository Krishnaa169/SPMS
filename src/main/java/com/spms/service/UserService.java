package com.spms.service;

import com.spms.model.User;
import java.util.List;

public interface UserService {
    User findByEmail(String email);
    User findById(Long id);
    void save(User user);
    User authenticate(String email, String password);
    void seedInitialUsersIfEmpty();
    List<User> findAll();
}
