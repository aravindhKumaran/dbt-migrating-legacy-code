with 

dim_customer_order_details as (

    select * from {{ ref('dim__customer_order_details') }}
),

dim_customer_order_dates as (

    select * from {{ ref('dim__customer_order_dates') }}
),

final as (

    select
        dim_customer_order_details.*,
        row_number() over (order by dim_customer_order_details.order_id) as transaction_seq,
        row_number() over (
            partition by dim_customer_order_details.customer_id order by dim_customer_order_details.order_id
        ) as customer_sales_seq,

        case
            when dim_customer_order_dates.first_order_date = dim_customer_order_details.order_placed_at then 'new' else 'return'
        end as nvsr,

        dim_customer_order_dates.first_order_date as fdos

    from dim_customer_order_details 

    left join dim_customer_order_dates using (customer_id)
        
    order by dim_customer_order_details.order_id

)

select * from final
