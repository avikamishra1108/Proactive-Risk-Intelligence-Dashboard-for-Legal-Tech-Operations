USE legal_risk_dashboard;
SELECT client_id, client_name, industry, risk_flag
FROM client;

SELECT 
    c.client_id,
    c.client_name,
    c.industry,
    c.risk_flag,
    i.invoice_id,
    i.amount_billed,
    i.amount_paid,
    i.due_date,
    i.status
FROM 
    client c
JOIN 
    invoice i ON c.client_id = i.client_id
WHERE 
    c.risk_flag = 'High'
ORDER BY 
    c.client_id, i.due_date;

SELECT 
    client_id,
    invoice_id,
    amount_billed,
    amount_paid,
    (amount_billed - amount_paid) AS outstanding_amount
FROM 
    invoice
WHERE 
    amount_billed > amount_paid;

SELECT 
    a.attorney_id,
    a.name,
    SUM(t.hours) AS total_hours,
    SUM(t.amount) AS total_billed
FROM 
    time_entries t
JOIN 
    attorney a ON t.attorney_id = a.attorney_id
GROUP BY 
    a.attorney_id, a.name
ORDER BY 
    total_hours DESC;

SELECT 
    m.matter_id,
    m.matter_title,
    c.client_name,
    SUM(expenses.cost) AS total_expenses
FROM 
    matter m
JOIN 
    expenses ON m.matter_id = expenses.matter_id
JOIN 
    client c ON m.client_id = c.client_id
GROUP BY 
    m.matter_id, m.matter_title, c.client_name
ORDER BY 
    total_expenses DESC;

SELECT 
    c.client_id,
    c.client_name,
    c.risk_flag,
    SUM(i.amount_billed - i.amount_paid) AS total_due
FROM 
    client c
JOIN 
    invoice i ON c.client_id = i.client_id
WHERE 
    c.risk_flag = 'High' AND i.amount_billed > i.amount_paid
GROUP BY 
    c.client_id, c.client_name, c.risk_flag
ORDER BY 
    total_due DESC;

SELECT 
    attorney_id,
    COUNT(*) AS entries_logged,
    SUM(hours) AS total_hours,
    SUM(amount) AS revenue_generated,
    ROUND(SUM(amount)/SUM(hours), 2) AS avg_rate
FROM 
    time_entries
GROUP BY 
    attorney_id
ORDER BY 
    avg_rate ASC;

SELECT 
    matter.matter_id,
    matter.matter_title,
    SUM(time_entries.amount) AS revenue,
    SUM(expenses.cost) AS expenses,
    (SUM(time_entries.amount) - SUM(expenses.cost)) AS profit
FROM 
    matter 
LEFT JOIN 
    time_entries ON matter.matter_id = time_entries.matter_id
LEFT JOIN 
    expenses ON matter.matter_id = expenses.matter_id
GROUP BY 
    matter.matter_id, matter.matter_title
ORDER BY 
    profit DESC;



