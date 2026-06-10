import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';
import { useAuth } from '../contexts/AuthContext';
import { Target, CheckCircle, X } from 'lucide-react';

type Skill = Database['public']['Tables']['skills']['Row'];
type KidProfile = Database['public']['Tables']['profiles']['Row'];
type Course = Database['public']['Tables']['courses']['Row'];

type GeneralAction = {
  id: string;
  name: string;
  amount: number;
};

const GENERAL_ACTIONS: GeneralAction[] = [
  { id: 'účast', name: 'Účast', amount: 5 },
  { id: 'pomoc', name: 'Pomoc kamarádovi', amount: 5 },
  { id: 'výhra', name: 'Výhra hry/výzvy', amount: 5 },
  { id: 'vyrušování', name: 'Vyrušování', amount: -5 },
  { id: 'nadávání', name: 'Nadávání', amount: -5 },
];

export function Skills() {
  const { user } = useAuth();
  const [skills, setSkills] = useState<Skill[]>([]);
  const [courses, setCourses] = useState<Course[]>([]);
  const [completedSkillIds, setCompletedSkillIds] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);

  // Coach-specific state
  const [selectedCourseId, setSelectedCourseId] = useState<string | null>(null);
  const [selectedSkill, setSelectedSkill] = useState<Skill | null>(null);
  const [kids, setKids] = useState<KidProfile[]>([]);
  const [kidsCompleted, setKidsCompleted] = useState<Set<string>>(new Set()); 
  const [selectedAction, setSelectedAction] = useState<GeneralAction | null>(null);
  const [recentlyAssignedKids, setRecentlyAssignedKids] = useState<Set<string>>(new Set());
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    const fetchData = async () => {
      if (!user) return;
      setLoading(true);

      let relevantCourseIds: string[] = [];

      if (user.role === 'kid') {
        const { data: enrollments } = await supabase
          .from('enrollments')
          .select('course_id, courses(*)')
          .eq('kid_id', user.id);
          
        if (enrollments) {
          relevantCourseIds = enrollments.map(e => e.course_id);
          const activeCourses = enrollments.map(e => e.courses as unknown as Course).filter(Boolean);
          setCourses(activeCourses);
        }

        const { data: activeSkills } = await supabase
          .from('kid_skills')
          .select('skill_id')
          .eq('kid_id', user.id);
          
        if (activeSkills) {
          setCompletedSkillIds(new Set(activeSkills.map(s => s.skill_id)));
        }

      } else if (user.role === 'coach') {
        const { data: cCoaches } = await supabase
          .from('course_coaches')
          .select('course_id, courses(*)')
          .eq('coach_id', user.id);

        if (cCoaches) {
          relevantCourseIds = cCoaches.map(c => c.course_id);
          const activeCourses = cCoaches.map(c => c.courses as unknown as Course).filter(Boolean);
          setCourses(activeCourses);
          if (activeCourses.length > 0) {
            setSelectedCourseId(activeCourses[0].id);
          }
        }
      }

      // Load skills for relevant courses
      const { data: sData } = await supabase
        .from('skills')
        .select('*')
        .order('created_at', { ascending: true });
        
      if (sData) {
        if (relevantCourseIds.length > 0) {
          const filteredSkills = sData.filter(s => s.course_id === null || relevantCourseIds.includes(s.course_id as string));
          setSkills(filteredSkills);
        } else {
          const filteredSkills = sData.filter(s => s.course_id === null);
          setSkills(filteredSkills);
        }
      }
      
      setLoading(false);
    };

    fetchData();
  }, [user]);

  // When coach selects a skill, load the kids FOR THAT SPECIFIC COURSE
  const openSkillModal = async (skill: Skill) => {
    if (user?.role !== 'coach') return;
    
    // Find which kids already completed this skill
    const { data: completed } = await supabase
      .from('kid_skills')
      .select('kid_id')
      .eq('skill_id', skill.id);
      
    if (completed) {
      setKidsCompleted(new Set(completed.map(d => d.kid_id)));
    } else {
      setKidsCompleted(new Set());
    }

    // Load kids for the course this skill belongs to (or selected course if global skill)
    const targetCourseId = skill.course_id || selectedCourseId;
    if (targetCourseId) {
      const { data: enrollments } = await supabase
        .from('enrollments')
        .select('profiles(*)')
        .eq('course_id', targetCourseId);

      if (enrollments) {
        const mappedKids = enrollments.map(e => e.profiles as unknown as KidProfile).filter(Boolean);
        mappedKids.sort((a, b) => a.first_name.localeCompare(b.first_name));
        setKids(mappedKids);
      }
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

  const openGeneralActionModal = async (action: GeneralAction) => {
    if (user?.role !== 'coach' || !selectedCourseId) return;
    
    // Load kids for the selected course
    const { data: enrollments } = await supabase
      .from('enrollments')
      .select('profiles(*)')
      .eq('course_id', selectedCourseId);

    if (enrollments) {
      const mappedKids = enrollments.map(e => e.profiles as unknown as KidProfile).filter(Boolean);
      mappedKids.sort((a, b) => a.first_name.localeCompare(b.first_name));
      setKids(mappedKids);
    }
    
    setSelectedAction(action);
  };

  const handleGeneralAction = async (kid: KidProfile) => {
    if (!selectedAction || !user || recentlyAssignedKids.has(kid.id)) return;

    const { error: txError } = await supabase
      .from('transactions')
      .insert({
        kid_id: kid.id,
        coach_id: user.id,
        amount: selectedAction.amount,
        custom_reason: selectedAction.name
      });

    if (!txError) {
      setRecentlyAssignedKids(prev => new Set(prev).add(kid.id));
      setTimeout(() => {
        setRecentlyAssignedKids(prev => {
          const newSet = new Set(prev);
          newSet.delete(kid.id);
          return newSet;
        });
      }, 2000);
    } else {
      alert("Error assigning " + selectedAction.name);
    }
  };

  if (loading) return <div className="page-container"><p>Loading...</p></div>;

  const currentSkills = user?.role === 'coach' && selectedCourseId
    ? skills.filter(s => s.course_id === selectedCourseId || s.course_id === null)
    : skills;

  return (
    <div className="page-container animate-slide-up" style={{ paddingBottom: '7rem' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem', flexWrap: 'wrap', gap: '1rem' }}>
        <h2 style={{ fontSize: '1.8rem', display: 'flex', alignItems: 'center', gap: '0.5rem', margin: 0 }}>
          <Target size={24} color="var(--primary)" />
          Dovednosti
        </h2>
        
        {user?.role === 'coach' && courses.length > 0 && (
          <select 
            value={selectedCourseId || ''} 
            onChange={(e) => setSelectedCourseId(e.target.value)}
            className="input-field"
            style={{ width: 'auto', minWidth: '200px' }}
          >
            {courses.map(c => (
              <option key={c.id} value={c.id}>{c.name}</option>
            ))}
          </select>
        )}
      </div>

      {user?.role === 'coach' && (
        <>
          <h3 style={{ fontSize: '1.4rem', marginBottom: '1rem', color: 'var(--text-muted)' }}>Obecné</h3>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(180px, 1fr))', gap: '1rem', marginBottom: '2rem' }}>
            {GENERAL_ACTIONS.map((action, index) => (
              <div 
                key={action.id} 
                className={`card stagger-${(index % 4) + 1}`}
                style={{
                  display: 'flex', 
                  justifyContent: 'space-between', 
                  alignItems: 'center',
                  padding: '1rem',
                  borderLeft: action.amount > 0 ? '4px solid var(--secondary)' : '4px solid var(--danger)',
                  cursor: 'pointer'
                }}
                onClick={() => openGeneralActionModal(action)}
                role="button"
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                  <h4 style={{ fontSize: '1.1rem', margin: 0 }}>
                    {action.name}
                  </h4>
                </div>
                <div className="coin-display" style={{ fontSize: '1.1rem', background: 'rgba(0,0,0,0.2)' }}>
                  {action.amount > 0 ? '+' : ''}{action.amount}
                </div>
              </div>
            ))}
          </div>
          <h3 style={{ fontSize: '1.4rem', marginBottom: '1rem', color: 'var(--text-muted)' }}>Dovednosti</h3>
        </>
      )}

      <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
        {currentSkills.map((skill, index) => {
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

        {currentSkills.length === 0 && (
          <div style={{ textAlign: 'center', padding: '3rem', color: 'var(--text-muted)' }}>
            Pro tento kurz zatím nejsou definovány žádné dovednosti.
          </div>
        )}
      </div>

      {/* Coach Modal */}
      {(selectedSkill || selectedAction) && user?.role === 'coach' && (
        <div className="modal-overlay" onClick={() => { setSelectedSkill(null); setSelectedAction(null); setSearchQuery(''); }}>
          <div className="glass-panel modal-content animate-slide-up" onClick={(e) => e.stopPropagation()}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
              <div>
                <h3 style={{ fontSize: '1.3rem', marginBottom: '0.25rem' }}>
                  {selectedSkill ? selectedSkill.name : selectedAction?.name}
                </h3>
                <p style={{ color: 'var(--text-muted)', fontSize: '0.9rem' }}>
                  {selectedSkill ? `Přiřadit +${selectedSkill.flowcoins_reward} FlowCoins` : `Transakce: ${selectedAction?.amount! > 0 ? '+' : ''}${selectedAction?.amount} FlowCoins`}
                </p>
              </div>
              <button 
                onClick={() => { setSelectedSkill(null); setSelectedAction(null); setSearchQuery(''); }}
                className="btn btn-secondary"
                style={{ padding: '0.5rem', borderRadius: '50%' }}
              >
                <X size={20} />
              </button>
            </div>

            {kids.length > 5 && (
              <input
                type="text"
                placeholder="Vyhledat jezdce..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="input-field"
                style={{ marginBottom: '1rem', padding: '0.5rem 0.8rem', fontSize: '0.95rem' }}
              />
            )}

            <div style={{ overflowY: 'auto', flex: 1, paddingRight: '0.5rem' }}>
              {kids.length === 0 ? (
                <p style={{ textAlign: 'center', marginTop: '2rem', color: 'var(--text-muted)' }}>V tomto kurzu nejsou žádní jezdci.</p>
              ) : (
                (() => {
                  const filteredKids = kids.filter(kid => 
                    `${kid.first_name} ${kid.last_name}`.toLowerCase().includes(searchQuery.toLowerCase())
                  );

                  if (filteredKids.length === 0) {
                    return <p style={{ textAlign: 'center', marginTop: '2rem', color: 'var(--text-muted)' }}>Žádný jezdec neodpovídá hledání.</p>;
                  }

                  return filteredKids.map(kid => {
                    if (selectedSkill) {
                      const isCompleted = kidsCompleted.has(kid.id);
                      return (
                        <div 
                          key={kid.id}
                          style={{
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center',
                            padding: '0.75rem 0.5rem',
                            borderBottom: '1px solid var(--border)'
                          }}
                        >
                          <span style={{ fontWeight: 600, fontSize: '1.05rem' }}>{kid.first_name} {kid.last_name}</span>
                          <button 
                            className={`btn ${isCompleted ? 'btn-secondary' : 'btn-primary'}`}
                            disabled={isCompleted}
                            onClick={() => markSkillCompleted(kid)}
                            style={{ padding: '0.4rem 0.8rem', fontSize: '0.9rem' }}
                          >
                            {isCompleted ? 'Hotovo' : 'Přiřadit'}
                          </button>
                        </div>
                      );
                    } else if (selectedAction) {
                      const recentlyAssigned = recentlyAssignedKids.has(kid.id);
                      const isPositive = selectedAction.amount > 0;
                      return (
                        <div 
                          key={kid.id}
                          style={{
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center',
                            padding: '0.75rem 0.5rem',
                            borderBottom: '1px solid var(--border)'
                          }}
                        >
                          <span style={{ fontWeight: 600, fontSize: '1.05rem' }}>{kid.first_name} {kid.last_name}</span>
                          <button 
                            className={`btn ${recentlyAssigned ? 'btn-secondary' : (isPositive ? 'btn-primary' : 'btn-danger')}`}
                            disabled={recentlyAssigned}
                            onClick={() => handleGeneralAction(kid)}
                            style={{ padding: '0.4rem 0.8rem', fontSize: '0.9rem', color: recentlyAssigned ? undefined : 'white', background: recentlyAssigned ? undefined : (isPositive ? 'var(--secondary)' : 'var(--danger)') }}
                          >
                            {recentlyAssigned ? 'Přiřazeno!' : (isPositive ? 'Přičíst' : 'Odečíst')}
                          </button>
                        </div>
                      );
                    }
                    return null;
                  });
                })()
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
