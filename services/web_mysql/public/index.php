<?php
$host = 'db2';
$user = 'example';
$password = 'example';
$dbname = 'example';

// Crear conexión
$conn = new mysqli($host, $user, $password, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

echo "Conexión MySQL exitosa!<br>";

// Aquí puedes seguir con tus consultas MySQL usando $conn->query() o prepared statements
?>
