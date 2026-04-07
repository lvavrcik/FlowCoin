import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';
import { Trophy, Medal, Users } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

type Profile = Database['public']['Tables']['profiles']['Row'];

export function Scoreboard() {
  const { user } = useAuth();
  const [leaders, setLeaders] = useState<Profile[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchLeaders = async () => {
      if (!user) return;

      let validKidIds: string[] = [];

      try {
        if (user.role === 'coach') {
          // 1. Get all courses this coach manages
          const { data: courses } = await supabase
            .from('course_coaches')
            .select('course_id')
            .eq('coach_id', user.id);

          const courseIds = courses?.map(c => c.course_id) || [];

          if (courseIds.length > 0) {
            // 2. Get all kids enrolled in these courses
            const { data: enrollments } = await supabase
              .from('enrollments')
              .select('kid_id')
              .in('course_id', courseIds);

            validKidIds = enrollments?.map(e => e.kid_id) || [];
          }
        } else if (user.role === 'kid') {
          // 1. Get all courses this kid is enrolled in
          const { data: courses } = await supabase
            .from('enrollments')
            .select('course_id')
            .eq('kid_id', user.id);

          const courseIds = courses?.map(c => c.course_id) || [];

          if (courseIds.length > 0) {
            // 2. Get all OTHER kids enrolled in these same courses
            const { data: enrollments } = await supabase
              .from('enrollments')
              .select('kid_id')
              .in('course_id', courseIds);

            validKidIds = enrollments?.map(e => e.kid_id) || [];
          }
        }

        // Deduplicate the IDs
        validKidIds = Array.from(new Set(validKidIds));

        if (validKidIds.length === 0) {
          setLeaders([]);
          setLoading(false);
          return;
        }

        // Final step: fetch the profile details and rank them
        const { data } = await supabase
          .from('profiles')
          .select('*')
          .eq('role', 'kid')
          .in('id', validKidIds)
          .order('flowcoins_balance', { ascending: false })
          .limit(50);

        if (data) setLeaders(data);
      } catch (err) {
        console.error("Error fetching leaderboard:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchLeaders();
  }, [user]);

  if (loading) return <div className="page-container"><p>Loading scoreboard...</p></div>;

  return (
    <div className="page-container animate-slide-up">
      <div style={{ textAlign: 'center', marginBottom: '2rem', marginTop: '1rem' }} className="stagger-1">
        <Trophy size={48} color="var(--accent)" style={{ margin: '0 auto 1rem auto', filter: 'drop-shadow(0 0 15px rgba(245,158,11,0.5))' }} />
        <h2 style={{ fontSize: '2rem', marginBottom: '0.25rem' }}>Žebříček bikerů</h2>
      </div>

      <div className="glass-panel stagger-2" style={{ padding: '0.5rem', display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
        {leaders.map((kid, index) => (
          <div 
            key={kid.id} 
            style={{ 
              display: 'flex', 
              alignItems: 'center', 
              padding: '1rem', 
              background: index < 3 ? 'rgba(255,255,255,0.05)' : 'transparent',
              borderRadius: 'var(--radius-md)',
              border: index < 3 ? '1px solid var(--border)' : 'none'
            }}
          >
            <div style={{ width: '40px', fontWeight: 800, fontSize: '1.2rem', color: index === 0 ? '#FBBF24' : index === 1 ? '#94A3B8' : index === 2 ? '#B45309' : 'var(--text-muted)' }}>
              {index + 1}
            </div>
            
            <div style={{ flex: 1, fontWeight: 600 }}>
              {kid.first_name} {kid.last_name.charAt(0)}.
              {index === 0 && <Medal size={16} color="#FBBF24" style={{ display: 'inline', marginLeft: '0.5rem' }} />}
            </div>
            
            <div className="coin-display">
              <span className="coin-icon" style={{ width: '0.8em', height: '0.8em', fontSize: '1em' }}>F</span>
              {kid.flowcoins_balance}
            </div>
          </div>
        ))}

        {leaders.length === 0 && (
          <div style={{ textAlign: 'center', padding: '2rem', color: 'var(--text-muted)' }}>
             No riders found.
          </div>
        )}
      </div>
    </div>
  );
}
