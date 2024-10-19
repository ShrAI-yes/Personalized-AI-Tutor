# OCR Engine

A Flask server running on Cuda-powered PyTorch libraries using [EasyOCR](https://github.com/JaidedAI/EasyOCR).

## How to start the server
1. Clone this folder
2. Create a python virtual environment, with following command.  
      On Windows
```
python -m venv .
```
      On Linux
```
python3 -m venv .
```
3. Activate the virtual environment.  
      On windows
```
./Scripts/Activate.ps1 #Powershell
.\Scripts\activate.bat #cmd
```
      On Linux
```
source ./Scripts/activate
```
4. Navigate to folder, and run following command.  
      On Windows
```shell
pip install -r requirements.txt
```
      On Linux
```
pip3 install -r requirements.txt
```
3. Start the server.  
      On Windows
```
python app.py
```
      On Linux
```linux
python3 ./app.py
```

## How to use the server
1. Send a `POST` request to the server URL.
2. Have a key-pair value of `imaage:<image.file>` in the body of `POST` request.
3. If status `200`, then response is a JSON with following format.
```javascript
{'text': ["Your image's text", "as separated along the lines"]}
```