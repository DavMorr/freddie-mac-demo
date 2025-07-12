import axios from 'axios';

// Get API configuration from environment variables
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://freddie-mac-demo.ddev.site';
const JSONAPI_ENDPOINT = import.meta.env.VITE_JSONAPI_ENDPOINT || '/jsonapi';
const API_ROOT = import.meta.env.VITE_API_ROOT || `${API_BASE_URL}${JSONAPI_ENDPOINT}`;
const API_TIMEOUT = import.meta.env.VITE_API_TIMEOUT || 10000;
const WITH_CREDENTIALS = import.meta.env.VITE_WITH_CREDENTIALS === 'true';

console.log('🔗 API Configuration:', {
  API_BASE_URL,
  JSONAPI_ENDPOINT,
  API_ROOT,
  API_TIMEOUT,
  WITH_CREDENTIALS
});

// Authentication configuration
const AUTH_CONFIG = {
  // Set to true to enable authentication
  enabled: false,
  // Update these with your Drupal credentials
  username: 'admin', // Replace with your Drupal username
  password: 'password', // Replace with your Drupal password
};

// Create axios instance with base configuration
const api = axios.create({
  baseURL: API_ROOT,
  headers: {
    'Accept': 'application/vnd.api+json',
    'Content-Type': 'application/vnd.api+json',
    // Add auth header if enabled
    ...(AUTH_CONFIG.enabled && {
      'Authorization': `Basic ${btoa(`${AUTH_CONFIG.username}:${AUTH_CONFIG.password}`)}`
    })
  },
  withCredentials: WITH_CREDENTIALS,
  timeout: parseInt(API_TIMEOUT), // Convert to number
});

// Add request interceptor for debugging
api.interceptors.request.use(
  (config) => {
    console.log(`🔗 API Request: ${config.method?.toUpperCase()} ${config.url}`);
    return config;
  },
  (error) => {
    console.error('❌ Request Error:', error);
    return Promise.reject(error);
  }
);

// Add response interceptor for debugging
api.interceptors.response.use(
  (response) => {
    console.log(`✅ API Response: ${response.status} ${response.statusText}`);
    return response;
  },
  (error) => {
    console.error('❌ API Error:', {
      message: error.message,
      status: error.response?.status,
      statusText: error.response?.statusText,
      url: error.config?.url,
    });
    return Promise.reject(error);
  }
);

// Toggle authentication
export const toggleAuthentication = (enabled, username = 'admin', password = 'admin') => {
  AUTH_CONFIG.enabled = enabled;
  AUTH_CONFIG.username = username;
  AUTH_CONFIG.password = password;

  // Update default headers
  if (enabled) {
    api.defaults.headers['Authorization'] = `Basic ${btoa(`${username}:${password}`)}`;
    console.log(`🔐 Authentication enabled for user: ${username}`);
  } else {
    delete api.defaults.headers['Authorization'];
    console.log('🔓 Authentication disabled');
  }

  return AUTH_CONFIG;
};

// Get current auth status
export const getAuthStatus = () => {
  return {
    enabled: AUTH_CONFIG.enabled,
    username: AUTH_CONFIG.username,
    hasAuthHeader: !!api.defaults.headers['Authorization']
  };
};

// Discover available endpoints
export const discoverEndpoints = async () => {
  try {
    const response = await api.get('/');
    return {
      success: true,
      data: response.data,
      endpoints: response.data.links || {}
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      details: error.response?.data || 'Failed to discover endpoints'
    };
  }
};

// Test authentication with loan records
export const testAuthWithLoans = async (username = 'admin', password = 'admin') => {
  try {
    console.log(`🔐 Testing authentication with ${username}...`);
    const response = await api.get('/loan_record/loan_record', {
      headers: {
        'Authorization': `Basic ${btoa(`${username}:${password}`)}`
      }
    });

    return {
      success: true,
      status: response.status,
      dataCount: response.data?.data?.length || 0,
      hasData: response.data?.data?.length > 0,
      data: response.data,
      message: `Authentication successful for ${username}`
    };
  } catch (error) {
    return {
      success: false,
      status: error.response?.status || 'No response',
      error: error.message,
      details: error.response?.data,
      message: `Authentication failed for ${username}`
    };
  }
};

