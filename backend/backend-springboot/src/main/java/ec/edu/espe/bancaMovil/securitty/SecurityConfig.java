package ec.edu.espe.bancaMovil.securitty;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/users/login").permitAll() // Permitir acceso al login sin autenticación
                        .requestMatchers("/api/cards/").permitAll()
                        .anyRequest().permitAll() 
                )
                .csrf(csrf -> csrf.disable()) // Deshabilitar CSRF de forma correcta en Spring Security 6.x
                .build();
    }
}
