-- 1. Table Profiles (Extends Auth Users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid REFERENCES auth.users NOT NULL PRIMARY KEY,
  username text UNIQUE,
  email text,
  avatar_url text,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  
  CONSTRAINT username_length CHECK (char_length(username) >= 3)
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policies Profiles
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public profiles are viewable by everyone.') THEN
        CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can insert their own profile.') THEN
        CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can update own profile.') THEN
        CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING (auth.uid() = id);
    END IF;
END $$;

-- 2. Table Portfolio Holdings
CREATE TABLE IF NOT EXISTS public.portfolio_holdings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id),
    coin_id text NOT NULL,
    symbol text NOT NULL,
    name text NOT NULL,
    amount numeric NOT NULL DEFAULT 0,
    avg_buy_price numeric NULL,
    notes text NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.portfolio_holdings ENABLE ROW LEVEL SECURITY;

-- Policies Portfolio
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can read own holdings') THEN
        CREATE POLICY "Users can read own holdings" ON public.portfolio_holdings FOR SELECT USING (auth.uid() = user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can insert own holdings') THEN
        CREATE POLICY "Users can insert own holdings" ON public.portfolio_holdings FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can update own holdings') THEN
        CREATE POLICY "Users can update own holdings" ON public.portfolio_holdings FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can delete own holdings') THEN
        CREATE POLICY "Users can delete own holdings" ON public.portfolio_holdings FOR DELETE USING (auth.uid() = user_id);
    END IF;
END $$;

-- 3. Function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, username)
  VALUES (new.id, new.email, new.raw_user_meta_data->>'username');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 4. Trigger for updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS update_portfolio_holdings_updated_at ON public.portfolio_holdings;
CREATE TRIGGER update_portfolio_holdings_updated_at
    BEFORE UPDATE ON public.portfolio_holdings
    FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at_column();

-- 5. TEST USER
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
  new_userId uuid := gen_random_uuid();
BEGIN
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'test@averroes.web.id') THEN
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
      raw_app_meta_data, raw_user_meta_data, created_at, updated_at, is_sso_user
    ) VALUES (
      new_userId, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      'test@averroes.web.id', crypt('password123', gen_salt('bf')), now(),
      '{"provider": "email", "providers": ["email"]}', '{"username": "Averroes Tester"}',
      now(), now(), false
    );
  END IF;
END $$;
