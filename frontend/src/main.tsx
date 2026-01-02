import React from "react";
import ReactDOM from "react-dom/client";

import App from "./App";
import { AuthProvider } from "@/auth/AuthContext";
import { ToastProvider } from "@/components/ui/ToastProvider";

import "@fontsource/oswald";
import "@fontsource/poppins";

// Tailwind
import "@/index.css";

// Estilos do sistema
import "@/styles/wg-system.css";
import "@/styles/wg-sidebar.css";
import "@/styles/layout.css";
import "@/styles/touch-targets.css";

const root = document.getElementById("root")!;

ReactDOM.createRoot(root).render(
  <React.StrictMode>
    <ToastProvider>
      <AuthProvider>
        <App />
      </AuthProvider>
    </ToastProvider>
  </React.StrictMode>
);
