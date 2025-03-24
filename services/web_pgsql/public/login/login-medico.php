<!DOCTYPE html>
<html>
<head>
    <title>HospiHub - Login de medico</title>
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
    <link rel="stylesheet" href="../css/register.css">
</head>
<body>

<?php
    // Incluir el archivo de conexión a la base de datos MySQL
    include('../conexion.php');
    $conexion = conexion(); // Llamamos a la función que crea la conexión

    // Comprobar si se envió el formulario
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // Recuperar datos del formulario
        $email = $_POST["email"];
        $pin = $_POST["pin"];

        // Preparar la consulta para verificar credenciales
        $sql = "SELECT id_medico FROM Medico WHERE email = ? AND pin = ?";
        $stmt = mysqli_prepare($conexion, $sql);
        
        if ($stmt) {
            // Vincular parámetros
            mysqli_stmt_bind_param($stmt, "ss", $email, $pin);
            mysqli_stmt_execute($stmt);
            mysqli_stmt_store_result($stmt);

            // Verificar si se encontró un médico con esas credenciales
            if (mysqli_stmt_num_rows($stmt) > 0) {
                mysqli_stmt_bind_result($stmt, $medico_id);
                mysqli_stmt_fetch($stmt);

                // Iniciar sesión y redirigir
                session_start();
                $_SESSION['medico_id'] = $medico_id;
                $_SESSION['email'] = $email;
                header("Location: ../menu-medico.php");
                exit();
            } else {
                echo "<br><br><br><br><hr style='border-top: 3px solid red; border-bottom: 3px solid red;'>
                      <p style='color:red; text-align:center; font-size: 1.5em;'>Las credenciales de inicio de sesión son incorrectas. Por favor, inténtalo de nuevo.</p>
                      <hr style='border-top: 3px solid red; border-bottom: 3px solid red;'>";
            }

            // Cerrar la consulta
            mysqli_stmt_close($stmt);
        }

        // Cerrar conexión a la base de datos
        mysqli_close($conexion);
    }
?>

<header>   
    <nav>
        <div id="logo">HospiHub</div>
    </nav>
</header>

<div id="contenedor">
    <h1>Iniciar sesión como medico<span class="material-symbols-outlined">stethoscope</span></h1>

    <form action="#" method="post" id="formulario">
        <label for="email">Email</label><br>
        <input type="text" id="email" name="email" required>
        <br><br>

        <label for="pin">Pin</label><br>
        <input type="number" id="pin" name="pin" required>
        <br><br>

        <button type="submit">Entrar</button>
    </form>
    <br><br>
</div>

<a href=".." id="volver">Volver al inicio <span class="material-symbols-outlined">home</span></a>

</body>
</html>
