{% macro fabric__rename_relation(from_relation, to_relation) -%}
  {% if from_relation.type == 'view' %}
    {% call statement('get_view_definition', fetch_result=True) %}
        select VIEW_DEFINITION
        from INFORMATION_SCHEMA.VIEWS
        where TABLE_CATALOG = '{{ from_relation.database }}'
        and TABLE_SCHEMA = '{{ from_relation.schema }}'
        and TABLE_NAME = '{{ from_relation.identifier }}'
    {% endcall %}
    {% set view_def_full = load_result('get_view_definition')['data'][0][0] %}
    {{ log("Found view definition " ~ view_def_full) }}
    {% set view_def_sql_matches = modules.re.match('^create\\s+view\\s+[0-9a-z.\\"\\[\\]_]+\\s+as\\s+\\(?(.*)\\)?\\s+;?\\s+$', view_def_full, modules.re.I) %}
    {% if not view_def_sql_matches %}
        {{ exceptions.raise_compiler_error("Could not extract view definition to rename") }}
    {% endif %}
    {% set view_def_sql = view_def_sql_matches.group(1) %}
    {{ log("Found view SQL " ~ view_def_sql) }}
    {% call statement('create_new_view') %}
        {{ create_view_as(to_relation, view_def_sql) }}
    {% endcall %}
    {% call statement('drop_old_view') %}
        drop view {{ from_relation.include(database=False) }};
    {% endcall %}
  {% endif %}
  {% if from_relation.type == 'table' %}
      {% call statement('rename_relation') %}
        create table {{ to_relation.include(database=False) }} as select * from {{ from_relation.include(database=False) }}
      {%- endcall %}
      {{ sqlserver__drop_relation(from_relation) }}
  {% endif %}
{% endmacro %}