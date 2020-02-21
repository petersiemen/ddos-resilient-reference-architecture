#!/bin/bash
yum update -y
yum install python2-pip.noarch -y
pip install flask

cat > /home/ec2-user/minimal.py << EOF
from flask import Flask
import random

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World! %s' %format(random.random())
EOF

export FLASK_APP=/home/ec2-user/minimal.py
flask run --host=0.0.0.0 --port=80 &