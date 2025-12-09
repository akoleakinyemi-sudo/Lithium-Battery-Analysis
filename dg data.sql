-- ===== ONE SQL FILE FOR COMPLETE ANALYSIS =====

-- 1. CREATE & SETUP (Only run once)
CREATE DATABASE lithium_analysis;
GO

USE lithium_analysis;
GO

CREATE TABLE incidents (
    id INT PRIMARY KEY,
    date DATE,
    battery_state VARCHAR(20),
    quantity INT,
    temp_celsius DECIMAL(5,2),
    damage_usd DECIMAL(12,2),
    response_min INT,
    injuries INT
);
GO

INSERT INTO incidents VALUES
(1, '2025-03-15', 'Damaged', 2500, 45.5, 4200000, 58, 5),
(2, '2024-11-08', 'Defective', 1800, 32.1, 1850000, 42, 2),
(3, '2024-07-22', 'Damaged', 3200, 38.9, 3100000, 67, 3),
(4, '2024-02-14', 'New', 1500, 28.5, 950000, 35, 1);
GO

-- 2. ANALYSIS (Run anytime)
-- Summary
SELECT 'Total Incidents' as metric, COUNT(*) as value FROM incidents
UNION ALL
SELECT 'Total Damage', SUM(damage_usd) FROM incidents
UNION ALL
SELECT 'Avg Response Time', AVG(response_min) FROM incidents
UNION ALL
SELECT 'Total Injuries', SUM(injuries) FROM incidents;
GO

-- Risk by Battery State
SELECT 
    battery_state,
    COUNT(*) as incidents,
    AVG(damage_usd) as avg_damage,
    AVG(response_min) as avg_response
FROM incidents
GROUP BY battery_state
ORDER BY avg_damage DESC;
GO

-- Temperature Risk
SELECT 
    CASE 
        WHEN temp_celsius > 40 THEN 'Critical'
        WHEN temp_celsius > 30 THEN 'High'
        ELSE 'Safe'
    END as risk_level,
    COUNT(*) as incidents,
    AVG(damage_usd) as avg_damage
FROM incidents
GROUP BY CASE 
    WHEN temp_celsius > 40 THEN 'Critical'
    WHEN temp_celsius > 30 THEN 'High'
    ELSE 'Safe'
END;
GO

-- Response Analysis
SELECT 
    CASE 
        WHEN response_min <= 30 THEN 'Fast'
        WHEN response_min <= 45 THEN 'Moderate'
        ELSE 'Slow'
    END as response,
    COUNT(*) as incidents,
    AVG(damage_usd) as avg_damage
FROM incidents
GROUP BY CASE 
    WHEN response_min <= 30 THEN 'Fast'
    WHEN response_min <= 45 THEN 'Moderate'
    ELSE 'Slow'
END;
GO