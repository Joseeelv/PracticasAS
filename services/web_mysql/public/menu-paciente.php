<?php
// Iniciar la sesión para acceder al id_paciente
session_start();
$id_paciente = $_GET['id_paciente']; // Obtener el ID del paciente de la URL
echo "ID del paciente: $id_paciente";
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Tu nombre">
    <meta name="description" content="Descripción de la página">
    <title>Menú de Gestión de Citas</title>
    <!-- Enlaces a las fuentes de Google y hojas de estilos -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,300..900;1,300..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="css/index.css">
</head>
<body>
    <header>   
        <nav>
            <div id="logo">HospiHub</div>
        </nav>
    </header>

    <br><br><br><br>

    <h2>Menú de Paciente <span class="material-symbols-outlined">
        personal_injury</span></h2>

   

    <div class="opcion">
        <a href="fun-paciente/elegir-citas.php">Solictar una cita <span class="material-symbols-outlined">
            event_note
        </span></a>
        <a href="fun-paciente/ver-citas-paciente.php">Ver citas <span class="material-symbols-outlined">
            event_note
        </span></a>
        <a href="index.html">Volver al menú principal <span class="material-symbols-outlined">
            home
        </span></a>
    </div>
    

</body>
</html>