package ec.edu.espe.bancaMovil;
import ec.edu.espe.bancaMovil.model.Card;
import ec.edu.espe.bancaMovil.service.CardService;
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
import ec.edu.espe.bancaMovil.controller.CardController;
public class CardControllerTest {

    private MockMvc mockMvc;

    @Mock
    private CardService cardService;

    @InjectMocks
    private CardController cardController;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(cardController).build();
    }

    @Test
    public void testAddCard() throws Exception {
        Card card = new Card(1L, "1234-5678-9012-3456", false, "12/25", "Visa");
        when(cardService.addCard(any(Card.class))).thenReturn(card);

        mockMvc.perform(post("/api/cards/")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"userId\":1,\"cardNumber\":\"1234-5678-9012-3456\",\"isFrozen\":false,\"expirationDate\":\"12/25\",\"cardType\":\"Visa\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.cardNumber").value("1234-5678-9012-3456"))
                .andExpect(jsonPath("$.expirationDate").value("12/25"))
                .andExpect(jsonPath("$.cardType").value("Visa"));
    }

    @Test
    public void testFreezeCard() throws Exception {
        doNothing().when(cardService).freezeCard(eq(1L), eq(true));

        mockMvc.perform(put("/api/cards/1/freeze")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("true"))
                .andExpect(status().isOk());

        verify(cardService, times(1)).freezeCard(eq(1L), eq(true));
    }

    @Test
    public void testGetCardsByUser() throws Exception {
        mockMvc.perform(get("/api/cards/user/1"))
                .andExpect(status().isOk());
    }
}