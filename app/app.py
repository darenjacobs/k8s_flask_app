from flask import Flask, jsonify
import time

app = Flask(__name__)

app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
@app.route('/')
def get_message():
    current_timestamp = int(time.time())
    message_payload = {
        "message": "Automate all the things!",
        "timestamp": current_timestamp
    }
    return jsonify(message_payload)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)