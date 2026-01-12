-- Ensure profiles has all columns
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS username text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS avatar_url text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS updated_at timestamp with time zone;

-- Ensure portfolio_holdings has all columns
ALTER TABLE public.portfolio_holdings ADD COLUMN IF NOT EXISTS coin_id text;
ALTER TABLE public.portfolio_holdings ADD COLUMN IF NOT EXISTS symbol text;
ALTER TABLE public.portfolio_holdings ADD COLUMN IF NOT EXISTS name text;
ALTER TABLE public.portfolio_holdings ADD COLUMN IF NOT EXISTS amount numeric;
ALTER TABLE public.portfolio_holdings ADD COLUMN IF NOT EXISTS avg_buy_price numeric;
ALTER TABLE public.portfolio_holdings ADD COLUMN IF NOT EXISTS notes text;

-- Fix any naming issues (user reported 'average_price' vs 'avg_buy_price' before)
DO $$
BEGIN
    -- Rename average_price to avg_buy_price ONLY if old exists AND new does NOT
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='portfolio_holdings' AND column_name='average_price') 
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='portfolio_holdings' AND column_name='avg_buy_price') THEN
        ALTER TABLE public.portfolio_holdings RENAME COLUMN average_price TO avg_buy_price;
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='portfolio_holdings' AND column_name='average_price') THEN
        -- If both exist, drop the old one
        ALTER TABLE public.portfolio_holdings DROP COLUMN average_price;
    END IF;

    -- Rename note to notes ONLY if old exists AND new does NOT
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='portfolio_holdings' AND column_name='note') 
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='portfolio_holdings' AND column_name='notes') THEN
        ALTER TABLE public.portfolio_holdings RENAME COLUMN note TO notes;
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='portfolio_holdings' AND column_name='note') THEN
        -- If both exist, drop the old one
        ALTER TABLE public.portfolio_holdings DROP COLUMN note;
    END IF;
END $$;
