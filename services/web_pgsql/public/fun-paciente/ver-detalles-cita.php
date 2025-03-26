<!DOCTYPE html>
<html>
<head>
    <title>Detalles de la Cita</title>
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
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

<nav>
    <div id="logo">HospiHub</div>
</nav>

<div id="contenedor">
    <h1>Detalles de la Cita</h1>

    <?php
    // Conecta al servicio XE (esto es, una base de datos) en el servidor "localhost"
    include('../conexion.php');
    $conexion = conexion();

    // Obtener el ID de la cita de la URL
    $id_cita = $_GET['id_cita'];

    // Obtener detalles del diagnóstico
    $stid_diagnostico = oci_parse($conexion, 
        'SELECT 
            d.Descripcion AS Descripcion_diagnostico,
            d.Recomendacion AS Recomendacion_diagnostico
        FROM 
            Tabla_Cita c
            JOIN Tabla_Diagnostico d ON c.Id_diagnostico = d.Id_diagnostico
        WHERE
            c.Id_Cita = :id_cita
         ');
    
    oci_bind_by_name($stid_diagnostico, ":id_cita", $id_cita);
    oci_execute($stid_diagnostico);

    // Mostrar detalles del diagnóstico
    echo "<h2>Diagnóstico:</h2>";
    echo "<ul>";
    while ($row = oci_fetch_assoc($stid_diagnostico)) {
        echo "<li><strong>Descripción:</strong> " . $row['DESCRIPCION_DIAGNOSTICO'] . "</li>";
        echo "<li><strong>Recomendación:</strong> " . $row['RECOMENDACION_DIAGNOSTICO'] . "</li>";
    }
    echo "</ul>";

    // Obtener detalles de los medicamentos
    $stid_medicamentos = oci_parse($conexion, 
        'SELECT 
            m.Nombre AS Nombre_medicamento,
            m.Frecuencia AS Frecuencia_medicamento
        FROM 
            Tabla_Cita c
            JOIN Tabla_Diagnostico d ON c.Id_diagnostico = d.Id_diagnostico
            LEFT JOIN Tabla_Medicamento m ON d.Id_diagnostico = m.Id_diagnostico
        WHERE
            c.Id_Cita = :id_cita
         ');

    oci_bind_by_name($stid_medicamentos, ":id_cita", $id_cita);
    oci_execute($stid_medicamentos);

    // Mostrar detalles de los medicamentos
    echo "<h2>Medicamentos:</h2>";
    echo "<table>";
    echo "<tr><th>Nombre</th><th>Frecuencia</th></tr>";
    while ($med_row = oci_fetch_assoc($stid_medicamentos)) {
        echo "<tr>";
        echo "<td>" . $med_row['NOMBRE_MEDICAMENTO'] . "</td>";
        echo "<td>" . $med_row['FRECUENCIA_MEDICAMENTO'] . "</td>";
        echo "</tr>";
    }
    echo "</table>";

    // Liberar recursos
    oci_free_statement($stid_diagnostico);
    oci_free_statement($stid_medicamentos);
    oci_close($conexion);
    ?>

</div>

<a href="ver-citas-paciente.php" id="volver">Volver a las citas <span class="material-symbols-outlined">
        arrow_left_alt
    </span>
    </a>
    <br></br>
<a href="../menu-paciente.php" id="volver">Volver al menú de paciente <span class="material-symbols-outlined">
    home
    </span>
</a>

</body>
</html>
