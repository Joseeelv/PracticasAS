<?php
// Verificar si se recibieron los datos del formulario
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['cita_id']) && isset($_POST['descripcion']) && isset($_POST['recomendacion'])) {
    // Obtener los datos del formulario
    $cita_id = $_POST['cita_id'];
    $descripcion = $_POST['descripcion'];
    $recomendacion = $_POST['recomendacion'];

    // Conectar a la base de datos
    include('../conexion.php');
    $conexion = conexion();

    // Preparar la consulta para insertar el diagnóstico
    $sqlDiagnostico = "BEGIN Insertar.Insertar_Diagnostico(:cita_id, :descripcion, :recomendacion); END;";
    $stmtDiagnostico = oci_parse($conexion, $sqlDiagnostico);

    // Bind de los parámetros
    oci_bind_by_name($stmtDiagnostico, ":cita_id", $cita_id);
    oci_bind_by_name($stmtDiagnostico, ":descripcion", $descripcion);
    oci_bind_by_name($stmtDiagnostico, ":recomendacion", $recomendacion);

    // Ejecutar la consulta para insertar el diagnóstico
    $resultadoDiagnostico = oci_execute($stmtDiagnostico);

    // Verificar si la inserción del diagnóstico fue exitosa
    if ($resultadoDiagnostico) {
        echo "El diagnóstico se ha insertado correctamente.<br>";

        // Obtener el ID del diagnóstico insertado
        $idDiagnostico = obtenerIdDiagnostico($conexion);

        // Verificar si se recibieron los datos de los medicamentos
        if (isset($_POST['nombre_medicamento']) && isset($_POST['frecuencia'])) {
            // Obtener los datos de los medicamentos
            $nombresMedicamentos = $_POST['nombre_medicamento'];
            $frecuencias = $_POST['frecuencia'];

            // Preparar la consulta para insertar los medicamentos asociados al diagnóstico
            $sqlMedicamento = "BEGIN Insertar_Medicamento(:id_diagnostico, :nombre_medicamento, :frecuencia); END;";
            $stmtMedicamento = oci_parse($conexion, $sqlMedicamento);

            // Iterar sobre los datos de los medicamentos y ejecutar la consulta para cada uno
            for ($i = 0; $i < count($nombresMedicamentos); $i++) {
                // Obtener los datos del medicamento actual
                $nombreMedicamento = $nombresMedicamentos[$i];
                $frecuencia = $frecuencias[$i];

                // Bind de los parámetros
                oci_bind_by_name($stmtMedicamento, ":id_diagnostico", $idDiagnostico);
                oci_bind_by_name($stmtMedicamento, ":nombre_medicamento", $nombreMedicamento);
                oci_bind_by_name($stmtMedicamento, ":frecuencia", $frecuencia);

                // Ejecutar la consulta para insertar el medicamento
                $resultadoMedicamento = oci_execute($stmtMedicamento);

                // Verificar si la inserción del medicamento fue exitosa
                if ($resultadoMedicamento) {
                    echo "El medicamento '$nombreMedicamento' se ha asociado al diagnóstico correctamente.<br>";
                } else {
                    echo "Error al insertar el medicamento '$nombreMedicamento'.<br>";
                }
            }
        } else {
            echo "No se recibieron datos de medicamentos.<br>";
        }
    } else {
        echo "Error al insertar el diagnóstico.<br>";
    }

    // Cerrar las conexiones y liberar los recursos
    oci_free_statement($stmtDiagnostico);
    oci_free_statement($stmtMedicamento);
    oci_close($conexion);
} else {
    echo "No se recibieron todos los datos necesarios.<br>";
}

// Función para obtener el ID del diagnóstico insertado
function obtenerIdDiagnostico($conexion)
{
    // Preparar la consulta SQL para llamar a la función PL/SQL
    $sql = "BEGIN :max_id := Obtener_Max_Id_Diagnostico(); END;";
    $stmt = oci_parse($conexion, $sql);
    
    // Bind de los parámetros
    oci_bind_by_name($stmt, ":max_id", $maxId, 100);
    
    // Ejecutar la consulta
    oci_execute($stmt);
    
    // Verificar si se obtuvo un valor válido
    if ($maxId !== null) {
        return $maxId;
    } else {
        // Manejar el caso en el que la función devuelve NULL
        // Aquí puedes lanzar una excepción o devolver un valor predeterminado
        return -1; // Por ejemplo, devolver -1 si no se puede obtener el valor
    }
}

?>
