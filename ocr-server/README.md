Here's the corrected version with the proper formatting for Linux code blocks:

# OCR Engine

A Flask server running on CUDA-powered PyTorch libraries using [EasyOCR](https://github.com/JaidedAI/EasyOCR).

## How to start the server
1. Clone this folder.
2. Create a Python virtual environment using the following command:  
   On Windows
   ```bash
   python -m venv .
   ```
   On Linux
   ```bash
   python3 -m venv .
   ```
3. Activate the virtual environment.  
   On Windows
   ```bash
   ./Scripts/Activate.ps1 # PowerShell
   ./Scripts/activate.bat # cmd
   ```
   On Linux
   ```bash
   source ./bin/activate
   ```
4. Navigate to the folder and run the following command.  
   On Windows
   ```bash
   pip install -r requirements.txt
   ```
   On Linux
   ```bash
   pip3 install -r requirements.txt
   ```
5. Start the server.  
   On Windows
   ```bash
   python app.py
   ```
   On Linux
   ```bash
   python3 ./app.py
   ```

## How to use the server
1. Send a `POST` request to the server URL.  
   For Image `<server_url>/ocr/img`  
   For PDF `<server_url>/ocr/pdf`  
2. Include a key-pair value of `filetype:<file.filetype>` in the body of the `POST` request.
3. If the status is `200`, the response will be a JSON with the following format:
   ```json
   {"text": ["Your file's text", "as separated along the lines"]}
   ```