"use client";

import React, { useState } from "react";
import Image from "next/image";
import { useSearchParams } from "next/navigation";
import preferanceData from "../../../common/preferanceData";
import toast from "react-hot-toast";
import ChatComponent from "../../../components/Chatbot";

const PreferancesPage = ({ params }) => {
  const searchParams = useSearchParams();
  const url = searchParams.get("url");

  const [preferance, setPreferance] = useState({});
  const [currentQuestion, setCurrentQuestion] = useState(0);

  const handleOptionClick = (option) => {
    setPreferance({
      ...preferance,
      [preferanceData[currentQuestion].label]: option,
    });
    if (currentQuestion === preferanceData.length - 1) {
      const formData = JSON.parse(localStorage.getItem("formData"));
      localStorage.setItem(
        "formData",
        JSON.stringify({ ...formData, ...preferance, url })
      );
      toast.success("Preferences saved successfully");
    }
    setCurrentQuestion(currentQuestion + 1);
  };

  return (
    <div className="w-full h-full bg-background flex flex-col items-center justify-center">
      {currentQuestion < preferanceData.length ? (
        <div className="w-full p-4 flex flex-col items-center justify-center gap-4  mt-10">
          <h1 className="text-2xl font-bold mb-10">
            What are your learning preferences?
          </h1>
          <div className="w-1/3 flex flex-col items-center justify-center gap-4 h-full bg-white rounded-md p-4">
            <h1 className="text-2xl font-bold">
              {preferanceData[currentQuestion].question}
            </h1>
            <div className="w-2/3 mt-4 flex flex-col gap-3 items-center justify-center">
              {preferanceData[currentQuestion].options.map((option) => (
                <button
                  key={option}
                  onClick={() => handleOptionClick(option)}
                  className="w-full h-10 border-2 text-black rounded-md hover:bg-[#41B3A2] hover:text-white transition-all duration-300"
                >
                  {option}
                </button>
              ))}
            </div>
          </div>
        </div>
      ) : (
        <div className="w-full h-full flex flex-col items-center justify-center gap-4">
          <div className="w-full h-full chat flex items-center justify-between">
            <div className="w-1/2 h-full">
              <iframe
                src={url}
                width={"100%"}
                height={"100%"}
                frameborder="0"
              ></iframe>
            </div>
            <div className="w-1/2 h-full">
              <ChatComponent 
              
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default PreferancesPage;
