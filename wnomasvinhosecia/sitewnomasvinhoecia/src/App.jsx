import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Toaster } from '@/components/ui/toaster';
import HomePage from '@/pages/HomePage';
import ProductPage from '@/pages/ProductPage';
import EducationalPage from '@/pages/EducationalPage';
import DashboardPage from '@/pages/DashboardPage';
import AboutPage from '@/pages/AboutPage';
import WinesAdminPage from '@/pages/admin/WinesAdminPage';
import SuppliersPage from '@/pages/admin/SuppliersPage';
import CostsPage from '@/pages/admin/CostsPage';
import SplashScreen from '@/components/SplashScreen';

function App() {
  const [showSplash, setShowSplash] = useState(true);

  // Check if splash was already shown in this session
  useEffect(() => {
    const splashShown = sessionStorage.getItem('splashShown');
    if (splashShown) {
      setShowSplash(false);
    }
  }, []);

  const handleSplashComplete = () => {
    sessionStorage.setItem('splashShown', 'true');
    setShowSplash(false);
  };

  return (
    <Router>
      {showSplash && <SplashScreen onComplete={handleSplashComplete} />}
      <div className="min-h-screen bg-[#FAF8F5]">
        <Routes>
          {/* Site Público */}
          <Route path="/" element={<HomePage />} />
          <Route path="/product/:id" element={<ProductPage />} />
          <Route path="/como-escolher" element={<EducationalPage />} />
          <Route path="/sobre" element={<AboutPage />} />

          {/* Área Administrativa */}
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/admin/vinhos" element={<WinesAdminPage />} />
          <Route path="/admin/fornecedores" element={<SuppliersPage />} />
          <Route path="/admin/custos" element={<CostsPage />} />
        </Routes>
        <Toaster />
      </div>
    </Router>
  );
}

export default App;
