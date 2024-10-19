import os
from flask import Flask, request, jsonify
from langchain_mistralai import ChatMistralAI
from langchain import ConversationChain
from langchain.memory import ConversationBufferMemory
from langchain.prompts import PromptTemplate
from flask_cors import CORS

# add api key to the environment variables
os.environ["MISTRAL_API_KEY"] = "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"
os.environ["HUGGINGFACE_API_TOKEN"] = "md8M3NEXWEOkQgEFNDaHJTU0qhbHaIAN"



app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})


# Ensure you have set MISTRAL_API_KEY and HUGGINGFACE_API_TOKEN as environment variables
if "MISTRAL_API_KEY" not in os.environ:
    raise ValueError("MISTRAL_API_KEY environment variable is not set")

if "HUGGINGFACE_API_TOKEN" not in os.environ:
    raise ValueError("HUGGINGFACE_API_TOKEN environment variable is not set")

llm = ChatMistralAI(model_name="mistral-large-latest", temperature=0, max_retries=2,
                    api_key="",
                   )

memory = ConversationBufferMemory()

prompt_template = """
You are an AI tutor helping students learn by guiding them to think critically rather than giving direct answers.
When a student asks a question or explains something, respond with a question or a hint to help them think about the problem differently.
Use the Socratic method and only provide answers as a last resort. Always encourage the student to explore their reasoning.

{history}
Student's statement: "{input}"

Your response:
"""

conversation_chain = ConversationChain(
    llm=llm,
    memory=memory,
    prompt=PromptTemplate(template=prompt_template, input_variables=["input", "history"])
)

@app.route('/')
def index():
    return "Hello, World!"

@app.route('/ai_tutor', methods=['POST'])
def ai_tutor():
    data = request.json
    student_input = data.get('input')
    print("got input", student_input)
    if not student_input:
        return jsonify({"error": "No input provided"}), 400
    
    response = conversation_chain.predict(input=student_input)
    return jsonify({"response": response})

@app.route('/reset_conversation', methods=['POST'])
def reset_conversation():
    global memory
    memory = ConversationBufferMemory()
    global conversation_chain
    conversation_chain = ConversationChain(
        llm=llm,
        memory=memory,
        prompt=PromptTemplate(template=prompt_template, input_variables=["input", "history"])
    )
    return jsonify({"message": "Conversation reset successfully"})

if __name__ == '__main__':
    app.run(debug=True)