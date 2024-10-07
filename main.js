import { MemoryVectorStore } from "langchain/vectorstores/memory";
import { RecursiveCharacterTextSplitter } from "@langchain/textsplitters";
import { createRetrievalChain } from "langchain/chains/retrieval";
import { createStuffDocumentsChain } from "langchain/chains/combine_documents";
import { ChatPromptTemplate } from "@langchain/core/prompts";
import "pdf-parse"; // Peer dep
import { PDFLoader } from "@langchain/community/document_loaders/fs/pdf";
import { CohereEmbeddings } from "@langchain/cohere";
import { ChatCohere } from "@langchain/cohere";
import express from "express";
import cors from "cors";

const app = express();
app.use(express.json());
app.use(
  cors({
    origin: "*",
  })
);

// Singleton class for LLM management
class LLMManager {
  constructor() {
    if (LLMManager.instance) {
      return LLMManager.instance;
    }
    this.llm = null;
    this.prompt = null;
    this.retriever = null;
    this.isInitialized = false;
    this.isInitializing = false; // Flag to prevent concurrent initialization
    LLMManager.instance = this;
  }

  async initialize(url) {
    if (this.isInitialized) {
      return; // Already initialized
    }

    if (this.isInitializing) {
      // If already initializing, wait until it's done
      console.log("Initialization in progress, please wait...");
      return; // Or you can implement a waiting mechanism if needed
    }

    this.isInitializing = true; // Set the flag to indicate initialization is in progress
    console.log("Initializing LLM, retriever, and prompt...");

    const cohereEmbedding = new CohereEmbeddings({
      apiKey: "WKOB0yTzRQ4QofPRmzoZXVG6FoL09KG2GxZXNDJ2",
      batchSize: 48, // Default value if omitted is 48. Max value is 96
      model: "embed-english-v3.0",
    });

    const textSplitter = new RecursiveCharacterTextSplitter({
      chunkSize: 1000,
      chunkOverlap: 200,
    });

    console.log("Loading PDF from URL:", url);
    const docs = await this.loadPDF(url);
    const splits = await textSplitter.splitDocuments(docs);
    const vectorstore = await MemoryVectorStore.fromDocuments(
      splits,
      cohereEmbedding
    );

    this.retriever = vectorstore.asRetriever();

    this.llm = new ChatCohere({
      model: "command-r-plus",
      temperature: 0,
      maxRetries: 2,
      apiKey: "WKOB0yTzRQ4QofPRmzoZXVG6FoL09KG2GxZXNDJ2", // Set your API key here
    });

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
    this.isInitializing = false; // Reset the initialization flag
    console.log("LLM, retriever, and prompt initialized successfully.");
  }

  async loadPDF(url) {
    try {
      const response = await fetch(url);
      const data = await response.blob();

      const loader = new PDFLoader(data);
      const docs = await loader.load();
      return docs;
    } catch (e) {
      console.log(e);
    }
  }
}

// Create an instance of LLMManager
const llmManager = new LLMManager();

// Define routes
app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/pdf", async (req, res) => {
  const url = req.query.url.replace(/ /g, "%2"); // Assuming the URL is passed as a query parameter
  console.log("url", url);
  if (!url) {
    return res.status(400).send("URL is required");
  }

  await llmManager.initialize(url);
  res.send("PDF loaded successfully, You can ask questions now");
});

app.get("/res", async (req, res) => {
  await llmManager.initialize(req.query.url.replace(/ /g, "%2")); // Ensure initialization
  const question = req.query.q;
  console.log("question", question);
  if (!llmManager.llm || !llmManager.prompt || !llmManager.retriever) {
    res.send("Model not loaded");
    return;
  }

  const questionAnswerChain = await createStuffDocumentsChain({
    llm: llmManager.llm,
    prompt: llmManager.prompt,
  });
  const ragChain = await createRetrievalChain({
    retriever: llmManager.retriever,
    combineDocsChain: questionAnswerChain,
  });

  const results = await ragChain.invoke({
    input: question,
  });

  console.log(results);
  res.send(results);
});

app.get("/summary", async (req, res) => {
  await llmManager.initialize(req.query.url.replace(/ /g, "%2")); // Ensure initialization

  if (!llmManager.llm || !llmManager.prompt || !llmManager.retriever) {
    res.send("Model not loaded");
    return;
  }

  const questionAnswerChain = await createStuffDocumentsChain({
    llm: llmManager.llm,
    prompt: llmManager.prompt,
  });
  const ragChain = await createRetrievalChain({
    retriever: llmManager.retriever,
    combineDocsChain: questionAnswerChain,
  });

  const results = await ragChain.invoke({
    input:
      "you have given a textbook, summarize based on chapters and topics in the book. don't describe anything other than chapters and topics",
  });

  console.log(results);
  res.send(results);
});

app.post("/question-paper", async (req, res) => {
  await llmManager.initialize(req.query.url.replace(/ /g, "%2")); // Ensure initialization
  const parameters = req.body;
  console.log("par", parameters);
  if (!llmManager.llm || !llmManager.prompt || !llmManager.retriever) {
    res.send("Model not loaded");
    return;
  }

  const questionAnswerChain = await createStuffDocumentsChain({
    llm: llmManager.llm,
    prompt: llmManager.prompt,
  });
  const ragChain = await createRetrievalChain({
    retriever: llmManager.retriever,
    combineDocsChain: questionAnswerChain,
  });

  const results = await ragChain.invoke({
    input: `generate a question  paper on this content. you have given student details so that you can generate question paper based on student's ${parameters.preference}.
    the student want to ${parameters.goal} and the student's age is ${parameters.age}, student having ${parameters.isExam} exam.
    make sure you give reponse that don't contains this ${parameters.hideWords} words.
    `,
  });

  console.log(results);
  res.send(results);
});

// Start the server
app.listen(3400, () => {
  console.log("Server running on port 3400");
});
