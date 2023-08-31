# Upload Server

If you are writing a frontend module that upload files, you could use this server as a stub to test. This server exposes only on API '/upload'.

The landing page ('/') has a html-form that can be used to verify the server is working.

This code also demonstrate using Flask, Flask.Blueprint, and Flask-RESTful.

## How to use this?

* Start the server
    ```bash
    python -m venv .venv    # Only first time 
    source .venv/bin/activate
    pip install -r requirements.txt # Only first time
    python -m src.server
    ```
* Note down the url (usually http://127.0.0.1:5000)

* open the url in a web browser. Try upload file to verify the server is working correctly.
 
* Use HTTP POST method on http://127.0.0.1:5000/upload in your test and send files.

  * If no error, you will receive a message like below
    {"message": "Success. The file <name> (<size> Bytes) is received"}

  * If error, the message will contain the raised exception

