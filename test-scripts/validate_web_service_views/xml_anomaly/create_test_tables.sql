drop table a_test_all purge;
drop table a_test_reseller purge;
drop table a_test_venue purge;
drop table a_test_assignment purge;

create table a_test_all as select * from tickets_available_all_v_xml;
create table a_test_reseller as select * from tickets_available_reseller_v_xml;
create table a_test_venue as select * from tickets_available_venue_v_xml;

create table a_test_assignment as select * from event_ticket_assignment_v_xml;