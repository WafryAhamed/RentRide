import React, { useState, useEffect } from 'react';
import { FaUsers, FaCarSide, FaCreditCard, FaLocationArrow } from 'react-icons/fa6';
import api from '../api/axios';

const StatCard = ({ title, value, icon: Icon, colorClass }) => (
  <div className="bg-dark-card border border-dark-border rounded-2xl p-6 transition-all hover:border-gray-600 hover:-translate-y-1">
    <div className="flex justify-between items-start">
      <div>
        <p className="text-gray-400 text-sm font-medium mb-1">{title}</p>
        <h3 className="text-3xl font-bold text-white">{value}</h3>
      </div>
      <div className={`p-3 rounded-xl bg-opacity-10 ${colorClass}`}>
        <Icon size={24} className={colorClass.replace('bg-', 'text-').split(' ')[0]} />
      </div>
    </div>
  </div>
);

const DashboardPage = () => {
  const [stats, setStats] = useState({ users: 0, vehicles: 0, payments: 0 });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // In a real scenario we'd hit /stats, but here we can hit the endpoints and count
    const fetchData = async () => {
      try {
        const [uRes, vRes, pRes] = await Promise.all([
          api.get('/admin/users').catch(() => ({ data: { data: [] } })),
          api.get('/admin/vehicles').catch(() => ({ data: { data: [] } })),
          api.get('/admin/payments').catch(() => ({ data: { data: [] } }))
        ]);
        
        setStats({
          users: uRes.data?.data?.length || 0,
          vehicles: vRes.data?.data?.length || 0,
          payments: pRes.data?.data?.length || 0
        });
      } catch (e) {
        console.error("Failed to load dashboard data");
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  return (
    <div className="space-y-6 animate-fade-in pb-10">
      
      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {[1,2,3].map(i => <div key={i} className="h-32 bg-dark-card animate-pulse rounded-2xl"></div>)}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <StatCard title="Total Users" value={stats.users} icon={FaUsers} colorClass="bg-blue-500 text-blue-500" />
          <StatCard title="Platform Vehicles" value={stats.vehicles} icon={FaCarSide} colorClass="bg-green-500 text-green-500" />
          <StatCard title="Payments" value={stats.payments} icon={FaCreditCard} colorClass="bg-orange-500 text-orange-500" />
        </div>
      )}

      {/* Placeholder for future charts or tables */}
      <h3 className="text-xl font-bold mt-10 mb-4 tracking-tight">Recent Activity</h3>
      <div className="bg-dark-card border border-dark-border rounded-2xl h-64 flex flex-col items-center justify-center text-gray-500">
        <FaLocationArrow size={48} className="opacity-20 mb-4" />
         <p>Activity logs will populate here when the backend is connected to the real system streams.</p>
      </div>

    </div>
  );
};

export default DashboardPage;
