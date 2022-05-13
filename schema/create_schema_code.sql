--recreate schema code objects for event platform projects
prompt deploying views and packages
@views\create_schema_views.sql;
@views\create_schema_views_json.sql;
@packages\create_schema_packages.sql;

