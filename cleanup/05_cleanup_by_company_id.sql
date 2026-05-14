BEGIN;

-- Preview data before deletion
SELECT
    c.id AS company_id,
    c.name AS company_name,
    COUNT(DISTINCT u.id) AS users_to_delete,
    COUNT(DISTINCT r.id) AS records_to_delete,
    COUNT(DISTINCT o.id) AS operations_to_delete
FROM companies c
LEFT JOIN users u ON u.company_id = c.id
LEFT JOIN records r ON r.company_id = c.id
LEFT JOIN operations o ON o.company_id = c.id
WHERE c.id = 1
GROUP BY c.id, c.name;


-- Delete company
-- Related users, records and operations will be deleted automatically
-- if foreign keys were created with ON DELETE CASCADE

DELETE FROM companies
WHERE id = 1;


-- Validate company was deleted
SELECT *
FROM companies
WHERE id = 1;

COMMIT;