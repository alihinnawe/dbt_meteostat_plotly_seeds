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
        
        {# Create a list of all current dbt model names #}
        {% set dbt_models = [] %}
        {% for node in graph.nodes.values() %}
            {% if node.resource_type == 'model' %}
                {% do dbt_models.append(node.name) %}
            {% endif %}
        {% endfor %}

        {{ log('Current dbt models: ' ~ dbt_models | join(', '), info=True) }}

        {# Loop through database tables and check if they exist in dbt #}
        {% for table_name in db_tables %}

            {% if table_name not in dbt_models %}

                {{ log(
                    'DROPPING ORPHANED TABLE: ' 
                    ~ schema_name 
                    ~ '.' 
                    ~ table_name,
                    info=True
                ) }}

                {% set drop_sql %}
                    DROP TABLE IF EXISTS "{{ schema_name }}"."{{ table_name }}" CASCADE;
                {% endset %}

                {% do run_query(drop_sql) %}

            {% endif %}

        {% endfor %}

    {% endif %}

{% endmacro %}