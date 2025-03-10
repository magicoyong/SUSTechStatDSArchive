import csv
import time
from kafka import KafkaProducer

broker = "localhost:9092"
producer = KafkaProducer(bootstrap_servers = broker, retries = 5)

csv_file = "./data/task3/shopping_data/user_log.csv"
with open(csv_file, "r", encoding = "utf-8") as file:
    reader = csv.reader(file, delimiter = ",")
    cnt = 0
    for row in reader:
        producer.send("q3", (",".join(row)).encode("utf-8"))
        producer.flush()
        cnt += 1
        if cnt % 1000 == 0:
            time.sleep(0.5)

producer.close()


