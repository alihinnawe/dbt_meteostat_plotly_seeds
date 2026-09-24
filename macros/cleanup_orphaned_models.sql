{% macro cleanup_orphaned_models(schema_name) %}

    {% set relations = adapter.list_relations_without_caching(
        database=target.database,
        schema=schema_name
    ) %}

    {% set dbt_models = graph.nodes.values()
        | selectattr("resource_type", "equalto", "model")
        | map(attribute="name")
        | list
    %}

    {% for relation in relations %}

        {% if relation.identifier not in dbt_models %}

            {{ log(
                "Dropping orphaned relation: "
                ~ relation.schema
                ~ "."
                ~ relation.identifier,
                info=True
            ) }}

            {% do adapter.drop_relation(relation) %}

        {% endif %}

    {% endfor %}

{% endmacro %}