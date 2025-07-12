import { useEffect, useState } from 'react';
import { fetchLoanRecords } from '../api/drupal';

export default function LoanList() {
  const [loans, setLoans] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState({ total: 0, defaulted: 0, avgFico: 0 });

  // Calculate loan statistics
  const calculateStats = (loanData) => {
    if (!loanData.length) return { total: 0, defaulted: 0, avgFico: 0 };

    const total = loanData.length;
    const defaulted = loanData.filter(loan => loan.attributes.defaulted).length;
    const avgFico = Math.round(
      loanData.reduce((sum, loan) => sum + (loan.attributes.fico_score || 0), 0) / total
    );

    return { total, defaulted, avgFico };
  };

  // Fetch loan data
  const handleFetchLoans = async () => {
    setLoading(true);
    setError(null);

    console.log('Fetching loan records...');
    const result = await fetchLoanRecords();

    if (result.success) {
      setLoans(result.data);
      setStats(calculateStats(result.data));
      console.log(`✅ Loaded ${result.data.length} loan records:`, result.data);
    } else {
      setError(result.error);
      console.error('❌ Failed to fetch loans:', result);
    }

    setLoading(false);
  };

  // Auto-fetch on component mount
  useEffect(() => {
    handleFetchLoans();
  }, []);

  // Format currency
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(amount);
  };

  // Get risk level styling
  const getRiskStyling = (riskSummary, defaulted) => {
    if (defaulted) return 'bg-red-100 text-red-800 border-red-300';

    if (!riskSummary) return 'bg-gray-100 text-gray-600 border-gray-300';

    const summary = riskSummary.toLowerCase();
    if (summary.includes('high risk')) return 'bg-red-100 text-red-700 border-red-300';
    if (summary.includes('moderate risk')) return 'bg-yellow-100 text-yellow-700 border-yellow-300';
    if (summary.includes('low risk')) return 'bg-green-100 text-green-700 border-green-300';

    return 'bg-blue-100 text-blue-700 border-blue-300';
  };

  // Get risk label
  const getRiskLabel = (riskSummary, defaulted) => {
    if (defaulted) return 'DEFAULTED';
    if (!riskSummary) return 'Not Analyzed';

    const summary = riskSummary.toLowerCase();
    if (summary.includes('high risk')) return 'High Risk';
    if (summary.includes('moderate risk')) return 'Moderate Risk';
    if (summary.includes('low risk')) return 'Low Risk';

    return 'Analyzed';
  };

  return (
    <div className="max-w-6xl mx-auto p-6">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-800 mb-2">Freddie Mac Loan Portfolio</h1>
        <p className="text-gray-600">AI-powered loan risk analysis and monitoring</p>
      </div>

      {/* Stats Dashboard */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="bg-white rounded-lg shadow-md p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Total Loans</p>
              <p className="text-2xl font-bold text-blue-600">{stats.total}</p>
            </div>
            <div className="text-blue-500">📊</div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Defaulted</p>
              <p className="text-2xl font-bold text-red-600">{stats.defaulted}</p>
            </div>
            <div className="text-red-500">⚠️</div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Default Rate</p>
              <p className="text-2xl font-bold text-orange-600">
                {stats.total ? Math.round((stats.defaulted / stats.total) * 100) : 0}%
              </p>
            </div>
            <div className="text-orange-500">📈</div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Avg FICO</p>
              <p className="text-2xl font-bold text-green-600">{stats.avgFico}</p>
            </div>
            <div className="text-green-500">📋</div>
          </div>
        </div>
      </div>

      {/* Controls */}
      <div className="bg-white rounded-lg shadow-md p-6 mb-6">
        <div className="flex justify-between items-center">
          <h2 className="text-xl font-semibold text-gray-700">Loan Records</h2>
          <button
            onClick={handleFetchLoans}
            disabled={loading}
            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg disabled:opacity-50 transition-colors"
          >
            {loading ? '⏳ Loading...' : '🔄 Refresh Data'}
          </button>
        </div>

        {error && (
          <div className="mt-4 bg-red-100 border border-red-300 text-red-700 p-3 rounded-lg">
            <strong>❌ Error:</strong> {error}
          </div>
        )}
      </div>

      {/* Loan Records */}
      <div className="space-y-4">
        {loading && (
          <div className="flex items-center justify-center py-12">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            <span className="ml-3 text-gray-600">Loading loan data...</span>
          </div>
        )}

        {!loading && loans.length === 0 && (
          <div className="text-center py-12 text-gray-500">
            No loan records found. Check your API connection.
          </div>
        )}

        {loans.map((loan) => (
          <div key={loan.id} className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
            <div className="flex justify-between items-start mb-4">
              <div>
                <h3 className="text-lg font-semibold text-gray-800">
                  {loan.attributes.borrower_name}
                </h3>
                <p className="text-sm text-gray-600">ID: {loan.attributes.loan_id}</p>
              </div>

              <div className={`px-3 py-1 rounded-full text-xs font-medium border ${getRiskStyling(loan.attributes.risk_summary, loan.attributes.defaulted)}`}>
                {getRiskLabel(loan.attributes.risk_summary, loan.attributes.defaulted)}
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
              <div>
                <span className="text-sm font-medium text-gray-600">Loan Amount</span>
                <p className="text-lg font-semibold text-blue-600">
                  {formatCurrency(loan.attributes.loan_amount)}
                </p>
              </div>

              <div>
                <span className="text-sm font-medium text-gray-600">FICO Score</span>
                <p className={`text-lg font-semibold ${loan.attributes.fico_score >= 740 ? 'text-green-600' :
                  loan.attributes.fico_score >= 670 ? 'text-yellow-600' : 'text-red-600'
                  }`}>
                  {loan.attributes.fico_score || 'N/A'}
                </p>
              </div>

              <div>
                <span className="text-sm font-medium text-gray-600">LTV Ratio</span>
                <p className={`text-lg font-semibold ${loan.attributes.ltv_ratio <= 80 ? 'text-green-600' :
                  loan.attributes.ltv_ratio <= 90 ? 'text-yellow-600' : 'text-red-600'
                  }`}>
                  {loan.attributes.ltv_ratio}%
                </p>
              </div>

              <div>
                <span className="text-sm font-medium text-gray-600">DTI Ratio</span>
                <p className={`text-lg font-semibold ${loan.attributes.dti <= 36 ? 'text-green-600' :
                  loan.attributes.dti <= 43 ? 'text-yellow-600' : 'text-red-600'
                  }`}>
                  {loan.attributes.dti}%
                </p>
              </div>
            </div>

            <div className="flex justify-between items-center text-sm text-gray-600 mb-4">
              <span>📍 {loan.attributes.borrower_state}</span>
              <span>💳 Internal ID: {loan.attributes.drupal_internal__id}</span>
            </div>

            {loan.attributes.risk_summary && (
              <details className="mt-4">
                <summary className="cursor-pointer text-sm font-medium text-gray-700 hover:text-gray-900">
                  AI Risk Analysis
                </summary>
                <div className="mt-2 p-3 bg-gray-50 rounded-lg text-sm text-gray-700 whitespace-pre-line">
                  {loan.attributes.risk_summary}
                </div>
              </details>
            )}
          </div>
        ))}
      </div>

      {/* Success Message */}
      {loans.length > 0 && (
        <div className="mt-6 bg-green-50 border border-green-200 rounded-lg p-4">
          <h3 className="font-semibold text-green-800 mb-2">API Integration Successful!</h3>
          <p className="text-green-700 text-sm">
            Your React app is now successfully connected to your Drupal backend via JSON:API.
            You're displaying {loans.length} loan records with full risk analysis data.
          </p>
        </div>
      )}
    </div>
  );
}
