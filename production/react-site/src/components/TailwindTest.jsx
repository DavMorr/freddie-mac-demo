import React from 'react';

export default function TailwindTest() {
  return (
    <div className="p-6 max-w-sm mx-auto bg-white rounded-xl shadow-md flex items-center space-x-4">
      <div className="shrink-0">
        <div className="h-12 w-12 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold">
          AI
        </div>
      </div>
      <div>
        <div className="text-xl font-medium text-black">Tailwind Test</div>
        <p className="text-gray-500">If you see this styled, Tailwind is working!</p>
      </div>
    </div>
  );
}
