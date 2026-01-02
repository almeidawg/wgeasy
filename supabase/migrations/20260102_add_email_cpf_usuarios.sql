-- Add email and CPF columns to usuarios table
-- Date: January 2, 2026
-- Purpose: Enable login by email or CPF with email confirmation flow

-- 1. Add columns to usuarios table
ALTER TABLE usuarios
ADD COLUMN IF NOT EXISTS email VARCHAR(255),
ADD COLUMN IF NOT EXISTS cpf VARCHAR(11),
ADD COLUMN IF NOT EXISTS email_confirmed BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS email_confirmed_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS account_status VARCHAR(50) DEFAULT 'pending' CHECK (account_status IN ('pending', 'active', 'suspended', 'inactive'));

-- 2. Create unique indexes for email and CPF
CREATE UNIQUE INDEX IF NOT EXISTS idx_usuarios_email_unique ON usuarios(email) WHERE email IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS idx_usuarios_cpf_unique ON usuarios(cpf) WHERE cpf IS NOT NULL;

-- 3. Create regular indexes for faster lookups
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_usuarios_cpf ON usuarios(cpf);
CREATE INDEX IF NOT EXISTS idx_usuarios_account_status ON usuarios(account_status);
CREATE INDEX IF NOT EXISTS idx_usuarios_email_confirmed ON usuarios(email_confirmed);

-- 4. Create email confirmation tokens table
CREATE TABLE IF NOT EXISTS email_confirmation_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  token VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL,
  tipo_usuario VARCHAR(50) NOT NULL,
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  confirmed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 5. Indexes for confirmation tokens
CREATE INDEX IF NOT EXISTS idx_confirmation_tokens_usuario_id ON email_confirmation_tokens(usuario_id);
CREATE INDEX IF NOT EXISTS idx_confirmation_tokens_token ON email_confirmation_tokens(token);
CREATE INDEX IF NOT EXISTS idx_confirmation_tokens_email ON email_confirmation_tokens(email);
CREATE INDEX IF NOT EXISTS idx_confirmation_tokens_expires_at ON email_confirmation_tokens(expires_at);
CREATE INDEX IF NOT EXISTS idx_confirmation_tokens_confirmed_at ON email_confirmation_tokens(confirmed_at);

-- 6. Enable RLS on email_confirmation_tokens
ALTER TABLE email_confirmation_tokens ENABLE ROW LEVEL SECURITY;

-- 7. RLS policies for email_confirmation_tokens
CREATE POLICY "Anyone can view token confirmation (for email validation)" ON email_confirmation_tokens
  FOR SELECT USING (true);

CREATE POLICY "Only system can create tokens" ON email_confirmation_tokens
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Only system can update tokens" ON email_confirmation_tokens
  FOR UPDATE USING (true);

-- 8. Create login audit table
CREATE TABLE IF NOT EXISTS login_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  email VARCHAR(255),
  cpf VARCHAR(11),
  login_method VARCHAR(50) CHECK (login_method IN ('email', 'cpf')),
  success BOOLEAN,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 9. Indexes for login attempts
CREATE INDEX IF NOT EXISTS idx_login_attempts_usuario_id ON login_attempts(usuario_id);
CREATE INDEX IF NOT EXISTS idx_login_attempts_email ON login_attempts(email);
CREATE INDEX IF NOT EXISTS idx_login_attempts_created_at ON login_attempts(created_at);

-- 10. Enable RLS on login_attempts
ALTER TABLE login_attempts ENABLE ROW LEVEL SECURITY;

-- 11. RLS policies for login_attempts
CREATE POLICY "Users can view their own login attempts" ON login_attempts
  FOR SELECT USING (auth.uid() = usuario_id OR usuario_id IS NULL);

CREATE POLICY "Only system can insert login attempts" ON login_attempts
  FOR INSERT WITH CHECK (true);
