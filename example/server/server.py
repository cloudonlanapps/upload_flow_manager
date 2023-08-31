# app_factory.py
import os
from io import BytesIO

from flask import Flask, request, Blueprint
from flask import render_template, make_response
from flask_restful import Resource, Api
from werkzeug.datastructures import FileStorage


class ConfigClass(object):
    APP_NAME = "File Uploader Stub"
    SECRET_KEY = 'Secret!'
    PROPAGATE_EXCEPTIONS = True


class CustomException(Exception):
    pass


class Upload(Resource):
    def post(cls):
        try:
            if "file" not in request.files:
                raise CustomException("missing file")
            f = request.files["file"]
            if f.filename == "":
                raise CustomException("missing file name")
            fileSize = saveFile(f)
            return {
                "message": f"Success. The file {f.filename} ({fileSize} Bytes) is received"}, 201
        except Exception as e:
            return {"message": str(e)}, 400


uploadUsingHTML = """
<HTML>
<HEAD>
<TITLE>File Upload Test</TITLE>
</HEAD>

<BODY>
<H1>File Upload Test</H1>
<FORM ENCTYPE = "multipart/form-data"
  ACTION="http://127.0.0.1:5000/upload"
  METHOD="POST">
Send this file: <INPUT NAME="file" TYPE="file">
<INPUT TYPE="submit" VALUE="Send File">
</FORM>
</BODY>
"""


class TestUpload(Resource):
    def get(self):
        headers = {'Content-Type': 'text/html'}
        return make_response(uploadUsingHTML, 200, headers)


def saveFile(im: FileStorage):
    """ If successful, return the bytes received, else raise exceptions"""
    bytes_io = BytesIO()
    im.save(bytes_io)
    if bytes_io.getbuffer().nbytes == 0:
        raise Exception("Empty File")

    return bytes_io.getbuffer().nbytes


upload_server = Blueprint("upload_server", __name__, url_prefix="/")

api = Api(upload_server)
api.add_resource(Upload, "/upload")
api.add_resource(TestUpload, '')


def create_app(config_object):
    app = Flask(config_object.APP_NAME, template_folder=os.path.abspath('.'))
    app.config.from_object(config_object)

    app.register_blueprint(upload_server)

    return app


app = create_app(ConfigClass)

if __name__ == '__main__':
    app.run(debug=True,)
