--customer table
create table customers(
  customer_id number generated always as identity 
       constraint customers_nn_id not null
       constraint customers_pk primary key,
  customer_name varchar2(50) 
       constraint customers_nn_customer_name not null,
  customer_email varchar2(50) 
       constraint customers_nn_customer_email not null
       constraint customers_u_customer_email unique
);

--parameter MAX_STRING_SIZE must be set to EXTENDED
--alter table customers 
--  modify (customer_email collate binary_ci);