import React, { useState } from 'react';
import { useNavigate, Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { Car, Lock, Mail, Loader2, AlertCircle } from 'lucide-react';

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { login, user } = useAuth();
  const navigate = useNavigate();

  // Redirect if already logged in
  if (user && user.role === "ADMIN") {
    return <Navigate to="/" replace />;
  }

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await login(email, password);
      // Let standard rerendering push us to dashboard since user object changes
      navigate("/", { replace: true });
    } catch (err) {
      if (err.response?.data?.error) {
        setError(err.response.data.error);
      } else {
        setError(err.message || 'An unexpected error occurred');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-dark flex flex-col justify-center py-12 px-6 lg:px-8 font-sans text-gray-100">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <div className="flex justify-center mb-6">
          <div className="bg-primary/20 p-4 rounded-3xl border border-primary/30 shadow-lg shadow-primary/10">
            <Car size={48} className="text-primary" />
          </div>
        </div>
        <h2 className="text-center text-3xl font-bold tracking-tight text-white mb-2">
          RentRide Workspace
        </h2>
        <p className="text-center text-sm text-gray-400">
          Sign in into your admin panel
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-dark-card border border-dark-border py-8 px-8 shadow-2xl sm:rounded-2xl">
          
          {error && (
            <div className="mb-6 bg-red-500/10 border border-red-500/50 p-4 rounded-xl flex items-start gap-3">
              <AlertCircle size={20} className="text-red-400 mt-0.5" />
              <p className="text-red-200 text-sm">{error}</p>
            </div>
          )}

          <form className="space-y-6" onSubmit={handleLogin}>
            <div>
              <label className="block text-sm font-medium text-gray-300">
                Email Address
              </label>
              <div className="mt-2 relative rounded-xl shadow-sm">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Mail className="h-5 w-5 text-gray-500" />
                </div>
                <input
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="block w-full pl-11 bg-dark/50 border border-dark-border rounded-xl py-3 text-white placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary transition-all sm:text-sm"
                  placeholder="admin@rentride.com"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-300">
                Password
              </label>
              <div className="mt-2 relative rounded-xl shadow-sm">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <Lock className="h-5 w-5 text-gray-500" />
                </div>
                <input
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="block w-full pl-11 bg-dark/50 border border-dark-border rounded-xl py-3 text-white placeholder-gray-500 focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary transition-all sm:text-sm"
                  placeholder="••••••••"
                />
              </div>
            </div>

            <div className="pt-2">
              <button
                type="submit"
                disabled={loading || !email || !password}
                className="w-full flex justify-center py-3 px-4 rounded-xl text-sm font-bold text-dark bg-primary hover:bg-yellow-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary focus:ring-offset-dark disabled:opacity-50 disabled:cursor-not-allowed transition-all shadow-lg shadow-primary/20"
              >
                {loading ? (
                  <Loader2 className="animate-spin h-5 w-5 text-dark" />
                ) : (
                  'Secure Login'
                )}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
