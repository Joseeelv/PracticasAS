<?php
function conexion() {
    $db_type = getenv('DB_TYPE') ?: 'mysql'; // 'mysql' o 'pgsql'
    $host = getenv('DB_HOST') ?: 'mysql'; 
    $user = getenv('DB_USER') ?: 'root';
    $password = getenv('DB_PASSWORD') ?: 'root';
    $dbname = getenv('DB_NAME') ?: 'testdb';

    if ($db_type === 'mysql') {
        $conn = mysqli_connect($host, $user, $password, $dbname);
        if (!$conn) {
            die("Error de conexión MySQL: " . mysqli_connect_error());
        }
    } else {
        $conn = pg_connect("host=$host dbname=$dbname user=$user password=$password");
        if (!$conn) {
            die("Error de conexión PostgreSQL: " . pg_last_error());
        }
    }

    return $conn;
}
?>
