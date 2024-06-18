# 1) Creo que funciona cuando lo suba a PRO
# import pandas as pd
# from flask import Flask, request, jsonify
# from joblib import load

# app = Flask(__name__)

# # Cargar el modelo entrenado
# model = load('ULTIMA_PRUEBA.joblib')

# # Endpoint para hacer predicciones
# @app.route('/predict', methods=['POST'])
# def predict():
#     data = request.get_json()
#     # Asegúrate de que los datos recibidos sean una lista de diccionarios
#     if isinstance(data, list) and all(isinstance(item, dict) for item in data):
#         new_data = pd.DataFrame(data)
#         predicted_price = model.predict(new_data)  # Asumiendo que 'model' está definido en otro lugar
#         return jsonify({'predicted_price': predicted_price.tolist()})
#     else:
#         return jsonify({'error': 'Los datos deben ser una lista de diccionarios'}), 400

# if __name__ == '__main__':
#     app.run(debug=True)

# 2) Usar esto ahora para poder probar en local
from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
import pandas as pd
from joblib import load

app = Flask(__name__)
CORS(app, resources={r"/predict": {"origins": "*"}})  # Permitir cualquier origen local dinámico

# Cargar el modelo entrenado
model = load('ULTIMA_PRUEBA.joblib')

# Endpoint para hacer predicciones
@app.route('/predict', methods=['POST'])
@cross_origin(origin='*', headers=['Content-Type'])
def predict():
    data = request.get_json()
    # Asegúrate de que los datos recibidos sean una lista de diccionarios
    if isinstance(data, list) and all(isinstance(item, dict) for item in data):
        new_data = pd.DataFrame(data)
        predicted_price = model.predict(new_data)  # Asumiendo que 'model' está definido en otro lugar
        return jsonify({'predicted_price': predicted_price.tolist()})
    else:
        return jsonify({'error': 'Los datos deben ser una lista de diccionarios'}), 400

if __name__ == '__main__':
    app.run(debug=True)


