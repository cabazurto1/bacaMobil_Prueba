import pytest
from flask import Flask
from flask_pymongo import PyMongo
from bson import ObjectId
import bcrypt

# Configuración de la aplicación Flask para pruebas
@pytest.fixture
def app():
    app = Flask(__name__)
    app.config["MONGO_URI"] = "mongodb+srv://oop:oop@cluster0.og4urrq.mongodb.net/bancaMovilTest"
    app.config['TESTING'] = True
    print("Using MongoDB URI:", app.config["MONGO_URI"])  # Verifica la URI de MongoDB
    mongo = PyMongo(app)

    # Colecciones de prueba
    app.db_notifications = mongo.db.notifications
    app.db_payments = mongo.db.payments
    app.db_transactions = mongo.db.transactions

    # Registra las rutas de la aplicación
    from backend import (
        get_notifications, mark_as_read, create_notification, update_notification, delete_notification,
        make_payment, get_payments, get_payment_by_id, update_payment, delete_payment,
        get_transactions, create_transaction, update_transaction, delete_transaction,
        download_transactions_pdf  # Importa la función para descargar el PDF
    )

    app.add_url_rule('/api/notifications', 'get_notifications', get_notifications, methods=['GET'])
    app.add_url_rule('/api/notifications/<notification_id>/mark-as-read', 'mark_as_read', mark_as_read, methods=['PUT'])
    app.add_url_rule('/api/notifications', 'create_notification', create_notification, methods=['POST'])
    app.add_url_rule('/api/notifications/<notification_id>', 'update_notification', update_notification, methods=['PUT'])
    app.add_url_rule('/api/notifications/<notification_id>', 'delete_notification', delete_notification, methods=['DELETE'])

    app.add_url_rule('/api/payments', 'make_payment', make_payment, methods=['POST'])
    app.add_url_rule('/api/payments', 'get_payments', get_payments, methods=['GET'])
    app.add_url_rule('/api/payments/<payment_id>', 'get_payment_by_id', get_payment_by_id, methods=['GET'])
    app.add_url_rule('/api/payments/<payment_id>', 'update_payment', update_payment, methods=['PUT'])
    app.add_url_rule('/api/payments/<payment_id>', 'delete_payment', delete_payment, methods=['DELETE'])

    app.add_url_rule('/api/transactions', 'get_transactions', get_transactions, methods=['GET'])
    app.add_url_rule('/api/transactions', 'create_transaction', create_transaction, methods=['POST'])
    app.add_url_rule('/api/transactions/<transaction_id>', 'update_transaction', update_transaction, methods=['PUT'])
    app.add_url_rule('/api/transactions/<transaction_id>', 'delete_transaction', delete_transaction, methods=['DELETE'])

    # Agrega la ruta para descargar el historial de transacciones en PDF
    app.add_url_rule('/api/transactions/download', 'download_transactions_pdf', download_transactions_pdf, methods=['GET'])

    yield app

    # Limpiar la base de datos después de las pruebas
    mongo.db.notifications.delete_many({})
    mongo.db.payments.delete_many({})
    mongo.db.transactions.delete_many({})

@pytest.fixture
def client(app):
    return app.test_client()


def test_get_transactions(client):
    # Crear un pago y una transacción asociada
    payment_data = {
        "userId": "user123",
        "amount": 100.0,
        "date": "2023-10-01",
        "type": "credit"
    }
    payment_response = client.post('/api/payments', json=payment_data)
    payment_id = payment_response.json["id"]

    # Obtener transacciones del pago
    response = client.get(f'/api/transactions?paymentId={payment_id}')
    assert response.status_code == 200
    assert isinstance(response.json, list)
    assert len(response.json) > 0
    # Comparar ObjectId con una cadena de texto
    assert str(response.json[0]["paymentId"]) == payment_id  # Convertir ObjectId a cadena

    
    
def test_download_transactions_pdf(client):
    # Crear una transacción de prueba
    transaction_data = {
        "userId": "user123",
        "amount": 100.0,
        "date": "2023-10-01",
        "status": "Success"
    }
    client.post('/api/transactions', json=transaction_data)

    # Descargar el PDF
    response = client.get('/api/transactions/download?userId=user123&startDate=2023-01-01&endDate=2025-02-19')
    assert response.status_code == 200
    assert response.headers["Content-Type"] == "application/pdf"
    assert "historial_transacciones.pdf" in response.headers["Content-Disposition"]

    # Verificar que el contenido del PDF no esté vacío (puedes verificar el tamaño)
    assert len(response.data) > 0  # El PDF debe tener datos

    # Si es necesario, también puedes guardar el PDF y verificar su contenido
    with open('test_historial_transacciones.pdf', 'wb') as f:
        f.write(response.data)


def test_create_notification(client):
    notification_data = {
        "userId": "user123",
        "message": "Nueva notificación",
        "read": False
    }
    response = client.post('/api/notifications', json=notification_data)
    assert response.status_code == 201
    assert "id" in response.json

def test_mark_notification_as_read(client):
    # Crear una notificación
    notification_data = {
        "userId": "user123",
        "message": "Nueva notificación",
        "read": False
    }
    create_response = client.post('/api/notifications', json=notification_data)
    notification_id = create_response.json["id"]

    # Marcar como leída
    response = client.put(f'/api/notifications/{notification_id}/mark-as-read')
    assert response.status_code == 200
    assert response.json["message"] == "Notificación marcada como leída"