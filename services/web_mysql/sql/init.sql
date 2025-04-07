-- Ejecutar tipos.sql
SOURCE /docker-entrypoint-initdb.d/tipos.sql;

-- Ejecutar funciones.sql
SOURCE /docker-entrypoint-initdb.d/funciones.sql;

-- Ejecutar disparadores.sql
SOURCE /docker-entrypoint-initdb.d/disparadores.sql;
