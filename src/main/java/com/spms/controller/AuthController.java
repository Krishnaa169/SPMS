package com.spms.controller;

import com.spms.model.User;
import com.spms.service.UserService;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController implements InitializingBean {

    @Autowired
    private UserService userService;

    @Override
    public void afterPropertiesSet() {
        try {
            userService.seedInitialUsersIfEmpty();
        } catch (Exception ignored) {
            // In case database is not initialized at startup, will re-attempt on /login
        }
    }

    @GetMapping("/")
    public String root(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                return "redirect:/teacher/dashboard";
            } else {
                return "redirect:/student/dashboard";
            }
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginForm(@RequestParam(value = "error", required = false) String error,
                                @RequestParam(value = "logout", required = false) String logout,
                                @RequestParam(value = "registered", required = false) String registered,
                                HttpSession session,
                                Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            if ("ROLE_TEACHER".equals(currentUser.getRole())) {
                return "redirect:/teacher/dashboard";
            } else {
                return "redirect:/student/dashboard";
            }
        }

        try {
            userService.seedInitialUsersIfEmpty();
        } catch (Exception ignored) {
        }

        if (error != null) {
            model.addAttribute("errorMsg", "Invalid email or password. Please try again.");
        }
        if (logout != null) {
            model.addAttribute("infoMsg", "You have been successfully logged out.");
        }
        if (registered != null) {
            model.addAttribute("successMsg", "Registration successful! You can now sign in with your credentials.");
        }
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        HttpSession session,
                        Model model) {
        try {
            userService.seedInitialUsersIfEmpty();
        } catch (Exception ignored) {
        }

        String trimmedEmail = (email != null) ? email.trim() : "";
        User user = userService.findByEmail(trimmedEmail);

        if (user == null) {
            model.addAttribute("errorMsg", "Account not found for '" + trimmedEmail + "'. Please check the email, register below, or use the pre-seeded accounts: student@spms.com (student123) / admin@spms.com (admin123).");
            model.addAttribute("enteredEmail", trimmedEmail);
            return "login";
        }

        if (!user.getPassword().equals(password)) {
            model.addAttribute("errorMsg", "Incorrect password for '" + trimmedEmail + "'. Please try again.");
            model.addAttribute("enteredEmail", trimmedEmail);
            return "login";
        }

        session.setAttribute("currentUser", user);

        if ("ROLE_TEACHER".equalsIgnoreCase(user.getRole())) {
            return "redirect:/teacher/dashboard";
        } else {
            return "redirect:/student/dashboard";
        }
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            return "redirect:/";
        }
        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("user") User user,
                               @RequestParam(value = "role", defaultValue = "ROLE_STUDENT") String role,
                               Model model) {
        if (user.getName() == null || user.getName().trim().isEmpty() ||
            user.getEmail() == null || user.getEmail().trim().isEmpty() ||
            user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            model.addAttribute("errorMsg", "Please fill in all required fields.");
            model.addAttribute("user", user);
            return "register";
        }

        String email = user.getEmail().trim();
        if (userService.findByEmail(email) != null) {
            model.addAttribute("errorMsg", "An account with email '" + email + "' already exists. Please sign in instead.");
            model.addAttribute("user", user);
            return "register";
        }

        user.setName(user.getName().trim());
        user.setEmail(email);
        user.setPassword(user.getPassword());
        user.setRole("ROLE_TEACHER".equalsIgnoreCase(role) ? "ROLE_TEACHER" : "ROLE_STUDENT");

        userService.save(user);

        return "redirect:/login?registered=true";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login?logout=true";
    }
}
