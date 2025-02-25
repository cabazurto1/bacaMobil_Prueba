package ec.edu.espe.bancaMovil.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import ec.edu.espe.bancaMovil.model.Card;
import ec.edu.espe.bancaMovil.service.CardService;
import java.util.List;
@RestController
@RequestMapping("/api/cards")
public class CardController {
    @Autowired
    private CardService cardService;

    // Agregar una tarjeta
    @PostMapping("/")
    public Card addCard(@RequestBody Card card) {
        return cardService.addCard(card);
    }

    // Congelar/Descongelar una tarjeta
    @PutMapping("/{cardId}/freeze")
    public void freezeCard(@PathVariable Long cardId, @RequestBody boolean isFrozen) {
        cardService.freezeCard(cardId, isFrozen);
    }

    // Eliminar una tarjeta
    @DeleteMapping("/{cardId}")
    public void deleteCard(@PathVariable Long cardId) {
        cardService.deleteCard(cardId);
    }

    // Obtener todas las tarjetas de un usuario
    @GetMapping("/user/{userId}")
    public List<Card> getCardsByUser(@PathVariable Long userId) {
        return cardService.getCardsByUser(userId);
    }

    // Obtener una tarjeta por Id
    @GetMapping("/{cardId}")
    public Card getCardById(@PathVariable Long id) {
        return cardService.getCardById(id);
    }
}
