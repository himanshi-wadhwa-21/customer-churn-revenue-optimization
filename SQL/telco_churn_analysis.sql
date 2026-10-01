CREATE TABLE telco_churn (
    customerID VARCHAR(20),
    gender VARCHAR(20),
    SeniorCitizen INTEGER,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INTEGER,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges VARCHAR(30),
    Churn VARCHAR(10)
);

SELECT COUNT(*)
FROM telco_churn;


-- Q1. What percentage of customers have churned?

SELECT 
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0 
        / COUNT(customerID) AS churn_rate
FROM telco_churn;



-- Q2. Which contract type has the highest churn rate?

SELECT
    contract,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY contract
ORDER BY churn_rate DESC;



-- Q3. Does churn differ between newer and longer-tenure customers?

SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END AS tenure_group,

    COUNT(customerID) AS total_customers,

    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,

    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate

FROM telco_churn

GROUP BY
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END

ORDER BY churn_rate DESC;


-- Q4. How does churn vary by Internet Service type?

SELECT
    internetservice,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY internetservice
ORDER BY churn_rate DESC;


-- Q5. How does churn vary by Payment Method?

SELECT
    paymentmethod,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY paymentmethod
ORDER BY churn_rate DESC;


-- Q6. How does churn vary across Monthly Charge groups?

SELECT
    CASE
        WHEN monthlycharges <= 30 THEN 'Low'
        WHEN monthlycharges <= 60 THEN 'Medium'
        WHEN monthlycharges <= 90 THEN 'High'
        ELSE 'Very High'
    END AS monthly_charge_group,

    COUNT(customerID) AS total_customers,

    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,

    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate

FROM telco_churn

GROUP BY
    CASE
        WHEN monthlycharges <= 30 THEN 'Low'
        WHEN monthlycharges <= 60 THEN 'Medium'
        WHEN monthlycharges <= 90 THEN 'High'
        ELSE 'Very High'
    END

ORDER BY churn_rate DESC;


-- Q7. How much monthly revenue is associated with churned customers?

SELECT
    churn,
    COUNT(customerID) AS customers,
    SUM(monthlycharges) AS monthly_revenue
FROM telco_churn
GROUP BY churn
ORDER BY monthly_revenue DESC;


-- Q8. Which high-value customers have churned?
-- High-value = monthly charges above the overall average.

SELECT
    customerID,
    contract,
    internetservice,
    monthlycharges,
    tenure,
    churn
FROM telco_churn
WHERE churn = 'Yes'
  AND monthlycharges > (
      SELECT AVG(monthlycharges)
      FROM telco_churn
  )
ORDER BY monthlycharges DESC;


-- Q9. Which Contract + Internet Service combinations
-- have the highest churn rates?

SELECT
    contract,
    internetservice,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY contract, internetservice
ORDER BY churn_rate DESC;


-- Q10. How does churn vary by Tech Support?

SELECT
    techsupport,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY techsupport
ORDER BY churn_rate DESC;


-- Q11. How does churn vary by Online Security?

SELECT
    onlinesecurity,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY onlinesecurity
ORDER BY churn_rate DESC;


-- Q12. How does churn vary by Streaming TV + Streaming Movies?

SELECT
    streamingtv,
    streamingmovies,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY streamingtv, streamingmovies
ORDER BY churn_rate DESC;


-- Q13. How does churn vary by Partner + Dependents?

SELECT
    partner,
    dependents,
    COUNT(customerID) AS total_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0
        / COUNT(customerID) AS churn_rate
FROM telco_churn
GROUP BY partner, dependents
ORDER BY churn_rate DESC;