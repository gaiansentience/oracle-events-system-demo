--create reseller using a json document
set serveroutput on;
declare
    l_json_doc clob;
    l_name resellers.reseller_name%type := 'Ticket Factory';
    l_email resellers.reseller_email%type := 'ticket.sales@TicketFactory.com';
    l_commission resellers.commission_percent%type := 0.09;
begin

l_json_doc :=
'
{
  "reseller_name" : "$$NAME$$",
  "reseller_email" : "$$EMAIL$$",
  "commission_percent" : $$COMMISSION$$
}
';

    l_json_doc := replace(l_json_doc,'$$NAME$$',l_name);
    l_json_doc := replace(l_json_doc,'$$EMAIL$$',l_email);
    l_json_doc := replace(l_json_doc,'$$COMMISSION$$',l_commission);
    
    events_json_api.create_reseller(p_json_doc => l_json_doc);
    dbms_output.put_line(events_json_api.format_json(l_json_doc));

 end;

/*  reply document for success

  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "commission_percent" : 0.09,
  "reseller_id" : 81,
  "status_code" : "SUCCESS",
  "status_message" : "Created reseller"
}

  reply document for duplicate name
{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "xxticket.sales@TicketFactory.com",
  "commission_percent" : 0.09,
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-00001: unique constraint (EVENT_SYSTEM.RESELLERS_U_RESELLER_NAME) violated"
}


  reply document for duplicate email
{
  "reseller_name" : "xxxTicket Factory",
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
  "status_message" : "ORA-20100: Missing reseller name, cannot create or update reseller."
}

  reply document for missing email
{
  "reseller_name" : "Ticket Factory",
  "commission_percent" : 0.09,
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Missing reseller email, cannot create or update reseller."
}

  reply document for missing commission
{
  "reseller_name" : "Ticket Factory",
  "reseller_email" : "ticket.sales@TicketFactory.com",
  "reseller_id" : 0,
  "status_code" : "ERROR",
  "status_message" : "ORA-20100: Missing reseller commission, cannot create or update reseller."
}

*/