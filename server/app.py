from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "message": "Server is running successfully!",
        "status": "OK"
    })

@app.route("/api/health")
def health():
    return jsonify({
        "health": "healthy"
    })

if __name__ == "__main__":
    app.run(debug=True)