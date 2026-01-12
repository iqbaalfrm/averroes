-- =============================================================================
-- REELS SYSTEM SCHEMA
-- =============================================================================

-- 1. Create Reels Table
CREATE TABLE IF NOT EXISTS public.reels_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL CHECK (category IN ('Fiqh Muamalah', 'Takdir', 'Sabar', 'Qonaah')),
    type TEXT NOT NULL CHECK (type IN ('ayat', 'hadith', 'quote')),
    arabic TEXT,
    indonesia TEXT NOT NULL,
    reflection TEXT,
    source TEXT NOT NULL,
    tags TEXT[],
    audio_url TEXT,
    duration_sec INT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Security (RLS)
ALTER TABLE public.reels_items ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view active reels (Guest included)
CREATE POLICY "Public can view active reels" 
ON public.reels_items 
FOR SELECT 
USING (is_active = true);

-- Policy: Only authenticated users (admins) can insert/update (Optional, usually handled via Dashboard/ServiceRole)
-- For this app, client-side write is disabled as per requirements.

-- 3. Storage Bucket Setup (Instructions for Dashboard)
-- Go to Storage -> Create new bucket "reels-audio" -> Make it PUBLIC.

-- 4. Sample Data
INSERT INTO public.reels_items (category, type, indonesia, source, is_active)
VALUES 
('Fiqh Muamalah', 'quote', 'Jual beli itu dihalalkan, riba itu diharamkan.', 'QS. Al-Baqarah: 275', true),
('Sabar', 'hadith', 'Sabar itu ada pada benturan pertama.', 'HR. Bukhari', true);
