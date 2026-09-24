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

            {% for node in graph.nodes.values() %}

                {% if node.resource_type == 'model'
                      and node.name == table_name %}

                    {% set found = true %}

                {% endif %}

            {% endfor %}

            {% if not found %}

                {{ log(
                    'ORPHAN FOUND: '
                    ~ schema_name
                    ~ '.'
                    ~ table_name,
                    info=True
                ) }}

            {% endif %}

        {% endfor %}

    {% endif %}

{% endmacro %}