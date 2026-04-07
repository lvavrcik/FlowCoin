import { useEffect, useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { LogOut, QrCode, ArrowRight } from 'lucide-react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';

type Season = Database['public']['Tables']['seasons']['Row'];
type Course = Database['public']['Tables']['courses']['Row'];

export function Dashboard() {
  const { user, logout } = useAuth();
  const [showQR, setShowQR] = useState(false);

  if (!user) return null;

  return (
    <div className="page-container animate-slide-up">
      {/* Header Profile Area */}
      <div className="glass-panel" style={{ padding: '1.5rem', marginBottom: '1rem', position: 'relative', overflow: 'hidden' }}>
        <div style={{ position: 'absolute', top: '-20px', right: '-20px', width: '100px', height: '100px', background: 'radial-gradient(circle, rgba(79,70,229,0.3) 0%, transparent 70%)', borderRadius: '50%' }} />
        
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', position: 'relative', zIndex: 10 }}>
          <div>
            <p className="input-label" style={{ color: 'var(--primary)' }}>
              {user.role === 'coach' ? 'Kouč' : 'Biker'}
            </p>
            <h2 style={{ fontSize: '1.8rem', marginBottom: '0.5rem' }}>
              Ahoj, {user.first_name}!
            </h2>
          </div>
          <button onClick={logout} className="btn" style={{ padding: '0.5rem', background: 'rgba(255,255,255,0.1)', border: '1px solid var(--border)', backdropFilter: 'blur(4px)' }}>
            <LogOut size={18} />
          </button>
        </div>

        {user.role === 'kid' && (
          <div style={{ marginTop: '1rem', background: 'rgba(0,0,0,0.2)', padding: '1rem', borderRadius: 'var(--radius-md)' }}>
            <p className="input-label" style={{ marginBottom: '0.25rem' }}>Tvoje FlowCoiny</p>
            <div style={{ fontSize: '3rem', fontWeight: '800', display: 'flex', alignItems: 'center', gap: '0.5rem', color: 'var(--text-main)', textShadow: '0 2px 10px rgba(0,0,0,0.5)' }}>
              <span className="coin-icon" style={{ width: '0.8em', height: '0.8em' }}>F</span>
              {user.flowcoins_balance || 0}
            </div>
            
            
            <div style={{ display: 'flex', gap: '0.5rem', marginTop: '1rem' }}>
              <button 
                className="btn btn-primary" 
                style={{ flex: 1, padding: '0.5rem' }}
                onClick={() => setShowQR(prev => !prev)}
              >
                <QrCode size={16} /> Můj QR kód
              </button>
              <button 
                className="btn btn-accent" 
                style={{ flex: 1, padding: '0.5rem' }}
                onClick={() => window.location.href = '/shop'}
              >
                Obchod
              </button>
            </div>
          </div>
        )}
      </div>

      {user.role === 'kid' && showQR && <KidQRDisplay kidId={user.id} name={user.first_name} />}
      {user.role === 'coach' ? <CoachDashboard /> : <KidDashboard kidId={user.id} />}
    </div>
  );
}

import { CoachScanner } from './CoachScanner';
import { ActionPanel } from './ActionPanel';
import { KidQRDisplay } from './KidQRDisplay';
import { useNavigate } from 'react-router-dom';

function CoachDashboard() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [activeSeason, setActiveSeason] = useState<Season | null>(null);
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);
  
  // Scanner state
  const [isScanning, setIsScanning] = useState(false);
  const [selectedKidId, setSelectedKidId] = useState<string | null>(null);

  useEffect(() => {
    if (!user) return;

    const fetchDashData = async () => {
      // Get current active season
      const { data: seasonData } = await supabase
        .from('seasons')
        .select('*')
        .eq('is_active', true)
        .single();
        
      if (seasonData) {
        setActiveSeason(seasonData);
        // Get courses for this coach in this season using the new join table
        const { data: cols } = await supabase
          .from('course_coaches')
          .select('courses(*)')
          .eq('coach_id', user.id);
          
        if (cols) {
          // Filter to only courses in the active season
          // Note: in a real app, you'd do this via a unified join or view, 
          // but filtering here works perfectly for a small dataset
          const validCourses = cols
            .map(c => c.courses as unknown as Course)
            .filter(c => c && c.season_id === seasonData.id);

          validCourses.sort((a,b) => a.name.localeCompare(b.name));
          setCourses(validCourses);
        }
      }
      setLoading(false);
    };

    fetchDashData();
  }, [user]);

  if (loading) return <div style={{ textAlign: 'center', padding: '2rem' }}>Loading...</div>;

  return (
    <div className="stagger-1">
      <h3 style={{ marginBottom: '1rem', display: 'flex', justifyContent: 'space-between' }}>
        Moje kurzy
        {activeSeason && <span style={{ fontSize: '0.8rem', fontWeight: 'normal', color: 'var(--primary)', background: 'rgba(79,70,229,0.1)', padding: '0.2rem 0.6rem', borderRadius: 'var(--radius-full)' }}>{activeSeason.name}</span>}
      </h3>
      
      {courses.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '3rem 1rem', background: 'rgba(0,0,0,0.1)', borderRadius: 'var(--radius-md)' }}>
           <p>No courses assigned for the active season.</p>
        </div>
      ) : (
        <div style={{ display: 'grid', gap: '1rem' }}>
          {courses.map(course => (
            <div 
              key={course.id} 
              className="card" 
              style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', cursor: 'pointer' }}
              onClick={() => navigate(`/courses/${course.id}`)}
              role="button"
            >
              <div>
                <h4 style={{ fontSize: '1.1rem', marginBottom: '0.25rem' }}>{course.name}</h4>
                {/* Normally we'd join with enrollments to get a count, for now just a placeholder */}
                <p style={{ fontSize: '0.875rem' }}>Náhled</p>
              </div>
              <button className="btn btn-secondary" style={{ padding: '0.5rem', borderRadius: '50%' }} tabIndex={-1}>
                <ArrowRight size={20} />
              </button>
            </div>
          ))}
        </div>
      )}

      <div style={{ marginTop: '2rem' }}>
        <button className="btn btn-primary" style={{ width: '100%', padding: '1rem' }} onClick={() => setIsScanning(true)}>
          <QrCode size={20} />
          Scan Rider QR Code
        </button>
      </div>

      {isScanning && (
        <CoachScanner 
          onScanKid={(kidId) => {
            setIsScanning(false);
            setSelectedKidId(kidId);
          }} 
          onClose={() => setIsScanning(false)} 
        />
      )}

      {selectedKidId && (
        <ActionPanel 
          kidId={selectedKidId} 
          onClose={() => {
            setSelectedKidId(null);
            // Optionally could trigger a refresh of course data here if needed
          }} 
        />
      )}
    </div>
  );
}

