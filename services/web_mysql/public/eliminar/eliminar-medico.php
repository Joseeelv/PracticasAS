<?php
    // Conexión a la base de datos Oracle
    include('../conexion.php');
    $conexion = conexion();

    // Inicializar la variable de mensaje
    $mensaje = '';

    // Comprobar si se envió el formulario
    if($_SERVER["REQUEST_METHOD"] == "POST"){
        // Recuperar el email del médico a eliminar
        $email_medico = $_POST["email_medico"];

        // Preparar y ejecutar la consulta SQL
        $sql = "BEGIN Eliminar.Eliminar_Medico(:email_medico); END;";
        $stid = oci_parse($conexion, $sql);
        oci_bind_by_name($stid, ":email_medico", $email_medico);
        oci_execute($stid);

        // Verificar si se ejecutó correctamente
        $mensaje = 'Médico eliminado correctamente';
    }
?>

<!DOCTYPE html>
<html>
<head>
    <title>HospiHub - Eliminar Médico</title>
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
    <!-- Enlaces a los archivos CSS -->
    <link rel="stylesheet" href="../css/register.css">
    <!-- Enlace al archivo JavaScript -->
    
</head>
<body>

<header>   
    <nav>
        <div id="logo">HospiHub</div>
    </nav>
</header>

<div id="contenedor">
    <h1>Eliminar Médico</h1>
    
    <form action="#" method="post" id="formulario">
        <label for="email_medico">Email del médico a eliminar</label><br>
        <input type="text" id="email_medico" name="email_medico" required>
            
        <br><br>

        <button type="submit">Eliminar</button>
    </form>

    <?php if (!empty($mensaje)) { ?>
        <div><?php echo $mensaje; ?></div>
    <?php } ?>
    <br>
    <br>
</div>


<a href="../menu-admin.php">Regresar al menú del administrador <span class="material-symbols-outlined">
            arrow_left_alt
            </span></a> <br>

    
</body>
</html>
