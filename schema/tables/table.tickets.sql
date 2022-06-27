--create event ticket sales table
create table tickets(
  ticket_id number generated always as identity
       constraint ticket_nn_id not null
       constraint ticket_pk primary key,
  ticket_sales_id number 
       constraint tickets_nn_ticket_sales_id not null 
       constraint tickets_fk_ticket_sales references ticket_sales(ticket_sales_id),
  status varchar2(25) default 'ISSUED',
  serial_code varchar2(1000)
       constraint tickets_nn_serial_code not null,
  issued_to_name varchar2(100),
  issued_to_id varchar2(100),
  assigned_section varchar2(20),
  assigned_row varchar2(10),
  assigned_seat varchar2(10)
  );

create index tickets_idx_ticket_sales_id on tickets (ticket_sales_id);

create index tickets_idx_serial_code on tickets (serial_code);