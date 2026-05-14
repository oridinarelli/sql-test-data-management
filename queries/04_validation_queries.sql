-- Validation queries for QA data checks

-- 1. Validate companies created
SELECT
    id,
    name,
    country,
    created_at
FROM companies
ORDER BY id;


-- 2. Validate users by company
SELECT
    c.id AS company_id,
    c.name AS company_name,
    u.id AS user_id,
    u.full_name,
    u.email,
    u.role,
    u.is_active
FROM companies c
JOIN users u ON u.company_id = c.id
ORDER BY c.id, u.id;


-- 3. Validate records by company
SELECT
    c.id AS company_id,
    c.name AS company_name,
    r.id AS record_id,
    r.record_type,
    r.document_number,
    r.full_name,
    r.business_name,
    r.risk_level
FROM companies c
JOIN records r ON r.company_id = c.id
ORDER BY c.id, r.id;


-- 4. Validate operations with related company, record and user
SELECT
    o.id AS operation_id,
    c.name AS company_name,
    r.record_type,
    COALESCE(r.full_name, r.business_name) AS record_name,
    u.full_name AS created_by,
    o.operation_type,
    o.amount,
    o.currency,
    o.status,
    o.created_at
FROM operations o
JOIN companies c ON c.id = o.company_id
LEFT JOIN records r ON r.id = o.record_id
LEFT JOIN users u ON u.id = o.created_by
ORDER BY o.id;


-- 5. Count records by risk level
SELECT
    risk_level,
    COUNT(*) AS total_records
FROM records
GROUP BY risk_level
ORDER BY total_records DESC;


-- 6. Count operations by status
SELECT
    status,
    COUNT(*) AS total_operations
FROM operations
GROUP BY status
ORDER BY total_operations DESC;


-- 7. QA validation: operations without associated record
SELECT
    o.id AS operation_id,
    o.company_id,
    o.operation_type,
    o.amount,
    o.currency,
    o.status
FROM operations o
WHERE o.record_id IS NULL;


-- 8. QA validation: operations without creator user
SELECT
    o.id AS operation_id,
    o.company_id,
    o.operation_type,
    o.amount,
    o.currency,
    o.status
FROM operations o
WHERE o.created_by IS NULL;


-- 9. QA validation: high risk records with operations
SELECT
    r.id AS record_id,
    COALESCE(r.full_name, r.business_name) AS record_name,
    r.risk_level,
    o.id AS operation_id,
    o.operation_type,
    o.amount,
    o.currency,
    o.status
FROM records r
JOIN operations o ON o.record_id = r.id
WHERE r.risk_level = 'HIGH'
ORDER BY o.amount DESC;


-- 10. Summary by company
SELECT
    c.id AS company_id,
    c.name AS company_name,
    COUNT(DISTINCT u.id) AS total_users,
    COUNT(DISTINCT r.id) AS total_records,
    COUNT(DISTINCT o.id) AS total_operations,
    COUNT(DISTINCT CASE WHEN r.risk_level = 'HIGH' THEN r.id END) AS high_risk_records,
    COUNT(DISTINCT CASE WHEN o.status = 'PENDING_REVIEW' THEN o.id END) AS pending_review_operations
FROM companies c
LEFT JOIN users u ON u.company_id = c.id
LEFT JOIN records r ON r.company_id = c.id
LEFT JOIN operations o ON o.company_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;