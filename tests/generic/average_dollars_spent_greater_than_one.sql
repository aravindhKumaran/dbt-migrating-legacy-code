{#
    This generic test checks whether the average of the specified column is greater than 0 
    when grouped by the specified columns.

    Parameters:
    - model: The table or model to test.
    - column_name: The column whose average is being calculated.
    - group_by_columns: A list of columns by which the data will be grouped.

    Example usage in a model's schema.yml:

    models:
        - name: fct__customer_orders
            columns:
            - name: total_amount_paid
                data_tests:
                  - average_dollars_spent_greater_than_ten:
                      group_by_columns: ['customer_id', 'order_id']

    In this example:
    - The 'total_amount_paid' column will be tested to ensure its average, 
      when grouped by 'customer_id' and 'order_id', is greater than 0.
#}


{% test average_dollars_spent_greater_than_zero(model, column_name, group_by_columns) %}

    {{ log('************************************') }}
    {{ log('Running the generic test average_dollars_spent_greater_than_ten for model: ' ~ model, info=True) }}
    {{ log('************************************') }}
    
    select 
        {{ group_by_columns | join(', ') }},
        avg( {{column_name}} ) as avg_{{ column_name }}
    
    from {{ model }}
    
    group by {{ group_by_columns | join(', ') }}
    having avg( {{column_name}} ) < 0

{% endtest %}