
{{
    config (
        materialized = 'table',schema = 'final'
    )
}}

WITH PORTS AS (
    SELECT
        PORT_ID,
        PORT_CODE, 
        REGION_ID,
        PORT_NAME,
        COUNTRY, 
        COUNTRY_CODE
    FROM
        {{ ref ('stg_ports') }}
),
price as (
    SELECT
    SHP_CONTRACT_ID,
    SRC_PORT_ID,
    DEST_PORT_ID,
    VALID_FROM,
    VALID_TO,
    COMPANY_ID,
    SUPPLIER_ID,
    EQUIPMENT_ID,
    DAY,
    TOTAL_USD,
    CASE
        WHEN CNT_BY_COMPANY >= {{ var('num_companies') }}
        AND CNT_BY_SUPPLIER >=  {{ var('num_suppliers') }} 
        THEN 'TRUE'
        ELSE 'FALSE'
    END AS DQ_OK
FROM
    (
        SELECT
            *,
            COUNT(DISTINCT COMPANY_ID) OVER (
                PARTITION BY SRC_PORT_ID,
                DEST_PORT_ID,
                EQUIPMENT_ID
            ) CNT_BY_COMPANY,
            COUNT(DISTINCT SUPPLIER_ID) OVER (
                PARTITION BY SRC_PORT_ID,
                DEST_PORT_ID,
                EQUIPMENT_ID
            ) CNT_BY_SUPPLIER,
        FROM
           {{ ref ('total_price_usd') }} 
    )
WHERE
    1 = 1
    AND DQ_OK = 'TRUE'
)   ,
FINAL as (
    select
        DISTINCT p.PORT_ID,
        p.REGION_ID,
        p.COUNTRY_CODE,
        S.SRC_PORT_ID,
        S.DEST_PORT_ID,
        S.COMPANY_ID,
        S.SUPPLIER_ID,
        S.EQUIPMENT_ID,
        S.DAY,
        ROUND(avg(S.TOTAL_USD),4) AVG_PRICE_IN_USD,
        ROUND({{ median('S.TOTAL_USD') }},4) as MEDIAN_PRICE_IN_USD,
        S.DQ_OK
    FROM
        price s
        left join ports p on (
            (p.PORT_ID = s.SRC_PORT_ID)
            OR (p.PORT_ID = s.DEST_PORT_ID)
        )
    group by
        p.PORT_ID,
        p.REGION_ID,
        p.COUNTRY_CODE,
        S.SRC_PORT_ID,
        S.DEST_PORT_ID,
        S.COMPANY_ID,
        S.SUPPLIER_ID,
        S.EQUIPMENT_ID,
        S.DAY,
        S.DQ_OK
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['PORT_ID', 'REGION_ID','COUNTRY_CODE','SRC_PORT_ID','DEST_PORT_ID','COMPANY_ID','SUPPLIER_ID','EQUIPMENT_ID']) }} as hash_agg_price_id,
     *
FROM
    FINAL