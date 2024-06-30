with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ ref('DE_casestudy_charges') }}

),

renamed as (

    select
       D_ID AS SHP_CONTRACT_ID,
       CURRENCY AS CURRENCY_CODE,
       CHARGE_VALUE AS CHARGE_VALUE,
       current_timestamp as dbt_updated_at

    from source

)

select * from renamed 

{{
config(
  materialized='incremental' ,
  incremental_strategy = 'append'
  )
}} 

{% if is_incremental() %} 

  where dbt_updated_at > (select max(dbt_updated_at) from {{ this }}) 

 {% endif %}

