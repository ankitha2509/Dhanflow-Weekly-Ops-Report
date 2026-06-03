-- Query 1: This Week's Loan Applications
SELECT 
    COUNT(*) as total_applications,
    SUM(loan_amount) as total_amount_applied
FROM loans
WHERE application_date >= '2026-05-01'
AND application_date <= '2026-05-31';

-- Query 2: This Week's Disbursements
SELECT 
    COUNT(*) as total_disbursed,
    SUM(loan_amount) as total_disbursed_amount
FROM loans
WHERE status = 'disbursed'
AND disbursed_date >= '2026-05-01'
AND disbursed_date <= '2026-05-31';

-- Query 3: This Week's Rejections
SELECT 
    COUNT(*) as total_rejected,
    rejection_reason
FROM loans
WHERE status = 'rejected'
AND application_date >= '2026-05-01'
AND application_date <= '2026-05-31'
GROUP BY rejection_reason;

-- Query 4: Overdue Repayments
SELECT 
    b.borrower_name,
    b.city,
    l.loan_amount,
    r.emi_amount,
    r.due_date
FROM repayments r
JOIN loans l ON r.loan_id = l.loan_id
JOIN borrowers b ON l.borrower_id = b.borrower_id
WHERE r.payment_status = 'unpaid'
AND r.due_date < '2026-05-31'
ORDER BY r.due_date ASC;

-- Query 5: Weekly KYC Status
SELECT 
    kyc_status,
    COUNT(*) as total
FROM kyc_verification
WHERE kyc_date >= '2026-01-01'
AND kyc_date <= '2026-05-31'
GROUP BY kyc_status;

-- Query 6: Month on Month Trend
SELECT 
    STRFTIME('%Y-%m', application_date) as month,
    COUNT(*) as total_applications,
    SUM(loan_amount) as total_amount,
    COUNT(CASE WHEN status = 'disbursed' THEN 1 END) as disbursed,
    COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejected,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending
FROM loans
GROUP BY STRFTIME('%Y-%m', application_date)
ORDER BY month ASC;
