<!DOCTYPE html>
<html>
<head>
    <title>HospiHub - Tus Citas</title>
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

<nav>
    <div id="logo">HospiHub</div>
</nav>

<div id="contenedor">
    <h1>Tus Citas</h1>

    <?php

    // Conecta al servicio XE (esto es, una base de datos) en el servidor "localhost"
    include('../conexion.php');
    $conexion = conexion();



    $stid = oci_parse($conexion, 
        'SELECT 
            c.Id_Cita, c.Fecha, TO_CHAR(c.Hora, \'HH24:MI:SS\') AS Hora_Cita, c.Id_Medico, c.Id_Paciente, c.Estado
        FROM 
            Tabla_Cita c
         ');
    
    oci_execute($stid);


    echo "<table class='table table-striped'>\n";
    echo "<thead>";
    echo "<tr>";
    echo "<th>Id de la cita</th>";
    echo "<th>Fecha de la cita</th>";
    echo "<th>Hora de la cita</th>";
    echo "<th>Id del Médico</th>";
    echo "<th>Id del Paciente</th>";
    echo "<th>Estado de la Cita</th>";
    echo "</tr>";
    echo "</thead>";
    while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
        echo "<tr>\n";
        foreach ($row as $item) {
            echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "") . "</td>\n";
        }
        // Añadido un botón para ver detalles solo si el estado es "Diagnóstico completo"
        echo "</tr>\n";
    }
    echo "</table>\n";
    ?>

</div>

<a href="../menu-admin.php" id="volver">Volver al menú del admin <span class="material-symbols-outlined">
    home
    </span>
</a>
</body>
</html>
