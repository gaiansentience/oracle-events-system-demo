--create reseller using a json document
set serveroutput on;
declare
  v_json_doc varchar2(4000);
begin

   v_json_doc :=
'{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "commission_percent" : 0.09
}';

   v_json_doc :=
'{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com"
}';

   events_json_api.create_reseller(p_json_doc => v_json_doc);
   
   dbms_output.put_line(events_json_api.format_json_string(v_json_doc));

 end;

/*  reply document for success
{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "commission_percent" : 0.09,
  "reseller_id" : 41,
  "status_code" : "SUCCESS",
  "status_message" : "Created reseller"
}

  reply document for duplicate name
{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "commission_percent" : 0.09,
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-00001: unique constraint (EVENT_SYSTEM.RESELLERS_U_RESELLER_NAME) violated"
}


  reply document for duplicate email
{
  "reseller_name" : "xTicket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "commission_percent" : 0.09,
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-00001: unique constraint (EVENT_SYSTEM.RESELLERS_U_RESELLER_EMAIL) violated"
}

  reply document for missing name
{
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "commission_percent" : 0.09,
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "Missing reseller name, cannot create reseller"
}

  reply document for missing email
{
  "reseller_name" : "Ticket Factory",
  "commission_percent" : 0.09,
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "Missing reseller email, cannot create reseller"
}

  reply document for missing commission
{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "Missing reseller commission, cannot create reseller"
}

*/