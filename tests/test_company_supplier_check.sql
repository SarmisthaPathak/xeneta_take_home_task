/*
Unit Test : test_company_supplier_check
Description : In this unit test, it is checked that at least 5 different companies and 
2 different suppliers provide data for a particular day, on particular lane and particular equipment type. 
*/ 


select * from (
select count(distinct company_id),
src_port_id,
dest_port_id,
equipment_id, 
day
from final.aggregated_price
group by
src_port_id,
dest_port_id,
equipment_id,
day
having count(distinct company_id) < 5
union all
select count(distinct SUPPLIER_ID),
src_port_id,
dest_port_id,
equipment_id, 
day
from final.aggregated_price
group by
src_port_id,
dest_port_id,
equipment_id , 
day
having count(distinct SUPPLIER_ID) < 2 );

