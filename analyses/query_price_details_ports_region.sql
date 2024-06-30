with vw_ports_region_agg_price as
(select * from {{ ref ('vw_ports_region_agg_price') }}
) 

SELECT * FROM final.vw_ports_region_agg_price 
where SRC_REGION_NAME = '{{ var ("src_region") }}'  
and DEST_REGION_NAME = '{{ var ("dest_region") }}' 
and EQUIPMENT_ID = '{{ var ("equipment_id") }}'  ;
