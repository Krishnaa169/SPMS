package com.spms.dao;

import com.spms.model.User;
import java.util.List;

public interface UserDAO {
    User findByEmail(String email);
    User findById(Long id);
    void save(User user);
    List<User> findAll();
    long count();
}
