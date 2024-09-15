{{

    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = ['fact_id', 'product_id'],
        merge_exclude_columns = ['fact_id', 'product_id'],
        on_schema_change = "sync_all_columns",
        post_hook = [
            "delete from {{ this }} as target
             where not exists (
                select 1
                from {{ source('stripe','sales') }} as source
                where 
                    source.fact_id = target.fact_id 
                    and source.product_id = target.product_id
            )"
        ]
    )

}}


with sales as (

    select *
    from {{ source('stripe','sales') }}
    
    {% if is_incremental() %}
        where sales_date > (select coalesce(max(sales_date), '1970-01-01') from {{ this }})
    {% endif %}

)

select * from sales 
