import { BrowserRouter, Routes, Route, Link, useLocation } from 'react-router-dom';
import { Home, Layers, ShoppingBag, Trophy, User } from 'lucide-react';

import { SplashLogin } from './pages/SplashLogin';
import { Dashboard } from './pages/Dashboard';
import { Shop } from './pages/Shop';
import { Scoreboard } from './pages/Scoreboard';
import { CourseDetail } from './pages/CourseDetail';
import { useAuth } from './contexts/AuthContext';

// Navigation Component
const BottomNav = () => {
  const location = useLocation();
  const path = location.pathname;
  
  // Hide nav on splash screen
  if (path === '/') return null;

  return (
    <nav className="bottom-nav">
      <Link to="/dashboard" className={`nav-item ${path === '/dashboard' ? 'active' : ''}`}>
        <Home size={24} />
        <span>Home</span>
      </Link>
      <Link to="/courses" className={`nav-item ${path.includes('/courses') ? 'active' : ''}`}>
        <Layers size={24} />
        <span>Courses</span>
      </Link>
      <Link to="/shop" className={`nav-item ${path.includes('/shop') ? 'active' : ''}`}>
        <ShoppingBag size={24} />
        <span>Shop</span>
      </Link>
      <Link to="/scoreboard" className={`nav-item ${path.includes('/scoreboard') ? 'active' : ''}`}>
        <Trophy size={24} />
        <span>Scores</span>
      </Link>
      <Link to="/profile" className={`nav-item ${path.includes('/profile') ? 'active' : ''}`}>
        <User size={24} />
        <span>Profile</span>
      </Link>
    </nav>
  );
};

function App() {
  const { user } = useAuth();

  return (
    <BrowserRouter>
      <div className="app-wrapper">
        <Routes>
          <Route path="/" element={user ? <Dashboard /> : <SplashLogin />} />
          <Route path="/dashboard" element={user ? <Dashboard /> : <SplashLogin />} />
          <Route path="/courses" element={user ? <Dashboard /> : <SplashLogin />} />
          <Route path="/courses/:id" element={user ? <CourseDetail /> : <SplashLogin />} />
          <Route path="/shop" element={user ? <Shop /> : <SplashLogin />} />
          <Route path="/scoreboard" element={user ? <Scoreboard /> : <SplashLogin />} />
          <Route path="/profile" element={user ? <Dashboard /> : <SplashLogin />} />
        </Routes>
        <BottomNav />
      </div>
    </BrowserRouter>
  );
}

export default App;
