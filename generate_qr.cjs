const QRCode = require('qrcode');

const url = 'https://flow-coin.vercel.app/';
const outputPath = './flowcoins-qr.png';

// Generate a high-resolution QR code
QRCode.toFile(outputPath, url, {
  color: {
    dark: '#0f172a',  // Slate 900 perfectly matches the theme
    light: '#ffffff' // White background
  },
  width: 1024, // High resolution for printing
  margin: 2
}, function (err) {
  if (err) throw err;
  console.log('Successfully generated flowcoins-qr.png!');
});
