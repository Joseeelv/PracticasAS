<?php
function conexion() {
    $db_type = getenv('DB_TYPE') ?: 'mysql'; // 'mysql' o 'pgsql'
    $host = getenv('DB_HOST') ?: 'db2';      // Nombre del servicio en Docker
    $port = getenv('DB_PORT') ?: '3306';     // Puerto interno de MySQL (3306)
    $user = getenv('DB_USER') ?: 'example';  // Usuario de la BD
    $password = getenv('DB_PASSWORD') ?: 'example'; // Contraseña
    $dbname = getenv('DB_NAME') ?: 'example';// Nombre de la BD

    if ($db_type === 'mysql') {
        // Conexión para MySQL con puerto explícito
        $conn = mysqli_connect($host, $user, $password, $dbname, $port);
        if (!$conn) {
            die("Error de conexión MySQL: " . mysqli_connect_error());
        }
    } else {
        // Conexión para PostgreSQL (opcional)
        $conn = pg_connect("host=$host dbname=$dbname user=$user password=$password");
        if (!$conn) {
            die("Error de conexión PostgreSQL: " . pg_last_error());
        }
    }

    return $conn;
}
?>