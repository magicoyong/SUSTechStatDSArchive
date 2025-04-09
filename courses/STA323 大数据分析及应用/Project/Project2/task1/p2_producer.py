import numpy as np
import pandas as pd
from kafka import KafkaProducer
import json

df = pd.read_parquet("./data/Task1/squad_v2/squad_v2/validation-00000-of-00001.parquet")

def convert_to_serializable(obj):
    if isinstance(obj, np.ndarray):
        return obj.tolist()
    return obj

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v, default=convert_to_serializable).encode('utf-8')
)

topic_name = "p2"
cnt = 0
for _, row in df.iterrows():
    producer.send(topic_name, row.to_dict())
    producer.flush()

producer.close()

