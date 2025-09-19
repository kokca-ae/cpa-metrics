-- Advertisers
CREATE TABLE advertisers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Campaigns
CREATE TABLE campaigns (
    id SERIAL PRIMARY KEY,
    advertiser_id INT NOT NULL REFERENCES advertisers(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_campaign_advertiser ON campaigns(advertiser_id);

-- Traffic sources
CREATE TABLE traffic_sources (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Raw CPA metrics
CREATE TABLE cpa_metrics_raw (
    id BIGSERIAL PRIMARY KEY,
    campaign_id INT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    traffic_source_id INT NOT NULL REFERENCES traffic_sources(id) ON DELETE CASCADE,
    event_time TIMESTAMPTZ NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    conversions INT DEFAULT 0,
    cost NUMERIC(12,2) DEFAULT 0.00,
    extra_data JSONB DEFAULT '{}'::jsonb
);
CREATE INDEX idx_campaign_time ON cpa_metrics_raw(campaign_id, event_time);
CREATE INDEX idx_source_time ON cpa_metrics_raw(traffic_source_id, event_time);
CREATE INDEX idx_event_time ON cpa_metrics_raw(event_time);

-- Aggregated daily metrics
CREATE TABLE cpa_metrics_daily (
    id BIGSERIAL PRIMARY KEY,
    campaign_id INT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    traffic_source_id INT NOT NULL REFERENCES traffic_sources(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    total_conversions INT DEFAULT 0,
    total_cost NUMERIC(12,2) DEFAULT 0.00,
    UNIQUE (campaign_id, traffic_source_id, date)
);
CREATE INDEX idx_campaign_date ON cpa_metrics_daily(campaign_id, date);
CREATE INDEX idx_source_date ON cpa_metrics_daily(traffic_source_id, date);
