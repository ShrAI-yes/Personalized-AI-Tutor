import PyPDF2
import cv2
from pytesseract import image_to_string
import numpy as np
from pdf2image import convert_from_path
from preprocessing import Preprocess

class Reader:
    #OCR Engine for Scanned PDFs
    def read_scan(self, pdf):
        with open(pdf, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)

            content = ''
            for page_num in range(len(pdf_reader.pages)):
                page = pdf_reader.pages[page_num]

                xobj = page['/Resources']['/XObject'].getObject()
                for obj in xobj:
                    if xobj[obj]['/Subtype'] == '/Image':
                        data = xobj[obj].getData()
                        image = cv2.imdecode(np.frombuffer(data, np.uint8), cv2.IMREAD_GRAYSCALE)
                        text = image_to_string(image)
                        # print(f'________________________________________\n{text}')

                content = content + ' ' + text

        pdf_file.close()
        return content

    #Python Library for Native PDFs containing vector graphics
    def read_native(self, pdf):
        with open(pdf, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)

            content = ''
            document = convert_from_path(pdf)
            for page in range(len(document)):
                text = image_to_string(document[page])
                content = content + ' ' + text

        pdf_file.close()
        return content

    #Main function to call to extract text from PDF
    #Mode= 1: Scanned PDF, Mode= 0(Default): Native PDF
    def scan(self,path,mode=0):

        cleanser = Preprocess()     #Custom Preprocess class
        if mode == 1:
            content = self.read_scan(path)
        else:
            content = self.read_native(path)

        # Preprocess extracted content of PDF
        cleansed_text = cleanser.preprocess(content)
        return cleansed_text

if __name__ == '__main__':
    read = Reader()
    extracted_text = read.scan('''Path of PDF''','''Mode''')
