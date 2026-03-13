import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';
import { ArrowLeft, UserPlus, FileEdit } from 'lucide-react';
import { ActionPanel } from './ActionPanel';

type KidProfile = Database['public']['Tables']['profiles']['Row'];
type Course = Database['public']['Tables']['courses']['Row'];

export function CourseDetail() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { user } = useAuth();

  const [course, setCourse] = useState<Course | null>(null);
  const [kids, setKids] = useState<KidProfile[]>([]);
  const [loading, setLoading] = useState(true);

  // Track selected kid to pop up the action panel directly from the list
  const [selectedKidId, setSelectedKidId] = useState<string | null>(null);

  useEffect(() => {
    if (!id || user?.role !== 'coach') {
      setLoading(false);
      return;
    }

    const loadData = async () => {
      // Fetch course details
      const { data: cData } = await supabase
        .from('courses')
        .select('*')
        .eq('id', id)
        .single();

      if (cData) setCourse(cData);

      // Fetch kids enrolled in this course
      // We query profiles by doing an inner join basically through enrollments
      const { data: eData } = await supabase
        .from('enrollments')
        .select('profiles(*)')
        .eq('course_id', id);

      if (eData) {
        // eData looks like [{ profiles: { id: ..., ... } }, ...]
        // The foreign key join returns a single linked object or an array of them. We know it's a single profile per enrollment.
        const mappedKids = eData.map(e => e.profiles as unknown as KidProfile).filter(Boolean);
        // Sort alphabetically
        mappedKids.sort((a, b) => a.first_name.localeCompare(b.first_name));
        setKids(mappedKids);
      }

      setLoading(false);
    };

    loadData();
  }, [id, user]);

  const handleActionClose = () => {
    setSelectedKidId(null);
    // Refresh balance by fetching kids again implicitly 
    // Usually we would just re-fetch the specific kid or list to see updated balance.
    // Given the small data set, we can just trigger a reload or optimistic update.
    navigate(0); // refresh data to show new balance
  };

  if (loading) return <div className="page-container"><p>Loading course...</p></div>;
  if (!course) return <div className="page-container"><p>Course not found.</p></div>;

  return (
    <div className="page-container animate-slide-up" style={{ paddingBottom: '7rem' }}>

      {/* Header back button */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginBottom: '1.5rem' }}>
        <button onClick={() => navigate(-1)} className="btn btn-secondary" style={{ padding: '0.5rem', borderRadius: '50%' }}>
          <ArrowLeft size={20} />
        </button>
        <h2 style={{ fontSize: '1.5rem', margin: 0 }}>{course.name}</h2>
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h3 style={{ fontSize: '1.1rem', color: 'var(--text-muted)' }}>Enrolled Riders ({kids.length})</h3>
        <button className="btn" style={{ background: 'transparent', padding: '0.25rem', color: 'var(--primary)', border: 'none', display: 'flex', gap: '0.25rem', alignItems: 'center', fontSize: '0.875rem' }}>
          <UserPlus size={16} /> Manage
        </button>
      </div>

      <div className="glass-panel" style={{ display: 'flex', flexDirection: 'column' }}>
        {kids.map((kid, index) => (
          <div
            key={kid.id}
            className="stagger-1"
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              padding: '1rem',
              borderBottom: index < kids.length - 1 ? '1px solid var(--border)' : 'none'
            }}
          >
            <div>
              <p style={{ fontWeight: 600, fontSize: '1.1rem' }}>
                {kid.first_name} {kid.last_name}
              </p>
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginTop: '0.25rem' }}>
                <p style={{ fontSize: '0.875rem', color: 'var(--text-muted)' }}>PIN: <span style={{ fontFamily: 'monospace', letterSpacing: '0.2em' }}>{kid.pin_code}</span></p>
              </div>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
              <div className="coin-display" style={{ fontSize: '1.1rem', background: 'rgba(0,0,0,0.2)', padding: '0.3rem 0.6rem', borderRadius: 'var(--radius-full)' }}>
                <span className="coin-icon" style={{ width: '0.8em', height: '0.8em', fontSize: '0.8em' }}>F</span>
                {kid.flowcoins_balance}
              </div>

              <button
                className="btn btn-primary"
                style={{ padding: '0.5rem', borderRadius: '50%' }}
                onClick={() => setSelectedKidId(kid.id)}
              >
                <FileEdit size={16} />
              </button>
            </div>
          </div>
        ))}

        {kids.length === 0 && (
          <div style={{ padding: '2rem', textAlign: 'center', color: 'var(--text-muted)' }}>
            No riders enrolled.
          </div>
        )}
      </div>

      {selectedKidId && (
        <ActionPanel
          kidId={selectedKidId}
          onClose={handleActionClose}
        />
      )}
    </div>
  );
}
