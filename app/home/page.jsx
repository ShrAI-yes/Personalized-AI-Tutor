"use client";

import { useRouter } from "next/navigation";
import React, { useEffect, useState } from "react";
import { ref, getDownloadURL, listAll } from "firebase/storage";
import Image from "next/image";
import { storage } from "../../util/firebase";
import Link from "next/link";

const Home = () => {
  const router = useRouter();
  const [files, setFiles] = useState([]);

  useEffect(() => {
    // load all the files from firebase storage
    const loadFiles = async () => {
      const files = await listAll(ref(storage, "/"));
      files.items.forEach(async (item) => {
        const url = await getDownloadURL(item);
        setFiles((prev) => [...new Set([...prev, { url, name: item.name }])]);
      });
    };
    loadFiles();
  }, []);

  const coverPages = [
    "/cover_pages/marathi.png",
    // "/cover_pages/english.png",
    // "/cover_pages/hindi.png",
    // "/cover_pages/kannada.png",
    // "/cover_pages/malayalam.png",
    // "/cover_pages/tamil.png",
    // "/cover_pages/telugu.png",
  ];

  const randomCoverPages = (num) => {
    return `/cover_pages/${
      coverPages[Math.floor(Math.random() * coverPages.length)]
    }`;
  };

  // display all pdf's name
  return (
    <div className="w-full h-screen bg-background grid grid-cols-3 gap-4 p-4 mt-10">
      {files.map((file) => (
        <div
          key={file.name}
          className="w-[200px] bg-[#41B3A2] px-3 h-min py-4 flex flex-col items-center gap-3 mx-4 rounded-md"
        >
          <a href={file.url} target="_blank">
            {file.name}
          </a>
          <div className="flex justify-center items-center">
            <Link
              href={{
                pathname: `/home/${file.name}`,
                query: {
                  url: file.url,
                  name: file.name,
                },
              }}
            >
              <Image
                className="w-[200px] h-[250px] cursor-pointer shadow-md rounded-md"
                src={"/cover_pages/marathi.png"}
                alt={file.name}
                width={100}
                height={100}
              />
            </Link>
          </div>
        </div>
      ))}
    </div>
  );
};

export default Home;
