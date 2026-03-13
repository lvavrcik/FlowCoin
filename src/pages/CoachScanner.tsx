import { useState } from 'react';
import { Scanner } from '@yudiel/react-qr-scanner';
import { X } from 'lucide-react';

interface CoachScannerProps {
  onScanKid: (kidId: string) => void;
  onClose: () => void;
}

export function CoachScanner({ onScanKid, onClose }: CoachScannerProps) {
  const [errorLine, setErrorLine] = useState('');

  const handleScan = (result: any) => {
    if (result) {
      try {
        const rawText = result[0].rawValue;
        const data = JSON.parse(rawText);
        if (data.type === 'flowcoin-kid' && data.id) {
          onScanKid(data.id);
        } else {
          setErrorLine('Invalid QR Code. Please scan a Rider\'s FlowCoin QR.');
        }
      } catch (err) {
        setErrorLine('Could not read QR. Ask the rider to refresh their screen.');
      }
    }
  };

  return (
    <div style={{
      position: 'fixed', inset: 0, zIndex: 100, 
      backgroundColor: 'var(--bg-base)', 
      display: 'flex', flexDirection: 'column'
    }}>
      <div style={{ padding: '1.5rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h3 style={{ margin: 0 }}>Scan Rider</h3>
        <button className="btn btn-secondary" style={{ padding: '0.5rem', borderRadius: '50%' }} onClick={onClose}>
          <X size={20} />
        </button>
      </div>
      
      <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
        <Scanner 
          onScan={handleScan}
          onError={(error: unknown) => console.log('Scanner error:', error)}
        />
        
        {/* Overlay targeting box */}
        <div style={{ position: 'absolute', inset: 0, display: 'flex', justifyContent: 'center', alignItems: 'center', pointerEvents: 'none' }}>
           <div style={{ width: '250px', height: '250px', border: '2px solid var(--primary)', borderRadius: '1rem', boxShadow: '0 0 0 4000px rgba(0,0,0,0.5)' }}></div>
        </div>
      </div>

      <div style={{ padding: '2rem', textAlign: 'center' }}>
        {errorLine ? (
          <p style={{ color: 'var(--danger)' }}>{errorLine}</p>
        ) : (
          <p>Point camera at a Rider's QR Code</p>
        )}
      </div>
    </div>
  );
}
