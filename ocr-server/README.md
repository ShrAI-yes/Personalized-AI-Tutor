# OCR Engine

A Flask server running on Cuda-powered PyTorch libraries using [EasyOCR](https://github.com/JaidedAI/EasyOCR).

## How to use
1. Clone this folder
2. Create a python virtual environment, with following command.
```
python -m venv .
```
3. Activate the virtual environment
On windows
```
./Scripts/Activate.ps1 #Powershell
.\Scripts\activate.bat #cmd
```
On Bash
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
On Windows,
```
python app.py
```
On Linux,
```linux
python3 ./app.py
```