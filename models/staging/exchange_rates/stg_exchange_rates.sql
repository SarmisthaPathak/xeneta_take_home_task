with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ ref('DE_casestudy_exchange_rates') }}

),

renamed as (

    select
       DAY AS DAY,
       CURRENCY AS CURRENCY_CODE,
       RATE AS EXCHANGE_RATE

    from source

)

select * from renamed