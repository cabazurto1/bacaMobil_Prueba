package ec.edu.espe.bancaMovil;

import ec.edu.espe.bancaMovil.model.User;
import ec.edu.espe.bancaMovil.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import ec.edu.espe.bancaMovil.controller.UserController;

public class UserControllerTest {

    private MockMvc mockMvc;

    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(userController).build();
    }

    @Test
    public void testRegisterUser() throws Exception {
        User user = new User("John Doe", "johndoe@example.com", "password123", 1000.0);
        when(userService.registerUser(any(User.class))).thenReturn(user);

        mockMvc.perform(post("/api/users/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"nombre\":\"John Doe\",\"correo\":\"johndoe@example.com\",\"password\":\"password123\",\"saldoDisponible\":1000.0}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nombre").value("John Doe"))
                .andExpect(jsonPath("$.correo").value("johndoe@example.com"))
                .andExpect(jsonPath("$.saldoDisponible").value(1000.0));
    }

    @Test
    public void testLoginUserValid() throws Exception {
        User user = new User("John Doe", "johndoe@example.com", "password123", 1000.0);
        when(userService.loginUser("johndoe@example.com", "password123")).thenReturn(user);

        mockMvc.perform(post("/api/users/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"correo\":\"johndoe@example.com\",\"password\":\"password123\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nombre").value("John Doe"))
                .andExpect(jsonPath("$.correo").value("johndoe@example.com"))
                .andExpect(jsonPath("$.saldoDisponible").value(1000.0));
    }

    @Test
    public void testLoginUserInvalid() throws Exception {
        when(userService.loginUser("johndoe@example.com", "wrongpassword")).thenReturn(null);

        mockMvc.perform(post("/api/users/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"correo\":\"johndoe@example.com\",\"password\":\"wrongpassword\"}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    public void testGetUserById() throws Exception {
        User user = new User("John Doe", "johndoe@example.com", "password123", 1000.0);
        when(userService.getUserById(1L)).thenReturn(user);

        mockMvc.perform(get("/api/users/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nombre").value("John Doe"))
                .andExpect(jsonPath("$.correo").value("johndoe@example.com"))
                .andExpect(jsonPath("$.saldoDisponible").value(1000.0));
    }

    @Test
    public void testUpdateUser() throws Exception {
        User updatedUser = new User("John Doe Updated", "johndoe@example.com", "newpassword123", 1500.0);
        when(userService.updateUser(1L, updatedUser)).thenReturn(updatedUser);

        mockMvc.perform(put("/api/users/3")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"correo\":\"johndoe@example.com\",\"nombre\":\"John Doe Updated\",\"password\":\"newpassword123\",\"saldoDisponible\":1500.0}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.correo").value("johndoe@example.com"))
                .andExpect(jsonPath("$.nombre").value("John Doe Updated"))
                .andExpect(jsonPath("$.saldoDisponible").value(1500.0));
    }

    @Test
    public void testDeleteUser() throws Exception {
        doNothing().when(userService).deleteUser(1L);

        mockMvc.perform(delete("/api/users/1"))
                .andExpect(status().isOk());
    }
}