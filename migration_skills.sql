-- Migration script to add Skills (Dovednosti) feature

-- Create the skills table
CREATE TABLE IF NOT EXISTS skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    flowcoins_reward INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Note: In Supabase, if row level security is enabled, you'd add policies here. 
-- Assuming they operate freely for now as per other tables.

-- Create table to track which kids have completed which skills
CREATE TABLE IF NOT EXISTS kid_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kid_id UUID REFERENCES profiles(id) NOT NULL,
    skill_id UUID REFERENCES skills(id) NOT NULL,
    coach_id UUID REFERENCES profiles(id) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(kid_id, skill_id)
);

-- Insert the first skill as requested
INSERT INTO skills (name, flowcoins_reward) 
VALUES ('Postoj - surikata', 10);