// Try the specific loan endpoint with different configurations
export const testLoanEndpointDetails = async () => {
  const endpoint = '/loan_record/loan_record';
  const tests = [];

  // Test 1: Basic request (current)
  try {
    console.log(`🔍 Test 1: Basic request to ${endpoint}`);
    const response = await api.get(endpoint);
    tests.push({
      test: 'Basic Request',
      success: true,
      status: response.status,
      dataCount: response.data?.data?.length || 0,
      data: response.data,
      headers: response.headers
    });
  } catch (error) {
    tests.push({
      test: 'Basic Request',
      success: false,
      status: error.response?.status || 'No response',
      error: error.message,
      details: error.response?.data
    });
  }

  // Test 2: With Accept header variations
  try {
    console.log(`🔍 Test 2: With application/json header`);
    const response = await api.get(endpoint, {
      headers: { 'Accept': 'application/json' }
    });
    tests.push({
      test: 'JSON Accept Header',
      success: true,
      status: response.status,
      dataCount: response.data?.data?.length || 0,
      data: response.data
    });
  } catch (error) {
    tests.push({
      test: 'JSON Accept Header',
      success: false,
      status: error.response?.status || 'No response',
      error: error.message,
      details: error.response?.data
    });
  }

  // Test 3: With query parameters
  try {
    console.log(`🔍 Test 3: With pagination parameters`);
    const response = await api.get(`${endpoint}?page[limit]=10&page[offset]=0`);
    tests.push({
      test: 'With Pagination',
      success: true,
      status: response.status,
      dataCount: response.data?.data?.length || 0,
      data: response.data
    });
  } catch (error) {
    tests.push({
      test: 'With Pagination',
      success: false,
      status: error.response?.status || 'No response',
      error: error.message,
      details: error.response?.data
    });
  }

  // Test 4: Check if authentication might be needed
  try {
    console.log(`🔍 Test 4: Testing with basic auth headers`);
    const response = await api.get(endpoint, {
      headers: {
        'Authorization': 'Basic ' + btoa('admin:admin'), // Common test credentials
        'Accept': 'application/vnd.api+json'
      }
    });
    tests.push({
      test: 'With Basic Auth (admin:admin)',
      success: true,
      status: response.status,
      dataCount: response.data?.data?.length || 0,
      data: response.data
    });
  } catch (error) {
    tests.push({
      test: 'With Basic Auth (admin:admin)',
      success: false,
      status: error.response?.status || 'No response',
      error: error.message,
      details: error.response?.data,
      authNote: 'This is just a test - replace with real credentials if needed'
    });
  }

  return tests;
};

// Test what's actually in the JSON:API root
export const inspectJsonApiRoot = async () => {
  try {
    console.log('🔍 Inspecting JSON:API root response...');
    const response = await api.get('/');

    return {
      success: true,
      data: response.data,
      // Look for common JSON:API properties
      hasData: !!response.data.data,
      hasLinks: !!response.data.links,
      hasMeta: !!response.data.meta,
      linksCount: response.data.links ? Object.keys(response.data.links).length : 0,
      // Check for loan-related endpoints in links
      loanEndpoints: response.data.links ?
        Object.keys(response.data.links).filter(key =>
          key.toLowerCase().includes('loan') ||
          key.toLowerCase().includes('record')
        ) : []
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      details: error.response?.data
    };
  }
};
export const testConnection = async () => {
  try {
    const response = await api.get('/');
    return { success: true, data: response.data };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      details: error.response?.data || 'Connection failed'
    };
  }
};

// Fetch loan records function
export const fetchLoanRecords = async () => {
  try {
    const response = await api.get('/loan_record/loan_record');
    return {
      success: true,
      data: response.data.data, // JSON:API data is nested
      meta: response.data.meta,
      count: response.data.data.length
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      details: error.response?.data || 'Failed to fetch loan records'
    };
  }
};

// Export the axios instance for direct use
export { api };

// Export default
export default api;
