--recreate schema code objects for event platform projects
prompt deploying views and packages
@views\create_api_views.sql;
@views\json\create_views_json.sql;
@views\xml\create_views_xml.sql;
@packages\create_schema_packages.sql;

