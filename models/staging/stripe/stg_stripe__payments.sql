with 
    payments as (

        select 
            id as payment_id,
            orderid as order_id,
            paymentmethod as payment_method,
            status as payment_status,
            amount as payment_amount,
            created as payment_date

        from {{ source('stripe','payment') }}
        where status <> 'fail'
),

payments_transformed as (

    select
        order_id,
        max(payment_date) as payment_finalized_date,
        sum(payment_amount) / 100.0 as total_amount_paid

    from payments
    group by 1
)

select * from payments_transformed