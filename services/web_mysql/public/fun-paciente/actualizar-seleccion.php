<!DOCTYPE html>
<html>
<head>
    <title>HospiHub - Citas Disponibles</title>
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
    <link rel="stylesheet" href="../css/procesar-citas.css">
    <!-- Enlace al archivo JavaScript hola jefe -->
    
</head>
<body>
    <header>   
        <nav>
            <div id="logo">HospiHub</div>
        </nav>
    </header>
<?php
    session_start(); // Iniciar la sesión para acceder al id_paciente

    // Verificar si se recibió el ID de la cita seleccionada y el ID del paciente
    if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['cita_id']) && isset($_SESSION['id_paciente'])) {
        // Obtener el ID de la cita seleccionada y el ID del paciente desde la sesión
        $id_cita = $_POST['cita_id'];
        $id_paciente = $_SESSION['id_paciente'];
        

        // Conectar a la base de datos
        include('../conexion.php');
        $conexion = conexion();

        // Preparar la consulta SQL para actualizar la cita con el ID del paciente y cambiar su estado
        $sql = "BEGIN Otros.Asignar_Cita(:id_paciente, :id_cita); END;";
        $stmt = oci_parse($conexion, $sql);

        // Bind de los parámetros
        oci_bind_by_name($stmt, ":id_paciente", $id_paciente);
        oci_bind_by_name($stmt, ":id_cita", $id_cita);

        // Ejecutar la consulta
        $resultado = oci_execute($stmt);

        // Verificar si la actualización fue exitosa
        if ($resultado) {
            echo "<br><br><br><br><br><hr style='border-top: 3px solid #52ee57; border-bottom: 3px solid #52ee57;'><p style='color:#52ee57; text-align:center; font-size: 1.5em;' >Su cita ha sido reservada correctamente.</p><hr style='border-top: 3px solid #52ee57; border-bottom: 3px solid #52ee57;'>";
        } else {
            echo "Error al asignar la cita.";
        }

        // Liberar recursos
        oci_free_statement($stmt);
        oci_close($conexion);
    } else {
        // Redireccionar si no se recibió el ID de la cita o el ID del paciente
        header("Location: elegir-citas.php");
        exit();
    }
?>

<br><br>

    <br>
    <a href="../menu-paciente.php">Regresar al menú del paciente <span class="material-symbols-outlined">
            arrow_left_alt
            </span></a>
    
</body>
</html>