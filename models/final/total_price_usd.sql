{{
    config (
        materialized = 'table',schema = 'final'
    )
}}

With valid_data AS (
    -- Identify valid datapoints for each day
    SELECT 
        d.SHP_CONTRACT_ID,
        cast(d.CREATED as date) as day,
        d.EQUIPMENT_ID,
        d.SRC_PORT_ID,
        d.DEST_PORT_ID,
		d.COMPANY_ID,
		d.SUPPLIER_ID,
		d.VALID_FROM,
        d.VALID_TO,
        c.CURRENCY_CODE,
        c.CHARGE_VALUE,
        
    FROM 
        staging.stg_datapoints d
    LEFT JOIN 
        staging.stg_charges c ON d.SHP_CONTRACT_ID = c.SHP_CONTRACT_ID 
    WHERE 
        cast(d.created as date)  BETWEEN '{{ var ('start_date') }}' AND '{{ var ('end_date') }}' 
), 

charges_with_exchange_rate AS ( 
    -- Join with exchange rates to convert charge values to USD
    SELECT 
        vd.SHP_CONTRACT_ID,
        vd.day,
        vd.EQUIPMENT_ID,
        vd.SRC_PORT_ID,
        vd.DEST_PORT_ID, 
		vd.VALID_FROM,
        vd.VALID_TO,
		vd.COMPANY_ID,
		vd.SUPPLIER_ID,
        (vd.CHARGE_VALUE / er.EXCHANGE_RATE) AS CHARGE_USD 
	FROM 
		valid_data vd 
		JOIN 
        staging.stg_exchange_rates er ON vd.day = er.DAY
) , 

daily_price AS (
    -- Calculate the total USD value of charges for each datapoint each day
    SELECT 
        SHP_CONTRACT_ID,
        day,
        EQUIPMENT_ID,
        SRC_PORT_ID,
        DEST_PORT_ID,
		VALID_FROM,
        VALID_TO,
		COMPANY_ID,
		SUPPLIER_ID,
        SUM(CHARGE_USD) AS TOTAL_USD 
	FROM 
        charges_with_exchange_rate
    GROUP BY 
        SHP_CONTRACT_ID, 
		day, 
		EQUIPMENT_ID, 
		SRC_PORT_ID, 
		DEST_PORT_ID, 
		VALID_FROM, 
		VALID_TO, 
		COMPANY_ID, 
		SUPPLIER_ID
)
--Select the final result with total_USD
SELECT 
    SHP_CONTRACT_ID,
    day,
    EQUIPMENT_ID,
    SRC_PORT_ID,
    DEST_PORT_ID,
	VALID_FROM,
    VALID_TO,
	COMPANY_ID,
	SUPPLIER_ID,
    TOTAL_USD
FROM 
    daily_price
ORDER BY 
    SHP_CONTRACT_ID, day, EQUIPMENT_ID 