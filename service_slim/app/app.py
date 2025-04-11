import os, socket
from bson import ObjectId
from flask import Flask, jsonify, send_from_directory, request
from flask_swagger_ui import get_swaggerui_blueprint
from pymongo import MongoClient

app = Flask(__name__)

#DATA_SET = ['1', '2', '3'] # some data

# init test data
def get_mongo_client():
    #mongo_uri = os.getenv('MONGO_URI', 'mongodb://localhost:27017')
    mongo_uri = os.getenv('MONGO_URI', 'mongodb://mongo_user:mongo_pw@mongodb-data:27017/?authSource=admin')
    client = MongoClient(mongo_uri)
    return client

def mongo_get_all_items():
    client = get_mongo_client()
    db = client['admin']
    collection = db['test']
    items = list(collection.find({}))
    for item in items:
        item['_id'] = str(item['_id'])  # Convert ObjectId to string
    return items

def mongo_insert_data(new_items):
    client = get_mongo_client()
    db = client['admin']
    collection = db['test']
    documents = [{'value': item} for item in new_items]
    result = collection.insert_many(documents)
    return result.inserted_ids


@app.route(f'/static/<path:path>')
def send_static(path):
    """set path to static files"""
    return send_from_directory('static', path)

@app.route("/")
def hello():
    html = "<h3>Hello Andy!!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" 

    return html.format(hostname=socket.gethostname())

@app.route('/test_get', methods=['GET'])
def test_get():
    return jsonify(mongo_get_all_items())

@app.route('/test_post', methods=['POST'])
def test_post():
    if request.is_json:
        data = request.get_json(force=True)
        new_item = data.get('new_item')
        #DATA_SET.append(new_item)
        mongo_insert_data([new_item])
        return jsonify(mongo_get_all_items())
    else:
        return jsonify('incorret input, not json')

### swagger specific ###
SWAGGER_URL = '/api/docs'  # URL for exposing Swagger UI (without trailing '/')
API_URL = '/static/swagger/swagger.json'
# Call factory function to create our blueprint
swaggerui_blueprint = get_swaggerui_blueprint(
    SWAGGER_URL,  # Swagger UI static files will be mapped to '{SWAGGER_URL}/dist/'
    API_URL,
    config={  # Swagger UI config overrides
        'app_name': "Andy Swagger App"
    },
    # oauth_config={  # OAuth config. See https://github.com/swagger-api/swagger-ui#oauth2-configuration .
    #    'clientId': "your-client-id",
    #    'clientSecret': "your-client-secret-if-required",
    #    'realm': "your-realms",
    #    'appName': "your-app-name",
    #    'scopeSeparator': " ",
    #    'additionalQueryStringParams': {'test': "hello"}
    # }
)
app.register_blueprint(swaggerui_blueprint)
### end swagger specific ###


#app.register_blueprint(request_api.get_blueprint())

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)