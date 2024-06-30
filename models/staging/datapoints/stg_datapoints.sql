{{ config(
    materialized="table",
    post_hook="{{ dq_check_dp() }}"
) }}

with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ ref('DE_casestudy_datapoints') }}

),

 renamed as (
  
  select 
      D_ID AS SHP_CONTRACT_ID,
       CREATED AS CREATED,
       ORIGIN_PID AS SRC_PORT_ID,
       DESTINATION_PID AS DEST_PORT_ID,
       VALID_FROM AS VALID_FROM,
       VALID_TO AS VALID_TO,
       COMPANY_ID AS COMPANY_ID,
       SUPPLIER_ID AS SUPPLIER_ID,
       EQUIPMENT_ID AS EQUIPMENT_ID, 
       current_timestamp as dbt_updated_at
  
  from source 

) select * from renamed 

{{
config(
  materialized='incremental',
  incremental_strategy = 'append'
  )
}} 

{% if is_incremental() %} 

 where created > (select max(created) from {{ this }}) 

 {% endif %}














