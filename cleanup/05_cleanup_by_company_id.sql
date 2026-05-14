-- 05_cleanup_by_company_id.sql
-- Cleanup all test data associated with a company

DO $$
DECLARE
    v_company_id INT := 1;
BEGIN

    RAISE NOTICE 'Starting cleanup for company_id: %', v_company_id;

    /*
    ==========================================
    PREVIEW DATA
    ==========================================
    */

    RAISE NOTICE 'Preview records before cleanup';

    /*
    ==========================================
    DELETE OPERATIONS
    ==========================================
    */

    DELETE FROM operations
    WHERE company_id = v_company_id;

    RAISE NOTICE 'Operations deleted: %', FOUND;

    /*
    ==========================================
    DELETE RECORDS
    ==========================================
    */

    DELETE FROM records
    WHERE company_id = v_company_id;

    RAISE NOTICE 'Records deleted: %', FOUND;

    /*
    ==========================================
    DELETE USERS
    ==========================================
    */

    DELETE FROM users
    WHERE company_id = v_company_id;

    RAISE NOTICE 'Users deleted: %', FOUND;

    /*
    ==========================================
    DELETE COMPANY
    ==========================================
    */

    DELETE FROM companies
    WHERE id = v_company_id;

    RAISE NOTICE 'Company deleted: %', FOUND;

    /*
    ==========================================
    VALIDATION
    ==========================================
    */

    IF EXISTS (
        SELECT 1
        FROM companies
        WHERE id = v_company_id
    ) THEN

        RAISE NOTICE 'Cleanup failed. Company still exists.';

    ELSE

        RAISE NOTICE 'Cleanup completed successfully for company_id: %', v_company_id;

    END IF;

END $$;