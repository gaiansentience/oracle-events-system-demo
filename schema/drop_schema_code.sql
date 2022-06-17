--drop schema objects before redeploy
prompt dropping schema views and packages
@packages\drop_schema_packages.sql;
@views\json\drop_schema_views_json.sql;
@views\drop_schema_views.sql;