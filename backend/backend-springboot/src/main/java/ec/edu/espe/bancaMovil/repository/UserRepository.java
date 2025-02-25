package ec.edu.espe.bancaMovil.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ec.edu.espe.bancaMovil.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByCorreo(String correo); // Método para buscar por correo
}