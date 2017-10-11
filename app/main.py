#!/usr/bin/python3

import os
from flask import Flask, send_file
from flask import request, abort, flash, redirect, render_template
from flask import json, url_for, jsonify, make_response

app = Flask(__name__)

@app.route("/hello")
def hello():
    return "Hello World from Flask"

@app.route("/")
def main():
    index_path = os.path.join(app.static_folder, 'index.html')
    return send_file(index_path)

# methods: if no specified, all methods are allowed
@app.route('/users/<user_id>', methods = ['GET', 'POST', 'DELETE', 'OPTIONS'])
def user(user_id):
    
    print('method = ', request.method, 'user_id = ', user_id)
    response = make_response() # jsonify({'users': user_id})

    # why add the followiing line willl make flask return 400 ???
    req_data = {}
    if request.data:
        req_data = request.get_json(force=True)
        print('request data = ', req_data)

    if request.method == 'GET':
        """return the information for <user_id>"""
        print('====> GET user_id = ', user_id)

    if request.method == 'POST':
        """modify/update the information for <user_id>"""
        # you can use <user_id>, which is a str but could
        # changed to be int or whatever you want, along
        # with your lxml knowledge to make the required
        # changes
        print('====> POST user_id = ', user_id)
        response.data = json.dumps({'users': user_id})
        response.status_code= 200
        response.mimetype='application/json'
        
    if request.method == 'DELETE':
        """delete user with ID <user_id>"""
        print('====> DELETE user_id = ', user_id)

    if request.method == 'OPTIONS':
        """OPTIONS user with ID <user_id>"""
        print('====> OPTIONS user_id = ', user_id)
        
        response.headers.add('Access-Control-Allow-Origin', '*')
        response.headers.add("Access-Control-Allow-Headers", "Content-Type")
        response.data = json.dumps({'users': user_id})
        response.status_code = 204
        print('====> OPTIONS status = ', response.status_code)
    
    print('response data:', response.data)
    return response

if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=False, port=8888)
