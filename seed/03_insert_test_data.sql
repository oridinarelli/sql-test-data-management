DO $$
DECLARE
    v_company_alpha_id INT;
    v_company_beta_id INT;

    v_record_id INT;
    v_user_id INT;

    v_total_users INT := 5;
    v_total_records INT := 10;
    v_total_operations INT := 20;

    v_random_company_id INT;
    v_random_record_id INT;
    v_random_user_id INT;

    i INT;
BEGIN

    /*
    ==========================================
    CREATE COMPANIES
    ==========================================
    */

    INSERT INTO companies (name, country)
    VALUES ('Alpha Demo Company', 'Chile')
    RETURNING id INTO v_company_alpha_id;

    INSERT INTO companies (name, country)
    VALUES ('Beta Demo Company', 'Argentina')
    RETURNING id INTO v_company_beta_id;

    /*
    ==========================================
    CREATE USERS
    ==========================================
    */

    FOR i IN 1..v_total_users LOOP

        INSERT INTO users (
            company_id,
            full_name,
            email,
            role
        )
        VALUES (
            CASE
                WHEN i % 2 = 0 THEN v_company_alpha_id
                ELSE v_company_beta_id
            END,
            'Test User ' || i,
            'testuser' || i || '@demo.com',
            CASE
                WHEN i % 3 = 0 THEN 'QA Analyst'
                WHEN i % 2 = 0 THEN 'Developer'
                ELSE 'Risk Analyst'
            END
        );

    END LOOP;

    /*
    ==========================================
    CREATE RECORDS
    ==========================================
    */

    FOR i IN 1..v_total_records LOOP

        INSERT INTO records (
            company_id,
            record_type,
            document_number,
            full_name,
            business_name,
            risk_level
        )
        VALUES (
            CASE
                WHEN i % 2 = 0 THEN v_company_alpha_id
                ELSE v_company_beta_id
            END,

            CASE
                WHEN i % 2 = 0 THEN 'PERSON'
                ELSE 'COMPANY'
            END,

            'DOC-' || LPAD(i::TEXT, 5, '0'),

            CASE
                WHEN i % 2 = 0 THEN 'Person Demo ' || i
                ELSE NULL
            END,

            CASE
                WHEN i % 2 != 0 THEN 'Business Demo ' || i
                ELSE NULL
            END,

            CASE
                WHEN i % 3 = 0 THEN 'HIGH'
                WHEN i % 2 = 0 THEN 'MEDIUM'
                ELSE 'LOW'
            END
        );

    END LOOP;

    /*
    ==========================================
    CREATE OPERATIONS
    ==========================================
    */

    FOR i IN 1..v_total_operations LOOP

        /*
        RANDOM COMPANY
        */

        v_random_company_id :=
            CASE
                WHEN random() < 0.5 THEN v_company_alpha_id
                ELSE v_company_beta_id
            END;

        /*
        RANDOM USER
        */

        SELECT id
        INTO v_random_user_id
        FROM users
        WHERE company_id = v_random_company_id
        ORDER BY random()
        LIMIT 1;

        /*
        RANDOM RECORD
        */

        SELECT id
        INTO v_random_record_id
        FROM records
        WHERE company_id = v_random_company_id
        ORDER BY random()
        LIMIT 1;

        /*
        INSERT OPERATION
        */

        INSERT INTO operations (
            company_id,
            record_id,
            created_by,
            operation_type,
            amount,
            currency,
            status
        )
        VALUES (
            v_random_company_id,

            v_random_record_id,

            v_random_user_id,

            CASE
                WHEN i % 3 = 0 THEN 'TRANSFER'
                WHEN i % 2 = 0 THEN 'PURCHASE'
                ELSE 'PAYMENT'
            END,

            ROUND((random() * 1000000)::NUMERIC, 2),

            CASE
                WHEN i % 2 = 0 THEN 'USD'
                ELSE 'CLP'
            END,

            CASE
                WHEN i % 4 = 0 THEN 'REJECTED'
                WHEN i % 3 = 0 THEN 'PENDING_REVIEW'
                ELSE 'APPROVED'
            END
        );

    END LOOP;

    RAISE NOTICE 'Test data generated successfully.';
    RAISE NOTICE 'Users created: %', v_total_users;
    RAISE NOTICE 'Records created: %', v_total_records;
    RAISE NOTICE 'Operations created: %', v_total_operations;

END $$;