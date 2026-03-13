import React, { createContext, useContext, useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';

type Profile = Database['public']['Tables']['profiles']['Row'];

interface AuthContextType {
  user: Profile | null;
  loading: boolean;
  loginAsCoach: (email: string, pass: string) => Promise<{ error: Error | null }>;
  loginAsKid: (pin: string) => Promise<{ error: Error | null }>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check active session on load
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session?.user) {
        fetchProfile(session.user.id);
      } else {
        // Also check if we have a kid session stored locally
        const kidId = localStorage.getItem('flowcoins_kid_id');
        if (kidId) {
          fetchKidProfile(kidId);
        } else {
          setLoading(false);
        }
      }
    });

    // Listen for auth changes (for coaches)
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        fetchProfile(session.user.id);
      } else {
        // Only clear if it wasn't a kid session
        if (!localStorage.getItem('flowcoins_kid_id')) {
           setUser(null);
        }
        setLoading(false);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  const fetchProfile = async (userId: string) => {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('user_id', userId)
      .single();
      
    if (!error && data) {
      setUser(data);
    } else {
      console.error("Error fetching coach profile", error);
    }
    setLoading(false);
  };

  const fetchKidProfile = async (profileId: string) => {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', profileId)
      .single();
      
    if (!error && data) {
      setUser(data);
    } else {
       localStorage.removeItem('flowcoins_kid_id');
    }
    setLoading(false);
  };

  const loginAsCoach = async (email: string, pass: string) => {
    try {
      setLoading(true);
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password: pass,
      });
      return { error };
    } finally {
      if (!user) setLoading(false); // only set to false if fetchProfile hasn't run yet
    }
  };

  const loginAsKid = async (pin: string) => {
    try {
      setLoading(true);
      // Since kids just use PIN, we query the profile directly. 
      // NOTE: In a real high-security app, we'd use a server function. 
      // For this, we assume RLS allows reading profiles to find the PIN, or we use a secure edge function.
      // Easiest approach for now: Query the DB for the PIN.
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('role', 'kid')
        .eq('pin_code', pin)
        .single();

      if (error || !data) {
        throw new Error("Invalid PIN");
      }

      localStorage.setItem('flowcoins_kid_id', data.id);
      setUser(data);
      return { error: null };
    } catch (error: any) {
      return { error };
    } finally {
      setLoading(false);
    }
  };

  const logout = async () => {
    await supabase.auth.signOut();
    localStorage.removeItem('flowcoins_kid_id');
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, loginAsCoach, loginAsKid, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
