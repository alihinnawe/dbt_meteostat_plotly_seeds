{% macro cleanup_orphaned_models(schema_name) %}

    {% set query %}
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = '{{ schema_name }}'
          AND table_type = 'BASE TABLE'
    {% endset %}

    {% set results = run_query(query) %}

    {% if execute %}

        {% set db_tables = results.columns[0].values() %}

        {% for table_name in db_tables %}

            {% set is_dbt_model = false %}

            {% for node in graph.nodes.values() %}

                {% if node.resource_type == 'model'
                      and node.name == table_name %}

                    {% set is_dbt_model = true %}

                {% endif %}

            {% endfor %}

            {% if not is_dbt_model %}

                {{ log(
                    'Dropping orphaned table: '
                    ~ schema_name
                    ~ '.'
                    ~ table_name,
                    info=True
                ) }}

                {% set drop_sql %}
                    DROP TABLE IF EXISTS
                    "{{ schema_name }}"."{{ table_name }}"
                {% endset %}

                {% do run_query(drop_sql) %}

            {% endif %}

        {% endfor %}

    {% endif %}

{% endmacro %}