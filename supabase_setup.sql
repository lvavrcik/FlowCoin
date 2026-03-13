-- Supabase Schema Setup for FlowCoins

-- 1. Seasons
CREATE TABLE seasons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    is_active BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Profiles (Extends auth.users, but we might just use this directly if using PINs)
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id), -- Nullable if kids log in just with PIN
    role TEXT NOT NULL CHECK (role IN ('coach', 'kid', 'admin')),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    flowcoins_balance INTEGER DEFAULT 0,
    pin_code TEXT, -- Simple 4-6 digit pin for kids
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Courses
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    coach_id UUID REFERENCES profiles(id) NOT NULL,
    season_id UUID REFERENCES seasons(id) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Enrollments (Kids in Courses)
CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID REFERENCES courses(id) NOT NULL,
    kid_id UUID REFERENCES profiles(id) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, kid_id)
);

-- 5. Activities (Reasons for getting/losing coins)
CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    default_coins INTEGER NOT NULL,
    icon TEXT, -- Optional name of lucide icon
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Transactions (Ledger)
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kid_id UUID REFERENCES profiles(id) NOT NULL,
    coach_id UUID REFERENCES profiles(id) NOT NULL,
    amount INTEGER NOT NULL,
    activity_id UUID REFERENCES activities(id),
    custom_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Merch Items
CREATE TABLE merch_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    cost INTEGER NOT NULL,
    image_url TEXT,
    stock INTEGER DEFAULT -1, -- -1 means unlimited
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. Purchases
CREATE TABLE purchases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kid_id UUID REFERENCES profiles(id) NOT NULL,
    merch_item_id UUID REFERENCES merch_items(id) NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'fulfilled', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger to safely update balance on new transaction
CREATE OR REPLACE FUNCTION update_flowcoins_balance()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE profiles
    SET flowcoins_balance = flowcoins_balance + NEW.amount
    WHERE id = NEW.kid_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER transaction_insert_trigger
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION update_flowcoins_balance();

-- Trigger to deduct balance on purchase
CREATE OR REPLACE FUNCTION handle_merch_purchase()
RETURNS TRIGGER AS $$
BEGIN
    -- Deduct from kid (assuming sufficient balance was checked before inserting)
    UPDATE profiles
    SET flowcoins_balance = flowcoins_balance - (SELECT cost FROM merch_items WHERE id = NEW.merch_item_id)
    WHERE id = NEW.kid_id;
    
    -- Decrease stock if not unlimited
    UPDATE merch_items
    SET stock = stock - 1
    WHERE id = NEW.merch_item_id AND stock > 0;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER purchase_insert_trigger
AFTER INSERT ON purchases
FOR EACH ROW
EXECUTE FUNCTION handle_merch_purchase();
