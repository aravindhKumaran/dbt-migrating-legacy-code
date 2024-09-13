{% macro cents_to_dollars(column_name, decimal_value=2) -%}

    round( 1.0 * {{ column_name }} / 100, {{ decimal_value }} )

{%- endmacro %}

{# 

usage:
======
select 
    payment_id,
    {{ cents_to_dollars('amount', 3) }} as payment_amount 
from payments

#}