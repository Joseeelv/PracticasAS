<!DOCTYPE html>
<html>
<head>
    <title>HospiHub - Crear todas las citas</title>
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
    <h1>Cancelar todas las citas</h1>
    <?php

    // Conecta al servicio XE (esto es, una base de datos) en el servidor "localhost"
    include('../conexion.php');
    $conexion = conexion();



    $stid = oci_parse($conexion, 
        'BEGIN
            Otros.Crear_Citas();
        END;
         ');
    
    oci_execute($stid);

    echo "<br><br><hr style='border-top: 3px solid orange; border-bottom: 3px solid orange;'><p style='color:orange; text-align:center; font-size: 1.5em;'>Se han creado citas para todos los médicos.</p><hr style='border-top: 3px solid orange; border-bottom: 3px solid orange;'>";
    ?>
</div>

<a href="../menu-admin.php" id="volver">Volver al menú del admin <span class="material-symbols-outlined">
    home
    </span>
</a>
</body>
</html>
