{% macro cleanup_orphaned_models(schema_name) %}

    {% set query %}
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = '{{ schema_name }}'
          AND table_type = 'BASE TABLE'
    {% endset %}

    {% set results = run_query(query) %}

    {% if execute %}

        {{ log('=== DATABASE TABLES ===', info=True) }}

        {% for row in results.rows %}
            {{ log('DB TABLE: ' ~ row[0], info=True) }}
        {% endfor %}

        {{ log('=== DBT MODELS ===', info=True) }}

        {% for node in graph.nodes.values() %}

            {% if node.resource_type == 'model' %}

                {{ log(
                    'DBT MODEL: '
                    ~ node.name
                    ~ ' | schema='
                    ~ node.schema
                    ~ ' | alias='
                    ~ node.alias,
                    info=True
                ) }}

            {% endif %}

        {% endfor %}

    {% endif %}

{% endmacro %}