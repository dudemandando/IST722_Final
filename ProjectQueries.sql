
-- Customer to stgCustomer (Stage)
SELECT
    customer_id, customer_firstname, customer_lastname, customer_city, customer_state, customer_zip, customer_email
FROM
    fm_customers

-- Orders to stgOrders (Stage)
SELECT
    fm_orders.order_id,
    fm_orders.customer_id,
    fm_orders.order_date,
    fm_orders.shipped_date,
    fm_customers.customer_zip,
    SUM(fm_products.product_retail_price) AS total_retail_price,
    SUM(fm_products.product_wholesale_price) AS total_wholesale_price
FROM
    fm_orders
INNER JOIN
    fm_customers ON fm_orders.customer_id = fm_customers.customer_id
INNER JOIN
    fm_order_details ON fm_orders.order_id = fm_order_details.order_id
INNER JOIN
    fm_products ON fm_order_details.product_id = fm_products.product_id
GROUP BY
    fm_orders.order_id,
    fm_orders.customer_id,
    fm_orders.order_date,
    fm_orders.shipped_date,
    fm_customers.customer_zip;

-- Product Review to stgProductReviews (Stage)
SELECT
    customer_id, product_id, review_date, review_stars
FROM
    fm_customer_product_reviews

-- Product to stgProduct (Stage)
SELECT
    product_id, product_department, product_name, product_retail_price, product_wholesale_price, product_is_active
FROM
    fm_products

-- -- Subs to stgSubs (Stage)
SELECT
    ff_accounts.account_id AS AccountID, ff_zipcodes.zip_state AS ZipState, ff_plans.plan_name AS PlanName, ff_plans.plan_price AS PlanPrice
FROM
    ff_accounts INNER JOIN
    ff_plans ON ff_accounts.account_plan_id = ff_plans.plan_id INNER JOIN
    ff_zipcodes ON ff_accounts.account_zipcode = ff_zipcodes.zip_code


-- stg OrderReviews to Fact Table OrderReviews By State
SELECT
    fdc.CustomerState AS State, COUNT(fdo.OrdersID) AS TotalStateOrders, MIN(fdpr.ReviewStars) AS MinReview, MAX(fdpr.ReviewStars) AS MaxReview, AVG(fdpr.ReviewStars) AS AverageProductReview, SUM(fdo.TotalRetail) 
                         AS TotalRetailRevenue, SUM(fdo.TotalWholesale) AS TotalWholesaleCost, SUM(fdo.TotalRetail) - SUM(fdo.TotalWholesale) AS RevenueWholesaleDifference
FROM
    fudgemart.DimCustomer AS fdc INNER JOIN
    fudgemart.DimOrders AS fdo ON fdc.CustomerID = fdo.CustomerID INNER JOIN
    fudgemart.DimProductReview AS fdpr ON fdc.CustomerID = fdpr.CustomerID
GROUP BY fdc.CustomerState

-- stgSubs to Fact Table Subs By State
SELECT
    ZipState AS State, COUNT(CASE WHEN PlanName = 'Basic Rental' THEN 1 END) AS [Basic Rental], COUNT(CASE WHEN PlanName = 'Basic Rental + Streaming' THEN 1 END) AS BasicRentalPlusStreaming, 
    COUNT(CASE WHEN PlanName = 'Premium Rental' THEN 1 END) AS PremiumRental, COUNT(CASE WHEN PlanName = 'Premium Rental + Streaming' THEN 1 END) AS PremiumRentalPlusStreaming, 
    COUNT(CASE WHEN PlanName = 'Streaming Only' THEN 1 END) AS StreamingOnly, COUNT(CASE WHEN PlanName IN ('Basic Rental', 'Basic Rental + Streaming', 'Premium Rental', 'Premium Rental + Streaming', 
    'Streaming Only') THEN 1 END) AS SubscriptionCount
FROM
    fudgemart.DimSubs
GROUP BY 
    ZipState