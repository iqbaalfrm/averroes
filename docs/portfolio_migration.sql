-- Migration for Portfolio Feature
-- Run this in Supabase SQL Editor

-- 1. Ensure Table Exists with correct schema
DROP TABLE IF EXISTS portfolio_holdings;

CREATE TABLE portfolio_holdings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id),
  coin_id text NOT NULL,        -- coingecko id e.g. 'bitcoin'
  symbol text NOT NULL,         -- 'BTC'
  name text NOT NULL,           -- 'Bitcoin'
  amount numeric NOT NULL DEFAULT 0,
  avg_buy_price numeric NULL,   -- optional
  notes text NULL,              -- optional
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 2. Enable RLS
ALTER TABLE portfolio_holdings ENABLE ROW LEVEL SECURITY;

-- 3. Policies
-- SELECT
CREATE POLICY "Users can read own holdings" ON portfolio_holdings
  FOR SELECT USING (auth.uid() = user_id);

-- INSERT
CREATE POLICY "Users can insert own holdings" ON portfolio_holdings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- UPDATE
CREATE POLICY "Users can update own holdings" ON portfolio_holdings
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE
CREATE POLICY "Users can delete own holdings" ON portfolio_holdings
  FOR DELETE USING (auth.uid() = user_id);

-- 4. Trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = now();
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_portfolio_holdings_updated_at
  BEFORE UPDATE ON portfolio_holdings
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
