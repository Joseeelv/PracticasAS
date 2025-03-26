<?php
$host = getenv('POSTGRES_HOST');
$db = getenv('POSTGRES_DB');
$user = getenv('POSTGRES_USER');
$pass = getenv('POSTGRES_PASSWORD');

$conn = pg_connect("host=$host dbname=$db user=$user password=$pass");

if (!$conn) {
    die("Conexión fallida: " . pg_last_error());
}

echo "Conexión a PostgreSQL exitosa!";
pg_close($conn);
?>
