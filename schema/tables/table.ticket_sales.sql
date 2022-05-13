--create event ticket sales table
create table ticket_sales(
  ticket_sales_id number generated always as identity
       constraint ticket_sales_nn_id not null
       constraint ticket_sales_pk primary key,
  ticket_group_id number 
       constraint ticket_sales_nn_ticket_group_id not  null 
       constraint ticket_sales_fk_ticket_groups references ticket_groups(ticket_group_id),
  customer_id number
       constraint ticket_sales_nn_customer_id not null 
       constraint ticket_sales_fk_customers references customers(customer_id),
  reseller_id number null 
       constraint ticket_sales_fk_resellers references resellers(reseller_id),
  ticket_quantity number
       constraint ticket_sales_nn_ticket_quantity not null
       constraint ticket_sales_chk_ticket_qty_gt_0 check (ticket_quantity > 0),
  extended_price number(9,2),
  reseller_commission number(7,2) default 0,
  sales_date date default sysdate 
       constraint ticket_sales_nn_sales_date not null
  );
