package ec.edu.espe.bancaMovil.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.crypto.password.PasswordEncoder;
import ec.edu.espe.bancaMovil.model.User;
import ec.edu.espe.bancaMovil.repository.UserRepository;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword())); // Encripta antes de guardar
        return userRepository.save(user);
    }

    public User loginUser(String correo, String password) {
        User user = userRepository.findByCorreo(correo);
        if (user != null && passwordEncoder.matches(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    // Obtener usuario por id
    public User getUserById(Long id) {
        return userRepository.findById(id).orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

    // Actualizar parcialmente el usuario
    public User updateUser(Long id, User updatedUser) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        // Verificar y actualizar cada campo si está presente
        if (updatedUser.getNombre() != null && !updatedUser.getNombre().isEmpty()) {
            user.setNombre(updatedUser.getNombre());
        }

        if (updatedUser.getCorreo() != null && !updatedUser.getCorreo().isEmpty()) {
            user.setCorreo(updatedUser.getCorreo());
        }

        if (updatedUser.getPassword() != null && !updatedUser.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(updatedUser.getPassword())); // Encriptar la nueva contraseña
        }

        if (updatedUser.getSaldoDisponible() >= 0) { // Validar que el saldo no sea negativo
            user.setSaldoDisponible(updatedUser.getSaldoDisponible());
        }

        return userRepository.save(user);
    }

    // Eliminar usuario
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
}