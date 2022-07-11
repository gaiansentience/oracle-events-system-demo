--get the customer information
--use to get current information before updating customer
select
*
from events_report_api.show_customer(4941);
    

select * from customers c 
where c.customer_email = 'Julius.Irving@example.customer.com';