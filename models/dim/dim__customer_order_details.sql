with 

customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}
),

orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (

    select * from {{ ref('stg_stripe__payments') }}
),

customer_order_details as (
    
    select
        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        orders.order_status,
        payments.total_amount_paid,
        
        sum(payments.total_amount_paid) 
            over (partition by orders.customer_id order by payments.payment_finalized_date) 
        as customer_lifetime_value,

        payments.payment_finalized_date,
        customers.customer_first_name,
        customers.customer_last_name

    from orders

    left join payments
        on orders.order_id = payments.order_id

    left join customers on orders.customer_id = customers.customer_id
)

select * from customer_order_details