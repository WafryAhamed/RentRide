import React from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { FaGaugeHigh, FaUsers, FaCarSide, FaCreditCard, FaRightFromBracket, FaLocationArrow } from 'react-icons/fa6';
import { useAuth } from '../contexts/AuthContext';

const SIDEBAR_ITEMS = [
  { path: '/', label: 'Overview', icon: FaGaugeHigh },
  { path: '/users', label: 'Users', icon: FaUsers },
  { path: '/vehicles', label: 'Vehicles', icon: FaCarSide },
  { path: '/payments', label: 'Payments', icon: FaCreditCard },
  { path: '/rides', label: 'Rides', icon: FaLocationArrow },
];

const Layout = () => {
  const location = useLocation();
  const { logout, user } = useAuth();

  return (
    <div className="flex h-screen bg-dark">
      {/* Sidebar */}
      <aside className="w-64 bg-dark-card border-r border-dark-border flex flex-col">
        <div className="p-6">
          <h1 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-primary to-orange-400">RentRide Admin</h1>
        </div>
        
        <nav className="flex-1 px-4 space-y-2 mt-4">
          {SIDEBAR_ITEMS.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.path;
            return (
              <Link
                key={item.path}
                to={item.path}
                className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${
                  isActive 
                    ? 'bg-primary/10 text-primary border border-primary/20 shadow-sm shadow-primary/5' 
                    : 'text-gray-400 hover:text-white hover:bg-white/5'
                }`}
              >
                <Icon size={20} className={isActive ? 'text-primary' : ''} />
                <span className="font-medium">{item.label}</span>
              </Link>
            )
          })}
        </nav>

        <div className="p-4 mt-auto">
          <button 
            onClick={logout}
            className="flex items-center gap-3 px-4 py-3 w-full text-red-400 hover:text-red-300 hover:bg-red-500/10 rounded-xl transition-all"
          >
            <FaRightFromBracket size={20} />
            <span className="font-medium">Logout</span>
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-auto flex flex-col relative">
        {/* Top Header */}
        <header className="h-16 border-b border-dark-border flex items-center justify-between px-8 absolute top-0 w-full bg-dark/80 backdrop-blur-md z-10">
          <h2 className="text-lg font-semibold text-gray-200 capitalize">
            {location.pathname === '/' ? 'Dashboard Overview' : location.pathname.substring(1)}
          </h2>
          <div className="flex items-center gap-4">
            <div className="w-8 h-8 rounded-full bg-primary/20 border border-primary/40 flex items-center justify-center text-primary font-bold shadow-sm shadow-primary/20">
              {user?.email ? user.email.charAt(0).toUpperCase() : 'A'}
            </div>
          </div>
        </header>
        
        {/* Content Body */}
        <div className="p-8 mt-16 pt-8 pb-12 w-full max-w-7xl mx-auto h-full overflow-y-auto">
          <Outlet />
        </div>
      </main>
    </div>
  );
};

export default Layout;
