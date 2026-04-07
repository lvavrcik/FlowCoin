import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';
import { useAuth } from '../contexts/AuthContext';
import { Target, CheckCircle, X } from 'lucide-react';

type Skill = Database['public']['Tables']['skills']['Row'];
type KidProfile = Database['public']['Tables']['profiles']['Row'];

export function Skills() {
  const { user } = useAuth();
  const [skills, setSkills] = useState<Skill[]>([]);
  const [completedSkillIds, setCompletedSkillIds] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);

  // Coach-specific state
  const [selectedSkill, setSelectedSkill] = useState<Skill | null>(null);
  const [kids, setKids] = useState<KidProfile[]>([]);
  const [kidsCompleted, setKidsCompleted] = useState<Set<string>>(new Set()); 

  useEffect(() => {
    const fetchSkills = async () => {
      // Load all skills
      const { data: sData } = await supabase
        .from('skills')
        .select('*')
        .order('created_at', { ascending: true });
        
      if (sData) setSkills(sData);

      if (user?.role === 'kid') {
        const { data: activeSkills } = await supabase
          .from('kid_skills')
          .select('skill_id')
          .eq('kid_id', user.id);
          
        if (activeSkills) {
          setCompletedSkillIds(new Set(activeSkills.map(s => s.skill_id)));
        }
      } else if (user?.role === 'coach') {
        // Load all kids this coach manages
        const { data: courses } = await supabase
          .from('course_coaches')
          .select('course_id')
          .eq('coach_id', user.id);

        const courseIds = courses?.map(c => c.course_id) || [];

        if (courseIds.length > 0) {
          const { data: enrollments } = await supabase
            .from('enrollments')
            .select('profiles(*)')
            .in('course_id', courseIds);

          if (enrollments) {
            const mappedKids = enrollments.map(e => e.profiles as unknown as KidProfile).filter(Boolean);
            // Deduplicate kids across courses
            const uniqueKids = Array.from(new Map(mappedKids.map(k => [k.id, k])).values());
            uniqueKids.sort((a, b) => a.first_name.localeCompare(b.first_name));
            setKids(uniqueKids);
          }
        }
      }
      
      setLoading(false);
    };

    fetchSkills();
  }, [user]);

  const openSkillModal = async (skill: Skill) => {
    if (user?.role !== 'coach') return;
    
    // Find which kids already completed this skill
    const { data } = await supabase
      .from('kid_skills')
      .select('kid_id')
      .eq('skill_id', skill.id);
      
    if (data) {
      setKidsCompleted(new Set(data.map(d => d.kid_id)));
    } else {
      setKidsCompleted(new Set());
    }
    
    setSelectedSkill(skill);
  };

  const markSkillCompleted = async (kid: KidProfile) => {
    if (!selectedSkill || !user) return;
    if (kidsCompleted.has(kid.id)) return;

    // Insert skill
    const { error: skillError } = await supabase
      .from('kid_skills')
      .insert({
        kid_id: kid.id,
        skill_id: selectedSkill.id,
        coach_id: user.id
      });

    if (skillError) {
      alert("Error marking skill done");
      return;
    }

    // Insert transaction (FlowCoins reward)
    const { error: txError } = await supabase
      .from('transactions')
      .insert({
        kid_id: kid.id,
        coach_id: user.id,
        amount: selectedSkill.flowcoins_reward,
        custom_reason: `Dokončena dovednost: ${selectedSkill.name}`
      });

    if (!txError) {
      setKidsCompleted(prev => new Set(prev).add(kid.id));
    }
  };

  if (loading) return <div className="page-container"><p>Loading...</p></div>;

  return (
    <div className="page-container animate-slide-up" style={{ paddingBottom: '7rem' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
        <h2 style={{ fontSize: '1.8rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Target size={24} color="var(--primary)" />
          Dovednosti
        </h2>
      </div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
        {skills.map((skill, index) => {
          const isDone = completedSkillIds.has(skill.id);
          return (
            <div 
              key={skill.id} 
              className={`card stagger-${(index % 4) + 1}`}
              style={{
                display: 'flex', 
                justifyContent: 'space-between', 
                alignItems: 'center',
                padding: '1.25rem',
                borderLeft: user?.role === 'coach' ? '4px solid var(--primary)' : (isDone ? '4px solid var(--secondary)' : '4px solid var(--border)'),
                opacity: (user?.role === 'kid' && isDone) ? 0.7 : 1,
                cursor: user?.role === 'coach' ? 'pointer' : 'default'
              }}
              onClick={() => openSkillModal(skill)}
              role={user?.role === 'coach' ? "button" : "presentation"}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                {user?.role === 'kid' && isDone && <CheckCircle size={20} color="var(--secondary)" />}
                <h3 style={{ fontSize: '1.2rem', margin: 0, textDecoration: (user?.role === 'kid' && isDone) ? 'line-through' : 'none' }}>
                  {skill.name}
                </h3>
              </div>
              <div className="coin-display" style={{ fontSize: '1.2rem', background: 'rgba(0,0,0,0.2)' }}>
                <span className="coin-icon" style={{ width: '0.8em', height: '0.8em', fontSize: '0.8em' }}>F</span>
                {skill.flowcoins_reward}
              </div>
            </div>
          );
        })}

        {skills.length === 0 && (
          <div style={{ textAlign: 'center', padding: '3rem', color: 'var(--text-muted)' }}>
            Žádné dovednosti.
          </div>
        )}
      </div>

      {/* Coach Modal */}
      {selectedSkill && user?.role === 'coach' && (
        <div style={{
          position: 'fixed',
          top: 0, left: 0, right: 0, bottom: 0,
          background: 'rgba(0,0,0,0.8)',
          display: 'flex',
          alignItems: 'flex-end',
          zIndex: 1000
        }}>
          <div className="glass-panel animate-slide-up" style={{
            width: '100%',
            height: '80vh',
            borderBottomLeftRadius: 0,
            borderBottomRightRadius: 0,
            padding: '1.5rem',
            display: 'flex',
            flexDirection: 'column'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
              <div>
                <h3 style={{ fontSize: '1.3rem', marginBottom: '0.25rem' }}>{selectedSkill.name}</h3>
                <p style={{ color: 'var(--text-muted)' }}>Assign +{selectedSkill.flowcoins_reward} FlowCoins</p>
              </div>
              <button 
                onClick={() => setSelectedSkill(null)}
                className="btn btn-secondary"
                style={{ padding: '0.5rem', borderRadius: '50%' }}
              >
                <X size={20} />
              </button>
            </div>

            <div style={{ overflowY: 'auto', flex: 1, paddingRight: '0.5rem' }}>
              {kids.length === 0 ? (
                <p style={{ textAlign: 'center', marginTop: '2rem', color: 'var(--text-muted)' }}>No riders found.</p>
              ) : (
                kids.map(kid => {
                  const isCompleted = kidsCompleted.has(kid.id);
                  return (
                    <div 
                      key={kid.id}
                      style={{
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        padding: '1rem',
                        borderBottom: '1px solid var(--border)'
                      }}
                    >
                      <span style={{ fontWeight: 600, fontSize: '1.1rem' }}>{kid.first_name} {kid.last_name}</span>
                      <button 
                        className={`btn ${isCompleted ? 'btn-secondary' : 'btn-primary'}`}
                        disabled={isCompleted}
                        onClick={() => markSkillCompleted(kid)}
                        style={{ padding: '0.5rem 1rem' }}
                      >
                        {isCompleted ? 'Hotovo' : 'Označit jako hotové'}
                      </button>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
