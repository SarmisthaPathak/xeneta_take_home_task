with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ ref('DE_casestudy_regions') }}

),

renamed as (

    select
        SLUG  AS REGION_ID,
        NAME  AS REGION_NAME,
        PARENT AS PARENT_REGION

    from source

)

select * from renamed