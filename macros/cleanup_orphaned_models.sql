{% macro find_orphaned_tables(schema_name) %}

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

            {% set found = false %}

            {# Check whether this database table belongs to a current dbt model #}
            {% for node in graph.nodes.values() %}

                {% if node.resource_type == 'model'
                      and node.name == table_name %}

                    {% set found = true %}

                {% endif %}

            {% endfor %}

            {# If no dbt model exists anymore, drop the table #}
            {% if not found %}

                {{ log(
                    'DROPPING ORPHANED TABLE: '
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