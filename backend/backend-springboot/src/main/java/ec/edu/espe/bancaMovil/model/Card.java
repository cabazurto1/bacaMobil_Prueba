package ec.edu.espe.bancaMovil.model;

import jakarta.persistence.*;

@Entity
@Table(name = "cards")
public class Card {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId; 
    private String cardNumber;
    private boolean isFrozen;
    private String expirationDate; 
    private String cardType;      

    // Getters y Setters
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public boolean isFrozen() {
        return isFrozen;
    }

    public void setFrozen(boolean frozen) {
        isFrozen = frozen;
    }

    public String getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(String expirationDate) {
        this.expirationDate = expirationDate;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    // Constructores
    public Card(Long userId, String cardNumber, boolean isFrozen, String expirationDate, String cardType) {
        this.userId = userId;
        this.cardNumber = cardNumber;
        this.isFrozen = isFrozen;
        this.expirationDate = expirationDate;
        this.cardType = cardType;
    }

    public Card() {
    }
}
