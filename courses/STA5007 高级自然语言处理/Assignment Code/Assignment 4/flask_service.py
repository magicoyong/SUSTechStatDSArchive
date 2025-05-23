import os
import json

from flask import Flask
from flask import request 
from transformers import AutoTokenizer, AutoModel


tokenizer = AutoTokenizer.from_pretrained("THUDM/chatglm-6b", trust_remote_code=True)
model = AutoModel.from_pretrained("THUDM/chatglm-6b", trust_remote_code=True).to("cpu", dtype=float)
model.eval()

app = Flask(__name__)

@app.route("/", methods=["POST", "GET"])
def root():
    """root
    """
    return "Welcome to chatglm model."

@app.route("/chat", methods=["POST"])
def chat():
    """chat
    """
    data_seq = request.get_data()
    data_dict = json.loads(data_seq)
    human_input = data_dict["human_input"]

    response, _ = model.chat(tokenizer, human_input, history=[])

    result_dict = {
        "response": response
    }
    result_seq = json.dumps(result_dict, ensure_ascii=False)
    return result_seq

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=False)