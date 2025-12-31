import React from 'react';
import ReactDOM from 'react-dom/client';
import App from '@/App';
import '@/index.css';
import { WineProvider } from '@/contexts/WineContext';

ReactDOM.createRoot(document.getElementById('root')).render(
  <WineProvider>
    <App />
  </WineProvider>
);
