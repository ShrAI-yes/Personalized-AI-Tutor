import easyocr
from PIL import Image
from flask import Flask, request, jsonify, render_template
import io
from PyPDF2 import PdfReader
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
reader = easyocr.Reader(['en'])

@app.route('/', methods=['GET', 'POST'])
def index():
    return render_template('index.html')

@app.post('/ocr/image')
def img():
    if 'image' not in request.files:
        return jsonify({
            'err': 'Attach an image'
          }), 400
    
    try:
      file = request.files['image']
      img = Image.open(file.stream)

      img_bytes = io.BytesIO()
      img.save(img_bytes, format='PNG')
      img_bytes = img_bytes.getvalue() 
      
      text = reader.readtext(img_bytes, detail=0)
      return jsonify({
          'text': text
        }), 200
    
    except Exception as e:
        return jsonify({
            'err': str(e)
        }), 400

@app.post('/ocr/pdf')
def pdf():
    if 'pdf' not in request.files:
        return jsonify({
            'err': "Attach an pdf"
        }), 400
    
    try:
        file = request.files['pdf']
        pdf_reader = PdfReader(file)

        text = '\n'.join([page.extract_text() for page in pdf_reader.pages])

        return jsonify({
            'text': text
        }), 200
    except Exception as e:
        return jsonify({
            'err': str(e)
        }), 400


if __name__ == '__main__':
    app.run(debug=True)