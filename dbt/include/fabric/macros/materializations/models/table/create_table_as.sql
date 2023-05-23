{% macro fabric__create_table_as(temporary, relation, sql) -%}
  {%- set sql_header = config.get('sql_header', none) -%}
  {%- set temp_view_sql = sql.replace("'", "''") -%}
  {%- set tmp_relation = relation.incorporate(
        path={"identifier": relation.identifier.replace("#", "") ~ '_temp_view'},
        type='view') -%}

  {{ sql_header if sql_header is not none }}

  -- drop previous temp view
   {{- sqlserver__drop_relation_script(tmp_relation) }}

    -- create temp view
   USE [{{ relation.database }}];
   EXEC('create view {{ tmp_relation.include(database=False) }} as
    {{ temp_view_sql }}
    ');

  -- now create the actual table
  create table
    {{ relation.include(database=(not temporary), schema=(not temporary)) }}
  as ( select * from {{ tmp_relation }} );

  -- drop temp view
   {{ sqlserver__drop_relation_script(tmp_relation) }}
{% endmacro %}
