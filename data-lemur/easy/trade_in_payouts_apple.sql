-- ======================================================================
--         Trade in Payouts [Apple SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/trade-in-payouts

-- Apple has a trade-in program where their customers can return the old iPhone device to Apple and Apple gives
-- the customers the trade-in value (known as payout) of the device in cash.

-- For each store, write a query of the total revenue from the trade-in. 
-- Order the result by the descending order.

SELECT
	tt.store_id,
	SUM(tp.payout_amount) payout
FROM trade_in_transactions as tt  
JOIN trade_in_payouts as tp
	ON tp.model_id = tt.model_id
GROUP BY tt.store_id
ORDER BY SUM(tp.payout_amount) DESC;