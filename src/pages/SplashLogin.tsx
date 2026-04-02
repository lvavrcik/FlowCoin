import React, { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { Camera, LogIn, Lock } from 'lucide-react';

export function SplashLogin() {
  const { loginAsCoach, loginAsKid, loading } = useAuth();
  const [isKidMode, setIsKidMode] = useState(true);
  
  // Form State
  const [pin, setPin] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [isSubmitLoading, setIsSubmitLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setIsSubmitLoading(true);

    let authError = null;

    if (isKidMode) {
      if (!pin || pin.length < 4) {
        setError('Please enter your full PIN');
        setIsSubmitLoading(false);
        return;
      }
      const res = await loginAsKid(pin);
      authError = res.error;
    } else {
      if (!email || !password) {
        setError('Please enter your email and password');
        setIsSubmitLoading(false);
        return;
      }
      const res = await loginAsCoach(email, password);
      authError = res.error;
    }

    setIsSubmitLoading(false);

    if (authError) {
      setError(authError.message || 'Login failed. Please try again.');
    }
  };

  if (loading) {
     return (
       <div className="page-container" style={{ justifyContent: 'center', alignItems: 'center' }}>
         <div className="animate-pulse-slow">
            <div style={{ fontSize: '4rem', filter: 'drop-shadow(0 0 20px rgba(79,70,229,0.8))' }}>💎</div>
         </div>
       </div>
     );
  }

  return (
    <div className="page-container" style={{ justifyContent: 'center', alignItems: 'center', paddingBottom: '2rem' }}>
      
      {/* Brand Header */}
      <div className="animate-slide-up stagger-1" style={{ marginBottom: '2.5rem', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
        <div className="animate-pulse-slow" style={{ marginBottom: '1rem' }}>
          <div style={{ 
            fontSize: '4.5rem', 
            filter: 'drop-shadow(0 0 30px rgba(245,158,11,0.6))',
            background: 'linear-gradient(135deg, #FCD34D, #F59E0B)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            display: 'inline-block'
          }}>💎</div>
        </div>
        <h1 style={{ fontSize: '2.5rem', marginBottom: '0.5rem', textAlign: 'center', background: 'linear-gradient(to right, #fff, #cbd5e1)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
          FlowCoins
        </h1>
        <p style={{ textAlign: 'center', color: 'var(--text-muted)' }}>The ultimate riding reward system</p>
      </div>
      
      {/* Role Toggle */}
      <div className="glass-panel animate-slide-up stagger-2" style={{ 
        display: 'flex', 
        padding: '0.35rem', 
        borderRadius: 'var(--radius-full)',
        marginBottom: '2rem',
        width: '100%',
        maxWidth: '300px'
      }}>
        <button 
          type="button"
          onClick={() => { setIsKidMode(true); setError(''); }}
          style={{
            flex: 1,
            padding: '0.6rem',
            borderRadius: 'var(--radius-full)',
            border: 'none',
            background: isKidMode ? 'var(--primary)' : 'transparent',
            color: isKidMode ? '#fff' : 'var(--text-muted)',
            fontWeight: 600,
            fontSize: '0.875rem',
            transition: 'all var(--transition-fast)',
            cursor: 'pointer'
          }}
        >
          Biker (PIN)
        </button>
        <button 
          type="button"
          onClick={() => { setIsKidMode(false); setError(''); }}
          style={{
            flex: 1,
            padding: '0.6rem',
            borderRadius: 'var(--radius-full)',
            border: 'none',
            background: !isKidMode ? 'var(--bg-surface)' : 'transparent',
            color: !isKidMode ? '#fff' : 'var(--text-muted)',
            fontWeight: 600,
            fontSize: '0.875rem',
            transition: 'all var(--transition-fast)',
            cursor: 'pointer'
          }}
        >
          Kouč
        </button>
      </div>

      {/* Login Form */}
      <form onSubmit={handleSubmit} className="animate-slide-up stagger-3" style={{ width: '100%', maxWidth: '320px' }}>
        
        {error && (
          <div style={{ backgroundColor: 'rgba(239,68,68,0.1)', color: 'var(--danger)', padding: '0.75rem', borderRadius: 'var(--radius-md)', marginBottom: '1rem', fontSize: '0.875rem', textAlign: 'center', border: '1px solid rgba(239,68,68,0.2)' }}>
            {error}
          </div>
        )}

        {isKidMode ? (
          <>
            <div className="input-group">
              <label className="input-label" style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                <Lock size={16} /> Vlož svůj 4-místný pin
              </label>
              <input 
                type="password" 
                maxLength={6}
                inputMode="numeric"
                className="input-field" 
                placeholder="____" 
                value={pin}
                onChange={(e) => setPin(e.target.value.replace(/\D/g, ''))} // numbers only
                style={{ fontSize: '1.5rem', textAlign: 'center', letterSpacing: '1rem' }}
              />
            </div>
            {/* Future improvement: QR login */}
            <button type="button" className="btn btn-secondary" style={{ width: '100%', marginBottom: '1.25rem', padding: '0.6rem' }}>
              <Camera size={18} /> Or scan QR Code
            </button>
          </>
        ) : (
          <>
            <div className="input-group">
              <label className="input-label">Email</label>
              <input 
                type="email" 
                className="input-field" 
                placeholder="coach@example.com" 
                value={email}
                onChange={e => setEmail(e.target.value)}
              />
            </div>
            <div className="input-group">
              <label className="input-label">Heslo</label>
              <input 
                type="password" 
                className="input-field" 
                placeholder="••••••••" 
                value={password}
                onChange={e => setPassword(e.target.value)}
              />
            </div>
          </>
        )}

        <button 
          type="submit" 
          className="btn btn-primary animate-pulse-slow" 
          style={{ width: '100%', marginTop: '0.5rem', padding: '1rem' }}
          disabled={isSubmitLoading}
        >
          {isSubmitLoading ? 'Loading...' : (isKidMode ? 'Jdeme shredit!' : 'Přihlášení')}
          {!isSubmitLoading && <LogIn size={20} />}
        </button>
        
      </form>
    </div>
  );
}
