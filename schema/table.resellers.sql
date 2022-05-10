--create resellers table
create table resellers(
  reseller_id number generated always as identity 
       constraint resellers_nn_id not null 
       constraint resellers_pk primary key,
  reseller_name varchar2(50) 
       constraint resellers_nn_reseller_name not null 
       constraint resellers_u_reseller_name unique,
  reseller_email varchar2(50) 
       constraint resellers_nn_reseller_email not null 
       constraint resellers_u_reseller_email unique,
  commission_percent number(6,4) default 0.10
       constraint resellers_nn_commission_pct not null
       constraint resellers_chk_commission_pct_gt_0 check (commission_percent > 0)
  );
