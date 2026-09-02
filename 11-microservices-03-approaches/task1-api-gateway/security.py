from flask import Flask, request, jsonify
import jwt
import datetime
import hashlib

app = Flask(__name__)
SECRET_KEY = 'supersecret'
users_db = {}

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

@app.route('/v1/user', methods=['POST'])
def create_user():
    data = request.get_json()
    login = data.get('login')
    password = data.get('password')
    if not login or not password:
        return jsonify({'error': 'login and password required'}), 400
    users_db[login] = hash_password(password)
    return jsonify({'status': 'created'}), 201

@app.route('/v1/user', methods=['GET'])
def get_user():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    payload = validate_token(token)
    if not payload:
        return jsonify({'error': 'invalid token'}), 401
    login = payload.get('sub')
    if login not in users_db:
        return jsonify({'error': 'user not found'}), 404
    return jsonify({'login': login}), 200

@app.route('/v1/token', methods=['POST'])
def login():
    data = request.get_json()
    login = data.get('login')
    password = data.get('password')
    if login not in users_db or users_db[login] != hash_password(password):
        return jsonify({'error': 'invalid credentials'}), 401
    token = jwt.encode({
        'sub': login,
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }, SECRET_KEY, algorithm='HS256')
    return jsonify({'access_token': token}), 200

@app.route('/v1/token/validation', methods=['GET'])
def validate():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    if validate_token(token):
        return jsonify({'status': 'valid'}), 200
    return jsonify({'error': 'invalid token'}), 401

def validate_token(token):
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
    except:
        return None

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
