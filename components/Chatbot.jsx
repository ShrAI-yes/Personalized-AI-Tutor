import React from "react";

import { School2Icon, SendHorizontalIcon } from "lucide-react";
import { useEffect, useState } from "react";

export default function ChatComponent({ transcript, videoId }) {
  const [inputText, setInputText] = useState("");
  const [error, setError] = useState("");
  const [loadingIndex, setLoadingIndex] = useState(null); // Track which response is loading

  const [questionsAsked, setQuestionsAsked] = useState(0);
  const [chatState, setChatState] = useState({
    chat: [
      {
        input: "",
        response: "Hi there! How can I help you today?",
      },
    ],
    status: "idle",
  });

  useEffect(() => {
    const element = document.getElementById("chat-section");
    element.scrollTo({ top: element.scrollHeight, behavior: "smooth" });
  }, [questionsAsked]);

  const handleSendMessage = async () => {
    if (inputText.trim()) {
      setChatState((prev) => ({
        chat: [...prev.chat, { input: inputText, response: "" }],
        status: "loading",
      }));

      // Send message to API
      await sendToApi(inputText);
      setInputText("");
    }
  };

  const sendToApi = async (input) => {
    console.log("input", input);
    const body = {
      input: input,
    };

    try {
      const response = await fetch("http://127.0.0.1:5000/ai_tutor", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
      });

      if (!response.ok) {
        const errorData = await response.json();
        setError(`Error: ${errorData.message}`);
        return;
      }

      const data = await response.json();
      setChatState((prev) => {
        const updatedChat = [...prev.chat];
        updatedChat[updatedChat.length - 1].response = data.response;
        return { chat: updatedChat, status: "idle" };
      });
      setError("");
    } catch (err) {
      setError("An error occurred while sending the audio to the API.");
    }
  };

  return (
    <div className="flex h-full flex-col rounded-l-2xl p-4 w-full px-8">
      <div
        id="chat-section"
        className="no-scrollbar flex-grow overflow-y-auto rounded-xl py-4 transition-all duration-300 ease-in-out"
      >
        {chatState.chat.length === 0 && chatState.status !== "loading" ? (
          <div className="flex h-full flex-col items-center justify-center rounded-xl bg-gray-200 p-8 tcenter shadow-md">
            <School2Icon size={48} className="tgray-600" />
            <h2 className="mt-4 tlg font-semibold tgray-700">
              How can I assist you today?
            </h2>
          </div>
        ) : (
          <div className="space-y-4">
            {chatState.chat.map((message, index) => (
              <div key={index}>
                {/* User Message */}
                {message.input !== "" && (
                  <div className="flex justify-end">
                    <div className="max-w-xs rounded-lg bg-[#41B3A2] p-3 twhite shadow-md">
                      {message.input}
                    </div>
                  </div>
                )}
                {/* Chatbot Response */}
                <div className="mt-2 flex justify-start">
                  <div className="relative max-w-xs rounded-lg bg-gray-100 p-3 tgray-900 shadow-md">
                    {loadingIndex === index &&
                    chatState.status === "loading" ? (
                      <div className="flex items-center">loading</div>
                    ) : (
                      message.response
                    )}
                  </div>
                </div>
              </div>
            ))}
            {error && <p style={{ color: "red" }}>{error}</p>}
          </div>
        )}
      </div>

      <div className="mt-4 flex w-full flex-wrap items-center space-x-2 rounded-full border border-gray-300 p-2 shadow-md">
        <input
          type="text"
          value={inputText}
          onChange={(e) => setInputText(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && handleSendMessage()}
          className="min-w-0 flex-1 rounded-full border-none bg-gray-100 px-4 py-2 tgray-900 placeholder-gray-500"
          placeholder="Type a message..."
        />
        <button
          onClick={handleSendMessage}
          className="rounded-full bg-[#41B3A2] p-2 hover:bg-purple-600"
        >
          <SendHorizontalIcon color="white" size={20} />
        </button>
      </div>
    </div>
  );
}
