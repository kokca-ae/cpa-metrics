-- Advertisers
INSERT INTO advertisers (name) VALUES ('Advertiser A'), ('Advertiser B');

-- Campaigns
INSERT INTO campaigns (advertiser_id, name, start_date, end_date) VALUES
    (1, 'Campaign 1', '2025-09-01', '2025-09-30'),
    (1, 'Campaign 2', '2025-09-05', '2025-09-25'),
    (2, 'Campaign X', '2025-09-10', '2025-09-20');

-- Traffic sources
INSERT INTO traffic_sources (name) VALUES ('Google Ads'), ('Facebook'), ('Email');

-- Raw metrics
INSERT INTO cpa_metrics_raw (campaign_id, traffic_source_id, event_time, action_type, conversions, cost, extra_data) VALUES
    (1, 1, '2025-09-01 10:00:00+05', 'signup', 10, 50.00, '{"region":"Moscow","device":"mobile"}'),
    (1, 2, '2025-09-01 11:00:00+05', 'signup', 5, 30.00, '{"region":"Moscow","device":"desktop"}'),
    (2, 1, '2025-09-05 12:00:00+05', 'purchase', 8, 40.00, '{"region":"SPB"}'),
    (2, 3, '2025-09-05 13:00:00+05', 'purchase', 3, 15.00, '{}'),
    (3, 1, '2025-09-10 14:00:00+05', 'signup', 12, 60.00, '{}');
