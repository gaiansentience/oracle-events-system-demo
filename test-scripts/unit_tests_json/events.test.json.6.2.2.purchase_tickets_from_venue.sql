set serveroutput on;
declare

v_jdoc varchar2(4000) :=
'{
  "event_id" : 24,
  "customer_id" : 337,
  "customer_name" : "John Kirby",
  "customer_email" : "John.Kirby@example.customer.com",
  "ticket_groups" :
  [
    {
      "ticket_group_id" : 39,
      "price" : 22,
      "ticket_quantity_requested" : 5
    },
    {
      "ticket_group_id" : 37,
      "price" : 100,
      "ticket_quantity_requested" : 6
    }, 
    {
      "ticket_group_id" : 38,
      "price" : 42,
      "ticket_quantity_requested" : 6
    }
  ]
}';

begin

delete from ticket_sales ts where ts.customer_id = 337;
commit;

events_json_api.purchase_tickets_from_venue(v_jdoc);
v_jdoc := events_json_api.format_json_clob(v_jdoc);
dbms_output.put_line(v_jdoc);

end;
