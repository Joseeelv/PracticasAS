!DOCTYPE html>
<html>
<head>
    <title>HospiHub - Cancelar todas las citas</title>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport">
    <!-- Metadatos del autor y diseñador del sitio -->
    <meta name="author" content="Carlos Antonio Cortés Lora, Roberto Rivero Díaz">
    <meta name="designer" content="Carlos Antonio Cortés Lora, Roberto Rivero Díaz">
    <!-- Enlaces a las fuentes de Google y hojas de estilos -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,300..900;1,300..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Enlaces a los archivos CSS -->
    <link rel="stylesheet" href="../css/ver.css">
</head>
<body>
    <header>   
        <nav>
            <div id="logo">HospiHub</div>
        </nav>
    </header>

<?php
// Conecta al servicio XE (esto es, una base de datos) en el servidor "localhost"
include('../conexion.php');
$conexion = conexion();

// Obtener el ID de la cita a cancelar de la URL
$id_cita = $_GET['id_cita'];

// Actualizar el estado de la cita a "Paciente sin asignar" y establecer id_paciente a NULL
$stid = oci_parse($conexion, 'UPDATE Tabla_Cita SET Id_Paciente = NULL, Estado = \'Paciente sin asignar\' WHERE Id_Cita = :id_cita');
oci_bind_by_name($stid, ":id_cita", $id_cita);
$result = oci_execute($stid);

if ($result) {
    echo "<br><br><br><br><br><hr style='border-top: 3px solid red; border-bottom: 3px solid red;'><p style='color:red; text-align:center; font-size:1.5em;'>La cita ha sido cancelada correctamente</p><hr style='border-top: 3px solid red; border-bottom: 3px solid red;'>";
} else {
    echo "<h2>Hubo un error al cancelar la cita. Por favor, inténtalo de nuevo.</h2>";
}

// Liberar recursos
oci_free_statement($stid);
oci_close($conexion);
?>
