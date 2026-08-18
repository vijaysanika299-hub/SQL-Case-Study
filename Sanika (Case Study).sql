use supply_chain;

------ Number 1) Get the number of orders by the Type of Transaction. Please exclude orders shipped from Sangli and Srinagar. 
------- Also, exclude the SUSPECTED_FRAUD cases based on the Order Status. Sort the result in the descending order based on the number of orders.
select * from orders;
select type as Transaction_type,
count(order_id) as Orders
from orders
where order_city not in('Sangli','Srinagar')
and order_status <> ('SUSPECTED_FRAUD')
group by type
order by orders desc;


------- NUMBER 2) Get the list of the Top 3 customers based on the completed orders along with the following details:
-- (Customer Id,Customer First Name,Customer City,Customer State, Number of completed orders,Total Sales)
select * from customer_info;
select * from orders;
select * from ordered_items;

select c.id,c.First_name,c.city,c.state,count(o.order_id) as complete_order,sum(oi.sales) as Total_Sales
from customer_info c
join orders o
 on c.id = o.customer_id
 join ordered_items oi
   on o.order_Id =oi.order_id
 where o.order_status = 'complete'
 GROUP BY
    c.id,
    c.first_name,
    c.city,
    c.state
ORDER BY
    complete_order DESC,
    Total_sales DESC
LIMIT 3;

----- number 3)Get the order count by the Shipping Mode and the Department Name. Consider departments with at least 40 closed/completed orders.
 select * from product_info;
 select * from orders;
 select * from ordered_items;
 select * from department;
 select o.shipping_Mode,d.name as Department_name,
count(distinct o.order_id) as Orders
from orders o
join ordered_items oi
  on o.order_id=oi.order_id
join product_info p
  on oi.item_id = p.product_id
join department d
  on p.department_id = d.id
where o.order_status in('COMPLETE','CLOSED')
 group by o.Shipping_Mode,d.name
 having count(distinct o.order_id) >= 40
 order by d.name,orders desc;
 
 -------- number 4) Which shipping mode was observed to have the greatest number of delayed orders?
 
 WITH shipment_cte AS
 ( select
Order_Id,
Shipping_Mode,
CASE
WHEN Order_Status IN ('SUSPECTED_FRAUD','CANCELED')
THEN 'Cancelled shipment'
WHEN Real_Shipping_Days < Scheduled_Shipping_Days
THEN 'Within schedule'
WHEN Real_Shipping_Days = Scheduled_Shipping_Days
THEN 'On time'
WHEN Real_Shipping_Days > Scheduled_Shipping_Days
AND Real_Shipping_Days <= Scheduled_Shipping_Days + 2
THEN 'Upto 2 days of delay'
WHEN Real_Shipping_Days > Scheduled_Shipping_Days + 2
THEN 'Beyond 2 days of delay'
ELSE 'Unknown'
END AS shipment_compliance
FROM orders)
SELECT
    Shipping_Mode,
    COUNT(Order_Id) AS Delayed_Orders
FROM shipment_cte
WHERE shipment_compliance IN ('Upto 2 days of delay',
                              'Beyond 2 days of delay')
GROUP BY Shipping_Mode
ORDER BY Delayed_Orders DESC
LIMIT 1;

----- number 5) An order is cancelled when the status of the order is either cancelled or SUSPECTED_FRAUD. 
------ Obtain the list of states by the order cancellation % and sort them in the descending order of the cancellation % 
WITH cancelled_orders AS
(
SELECT
Order_State,
COUNT(Order_Id) AS Cancelled_Orders
FROM orders
WHERE Order_Status IN ('CANCELED', 'SUSPECTED_FRAUD')
GROUP BY Order_State
),
total_orders AS
(
SELECT
Order_State,
COUNT(Order_Id) AS Total_Orders
FROM orders
GROUP BY Order_State
)

SELECT
t.Order_State,
ROUND((COALESCE(c.Cancelled_Orders,0) * 100.0) / t.Total_Orders, 2) AS Cancellation_Percentage
FROM total_orders t
LEFT JOIN cancelled_orders c
ON t.Order_State = c.Order_State
ORDER BY Cancellation_Percentage DESC;




