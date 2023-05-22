{% macro sqlserver__drop_relation_script(relation) -%}
    {% call statement('find_references', fetch_result=true) %}
        select
            sch.name as schema_name,
            obj.name as view_name
        from sys.sql_expression_dependencies refs
        inner join sys.objects obj
        on refs.referencing_id = obj.object_id
        inner join sys.schemas sch
        on obj.schema_id = sch.schema_id
        where refs.referenced_database_name = '{{ relation.database }}'
        and refs.referenced_schema_name = '{{ relation.schema }}'
        and refs.referenced_entity_name = '{{ relation.identifier }}'
        and refs.referencing_class = 1
        and obj.type = 'V'
    {% endcall %}
    {% set references = load_result('find_references')['data'] %}
    {% for reference in references -%}
        -- dropping referenced view {{ reference[0] }}.{{ reference[1] }}
        {{ sqlserver__drop_relation_script(relation.incorporate(
            type="view",
            path={"schema": reference[0], "identifier": reference[1]})) }}
    {% endfor %}
    {% if relation.type == 'view' -%}
        {% set object_id_type = 'V' %}
    {% elif relation.type == 'table'%}
        {% set object_id_type = 'U' %}
    {%- else -%}
        {{ exceptions.raise_not_implemented('Invalid relation being dropped: ' ~ relation) }}
    {% endif %}
    if object_id ('{{ relation.include(database=False) }}','{{ object_id_type }}') is not null
        begin
            drop {{ relation.type }} {{ relation.include(database=False) }}
        end
{% endmacro %}
