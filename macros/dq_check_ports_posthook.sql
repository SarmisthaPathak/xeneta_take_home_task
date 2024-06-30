{% macro remove_duplicate() %}
create table staging.tmp_stg_ports as (
select *, ROW_NUMBER () over (partition by PORT_ID , PORT_CODE) as cnt
from staging.stg_ports );  

delete from staging.tmp_stg_ports where cnt > 1;

alter table staging.tmp_stg_ports drop column cnt;

truncate table staging.stg_ports ;

insert into staging.stg_ports select * from staging.tmp_stg_ports; 

delete from staging.tmp_stg_ports where length(PORT_CODE) <> 5; 

delete from staging.tmp_stg_ports where length(COUNTRY_CODE) <> 2;

drop table staging.tmp_stg_ports;
{% endmacro %} 



