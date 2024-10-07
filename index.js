class LLMManager {
  constructor() {
    if (LLMManager.instance) {
      return LLMManager.instance;
    }
    this.llm = null;
    this.prompt = null;
    this.retriever = null;
    this.isInitialized = false;
    LLMManager.instance = this;
  }

  async initialize() {
    if (!this.isInitialized) {
      console.log("Initializing LLM, retriever, and prompt...");
      this.llm = new ChatCohere({
        model: "command-r-plus",
        temperature: 0,
        maxRetries: 2,
        apiKey: "YOUR_API_KEY",
      });

      this.retriever = vectorstore.asRetriever();

      const systemTemplate = [
        `You are an assistant for question-answering tasks. `,
        `Use the following pieces of retrieved context to answer `,
        `the question. If you don't know the answer, say that you `,
        `don't know. Use three sentences maximum and keep the `,
        `answer concise.`,
        `\n\n`,
        `{context}`,
      ].join("");

      this.prompt = ChatPromptTemplate.fromMessages([
        ["system", systemTemplate],
        ["human", "{input}"],
      ]);

      this.isInitialized = true; // Set the flag to true after initialization
    }
  }
}

export default LLMManager;
