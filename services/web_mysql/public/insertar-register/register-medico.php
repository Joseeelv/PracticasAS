<!DOCTYPE html>
<html>
<head>
    <title>HospiHub - Registrarse como médico</title>  
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
    <link rel="stylesheet" href="../css/register.css">
    <!-- Enlace al archivo JavaScript -->
    
</head>
<body>

<?php
    // Conexión a la base de datos Oracle
    include('../conexion.php');
    $conexion = conexion();

    // Comprobar si se envió el formulario
    if($_SERVER["REQUEST_METHOD"] == "POST"){
        // Recuperar datos del formulario
        $nombre = $_POST["nombre"];
        $apellidos = $_POST["apellidos"];
        $telefono = $_POST["telefono"];
        $fecha_nacimiento = $_POST["fecha"];
        $ciudad = $_POST["ciudad"];
        $calle = $_POST["calle"];
        $email = $_POST["email"];
        $pin = $_POST["pin"];
        $hospital = $_POST["hospital"];
        $departamento = $_POST["departamento"];

        // Preparar y ejecutar la consulta SQL
        $sql = "BEGIN Insertar.Insertar_Medico(:hospital,:departamento, :nombre, :apellidos, :telefono, TO_DATE(:fecha_nacimiento, 'YYYY-MM-DD'), :ciudad, :calle, :email, :pin); END;";
        $stid = oci_parse($conexion, $sql);
        oci_bind_by_name($stid, ":nombre", $nombre);
        oci_bind_by_name($stid, ":apellidos", $apellidos);
        oci_bind_by_name($stid, ":telefono", $telefono);
        oci_bind_by_name($stid, ":fecha_nacimiento", $fecha_nacimiento);
        oci_bind_by_name($stid, ":ciudad", $ciudad);
        oci_bind_by_name($stid, ":calle", $calle);
        oci_bind_by_name($stid, ":email", $email);
        oci_bind_by_name($stid, ":pin", $pin);
        oci_bind_by_name($stid, ":departamento", $departamento);
        oci_bind_by_name($stid, ":hospital", $hospital);
        oci_execute($stid);
        oci_error();
    }
?>

    <header>   
        <nav>
            <div id="logo">HospiHub</div>
        </nav>
    </header>

    <div id="contenedor">
        <h1>Registrarse como médico<span class="material-symbols-outlined">
            stethoscope
        </span>
        </h1>
    
        <form action="#" method="post" id="formulario">
            <label for="nombre">Nombre</label><br>
            <input type="text" id="nombre" name="nombre" required>
    
            <br><br>
    
            <label for="apellidos">Apellidos</label><br>
            <input type="text" id="apellidos" name="apellidos" required>
    
            <br><br>
    
            <label for="telefono">Teléfono</label><br>
            <input type="number" id="telefono" name="telefono" required>
    
            <br><br>
    
            <label for="fecha">Fecha de nacimiento</label><br>
            <input type="date" id="fecha" name="fecha" required>
                    
            <br><br>
            
            <label for="ciudad">Ciudad</label><br>
            <input type="text" id="ciudad" name="ciudad" required>
            
            <br><br>
            
            <label for="calle">Calle</label><br>
            <input type="text" id="calle" name="calle" required>
            
            <br><br>
    
            <label for="email">Email</label><br>
            <input type="text" id="email" name="email" required>
    
            <br><br>
    
            <label for="pin">Pin</label><br>
            <input type="number" id="pin" name="pin" required>
           
            <br><br>

            <label for="hospital">Hospital</label><br>
            <input type="text" id="hospital" name="hospital" required> 

            <br><br>
            
            <label for="departamento">Departamento</label><br>
            <input type="text" id="departamento" name="departamento" required> 

            <br><br>

            <button type="submit">Registrarse</button>
    
        </form>
        <br>
        <br>
    </div>
	
    
<a href="../menu-admin.php">Regresar al menú del administrador <span class="material-symbols-outlined">
            arrow_left_alt
            </span></a> <br>


</body>
</html>