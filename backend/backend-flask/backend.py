from flask import Flask, request, jsonify, send_file
from flask_pymongo import PyMongo
from flask_cors import CORS
from bson import ObjectId
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
import io

app = Flask(__name__)
CORS(app)

# Configura MongoDB Atlas
app.config["MONGO_URI"] = "mongodb+srv://oop:oop@cluster0.og4urrq.mongodb.net/bancaMovil"
mongo = PyMongo(app)

# Colecciones
db_notifications = mongo.db.notifications
db_payments = mongo.db.payments
db_transactions = mongo.db.transactions


# CRUD para notificaciones

# Obtener todas las notificaciones
@app.route('/api/notifications', methods=['GET'])
def get_notifications():
    user_id = request.args.get('userId')
    notifications = list(db_notifications.find({"userId": user_id}))
    for n in notifications:
        n["_id"] = str(n["_id"])
    return jsonify(notifications), 200

# Marcar una notificación como leída
@app.route('/api/notifications/<notification_id>/mark-as-read', methods=['PUT'])
def mark_as_read(notification_id):
    db_notifications.update_one({"_id": ObjectId(notification_id)}, {"$set": {"read": True}})
    return jsonify({"message": "Notificación marcada como leída"}), 200

# Crear una notificación
@app.route('/api/notifications', methods=['POST'])
def create_notification():
    data = request.json
    notification_id = db_notifications.insert_one(data).inserted_id
    return jsonify({"id": str(notification_id), "message": "Notificación creada"}), 201

# Actualizar una notificación (solo los campos enviados)
@app.route('/api/notifications/<notification_id>', methods=['PUT'])
def update_notification(notification_id):
    data = request.json
    # Solo actualizamos los campos que se envíen
    db_notifications.update_one({"_id": ObjectId(notification_id)}, {"$set": data})
    return jsonify({"message": "Notificación actualizada"}), 200

# Eliminar una notificación
@app.route('/api/notifications/<notification_id>', methods=['DELETE'])
def delete_notification(notification_id):
    db_notifications.delete_one({"_id": ObjectId(notification_id)})
    return jsonify({"message": "Notificación eliminada"}), 200


# CRUD para pagos

# Crear un pago
@app.route('/api/payments', methods=['POST'])
def make_payment():
    data = request.json
    payment_id = db_payments.insert_one(data).inserted_id
    # Crear una transacción asociada
    transaction = {
        "paymentId": ObjectId(payment_id),
        "userId": data.get("userId"),
        "amount": data.get("amount"),
        "status": "Success",  # Suponiendo que el pago es exitoso
        "date": data.get("date")
    }
    db_transactions.insert_one(transaction)
    return jsonify({"id": str(payment_id), "message": "Pago realizado y transacción registrada"}), 201

# Obtener pagos
@app.route('/api/payments', methods=['GET'])
def get_payments():
    user_id = request.args.get('userId')
    start_date = request.args.get('startDate')
    end_date = request.args.get('endDate')
    payment_type = request.args.get('type')
    
    query = {"userId": user_id}
    if start_date and end_date:
        query["date"] = {"$gte": start_date, "$lte": end_date}
    if payment_type:
        query["type"] = payment_type

    payments = list(db_payments.find(query))
    for p in payments:
        p["_id"] = str(p["_id"])
    return jsonify(payments), 200

# Obtener un pago por su ID
@app.route('/api/payments/<payment_id>', methods=['GET'])
def get_payment_by_id(payment_id):
    payment = db_payments.find_one({"_id": ObjectId(payment_id)})
    if payment:
        payment["_id"] = str(payment["_id"])
        return jsonify(payment), 200
    return jsonify({"message": "Pago no encontrado"}), 404

# Actualizar un pago (solo los campos enviados)
@app.route('/api/payments/<payment_id>', methods=['PUT'])
def update_payment(payment_id):
    data = request.json
    # Solo actualizamos los campos que se envíen
    db_payments.update_one({"_id": ObjectId(payment_id)}, {"$set": data})
    return jsonify({"message": "Pago actualizado"}), 200

