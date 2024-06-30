/*
Unit Test : test_unique_pid_check
Description : In this unit test, it is checked that at least 5 different companies and 
2 different suppliers provide data for a particular day, on particular lane and particular equipment type. 
*/  

select port_id, count(*) 
   from staging.stg_ports 
   group by port_id 
   having count(*) > 1; 


