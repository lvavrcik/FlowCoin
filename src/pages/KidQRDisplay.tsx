import { QRCodeSVG } from 'qrcode.react';

interface KidQRDisplayProps {
  kidId: string;
  name: string;
}

export function KidQRDisplay({ kidId, name }: KidQRDisplayProps) {
  // We'll generate a URL that, if scanned by a standard phone camera, 
  // opens the app. Here, we just encode the kidId for the coach to scan within the app.
  const qrData = JSON.stringify({ type: 'flowcoin-kid', id: kidId });

  return (
    <div className="card text-center" style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', margin: '2rem 0' }}>
      <p style={{ marginBottom: '1rem', fontWeight: 600 }}>Scan to award FlowCoins to {name}</p>
      
      <div style={{ background: '#fff', padding: '1rem', borderRadius: '1rem', display: 'inline-block' }}>
        <QRCodeSVG 
          value={qrData} 
          size={200}
          bgColor={"#ffffff"}
          fgColor={"#0F172A"}
          level={"Q"}
        />
      </div>
      
      <p style={{ marginTop: '1rem', fontSize: '0.875rem', color: 'var(--text-muted)' }}>
        Show this to your coach
      </p>
    </div>
  );
}
