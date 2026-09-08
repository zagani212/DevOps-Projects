package com.devops;

import com.devops.config.SecretsManagerConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LoginApplication {
	public static void main(String[] args) {
		SpringApplication app = new SpringApplication(LoginApplication.class);
		app.addInitializers(new SecretsManagerConfig());
		app.run(args);
	}
}
