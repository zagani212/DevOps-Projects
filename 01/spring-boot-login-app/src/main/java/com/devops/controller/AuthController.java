package com.devops.controller;

import com.devops.entity.User;
import com.devops.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/auth")
public class AuthController {
	@Autowired
	private UserService userService;

	@GetMapping("/login")
	public String showLoginPage() {
		return "login";
	}

	@GetMapping("/register")
	public String showRegisterPage() {
		return "register";
	}

	@PostMapping("/register")
	public String registerUser(@RequestParam String username, @RequestParam String password,
			@RequestParam String firstName, @RequestParam String lastName,
			@RequestParam String email, Model model) {
		try {
			User user = new User(username, password, firstName, lastName, email);
			userService.registerUser(user);
			model.addAttribute("message", "Registration successful! Please login.");
			return "redirect:/auth/login";
		} catch (Exception e) {
			model.addAttribute("error", e.getMessage());
			return "register";
		}
	}
}
