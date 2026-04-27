import React, { createContext, useContext, useState, useEffect } from 'react';
import api from '../api/axios';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [token, setToken] = useState(localStorage.getItem('token') || null);
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // Initialize and validate token
  useEffect(() => {
    let mounted = true;
    const decodeAndSet = async () => {
      if (token) {
        try {
          const mod = await import('jwt-decode');
          const fn = mod?.default || mod;
          const decoded = fn(token);
          // Ensure not expired
          if (decoded.exp * 1000 < Date.now()) {
            logout();
          } else if (mounted) {
            setUser({
              ...decoded,
            });
          }
        } catch (error) {
          console.error('Invalid token format', error);
          logout();
        }
      } else {
        if (mounted) setUser(null);
      }
      if (mounted) setLoading(false);
    };

    decodeAndSet();

    return () => { mounted = false; };
  }, [token]);

  // Handle global 401 events dispatched from axios
  useEffect(() => {
    const handleUnauthorized = () => logout();
    window.addEventListener('auth:unauthorized', handleUnauthorized);
    return () => window.removeEventListener('auth:unauthorized', handleUnauthorized);
  }, []);

  const login = async (email, password) => {
    // Support a local mock-login flow for quick local dev without backend.
    // Enable by setting localStorage.setItem('MOCK_ADMIN', 'true') in the browser devtools,
    // or by setting Vite env var VITE_MOCK_AUTH=true and restarting the dev server.
    const mockEnabled = localStorage.getItem('MOCK_ADMIN') === 'true' || import.meta.env.VITE_MOCK_AUTH === 'true';
    if (mockEnabled) {
      // create a simple unsigned JWT-like token (header.payload.sig) — sufficient for jwt-decode usage
      const base64Url = (obj) => {
        const s = JSON.stringify(obj);
        return btoa(unescape(encodeURIComponent(s))).replace(/=+$/g, '').replace(/\+/g, '-').replace(/\//g, '_');
      };
      const now = Math.floor(Date.now() / 1000);
      const payload = { user_id: 1, email, role: 'ADMIN', iat: now, exp: now + 60 * 60 * 24 * 365 * 10 };
      const header = { alg: 'none', typ: 'JWT' };
      const fakeToken = `${base64Url(header)}.${base64Url(payload)}.`;
      localStorage.setItem('token', fakeToken);
      setToken(fakeToken);
      return;
    }
    // Calling backend auth service explicitly via api gateway
    const res = await api.post('/auth/login', { email, password });
    const { access_token } = res.data.data;
    
    // Quick decode to check role *before* accepting login
    const mod = await import('jwt-decode');
    const fn = mod?.default || mod;
    const decoded = fn(access_token);
    const userRole = (decoded.role || '').toUpperCase();
    if (userRole !== "ADMIN") {
      throw new Error("Insufficient permissions. Admins only.");
    }

    localStorage.setItem('token', access_token);
    setToken(access_token);
  };

  const logout = () => {
    localStorage.removeItem('token');
    setToken(null);
    setUser(null);
    // Let ProtectedRoute handle redirection based on null user
  };

  return (
    <AuthContext.Provider value={{ token, user, role: user?.role, loading, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
