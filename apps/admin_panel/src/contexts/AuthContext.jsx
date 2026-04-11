import React, { createContext, useContext, useState, useEffect } from 'react';
import { jwtDecode } from 'jwt-decode';
import api from '../api/axios';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [token, setToken] = useState(localStorage.getItem('token') || null);
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  // Initialize and validate token
  useEffect(() => {
    if (token) {
      try {
        const decoded = jwtDecode(token);
        // Ensure not expired
        if (decoded.exp * 1000 < Date.now()) {
          logout();
        } else {
          setUser({
            ...decoded,
            // the backend middleware passes role, typically stored directly in claims payload
          });
        }
      } catch (error) {
        console.error("Invalid token format", error);
        logout();
      }
    } else {
      setUser(null);
    }
    setLoading(false);
  }, [token]);

  // Handle global 401 events dispatched from axios
  useEffect(() => {
    const handleUnauthorized = () => logout();
    window.addEventListener('auth:unauthorized', handleUnauthorized);
    return () => window.removeEventListener('auth:unauthorized', handleUnauthorized);
  }, []);

  const login = async (email, password) => {
    // Calling backend auth service explicitly via api gateway
    const res = await api.post('/auth/login', { email, password });
    const { access_token } = res.data.data;
    
    // Quick decode to check role *before* accepting login
    const decoded = jwtDecode(access_token);
    if (decoded.role !== "ADMIN") {
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
