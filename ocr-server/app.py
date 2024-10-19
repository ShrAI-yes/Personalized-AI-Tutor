import easyocr
from PIL import Image
from flask import Flask, request, jsonify, render_template
import io

app = Flask(__name__)
reader = easyocr.Reader(['en'])

@app.route('/', methods=['GET', 'POST'])
def index():
    return render_template('index.html')

@app.post('/ocr')
def ocr():
    if 'image' not in request.files:
        return jsonify({'err': 'Attach an image'}), 400
    
    file = request.files['image']
    try:
      img = Image.open(file.stream)

      img_bytes = io.BytesIO()
      img.save(img_bytes, format='PNG')
      img_bytes = img_bytes.getvalue() 
      
      text = reader.readtext(img_bytes, detail=0)
      return jsonify({'text': text}), 200
    
    except Exception as e:
        return jsonify({'err': str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True)