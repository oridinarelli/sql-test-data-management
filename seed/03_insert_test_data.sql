DO $$
DECLARE
    v_company_alpha_id INT;
    v_company_beta_id INT;

    v_user_admin_id INT;
    v_user_qa_id INT;
    v_user_analyst_id INT;

    v_record_person_natural_id INT;
    v_record_company_id INT;
    v_record_beta_person_id INT;

    v_operation_transfer_id INT;
    v_operation_purchase_id INT;
    v_operation_review_id INT;
BEGIN
    INSERT INTO companies (name, country)
    VALUES ('Alpha Demo Company', 'Chile')
    RETURNING id INTO v_company_alpha_id;

    INSERT INTO companies (name, country)
    VALUES ('Beta Demo Company', 'Argentina')
    RETURNING id INTO v_company_beta_id;

    INSERT INTO users (company_id, full_name, email, role)
    VALUES
        (v_company_alpha_id, 'Admin User Demo', 'admin@alpha-demo.com', 'Admin')
    RETURNING id INTO v_user_admin_id;

    INSERT INTO users (company_id, full_name, email, role)
    VALUES
        (v_company_alpha_id, 'QA User Demo', 'qa@alpha-demo.com', 'QA Analyst')
    RETURNING id INTO v_user_qa_id;

    INSERT INTO users (company_id, full_name, email, role)
    VALUES
        (v_company_beta_id, 'Risk Analyst Demo', 'analyst@beta-demo.com', 'Risk Analyst')
    RETURNING id INTO v_user_analyst_id;

    INSERT INTO records (
        company_id,
        record_type,
        document_number,
        full_name,
        business_name,
        risk_level
    )
    VALUES
        (
            v_company_alpha_id,
            'PERSON',
            '11111111-1',
            'Persona Demo Uno',
            NULL,
            'LOW'
        )
    RETURNING id INTO v_record_person_natural_id;

    INSERT INTO records (
        company_id,
        record_type,
        document_number,
        full_name,
        business_name,
        risk_level
    )
    VALUES
        (
            v_company_alpha_id,
            'COMPANY',
            '22222222-2',
            NULL,
            'Business Demo Alpha',
            'MEDIUM'
        )
    RETURNING id INTO v_record_company_id;

    INSERT INTO records (
        company_id,
        record_type,
        document_number,
        full_name,
        business_name,
        risk_level
    )
    VALUES
        (
            v_company_beta_id,
            'PERSON',
            '33333333-3',
            'Persona Demo Beta',
            NULL,
            'HIGH'
        )
    RETURNING id INTO v_record_beta_person_id;

    INSERT INTO operations (
        company_id,
        record_id,
        created_by,
        operation_type,
        amount,
        currency,
        status
    )
    VALUES
        (
            v_company_alpha_id,
            v_record_person_natural_id,
            v_user_admin_id,
            'TRANSFER',
            150000.00,
            'CLP',
            'APPROVED'
        )
    RETURNING id INTO v_operation_transfer_id;

    INSERT INTO operations (
        company_id,
        record_id,
        created_by,
        operation_type,
        amount,
        currency,
        status
    )
    VALUES
        (
            v_company_alpha_id,
            v_record_company_id,
            v_user_qa_id,
            'PURCHASE',
            2500.00,
            'USD',
            'PENDING_REVIEW'
        )
    RETURNING id INTO v_operation_purchase_id;

    INSERT INTO operations (
        company_id,
        record_id,
        created_by,
        operation_type,
        amount,
        currency,
        status
    )
    VALUES
        (
            v_company_beta_id,
            v_record_beta_person_id,
            v_user_analyst_id,
            'TRANSFER',
            500000.00,
            'ARS',
            'REJECTED'
        )
    RETURNING id INTO v_operation_review_id;

    RAISE NOTICE 'Test data inserted successfully.';
    RAISE NOTICE 'Alpha Demo Company ID: %', v_company_alpha_id;
    RAISE NOTICE 'Beta Demo Company ID: %', v_company_beta_id;
    RAISE NOTICE 'Operation Transfer ID: %', v_operation_transfer_id;
    RAISE NOTICE 'Operation Purchase ID: %', v_operation_purchase_id;
    RAISE NOTICE 'Operation Review ID: %', v_operation_review_id;
END $$;