-- AI-Powered Business Content Automation Platform
-- Production-Ready PostgreSQL Schema (Version 1)
-- Compatible with Supabase PostgreSQL

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Trigger function to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Projects
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft','running','completed','partially_completed','failed','archived')),
    current_workflow_run_id UUID,
    last_generated_at TIMESTAMPTZ,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Business Profiles
CREATE TABLE IF NOT EXISTS business_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL UNIQUE REFERENCES projects(id) ON DELETE CASCADE,
    business_name VARCHAR(200) NOT NULL,
    business_type VARCHAR(100) NOT NULL,
    business_description TEXT,
    target_audience VARCHAR(200) NOT NULL,
    target_location VARCHAR(200),
    marketing_goal VARCHAR(100) NOT NULL,
    campaign_type VARCHAR(100),
    brand_tone VARCHAR(50),
    preferred_language VARCHAR(30) NOT NULL,
    brand_colors JSONB NOT NULL DEFAULT '[]'::jsonb,
    offer_title VARCHAR(200),
    offer_details TEXT,
    offer_valid_until DATE,
    call_to_action VARCHAR(200),
    website_url TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Content Selections
CREATE TABLE IF NOT EXISTS content_selections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL UNIQUE REFERENCES projects(id) ON DELETE CASCADE,
    selected_content_types JSONB NOT NULL DEFAULT '[]'::jsonb,
    target_platform VARCHAR(50),
    preferred_language VARCHAR(30) NOT NULL,
    quantity_config JSONB NOT NULL DEFAULT '{}'::jsonb,
    output_format VARCHAR(30) NOT NULL DEFAULT 'structured',
    creativity_level SMALLINT NOT NULL DEFAULT 7 CHECK (creativity_level BETWEEN 1 AND 10),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Workflow Runs
CREATE TABLE IF NOT EXISTS workflow_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    status VARCHAR(30) NOT NULL DEFAULT 'queued'
        CHECK (status IN ('queued','running','completed','partially_completed','failed','cancelled')),
    trigger_type VARCHAR(30) NOT NULL DEFAULT 'initial',
    error_message TEXT,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    duration_ms INTEGER,
    module_statuses JSONB NOT NULL DEFAULT '{}'::jsonb,
    formatted_output JSONB NOT NULL DEFAULT '{}'::jsonb,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add circular FK after workflow_runs exists
ALTER TABLE projects
    ADD CONSTRAINT fk_projects_current_workflow_run
    FOREIGN KEY (current_workflow_run_id)
    REFERENCES workflow_runs(id)
    ON DELETE SET NULL;

-- Prompt Packages
CREATE TABLE IF NOT EXISTS prompt_packages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    workflow_run_id UUID NOT NULL REFERENCES workflow_runs(id) ON DELETE CASCADE,
    content_type VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    provider_type VARCHAR(50),
    model_name VARCHAR(100),
    prompt_text TEXT NOT NULL CHECK (length(trim(prompt_text)) > 0),
    system_instructions TEXT,
    template_name VARCHAR(100),
    template_version VARCHAR(30),
    expected_output_format VARCHAR(30),
    prompt_hash VARCHAR(64),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Generated Contents
CREATE TABLE IF NOT EXISTS generated_contents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    workflow_run_id UUID NOT NULL REFERENCES workflow_runs(id) ON DELETE CASCADE,
    prompt_package_id UUID REFERENCES prompt_packages(id) ON DELETE SET NULL,
    content_type VARCHAR(100) NOT NULL,
    title VARCHAR(255),
    sequence_number INTEGER NOT NULL DEFAULT 1 CHECK (sequence_number >= 1),
    raw_response TEXT,
    formatted_content TEXT,
    structured_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    status VARCHAR(30) NOT NULL DEFAULT 'success',
    error_message TEXT,
    word_count INTEGER CHECK (word_count IS NULL OR word_count >= 0),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Visual Assets
CREATE TABLE IF NOT EXISTS visual_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    workflow_run_id UUID NOT NULL REFERENCES workflow_runs(id) ON DELETE CASCADE,
    generated_content_id UUID REFERENCES generated_contents(id) ON DELETE SET NULL,
    asset_type VARCHAR(50) NOT NULL,
    title VARCHAR(255),
    sequence_number INTEGER NOT NULL DEFAULT 1 CHECK (sequence_number >= 1),
    storage_bucket VARCHAR(100),
    storage_path TEXT NOT NULL,
    public_url TEXT,
    mime_type VARCHAR(100),
    file_size_bytes BIGINT CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    width INTEGER CHECK (width IS NULL OR width > 0),
    height INTEGER CHECK (height IS NULL OR height > 0),
    generation_method VARCHAR(50) NOT NULL DEFAULT 'template_engine',
    status VARCHAR(30) NOT NULL DEFAULT 'success',
    error_message TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Export Files
CREATE TABLE IF NOT EXISTS export_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    workflow_run_id UUID NOT NULL REFERENCES workflow_runs(id) ON DELETE CASCADE,
    export_type VARCHAR(30) NOT NULL,
    title VARCHAR(255),
    storage_bucket VARCHAR(100),
    storage_path TEXT NOT NULL,
    public_url TEXT,
    file_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100),
    file_size_bytes BIGINT CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    status VARCHAR(30) NOT NULL DEFAULT 'success',
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Project Assets
CREATE TABLE IF NOT EXISTS project_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    asset_type VARCHAR(50) NOT NULL,
    title VARCHAR(255),
    storage_bucket VARCHAR(100),
    storage_path TEXT NOT NULL,
    public_url TEXT,
    file_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100),
    file_size_bytes BIGINT CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    width INTEGER CHECK (width IS NULL OR width > 0),
    height INTEGER CHECK (height IS NULL OR height > 0),
    status VARCHAR(30) NOT NULL DEFAULT 'active',
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
CREATE INDEX IF NOT EXISTS idx_business_profiles_business_type ON business_profiles(business_type);
CREATE INDEX IF NOT EXISTS idx_content_selections_target_platform ON content_selections(target_platform);
CREATE INDEX IF NOT EXISTS idx_workflow_runs_project_id ON workflow_runs(project_id);
CREATE INDEX IF NOT EXISTS idx_workflow_runs_status ON workflow_runs(status);
CREATE INDEX IF NOT EXISTS idx_prompt_packages_workflow_run_id ON prompt_packages(workflow_run_id);
CREATE INDEX IF NOT EXISTS idx_generated_contents_workflow_content ON generated_contents(workflow_run_id, content_type);
CREATE INDEX IF NOT EXISTS idx_visual_assets_workflow_asset ON visual_assets(workflow_run_id, asset_type);
CREATE INDEX IF NOT EXISTS idx_export_files_workflow_export ON export_files(workflow_run_id, export_type);
CREATE INDEX IF NOT EXISTS idx_project_assets_project_type ON project_assets(project_id, asset_type);

-- updated_at triggers
CREATE TRIGGER trg_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_business_profiles_updated_at
BEFORE UPDATE ON business_profiles
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_content_selections_updated_at
BEFORE UPDATE ON content_selections
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_generated_contents_updated_at
BEFORE UPDATE ON generated_contents
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_project_assets_updated_at
BEFORE UPDATE ON project_assets
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- Note: workflow_runs, prompt_packages, visual_assets, and export_files are append-only
-- and therefore do not require updated_at columns or update triggers.
