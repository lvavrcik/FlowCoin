import { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';
import { X, CheckCircle, AlertTriangle } from 'lucide-react';

type Activity = Database['public']['Tables']['activities']['Row'];
type Profile = Database['public']['Tables']['profiles']['Row'];

interface ActionPanelProps {
  kidId: string;
  onClose: () => void;
}

export function ActionPanel({ kidId, onClose }: ActionPanelProps) {
  const { user } = useAuth(); // The coach
  const [kid, setKid] = useState<Profile | null>(null);
  const [activities, setActivities] = useState<Activity[]>([]);
  const [loading, setLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    const loadData = async () => {
      // Load kid profile
      const { data: kData } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', kidId)
        .single();
      
      if (kData) setKid(kData);

      // Load action catalog
      const { data: aData } = await supabase
        .from('activities')
        .select('*')
        .order('default_coins', { ascending: false });

      if (aData) setActivities(aData);
      setLoading(false);
    };

    loadData();
  }, [kidId]);

  const handleTransaction = async (activity: Activity) => {
    if (!user || !kid || isSubmitting) return;

    try {
      setIsSubmitting(true);

      const { error } = await supabase
        .from('transactions')
        .insert({
          kid_id: kid.id,
          coach_id: user.id,
          amount: activity.default_coins,
          activity_id: activity.id,
          custom_reason: null
        });

      if (error) throw error;
      
      setSuccess(true);
      setTimeout(() => {
        onClose();
      }, 1500);

    } catch (err: any) {
      alert("Failed to award coins: " + err.message);
      setIsSubmitting(false);
    }
  };

  if (loading) return (
    <div style={{ position: 'fixed', inset: 0, zIndex: 100, backgroundColor: 'rgba(15,23,42,0.9)', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
      <p>Loading Rider...</p>
    </div>
  );

  if (!kid) return (
    <div style={{ position: 'fixed', inset: 0, zIndex: 100, backgroundColor: 'rgba(15,23,42,0.9)', display: 'flex', justifyContent: 'center', alignItems: 'center', flexDirection: 'column', gap: '1rem' }}>
      <AlertTriangle color="var(--danger)" size={48} />
      <p>Rider not found</p>
      <button className="btn btn-secondary" onClick={onClose}>Close</button>
    </div>
  );

  return (
    <div style={{
      position: 'fixed', inset: 0, zIndex: 100, 
      backgroundColor: 'rgba(15,23,42,0.95)', 
      backdropFilter: 'blur(8px)',
      display: 'flex', flexDirection: 'column',
      padding: '2rem 1.5rem',
      overflowY: 'auto'
    }}>
      <div className="card glass-panel animate-slide-up" style={{ position: 'relative', marginTop: '10vh' }}>
        
        <button 
          className="btn btn-secondary" 
          onClick={onClose}
          style={{ position: 'absolute', top: '-1rem', right: '-1rem', padding: '0.5rem', borderRadius: '50%', zIndex: 10 }}
        >
          <X size={20} />
        </button>

        {success ? (
          <div style={{ textAlign: 'center', padding: '3rem 1rem' }} className="animate-pulse-slow">
            <CheckCircle size={64} color="var(--secondary)" style={{ margin: '0 auto 1rem auto' }} />
            <h3 style={{ fontSize: '1.5rem', color: 'var(--secondary)' }}>Coins Awarded!</h3>
          </div>
        ) : (
          <>
            <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
              <p className="input-label">Awarding to</p>
              <h2 style={{ fontSize: '2rem' }}>{kid.first_name} {kid.last_name}</h2>
              <p style={{ color: 'var(--text-muted)' }}>Current Balance: {kid.flowcoins_balance}</p>
            </div>

            <h4 style={{ marginBottom: '1rem', borderBottom: '1px solid var(--border)', paddingBottom: '0.5rem' }}>Select Action</h4>
            
            <div style={{ display: 'grid', gap: '0.75rem', maxHeight: '50vh', overflowY: 'auto', paddingRight: '0.5rem' }}>
              {activities.map(activity => (
                <button 
                  key={activity.id}
                  onClick={() => handleTransaction(activity)}
                  disabled={isSubmitting}
                  className={`btn ${activity.default_coins > 0 ? 'btn-secondary' : 'btn-danger'}`}
                  style={{ 
                    justifyContent: 'space-between', 
                    padding: '1rem', 
                    borderRadius: 'var(--radius-md)',
                    borderLeft: activity.default_coins > 0 ? '4px solid var(--secondary)' : '4px solid var(--danger)'
                  }}
                >
                  <span style={{ fontWeight: 600 }}>{activity.name}</span>
                  <span style={{ 
                    fontWeight: 800, 
                    fontSize: '1.25rem',
                    color: activity.default_coins > 0 ? 'var(--secondary)' : 'var(--danger)'
                  }}>
                    {activity.default_coins > 0 ? '+' : ''}{activity.default_coins}
                  </span>
                </button>
              ))}

              {activities.length === 0 && (
                <p style={{ textAlign: 'center', color: 'var(--text-muted)', fontStyle: 'italic' }}>No activities configured in database.</p>
              )}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
