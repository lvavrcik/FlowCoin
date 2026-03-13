import { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';
import type { Database } from '../lib/database.types';
import { ShoppingCart, Check, PackageOpen } from 'lucide-react';

type MerchItem = Database['public']['Tables']['merch_items']['Row'];
type Purchase = Database['public']['Tables']['purchases']['Row'] & {
  merch_items?: { name: string, image_url: string };
  profiles?: { first_name: string, last_name: string };
};

export function Shop() {
  const { user } = useAuth();
  const [items, setItems] = useState<MerchItem[]>([]);
  const [pendingPurchases, setPendingPurchases] = useState<Purchase[]>([]);
  const [loading, setLoading] = useState(true);
  const [buyingId, setBuyingId] = useState<string | null>(null);
  
  // Need to track live balance for kids
  const [liveBalance, setLiveBalance] = useState(user?.flowcoins_balance || 0);

  useEffect(() => {
    if (user?.role === 'kid') {
      setLiveBalance(user.flowcoins_balance || 0);
    }
  }, [user]);

  useEffect(() => {
    const loadData = async () => {
      // Load Shop items
      const { data: mData } = await supabase
        .from('merch_items')
        .select('*')
        .order('cost', { ascending: true });
        
      if (mData) setItems(mData);

      // If coach, load pending purchases
      if (user?.role === 'coach') {
        const { data: pData } = await supabase
          .from('purchases')
          .select('*, merch_items(name, image_url), profiles(first_name, last_name)')
          .eq('status', 'pending');
          
        if (pData) setPendingPurchases(pData as any[]);
      }
      
      setLoading(false);
    };

    loadData();
  }, [user]);

  const handleBuy = async (item: MerchItem) => {
    if (!user || user.role !== 'kid') return;
    
    if (liveBalance < item.cost) {
      alert("Not enough FlowCoins!");
      return;
    }

    if (!confirm(`Buy ${item.name} for ${item.cost} FlowCoins?`)) return;

    setBuyingId(item.id);
    
    // Create purchase record
    const { error } = await supabase
      .from('purchases')
      .insert({
        kid_id: user.id,
        merch_item_id: item.id
      });

    if (!error) {
      // Optimistically update UI balance tracking since trigger handles it in DB
      setLiveBalance(prev => prev - item.cost);
      alert("Purchased! Tell your coach to collect it.");
    } else {
      alert("Purchase failed: " + error.message);
    }
    
    setBuyingId(null);
  };

  const fulfillPurchase = async (purchaseId: string) => {
    if (user?.role !== 'coach') return;
    
    const { error } = await supabase
      .from('purchases')
      .update({ status: 'fulfilled' })
      .eq('id', purchaseId);
      
    if (!error) {
      setPendingPurchases(prev => prev.filter(p => p.id !== purchaseId));
    }
  };

  if (loading) return <div className="page-container"><p>Loading shop...</p></div>;

  return (
    <div className="page-container animate-slide-up">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h2 style={{ fontSize: '1.8rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <ShoppingCart size={24} color="var(--primary)" />
          Merch Shop
        </h2>
        {user?.role === 'kid' && (
          <div className="coin-display" style={{ fontSize: '1.25rem' }}>
            <span className="coin-icon">F</span> {liveBalance}
          </div>
        )}
      </div>

      {user?.role === 'coach' && pendingPurchases.length > 0 && (
        <div className="card" style={{ borderLeft: '4px solid var(--accent)', marginBottom: '1rem' }}>
          <h3 style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '1rem' }}>
            <PackageOpen size={18} color="var(--accent)" /> Pending Orders
          </h3>
          <div style={{ display: 'grid', gap: '0.5rem' }}>
            {pendingPurchases.map(p => (
              <div key={p.id} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', background: 'rgba(0,0,0,0.2)', padding: '0.75rem', borderRadius: 'var(--radius-sm)' }}>
                <div>
                  <p style={{ fontWeight: 600 }}>{p.profiles?.first_name} {p.profiles?.last_name}</p>
                  <p style={{ fontSize: '0.875rem', color: 'var(--text-muted)' }}>{p.merch_items?.name}</p>
                </div>
                <button className="btn btn-secondary" onClick={() => fulfillPurchase(p.id)} style={{ padding: '0.5rem' }}>
                  <Check size={16} color="var(--secondary)" /> Handed over
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(140px, 1fr))', gap: '1rem', marginTop: '1rem' }}>
        {items.map((item, i) => (
          <div key={item.id} className={`card glass-panel stagger-${(i % 4) + 1}`} style={{ padding: '1rem', display: 'flex', flexDirection: 'column' }}>
            <div style={{ 
              width: '100%', 
              aspectRatio: '1', 
              background: item.image_url ? `url(${item.image_url}) center/cover` : 'var(--bg-surface-elevated)',
              borderRadius: 'var(--radius-sm)',
              marginBottom: '1rem',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center'
            }}>
              {!item.image_url && <ShoppingCart size={32} color="var(--text-muted)" opacity={0.5} />}
            </div>
            
            <h4 style={{ flex: 1, marginBottom: '0.5rem', fontSize: '1rem' }}>{item.name}</h4>
            
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 'auto' }}>
              <div className="coin-display" style={{ fontSize: '1.1rem' }}>
                 <span className="coin-icon" style={{ width: '1em', height: '1em', fontSize: '0.6em' }}>F</span>
                 {item.cost}
              </div>
              
              {user?.role === 'kid' && (
                <button 
                  onClick={() => handleBuy(item)}
                  disabled={buyingId === item.id || liveBalance < item.cost || (item.stock === 0)}
                  className={`btn ${liveBalance >= item.cost ? 'btn-primary' : 'btn-secondary'}`}
                  style={{ padding: '0.4rem 0.8rem', fontSize: '0.875rem' }}
                >
                  {buyingId === item.id ? '...' : (item.stock === 0 ? 'Sold Out' : 'Buy')}
                </button>
              )}
            </div>
          </div>
        ))}

        {items.length === 0 && (
          <div style={{ gridColumn: '1 / -1', textAlign: 'center', padding: '3rem', color: 'var(--text-muted)' }}>
            <p>No merch available yet.</p>
          </div>
        )}
      </div>

    </div>
  );
}
