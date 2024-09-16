{% test assert_value_greater_than_expected(model, column_name, expected_value) %}

    select *
    from {{ model }}
    where {{ column_name }} <= {{ expected_value }}

{% endtest %}