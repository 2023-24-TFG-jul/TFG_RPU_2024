from flask import Flask, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)

# Cargar el modelo
model = joblib.load('watch_price_predictor.joblib')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    df = pd.DataFrame(data, index=[0])
    
    # Convertir datos categóricos a numéricos si es necesario
    df = pd.get_dummies(df)
    
    # Asegurarse de que las columnas del DataFrame coincidan con las que el modelo espera
    missing_cols = set(X.columns) - set(df.columns)
    for c in missing_cols:
        df[c] = 0
    df = df[X.columns]
    
    prediction = model.predict(df)
    return jsonify({'price': prediction[0]})

if __name__ == '__main__':
    app.run(debug=True)
