--drop schema objects before redeploy
prompt dropping schema views and packages
@packages\drop_schema_packages.sql;
@views\json\drop_views_json.sql;
@views\xml\drop_views_xml.sql;
@views\drop_api_views.sql;