{% macro union_tables_by_prefix(database, schema_pattern, table_pattern) %}

    {% set tables = dbt_utils.get_relations_by_pattern(database=database, schema_pattern=schema_pattern, table_pattern=table_pattern) %}

    {% for table in tables %}

        {% if loop.first %}
        union all
        {% endif %}

        select * from {{ table.database }}.{{ table.schema }}.{{ table.name }}

    {% endfor %}
    
{% endmacro %}