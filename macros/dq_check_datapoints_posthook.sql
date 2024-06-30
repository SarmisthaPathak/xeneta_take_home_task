{% macro dq_check_dp() %}
create table staging.tmp_stg_datapoints as (
select *, ROW_NUMBER () over (partition by shp_contract_id order by shp_contract_id) as cnt
from staging.stg_datapoints );  

delete from staging.tmp_stg_datapoints where cnt > 1;

alter table staging.tmp_stg_datapoints drop column cnt;

truncate table staging.stg_datapoints ;

insert into staging.stg_datapoints select * from staging.tmp_stg_datapoints;

drop table staging.tmp_stg_datapoints;

delete from staging.stg_datapoints where equipment_id > 6
{% endmacro %} 