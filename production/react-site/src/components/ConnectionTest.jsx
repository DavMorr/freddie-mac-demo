import React, { useState } from 'react';
import { testConnection, testLoanEndpointDetails, getAuthStatus, inspectJsonApiRoot } from '../api/drupal.js';

const ConnectionTest = () => {
  const [results, setResults] = useState({});
  const [loading, setLoading] = useState(false);

  const runTests = async () => {
    setLoading(true);
    const testResults = {};

    // Test 1: Basic connection
    console.log('Testing basic connection...');
    testResults.connection = await testConnection();

    // Test 2: JSON:API root inspection
    console.log('Inspecting JSON:API root...');
    testResults.apiRoot = await inspectJsonApiRoot();

    // Test 3: Loan endpoint tests
    console.log('Testing loan endpoints...');
    testResults.loanTests = await testLoanEndpointDetails();

    // Test 4: Auth status
    testResults.authStatus = getAuthStatus();

    setResults(testResults);
    setLoading(false);
  };

  return (
    <div className="max-w-6xl mx-auto p-6">
      <h1 className="text-3xl font-bold text-gray-800 mb-2">Drupal Connection Test</h1>

      <button
        onClick={runTests}
        disabled={loading}
        className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded mb-6"
      >
        {loading ? 'Testing...' : 'Run Connection Tests'}
      </button>

      {Object.keys(results).length > 0 && (
        <div className="space-y-6">
          {/* Basic Connection Test */}
          <div className="bg-white border rounded-lg p-4">
            <h2 className="text-xl font-semibold mb-2">
              {results.connection?.success ? '✅' : '❌'} Basic Connection
            </h2>
            <pre className="bg-gray-100 p-3 rounded text-sm overflow-auto">
              {JSON.stringify(results.connection, null, 2)}
            </pre>
          </div>

          {/* API Root Test */}
          <div className="bg-white border rounded-lg p-4">
            <h2 className="text-xl font-semibold mb-2">
              {results.apiRoot?.success ? '✅' : '❌'} JSON:API Root
            </h2>
            <pre className="bg-gray-100 p-3 rounded text-sm overflow-auto">
              {JSON.stringify(results.apiRoot, null, 2)}
            </pre>
          </div>

          {/* Loan Endpoint Tests */}
          <div className="bg-white border rounded-lg p-4">
            <h2 className="text-xl font-semibold mb-2">Loan Endpoint Tests</h2>
            {results.loanTests?.map((test, index) => (
              <div key={index} className="mb-4 border-b pb-3">
                <h3 className="font-medium">
                  {test.success ? '✅' : '❌'} {test.test}
                </h3>
                <pre className="bg-gray-100 p-2 rounded text-xs overflow-auto mt-2">
                  {JSON.stringify(test, null, 2)}
                </pre>
              </div>
            ))}
          </div>

          {/* Auth Status */}
          <div className="bg-white border rounded-lg p-4">
            <h2 className="text-xl font-semibold mb-2">Authentication Status</h2>
            <pre className="bg-gray-100 p-3 rounded text-sm overflow-auto">
              {JSON.stringify(results.authStatus, null, 2)}
            </pre>
          </div>
        </div>
      )}
    </div>
  );
};

export default ConnectionTest;