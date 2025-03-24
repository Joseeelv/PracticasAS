<?php
// Iniciar la sesión para acceder al id_paciente
session_start();
?>
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

    <nav>
        <div id="logo">HospiHub</div>
    </nav>

    <div id="contenedor">
        <h1>Citas Disponibles</h1>

        <?php
// Conecta al servicio XE (esto es, una base de datos) en el servidor "localhost"
include('../conexion.php');
$conexion = conexion();

$hospital = $_POST['hospital'];
$departamento = $_POST['departamento'];
$fecha_formulario = $_POST['fecha'];

$fecha  = date('d/m/Y', strtotime($fecha_formulario));

echo "<h2>Hospital: $hospital</h2>";
echo "<h2>Departamento: $departamento</h2>";
echo "<h2>Fecha: $fecha</h2>";

// Preparar la llamada a la función que devuelve un cursor con las citas pendientes
$cursor = oci_new_cursor($conexion);
$consulta = oci_parse($conexion, "BEGIN :cursor := Obtener.Obtener_Citas_Pendientes_Cursor(:hospital, :departamento, :fecha); END;");

// Asignar el parámetro de salida para el cursor
oci_bind_by_name($consulta, ":cursor", $cursor, -1, OCI_B_CURSOR);
oci_bind_by_name($consulta, ":hospital", $hospital);
oci_bind_by_name($consulta, ":departamento", $departamento);
oci_bind_by_name($consulta, ":fecha", $fecha);

// Ejecutar la consulta
oci_execute($consulta);
oci_execute($cursor);

// Mostrar los resultados en una tabla
echo "<table class='table table-striped'>\n";
echo "<thead>";
echo "<tr>";
echo "<th>Id de la cita</th>";
echo "<th>Fecha de la cita</th>";
echo "<th>Hora de la cita</th>";
echo "<th>Id del Medico</th>";
echo "<th>Medico de la Cita</th>";
echo "<th>Seleccionar</th>"; // Agregar una nueva columna para el botón "Seleccionar"
echo "</tr>";
echo "</thead>";
while ($row = oci_fetch_array($cursor, OCI_ASSOC+OCI_RETURN_NULLS)) {
    echo "<tr>\n";
    foreach ($row as $item) {
        echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "") . "</td>\n";
    }
    // Agregar el formulario y el botón "Seleccionar" en cada fila de la tabla
    echo "<td>";
    echo "<form action='actualizar-seleccion.php' method='post'>";
    echo "<input type='hidden' name='cita_id' value='" . $row['ID_CITA'] . "'>"; // Pasar el ID de la cita
    echo "<button type='submit'>Seleccionar</button>"; // Botón "Seleccionar"
    echo "</form>";
    echo "</td>";
    echo "</tr>\n";
}
echo "</table>\n";

// Liberar recursos
oci_free_statement($consulta);
oci_close($conexion);
?>

    </div>

    <br><br><br>
    <a href="elegir-citas.php">Volver atrás <span class="material-symbols-outlined">
            arrow_left_alt
            </span></a>

    <br>
    <a href="../menu-paciente.php">Regresar al menú del paciente <span class="material-symbols-outlined">
            arrow_left_alt
            </span></a>
    
</body>
</html>