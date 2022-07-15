--get the customer information
--use to get current information before updating customer
select
*
from customer_api.show_customer(5021);
    

select * from customers c 
where c.customer_email = 'Julius.Irving@example.customer.com';