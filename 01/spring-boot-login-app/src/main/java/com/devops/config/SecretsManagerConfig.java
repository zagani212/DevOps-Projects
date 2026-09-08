package com.devops.config;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;

@Component
public class SecretsManagerConfig implements ApplicationContextInitializer<ConfigurableApplicationContext> {

	@Override
	public void initialize(ConfigurableApplicationContext applicationContext) {
		ConfigurableEnvironment env = applicationContext.getEnvironment();

		String secretName = env.getProperty("aws.secrets.name", "login-app-db-secret");
		String region = env.getProperty("aws.region", "eu-west-3");

		try {
			String secretValue = getSecretValue(secretName, region);
			if (secretValue != null) {
				parseAndSetEnvironmentProperties(env, secretValue);
				System.out.println("✓ Database credentials loaded from AWS Secrets Manager");
			} else {
				System.out.println("⚠ AWS Secrets Manager not available, using local properties");
			}
		} catch (Exception e) {
			System.out.println("⚠ Warning: Could not fetch from AWS Secrets Manager: " + e.getMessage());
			System.out.println("  Using credentials from application.properties");
		}
	}

	/**
	 * Fetches secret value from AWS Secrets Manager
	 */
	private String getSecretValue(String secretName, String region) {
		try (SecretsManagerClient client = SecretsManagerClient.builder()
				.region(software.amazon.awssdk.regions.Region.of(region))
				.build()) {

			GetSecretValueRequest request = GetSecretValueRequest.builder()
					.secretId(secretName)
					.build();

			GetSecretValueResponse response = client.getSecretValue(request);
			return response.secretString();
		} catch (Exception e) {
			System.out.println("Could not retrieve secret: " + e.getMessage());
			return null;
		}
	}

	/**
	 * Parses JSON secret and sets environment properties
	 */
	private void parseAndSetEnvironmentProperties(ConfigurableEnvironment env, String secretJson) {
		try {
			ObjectMapper mapper = new ObjectMapper();
			JsonNode root = mapper.readTree(secretJson);

			String username = getNodeValue(root, "username", "root");
			String password = getNodeValue(root, "password", "");
			String host = getNodeValue(root, "host", "localhost");
			String port = getNodeValue(root, "port", "3306");
			String dbname = getNodeValue(root, "dbname", "logindb");

			// Set environment properties (will override application.properties)
			String dataSourceUrl = String.format(
				"jdbc:mysql://%s:%s/%s?serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=true&serverSslMode=REQUIRED",
				host, port, dbname
			);

			System.setProperty("spring.datasource.url", dataSourceUrl);
			System.setProperty("spring.datasource.username", username);
			System.setProperty("spring.datasource.password", password);

		} catch (Exception e) {
			System.out.println("Error parsing secret JSON: " + e.getMessage());
		}
	}

	/**
	 * Helper method to safely get JSON node value
	 */
	private String getNodeValue(JsonNode root, String fieldName, String defaultValue) {
		try {
			JsonNode node = root.get(fieldName);
			if (node != null && !node.isNull()) {
				String value = node.asText();
				if (!value.isEmpty()) {
					return value;
				}
			}
		} catch (Exception e) {
			// Continue with default
		}
		return defaultValue;
	}
}
