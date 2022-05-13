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