import { createClient } from "@supabase/supabase-js";

// Configuração DIRETA (sem arquivos externos)
// Use SEMPRE as chaves reais que você já tem
const SUPABASE_URL = "https://ahlqzzkxuutwoepirpzr.supabase.co";

const SERVICE_ROLE_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo";

export const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: {
    persistSession: false,
  },
});