function KidDashboard({ kidId }: { kidId: string }) {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const [transactions, setTransactions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTransactions = async () => {
      const { data } = await supabase
        .from('transactions')
        .select(`
          id, amount, created_at,
          activities (name, icon)
        `)
        .eq('kid_id', kidId)
        .order('created_at', { ascending: false })
        .limit(5);

      setTransactions(data || []);
      setLoading(false);
    };

    fetchTransactions();
  }, [kidId]);

  return (
    <div className="stagger-1">
      <h3 style={{ marginBottom: '1rem', fontSize: '1.2rem' }}>Recent Flow</h3>
      
      {loading ? (
        <p>Loading...</p>
      ) : transactions.length === 0 ? (
        <div style={{ textAlign: 'center', padding: '2rem 1rem', background: 'rgba(0,0,0,0.1)', borderRadius: 'var(--radius-md)' }}>
           <p>No FlowCoins yet! Keep riding!</p>
        </div>
      ) : (
        <div style={{ display: 'grid', gap: '0.75rem' }}>
          {transactions.map(t => (
            <div key={t.id} className="card" style={{ padding: '1rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderLeft: t.amount > 0 ? '4px solid var(--secondary)' : '4px solid var(--danger)' }}>
               <div>
                 <p style={{ fontWeight: '600', marginBottom: '0.2rem' }}>
                   {t.activities?.name || 'Manual Adjustment'}
                 </p>
                 <p style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                   {new Date(t.created_at).toLocaleDateString()}
                 </p>
               </div>
               <div style={{ fontSize: '1.25rem', fontWeight: '800', color: t.amount > 0 ? 'var(--secondary)' : 'var(--danger)' }}>
                 {t.amount > 0 ? '+' : ''}{t.amount}
               </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
