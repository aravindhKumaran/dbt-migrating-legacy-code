-- pivoted payment methods
{% set payment_methods = ['bank_transfer', 'credit_card', 'coupon', 'gift_card'] -%}

with payments as (

    select * from {{ source('stripe','payment') }}
),

pivoted as (

    select 
        orderid as order_id,
        
        {% for method in payment_methods -%}    
            sum( case when paymentmethod = '{{ method }}' then amount else 0 end ) as {{ method }}_amount
            {%- if not loop.last -%}
                ,
            {% endif -%}
        {% endfor %}
    
    from payments
    where status <> 'fail'  
    group by 1
)

select * from pivoted
