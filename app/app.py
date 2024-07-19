from flask import Flask, jsonify
import time

app = Flask(__name__)


@app.route('/')
def get_message():
    current_timestamp = int(time.time())
    message_payload = {
        "message": "Hello World! - Automate all the things!",
        "timestamp": current_timestamp
    }
    return jsonify(message_payload)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
