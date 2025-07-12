import React from 'react';

export default function LoanDashboard() {
  return (
    <div className="p-8 max-w-7xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">OpenRisk Loan Dashboard</h1>
      <div className="grid gap-4 grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
        {/* Loan cards will go here */}
        <div className="p-4 bg-white shadow rounded">
          <div className="text-lg font-semibold">Loan #123</div>
          <div className="text-sm text-gray-600 mt-1">Borrower: Jane Doe</div>
          <div className="text-sm mt-2 text-yellow-700">Risk summary not yet available</div>
        </div>
      </div>
    </div>
  );
}