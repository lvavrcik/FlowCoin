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
  
  // Track kid's own purchases for limits
  const [kidPurchases, setKidPurchases] = useState<Database['public']['Tables']['purchases']['Row'][]>([]);
  
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

      // If kid, load their purchases to check limits
      if (user?.role === 'kid') {
        const { data: kpData } = await supabase
          .from('purchases')
          .select('*')
          .eq('kid_id', user.id)
          .neq('status', 'cancelled');
          
        if (kpData) setKidPurchases(kpData);
      }

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

  const getPurchaseCount = (itemId: string) => {
    return kidPurchases.filter(p => p.merch_item_id === itemId).length;
  };

  const handleBuy = async (item: MerchItem) => {
    if (!user || user.role !== 'kid') return;
    
    // Check purchase limit
    if (item.purchase_limit && item.purchase_limit > 0) {
      const alreadyBought = getPurchaseCount(item.id);
      if (alreadyBought >= item.purchase_limit) {
        alert(`Už jsi vyčerpal limit pro tento předmět: ${item.name} (max ${item.purchase_limit}x)`);
        return;
      }
    }
    
    if (liveBalance < item.cost) {
      alert("Not enough FlowCoins!");
      return;
    }

    if (!confirm(`Buy ${item.name} for ${item.cost} FlowCoins?`)) return;

    setBuyingId(item.id);
    
    // Create purchase record
    const { data, error } = await supabase
      .from('purchases')
      .insert({
        kid_id: user.id,
        merch_item_id: item.id
      })
      .select();

    if (!error) {
      // Optimistically update UI balance tracking since trigger handles it in DB
      setLiveBalance(prev => prev - item.cost);
      if (data && data.length > 0) {
        setKidPurchases(prev => [...prev, data[0]]);
      }
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
          Obchod
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
            <PackageOpen size={18} color="var(--accent)" /> Nevyřízené objednávky
          </h3>
          <div style={{ display: 'grid', gap: '0.5rem' }}>
            {pendingPurchases.map(p => (
              <div key={p.id} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', background: 'rgba(0,0,0,0.2)', padding: '0.75rem', borderRadius: 'var(--radius-sm)' }}>
                <div>
                  <p style={{ fontWeight: 600 }}>{p.profiles?.first_name} {p.profiles?.last_name}</p>
                  <p style={{ fontSize: '0.875rem', color: 'var(--text-muted)' }}>{p.merch_items?.name}</p>
                </div>
                <button className="btn btn-secondary" onClick={() => fulfillPurchase(p.id)} style={{ padding: '0.5rem' }}>
                  <Check size={16} color="var(--secondary)" /> Vyřízeno
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(140px, 1fr))', gap: '1rem', marginTop: '1rem' }}>
        {items.map((item, i) => {
          const alreadyBought = getPurchaseCount(item.id);
          const hasReachedLimit = item.purchase_limit && item.purchase_limit > 0 && alreadyBought >= item.purchase_limit;
          const isSoldOut = item.stock === 0;

          return (
            <div key={item.id} className={`card glass-panel stagger-${(i % 4) + 1}`} style={{ padding: '1.25rem 1rem', display: 'flex', flexDirection: 'column', justifyContent: 'space-between', minHeight: '120px' }}>
              <div>
                <h4 style={{ marginBottom: '0.25rem', fontSize: '1.05rem', fontWeight: 600 }}>{item.name}</h4>
                {item.purchase_limit && item.purchase_limit > 0 && (
                  <p style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginBottom: '0.5rem' }}>
                    Limit: {user?.role === 'kid' ? `${alreadyBought}/${item.purchase_limit}` : `${item.purchase_limit} na osobu`}
                  </p>
                )}
              </div>
              
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 'auto' }}>
                <div className="coin-display" style={{ fontSize: '1.1rem' }}>
                   <span className="coin-icon" style={{ width: '1em', height: '1em', fontSize: '0.6em' }}>F</span>
                   {item.cost}
                </div>
                
                {user?.role === 'kid' && (
                  <button 
                    onClick={() => handleBuy(item)}
                    disabled={buyingId === item.id || liveBalance < item.cost || isSoldOut || hasReachedLimit}
                    className={`btn ${liveBalance >= item.cost && !hasReachedLimit && !isSoldOut ? 'btn-primary' : 'btn-secondary'}`}
                    style={{ padding: '0.4rem 0.8rem', fontSize: '0.875rem' }}
                  >
                    {buyingId === item.id ? '...' : (isSoldOut ? 'Sold Out' : (hasReachedLimit ? 'Limit' : 'Nákup'))}
                  </button>
                )}
              </div>
            </div>
          );
        })}

        {items.length === 0 && (
          <div style={{ gridColumn: '1 / -1', textAlign: 'center', padding: '3rem', color: 'var(--text-muted)' }}>
            <p>Zatím tu nic není. Těš se na doplnění!</p>
          </div>
        )}
      </div>

    </div>
  );
}
