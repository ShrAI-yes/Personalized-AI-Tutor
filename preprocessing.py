import re
import contractions
import nltk
import spacy
import unicodedata
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import word_tokenize
from spellchecker import SpellChecker

nltk.download('punkt')
nltk.download('punkt_tab')
nltk.download('stopwords')
nltk.download('averaged_perceptron_tagger')
nltk.download('wordnet')
nltk.download('omw-1.4')

class Preprocess:
    def reformat(text):
        text = contractions.fix(text)
        text = re.sub(r'[^a-zA-Z0-9,.\?\s]', '', text)
        text = re.sub(r'\s+', ' ', text).strip()
        text = text.lower()
        return text

    def remove_single_char(text):
        single_char_pattern = r'\s+[a-zA-Z]\s+'
        without_sc = re.sub(pattern=single_char_pattern, repl=" ", string=text)
        return without_sc

    def cleanse(text):
        cleansing_text = []
        for word in text.split():
            if len(word) > 2 and word not in stopwords:
                cleansing_text.append(word)
        return ' '.join(cleansing_text)

    def normal_char(text):
        return unicodedata.normalize('NFKD', text).encode('ascii', 'ignore').decode('ascii')

    def spell_check(text):
        spellchecker = SpellChecker()
        nlp = spacy.load('en_core_web_sm')
        doc = nlp(text)
        named_entities = [ent.text for ent in doc.ents if ent.label_ == 'PERSON']
        words_to_check = [word for word in text.split() if word not in named_entities]

        corrected_text = []
        for word in text.split():
            if word in words_to_check and spellchecker.correction(word) != None:
                corrected_text.append(spellchecker.correction(word))
            else:
                corrected_text.append(word)

        return " ".join(corrected_text)

    def lemmatization(text):
        lemma = WordNetLemmatizer()
        tokens = word_tokenize(text)
        for index in range(len(tokens)):
            lemma_word = lemma.lemmatize(tokens[index])
            tokens[index] = lemma_word

        return ' '.join(tokens)

    #Main function which applies all preprocessing functions defined above
    def preprocess(self,text):
        text = self.reformat(text)
        text = self.remove_single_char(text)
        text = self.cleanse(text)
        text = self.normal_char(text)
        text = self.spell_check(text)
        preprocessed_text = self.lemmatization(text)
        return preprocessed_text