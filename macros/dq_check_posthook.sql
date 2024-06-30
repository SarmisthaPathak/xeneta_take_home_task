{% macro dq_check() %}
delete from {{this}} where length(currency_code) <> 3 
{% endmacro %} 