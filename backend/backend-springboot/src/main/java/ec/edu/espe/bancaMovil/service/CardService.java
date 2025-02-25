package ec.edu.espe.bancaMovil.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ec.edu.espe.bancaMovil.model.Card;
import ec.edu.espe.bancaMovil.repository.CardRepository;
import java.util.List;
@Service
public class CardService {
    @Autowired
    private CardRepository cardRepository;

    // Agregar una nueva tarjeta
    public Card addCard(Card card) {
        return cardRepository.save(card);
    }

    // Congelar o descongelar una tarjeta
    public void freezeCard(Long cardId, boolean isFrozen) {
        Card card = cardRepository.findById(cardId).orElseThrow(() -> new RuntimeException("Tarjeta no encontrada"));
        card.setFrozen(isFrozen);
        cardRepository.save(card);
    }

    // Eliminar una tarjeta
    public void deleteCard(Long cardId) {
        cardRepository.deleteById(cardId);
    }

    // Obtener todas las tarjetas de un usuario
    public List<Card> getCardsByUser(Long userId) {
        return cardRepository.findByUserId(userId);
    }
    // Obtener usuario por id
    public Card getCardById(Long id) {
        return cardRepository.findById(id).orElseThrow(() -> new RuntimeException("Tarjeta no encontrada"));
    }
}
