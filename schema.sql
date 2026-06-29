-- ============================================================
-- AZAD PROVISION STORE — Supabase Database Schema
-- Run this entire file in your Supabase SQL Editor once
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- ============================================================
-- CATEGORIES
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en TEXT NOT NULL,
  name_gu TEXT NOT NULL,
  icon TEXT DEFAULT '🛒',
  display_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read categories"
  ON categories FOR SELECT USING (true);

CREATE POLICY "Admin manage categories"
  ON categories FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');


-- ============================================================
-- PRODUCTS
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name_en TEXT NOT NULL,
  name_gu TEXT,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  image_url TEXT,
  price NUMERIC(10,2),
  show_price BOOLEAN DEFAULT false,
  in_stock BOOLEAN DEFAULT true,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read active products"
  ON products FOR SELECT USING (is_active = true);

CREATE POLICY "Admin manage products"
  ON products FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();


-- ============================================================
-- DEALS
-- ============================================================
CREATE TABLE IF NOT EXISTS deals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title_en TEXT NOT NULL,
  title_gu TEXT,
  image_url TEXT,
  original_price NUMERIC(10,2),
  deal_price NUMERIC(10,2),
  show_price BOOLEAN DEFAULT true,
  valid_from DATE DEFAULT CURRENT_DATE,
  valid_until DATE,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  source TEXT DEFAULT 'admin' CHECK (source IN ('admin', 'vendor')),
  vendor_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE deals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read active deals"
  ON deals FOR SELECT
  USING (
    is_active = true
    AND (valid_until IS NULL OR valid_until >= CURRENT_DATE)
  );

CREATE POLICY "Admin manage deals"
  ON deals FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');


-- ============================================================
-- VENDOR SUBMISSIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS vendor_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_id UUID REFERENCES auth.users(id) NOT NULL,
  vendor_name TEXT,
  deal_title TEXT NOT NULL,
  products_covered TEXT,
  image_url TEXT,
  original_price NUMERIC(10,2),
  offer_price NUMERIC(10,2),
  valid_from DATE,
  valid_until DATE,
  notes TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  rejection_reason TEXT,
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE vendor_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Vendors read own submissions"
  ON vendor_submissions FOR SELECT
  USING (vendor_id = auth.uid());

CREATE POLICY "Vendors insert submissions"
  ON vendor_submissions FOR INSERT
  WITH CHECK (vendor_id = auth.uid());

CREATE POLICY "Admin manage all vendor submissions"
  ON vendor_submissions FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');


-- ============================================================
-- STORE SETTINGS
-- ============================================================
CREATE TABLE IF NOT EXISTS store_settings (
  key TEXT PRIMARY KEY,
  value TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE store_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read settings"
  ON store_settings FOR SELECT USING (true);

CREATE POLICY "Admin manage settings"
  ON store_settings FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');


-- ============================================================
-- SEED: Default categories
-- ============================================================
INSERT INTO categories (name_en, name_gu, icon, display_order) VALUES
  ('Groceries',           'કરિયાણું',        '🌾', 1),
  ('Dairy & Eggs',        'ડેરી અને ઇંડા',   '🥛', 2),
  ('Snacks',              'નાસ્તો',           '🍟', 3),
  ('Beverages',           'પીણાં',            '🧃', 4),
  ('Household Essentials','ઘરેલુ જરૂરિયાત',  '🏠', 5),
  ('Personal Care',       'વ્યક્તિગત સંભાળ', '🧴', 6),
  ('Spices & Masalas',    'મસાલા',            '🌶️', 7),
  ('Baby Products',       'બાળ ઉત્પાદનો',    '👶', 8)
ON CONFLICT DO NOTHING;


-- ============================================================
-- SEED: Store settings
-- ============================================================
INSERT INTO store_settings (key, value) VALUES
  ('store_name_en',  'Azad Provision Store'),
  ('store_name_gu',  'આઝાદ પ્રોવિઝન સ્ટોર'),
  ('whatsapp_number','919876543210'),
  ('phone_number',   '+91 98765 43210'),
  ('address_en',     'Ambavadi, Ahmedabad, Gujarat 380015'),
  ('address_gu',     'અંબાવાડી, અમદાવાદ, ગુજરાત ૩૮૦૦૧૫'),
  ('established',    '1990'),
  ('delivery_note',  'Home Delivery & Cash on Delivery Available')
ON CONFLICT DO NOTHING;
