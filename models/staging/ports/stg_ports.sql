{{ config(
    materialized="table",
    post_hook="{{ remove_duplicate() }}"
) }}


with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ ref('DE_casestudy_ports') }}

),

renamed as (

    select
       PID AS PORT_ID ,
       CODE AS PORT_CODE,
       SLUG AS REGION_ID,
       NAME AS PORT_NAME ,
       COUNTRY  AS COUNTRY,
       COUNTRY_CODE AS COUNTRY_CODE

    from source

)

select * from renamed 