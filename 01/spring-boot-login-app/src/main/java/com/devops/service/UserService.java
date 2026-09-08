package com.devops.service;

import com.devops.entity.User;
import com.devops.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
	@Autowired
	private UserRepository userRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	public User registerUser(User user) {
		if (userRepository.findByUsername(user.getUsername()) != null) {
			throw new RuntimeException("Username already exists!");
		}
		if (userRepository.findByEmail(user.getEmail()) != null) {
			throw new RuntimeException("Email already exists!");
		}
		user.setPassword(passwordEncoder.encode(user.getPassword()));
		return userRepository.save(user);
	}

	public User loginUser(String username, String password) {
		User user = userRepository.findByUsername(username);
		if (user != null && passwordEncoder.matches(password, user.getPassword())) {
			return user;
		}
		return null;
	}

	public User getUserByUsername(String username) {
		return userRepository.findByUsername(username);
	}
}