# Eliminar un pago
@app.route('/api/payments/<payment_id>', methods=['DELETE'])
def delete_payment(payment_id):
    db_payments.delete_one({"_id": ObjectId(payment_id)})
    # Eliminar las transacciones asociadas
    db_transactions.delete_many({"paymentId": ObjectId(payment_id)})
    return jsonify({"message": "Pago y transacciones eliminadas"}), 200


# CRUD para transacciones

# Obtener transacciones de un pago
@app.route('/api/transactions', methods=['GET'])
def get_transactions():
    payment_id = request.args.get('paymentId')
    transactions = list(db_transactions.find({"paymentId": ObjectId(payment_id)}))
    for t in transactions:
        t["_id"] = str(t["_id"])
    return jsonify(transactions), 200

# Crear una transacción
@app.route('/api/transactions', methods=['POST'])
def create_transaction():
    data = request.json
    transaction_id = db_transactions.insert_one(data).inserted_id
    return jsonify({"id": str(transaction_id), "message": "Transacción creada"}), 201

# Actualizar una transacción (solo los campos enviados)
@app.route('/api/transactions/<transaction_id>', methods=['PUT'])
def update_transaction(transaction_id):
    data = request.json
    # Solo actualizamos los campos que se envíen
    db_transactions.update_one({"_id": ObjectId(transaction_id)}, {"$set": data})
    return jsonify({"message": "Transacción actualizada"}), 200

# Eliminar una transacción
@app.route('/api/transactions/<transaction_id>', methods=['DELETE'])
def delete_transaction(transaction_id):
    db_transactions.delete_one({"_id": ObjectId(transaction_id)})
    return jsonify({"message": "Transacción eliminada"}), 200

# Ruta para descargar el historial de transacciones en PDF
from flask import Response
from flask import Response

@app.route('/api/transactions/download', methods=['GET'])
def download_transactions_pdf():
    user_id = request.args.get('userId')
    start_date = request.args.get('startDate')
    end_date = request.args.get('endDate')

    query = {"userId": user_id}
    if start_date and end_date:
        query["date"] = {"$gte": start_date, "$lte": end_date}

    transactions = list(db_transactions.find(query))

    # Crear el archivo PDF en memoria
    buffer = io.BytesIO()
    c = canvas.Canvas(buffer, pagesize=letter)

    # Títulos y cabecera
    c.setFont("Helvetica", 12)
    c.drawString(30, 750, "Historial de Transacciones")
    c.drawString(30, 735, f"Usuario: {user_id}")
    c.drawString(30, 720, f"Fecha de consulta: {start_date} a {end_date}")
    c.drawString(30, 705, "-" * 100)

    # Columnas del PDF
    y_position = 690
    c.drawString(30, y_position, "ID Transacción")
    c.drawString(200, y_position, "Monto")
    c.drawString(300, y_position, "Fecha")
    c.drawString(400, y_position, "Estado")

    y_position -= 20

    # Agregar las transacciones al PDF
    for transaction in transactions:
        c.drawString(30, y_position, str(transaction.get('_id')))
        c.drawString(200, y_position, str(transaction.get('amount')))
        c.drawString(300, y_position, str(transaction.get('date')))
        c.drawString(400, y_position, str(transaction.get('status')))
        y_position -= 20

    c.showPage()
    c.save()

    buffer.seek(0)

    # Verifica si el PDF tiene contenido
    pdf_content = buffer.getvalue()
    if not pdf_content:
        return "Error: El PDF está vacío", 500

    # Asegúrate de enviar el archivo correctamente con los encabezados apropiados manualmente
    response = Response(pdf_content, mimetype='application/pdf')
    response.headers["Content-Disposition"] = 'attachment; filename="historial_transacciones.pdf"'
    return response



if __name__ == '__main__':
    app.run(debug=True)
