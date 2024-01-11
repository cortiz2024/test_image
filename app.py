from flask import Flask

app = Flask(__name__)

@app.route('/', methods=['GET'])
def hello_get():
    return '<h1>Hello, World!</h1>'

if __name__ == '__main__':
    app.run(debug=True)
