/**
 * 
 */
package com.unir.jwt.service;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.unir.jwt.dto.AuthRequest;
import com.unir.jwt.dto.AuthResponse;
import com.unir.jwt.model.Role;
import com.unir.jwt.model.User;
import com.unir.jwt.repository.UserRepository;
import com.unir.jwt.security.JwtService;

@Service
public class AuthService {

    private final UserRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    
 // Constructor manual para Inyección de Dependencias
    public AuthService(
            UserRepository repository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            AuthenticationManager authenticationManager
    ) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
    }

    public AuthResponse register(AuthRequest request) {
        // Sustituimos el Builder por el constructor manual
        User user = new User(
                request.email(),
                passwordEncoder.encode(request.password()),
                Role.ROLE_USER // Asegúrate que en tu Enum sea USER o ROLE_USER
        );

        repository.save(user); // Este error debería irse si el import de UserRepository es correcto
        
        String jwtToken = jwtService.generateToken(user);
        return new AuthResponse(jwtToken);
    }

    public AuthResponse authenticate(AuthRequest request) {
        // Esto valida automáticamente el email y password contra la DB
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );
        var user = repository.findByEmail(request.email()).orElseThrow();
        var jwtToken = jwtService.generateToken(user);
        return new AuthResponse(jwtToken);
    }
}
