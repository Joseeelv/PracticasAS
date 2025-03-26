
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="Carlos Antonio Cortés Lora, Roberto Rivero Díaz">
    <meta name="designer" content="Carlos Antonio Cortés Lora, Roberto Rivero Díaz">
    <!-- Enlaces a las fuentes de Google y hojas de estilos -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Rubik:ital,wght@0,300..900;1,300..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Enlaces a los archivos CSS -->
    <link rel="stylesheet" href="css/menu.css">
    <title>HospiHub - Menú del adminstrador</title>
</head>
<body>
    <header>   
        <nav>
            <div id="logo">HospiHub</div>
        </nav>
    </header>

    <br><br>

    <h1>Menú del Administrador <span class="material-symbols-outlined">
        admin_panel_settings
    </span></h1>

    <div class="opcion">
        <h2>Dar de Alta <span class="material-symbols-outlined">
            done
            </span>
        </h2>
        <a href="insertar-register/register-paciente.php">Registrar a un paciente
            <span class="material-symbols-outlined">
                personal_injury</span>
        </a>
    
        <a href="insertar-register/register-medico.php">Registrar a un médico
            <span class="material-symbols-outlined">
                stethoscope
            </span>
        </a>
    
        <a href="insertar-register/insertar-departamento.php">Registrar un departamento
            <span class="material-symbols-outlined">
                business
            </span>
        </a>

        <a href="insertar-register/insertar-hospital.php">Registrar un hospital
            <span class="material-symbols-outlined">
                local_hospital
            </span>
        </a>
    
        <h2>Ver <span class="material-symbols-outlined">
            info
            </span></h2>
        <a href="ver/ver-pacientes.php">Ver pacientes
            <span class="material-symbols-outlined">
                personal_injury
            </span>
        </a>
    
        <a href="ver/ver-medicos.php">Ver médicos
            <span class="material-symbols-outlined">
                stethoscope
            </span>
        </a>
        
        <a href="ver/ver-departamentos.php">Ver departamentos
            <span class="material-symbols-outlined">
                business
            </span>
        </a>
        
        <a href="ver/ver-hospitales.php">Ver hospitales
            <span class="material-symbols-outlined">
                local_hospital
            </span>
        </a>
    
    
        <h2>Eliminar <span class="material-symbols-outlined">
            close
            </span></h2>
        <a href="eliminar/eliminar-paciente.php">Eliminar paciente
            <span class="material-symbols-outlined">
                personal_injury
            </span>
        </a>
    
        <a href="eliminar/eliminar-medico.php">Eliminar médico
            <span class="material-symbols-outlined">
                stethoscope
            </span>
        </a>
    
        <a href="eliminar/eliminar-departamento.php">Eliminar departamento
            <span class="material-symbols-outlined">
                business
            </span>
        </a>

        <a href="eliminar/eliminar-hospital.php">Eliminar hospital
            <span class="material-symbols-outlined">
                local_hospital
            </span>
        </a>
        
        <h2>Opciones de las citas <span class="material-symbols-outlined">
            event
            </span>
        </h2>



        <a href="admin-citas/crear-citas.php">Crear citas
            <span class="material-symbols-outlined">
                event
            </span>
        </a>

        <a href="admin-citas/ver-citas.php">Ver citas
            <span class="material-symbols-outlined">
                event
            </span>
        </a>


        <a href="admin-citas/eliminar-citas.php">Cancelar las citas
            <span class="material-symbols-outlined">
                event
            </span>
        </a>


        <h2>Salir <span class="material-symbols-outlined">
            logout
            </span>
        </h2>

        <a href=".." id="volver">Volver al inicio <span class="material-symbols-outlined">
            home
            </span>
        </a>

    
    </div>
    
   

</body>
</html>
