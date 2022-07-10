--create more random sales for random events from resellers and directly from the venue
--use show_vendor_reseller_performance to see results (test.06)
--use show_venue_reseller_commissions to see results (test.07)
set serveroutput on;

declare
begin

events_test_data_api.create_ticket_sales;

end;