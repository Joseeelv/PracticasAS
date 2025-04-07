DELIMITER $$

-- Procedimiento para insertar un paciente

CREATE PROCEDURE Insertar_Paciente(
    IN nombre_param VARCHAR(100),
    IN apellidos_param VARCHAR(100),
    IN telefono_param VARCHAR(20),
    IN fecha_nacimiento_param DATE,
    IN ciudad_param VARCHAR(100),
    IN calle_param VARCHAR(255),
    IN email_param VARCHAR(100),
    IN pin_param VARCHAR(50)
)
BEGIN
    DECLARE id_direccion_existente INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al insertar el paciente';
    END;

    START TRANSACTION;

    -- Verificar si la dirección ya existe
    SELECT Id_direccion INTO id_direccion_existente
    FROM Direccion
    WHERE Ciudad = ciudad_param AND Calle = calle_param
    LIMIT 1;

    -- Si no existe, insertamos una nueva dirección
    IF id_direccion_existente IS NULL THEN
        INSERT INTO Direccion (Ciudad, Calle)
        VALUES (ciudad_param, calle_param);
        
        -- Obtener el ID de la nueva dirección
        SET id_direccion_existente = LAST_INSERT_ID();
    END IF;

    -- Insertar el paciente con la dirección correcta
    INSERT INTO Paciente (Nombre, Apellidos, Telefono, Fecha_nacimiento, Id_direccion, Email, PIN)
    VALUES (nombre_param, apellidos_param, telefono_param, fecha_nacimiento_param, id_direccion_existente, email_param, pin_param);

    COMMIT;
    SELECT 'Paciente insertado correctamente' AS Mensaje;
END $$




-- Procedimiento para insertar un médico
CREATE PROCEDURE Insertar_Medico(
    IN nombre_hospital VARCHAR(50),
    IN nombre_departamento VARCHAR(50),
    IN nombre VARCHAR(50),
    IN apellidos VARCHAR(50),
    IN telefono INT,
    IN fecha_nacimiento DATE,
    IN ciudad VARCHAR(50),
    IN calle VARCHAR(50),
    IN email VARCHAR(50),
    IN pin INT
)
BEGIN
    DECLARE v_id_hospital INT;
    DECLARE v_id_departamento INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al insertar el médico';
    END;

    START TRANSACTION;

    -- Obtener el ID del hospital
    SELECT Id_hospital INTO v_id_hospital FROM Hospital WHERE Nombre = nombre_hospital;

    -- Obtener el ID del departamento
    SELECT Id_departamento INTO v_id_departamento FROM Departamento WHERE Nombre = nombre_departamento AND Id_hospital = v_id_hospital;

    -- Insertar la dirección si no existe
    INSERT INTO Direccion (Ciudad, Calle) 
    SELECT ciudad, calle FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM Direccion WHERE Ciudad = ciudad AND Calle = calle);
    
    SET @id_direccion = (SELECT Id_direccion FROM Direccion WHERE Ciudad = ciudad AND Calle = calle LIMIT 1);

    -- Insertar el médico
    INSERT INTO Medico (Id_departamento, Nombre, Apellidos, Telefono, Fecha_nacimiento, Id_direccion, Email, PIN)
    VALUES (v_id_departamento, nombre, apellidos, telefono, fecha_nacimiento, @id_direccion, email, pin);

    COMMIT;
    SELECT 'Médico insertado correctamente' AS Mensaje;
END$$

-- Procedimiento para insertar un departamento
CREATE PROCEDURE Insertar_Departamento(
    IN nombre_hospital VARCHAR(50),
    IN nombre VARCHAR(50),
    IN ubicacion VARCHAR(50)
)
BEGIN
    DECLARE v_id_hospital INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al insertar el departamento';
    END;

    START TRANSACTION;

    -- Obtener el ID del hospital
    SELECT Id_hospital INTO v_id_hospital FROM Hospital WHERE Nombre = nombre_hospital;

    -- Insertar el departamento si no existe
    INSERT INTO Departamento (Id_hospital, Nombre, Ubicacion) 
    SELECT v_id_hospital, nombre, ubicacion FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM Departamento WHERE Nombre = nombre AND Id_hospital = v_id_hospital);

    COMMIT;
    SELECT 'Departamento insertado correctamente' AS Mensaje;
END$$

-- Procedimiento para insertar un hospital

CREATE PROCEDURE Insertar_Hospital(
    IN nombre_param VARCHAR(50),
    IN ciudad_param VARCHAR(50),
    IN calle_param VARCHAR(50)
)
BEGIN
    DECLARE id_direccion_existente INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al insertar el hospital';
    END;

    START TRANSACTION;

    -- Verificar si la dirección ya existe
    SELECT Id_direccion INTO id_direccion_existente
    FROM Direccion
    WHERE Ciudad = ciudad_param AND Calle = calle_param
    LIMIT 1;

    -- Si no existe, insertamos una nueva dirección
    IF id_direccion_existente IS NULL THEN
        INSERT INTO Direccion (Ciudad, Calle)
        VALUES (ciudad_param, calle_param);
        
        -- Obtener el ID de la nueva dirección
        SET id_direccion_existente = LAST_INSERT_ID();
    END IF;

    -- Insertar el hospital si no existe
    IF NOT EXISTS (SELECT 1 FROM Hospital WHERE Nombre = nombre_param) THEN
        INSERT INTO Hospital (Nombre, Id_direccion) 
        VALUES (nombre_param, id_direccion_existente);
    END IF;

    COMMIT;
    SELECT 'Hospital insertado correctamente' AS Mensaje;
END $$



-- Procedimiento para insertar un diagnóstico
CREATE PROCEDURE Insertar_Diagnostico(
    IN cita_id INT,
    IN descripcion VARCHAR(100),
    IN recomendacion VARCHAR(100)
)
BEGIN
    DECLARE v_diagnostico_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al insertar el diagnóstico';
    END;

    START TRANSACTION;

    -- Insertar el diagnóstico
    INSERT INTO Diagnostico (Descripcion, Recomendacion) VALUES (descripcion, recomendacion);
    SET v_diagnostico_id = LAST_INSERT_ID();

    -- Actualizar la cita con el ID del diagnóstico
    UPDATE Cita SET Id_diagnostico = v_diagnostico_id, Estado = 'Diagnostico Completo' WHERE Id_cita = cita_id;

    COMMIT;
    SELECT 'Diagnóstico insertado correctamente' AS Mensaje;
END$$

DELIMITER ;
-----------------------------
   --INSERTAR MEDICAMENTO--    
-----------------------------
DELIMITER $$

CREATE PROCEDURE Insertar_Medicamento(
    IN id_diagnostico INT,
    IN nombre_medicamento VARCHAR(255),
    IN frecuencia VARCHAR(255)
)
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
        -- Usar GET DIAGNOSTICS para MySQL en lugar de ERROR_MESSAGE()
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
        @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        SELECT CONCAT('Error al insertar el medicamento: ', @text) AS mensaje_error;
    END;

    START TRANSACTION;
    INSERT INTO Tabla_Medicamento (Id_diagnostico, Nombre, Frecuencia)
    VALUES (id_diagnostico, nombre_medicamento, frecuencia);
    COMMIT;

    SELECT 'Medicamento insertado correctamente' AS mensaje;
END$$

DELIMITER ;



DELIMITER $$

-- Procedimiento para eliminar un paciente
CREATE PROCEDURE Eliminar_Paciente(
    IN email_paciente VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al eliminar el paciente';
    END;

    START TRANSACTION;

    -- Eliminar citas asociadas al paciente
    DELETE FROM Cita WHERE Id_paciente = (SELECT Id_paciente FROM Paciente WHERE Email = email_paciente);
    
    -- Eliminar el paciente
    DELETE FROM Paciente WHERE Email = email_paciente;

    COMMIT;
    SELECT 'Paciente eliminado correctamente' AS Mensaje;
END$$

-- Procedimiento para eliminar un médico
CREATE PROCEDURE Eliminar_Medico(
    IN email_medico VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al eliminar el médico';
    END;

    START TRANSACTION;

    -- Eliminar citas asociadas al médico
    DELETE FROM Cita WHERE Id_medico = (SELECT Id_medico FROM Medico WHERE Email = email_medico);
    
    -- Eliminar el médico
    DELETE FROM Medico WHERE Email = email_medico;

    COMMIT;
    SELECT 'Médico eliminado correctamente' AS Mensaje;
END$$

-- Procedimiento para eliminar un departamento
DELIMITER //

CREATE PROCEDURE Eliminar_Departamento(
    IN p_id_departamento INT
)
BEGIN
    DECLARE v_tiene_medicos INT DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al eliminar el departamento' AS resultado;
    END;

    START TRANSACTION;

    -- Verificar si el departamento tiene médicos asignados
    SELECT COUNT(*) INTO v_tiene_medicos
    FROM Medico
    WHERE Id_departamento = p_id_departamento;
    
    IF v_tiene_medicos > 0 THEN
        SELECT 'No se puede eliminar el departamento porque tiene médicos asignados' AS resultado;
    ELSE
        -- Eliminar el departamento
        DELETE FROM Departamento 
        WHERE Id_departamento = p_id_departamento;
        
        SELECT 'Departamento eliminado correctamente' AS resultado;
    END IF;

    COMMIT;
END //

DELIMITER ;

DELIMITER $$

-- Procedimiento para eliminar un hospital
CREATE PROCEDURE Eliminar_Hospital(
    IN nombre_hospital VARCHAR(50)
)
BEGIN
    DECLARE v_id_hospital INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al eliminar el hospital';
    END;

    START TRANSACTION;

    -- Obtener el ID del hospital
    SELECT Id_hospital INTO v_id_hospital FROM Hospital WHERE Nombre = nombre_hospital;
    
    -- Eliminar departamentos asociados al hospital
    DELETE FROM Departamento WHERE Id_hospital = v_id_hospital;
    
    -- Eliminar el hospital
    DELETE FROM Hospital WHERE Id_hospital = v_id_hospital;

    COMMIT;
    SELECT 'Hospital eliminado correctamente' AS Mensaje;
END$$

-- Función para obtener el máximo ID de diagnóstico
CREATE FUNCTION Obtener_Max_Id_Diagnostico() RETURNS INT  
READS SQL DATA  
BEGIN  
    DECLARE max_id_diagnostico INT;  

    -- Obtener el máximo ID de diagnóstico (manejar nulos)  
    SELECT IFNULL(MAX(Id_diagnostico), 0) INTO max_id_diagnostico FROM Diagnostico;  

    RETURN max_id_diagnostico;  
END$$  

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE `Crear_Citas`()
BEGIN
    DECLARE v_fecha_inicio DATE;
    DECLARE v_fecha_fin DATE;
    DECLARE v_fecha_actual DATE;
    DECLARE v_hora TIME;
    DECLARE v_estado VARCHAR(50) DEFAULT 'Paciente sin asignar';
    DECLARE v_citas_existen INT;
    
    DECLARE done INT DEFAULT FALSE;
    DECLARE hospital_id INT;
    DECLARE dept_id INT;
    DECLARE medico_id INT;

    -- Cursores para hospitales, departamentos y médicos
    DECLARE cur_hospital CURSOR FOR SELECT Id_hospital FROM Hospital;
    DECLARE cur_dept CURSOR FOR SELECT Id_departamento FROM Departamento WHERE Id_hospital = hospital_id;
    DECLARE cur_medico CURSOR FOR SELECT Id_medico FROM Medico WHERE Id_departamento = dept_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Configurar rango de fechas (1 año desde hoy)
    SET v_fecha_inicio = CURDATE();
    SET v_fecha_fin = DATE_ADD(v_fecha_inicio, INTERVAL 1 YEAR);
    SET v_fecha_actual = v_fecha_inicio;

    -- Crear citas para cada día del año
    WHILE v_fecha_actual <= v_fecha_fin DO
        -- Solo días laborables (de lunes a viernes)
        IF DAYOFWEEK(v_fecha_actual) BETWEEN 2 AND 6 THEN
            -- Verificar si ya existen citas para esta fecha
            SELECT COUNT(*) INTO v_citas_existen FROM Cita WHERE Fecha = v_fecha_actual;
            
            IF v_citas_existen = 0 THEN
                -- Reiniciar cursores para cada fecha
                SET done = FALSE;
                
                OPEN cur_hospital;
                hospital_loop: LOOP
                    FETCH cur_hospital INTO hospital_id;
                    IF done THEN LEAVE hospital_loop; END IF;

                    OPEN cur_dept;
                    dept_loop: LOOP
                        FETCH cur_dept INTO dept_id;
                        IF done THEN LEAVE dept_loop; END IF;

                        OPEN cur_medico;
                        medico_loop: LOOP
                            FETCH cur_medico INTO medico_id;
                            IF done THEN LEAVE medico_loop; END IF;

                            -- Crear citas cada hora desde las 8:00 hasta las 13:00
                            SET v_hora = TIME('08:00:00');
                            
                            WHILE v_hora <= TIME('13:00:00') DO
                                INSERT INTO Cita (
                                    Id_medico, 
                                    Fecha, 
                                    Hora, 
                                    Estado
                                ) VALUES (
                                    medico_id, 
                                    v_fecha_actual, 
                                    CONCAT(v_fecha_actual, ' ', v_hora), 
                                    v_estado
                                );

                                SET v_hora = ADDTIME(v_hora, '01:00:00');
                            END WHILE;

                        END LOOP;
                        CLOSE cur_medico;
                        SET done = FALSE;
                    END LOOP;
                    CLOSE cur_dept;
                    SET done = FALSE;
                END LOOP;
                CLOSE cur_hospital;
            END IF;
        END IF;
        
        SET v_fecha_actual = DATE_ADD(v_fecha_actual, INTERVAL 1 DAY);
    END WHILE;
    
    SELECT CONCAT('Citas creadas desde ', v_fecha_inicio, ' hasta ', v_fecha_fin) AS Resultado;
END$$

DELIMITER ;


DELIMITER //
CREATE PROCEDURE Asignar_Cita(
    IN id_paciente_param INT, 
    IN id_cita_param INT
)
BEGIN
    UPDATE Cita SET  -- Nombre de tabla corregido
        Id_paciente = id_paciente_param,
        Estado = 'Paciente Asignado'
    WHERE Id_cita = id_cita_param;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cita especificada no existe o ya ha sido asignada.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION Verificar_Credenciales_Medico(
    email_in VARCHAR(50), 
    pin_in INT  -- Cambiado a INT para coincidir con el tipo de la tabla
) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE id_medico INT;

    SELECT Id_Medico INTO id_medico
    FROM Medico  -- Nombre de tabla corregido
    WHERE Email = email_in AND PIN = pin_in;

    RETURN COALESCE(id_medico, 0);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION Verificar_Credenciales_Paciente(
    email_in VARCHAR(50), 
    pin_in INT  -- Cambiado a INT para coincidir con el tipo de la tabla
) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE paciente_id INT;

    SELECT Id_paciente INTO paciente_id
    FROM Paciente  -- Nombre de tabla corregido
    WHERE Email = email_in AND PIN = pin_in;

    RETURN COALESCE(paciente_id, 0);
END //
DELIMITER ;


-- -------------------------------
-- OBTENER DEPARTAMENTOS HOSPITALES
-- -------------------------------
DELIMITER $$

CREATE PROCEDURE Obtener_Departamentos_Hospitales_Cursor(
    IN id_departamento_param INT
)
BEGIN
    IF id_departamento_param IS NULL OR id_departamento_param = 0 THEN
        -- Si no se proporciona un ID, devolver todos los departamentos
        SELECT 
            d.Id_departamento,
            d.Nombre AS Nombre_departamento,
            d.Ubicacion AS Ubicacion_departamento,
            h.Id_hospital,
            h.Nombre AS Nombre_hospital,
            dir.Ciudad AS Ciudad_hospital,  
            dir.Calle AS Calle_hospital     
        FROM 
            Departamento d
            JOIN Hospital h ON d.Id_hospital = h.Id_hospital
            JOIN Direccion dir ON h.Id_direccion = dir.Id_direccion;
    ELSE
        -- Si se proporciona un ID, devolver solo ese departamento
        SELECT 
            d.Id_departamento,
            d.Nombre AS Nombre_departamento,
            d.Ubicacion AS Ubicacion_departamento,
            h.Id_hospital,
            h.Nombre AS Nombre_hospital,
            dir.Ciudad AS Ciudad_hospital,  
            dir.Calle AS Calle_hospital     
        FROM 
            Departamento d
            JOIN Hospital h ON d.Id_hospital = h.Id_hospital
            JOIN Direccion dir ON h.Id_direccion = dir.Id_direccion
        WHERE 
            d.Id_departamento = id_departamento_param;
    END IF;
END$$

DELIMITER ;


-- -------------------------------
-- OBTENER HOSPITALES
-- -------------------------------
DELIMITER $$

CREATE PROCEDURE Obtener_Hospitales_Cursor(
    IN p_Id_hospital INT
)
BEGIN
    IF p_Id_hospital IS NULL OR p_Id_hospital = 0 THEN
        -- Si no se recibe un ID o es 0, devuelve todos los hospitales
        SELECT 
            h.Id_hospital,
            h.Nombre AS Nombre_hospital,
            dir.Ciudad AS Ciudad_hospital,
            dir.Calle AS Calle_hospital
        FROM 
            Hospital h
            JOIN Direccion dir ON h.Id_direccion = dir.Id_direccion;
    ELSE
        -- Si se recibe un ID válido, devuelve solo ese hospital
        SELECT 
            h.Id_hospital,
            h.Nombre AS Nombre_hospital,
            dir.Ciudad AS Ciudad_hospital,
            dir.Calle AS Calle_hospital
        FROM 
            Hospital h
            JOIN Direccion dir ON h.Id_direccion = dir.Id_direccion
        WHERE 
            h.Id_hospital = p_Id_hospital;
    END IF;
END$$

DELIMITER ;


-- -------------------------------
-- OBTENER MEDICOS
-- -------------------------------
DELIMITER $$

CREATE PROCEDURE Obtener_Medicos_Cursor(
    IN id_medico_param INT
)
BEGIN
    IF id_medico_param IS NULL OR id_medico_param = 0 THEN
        -- Si no se proporciona un ID, devuelve todos los médicos
        SELECT 
            m.Id_medico,
            m.Nombre,
            m.Apellidos,
            m.Telefono,
            m.Fecha_nacimiento,
            dir.Ciudad,  
            dir.Calle,   
            m.Email,
            m.PIN,
            d.Id_departamento,
            d.Nombre AS Nombre_departamento,
            h.Id_hospital,
            h.Nombre AS Nombre_hospital
        FROM 
            Medico m
            JOIN Direccion dir ON m.Id_direccion = dir.Id_direccion  
            JOIN Departamento d ON m.Id_departamento = d.Id_departamento
            JOIN Hospital h ON d.Id_hospital = h.Id_hospital;
    ELSE
        -- Si se proporciona un ID, devuelve solo ese médico
        SELECT 
            m.Id_medico,
            m.Nombre,
            m.Apellidos,
            m.Telefono,
            m.Fecha_nacimiento,
            dir.Ciudad,  
            dir.Calle,   
            m.Email,
            m.PIN,
            d.Id_departamento,
            d.Nombre AS Nombre_departamento,
            h.Id_hospital,
            h.Nombre AS Nombre_hospital
        FROM 
            Medico m
            JOIN Direccion dir ON m.Id_direccion = dir.Id_direccion  
            JOIN Departamento d ON m.Id_departamento = d.Id_departamento
            JOIN Hospital h ON d.Id_hospital = h.Id_hospital
        WHERE 
            m.Id_medico = id_medico_param;
    END IF;
END $$

DELIMITER ;


-- -------------------------------
-- OBTENER PACIENTES
-- -------------------------------
DELIMITER //
CREATE PROCEDURE Obtener_Pacientes_Cursor(IN id_paciente_param INT)
BEGIN
    IF id_paciente_param IS NULL THEN
        -- Si no se recibe un ID, devolver todos los pacientes
        SELECT 
            p.Id_paciente,
            p.Nombre,
            p.Apellidos,
            p.Telefono,
            p.Fecha_nacimiento,
            dir.Ciudad,
            dir.Calle,
            p.Email,
            p.PIN
        FROM 
            Paciente p
        JOIN Direccion dir ON p.Id_direccion = dir.Id_direccion;
    ELSE
        -- Si se recibe un ID, devolver solo ese paciente
        SELECT 
            p.Id_paciente,
            p.Nombre,
            p.Apellidos,
            p.Telefono,
            p.Fecha_nacimiento,
            dir.Ciudad,
            dir.Calle,
            p.Email,
            p.PIN
        FROM 
            Paciente p
        JOIN Direccion dir ON p.Id_direccion = dir.Id_direccion
        WHERE p.Id_paciente = id_paciente_param;
    END IF;
END//
DELIMITER ;

-- -------------------------------
-- OBTENER CITAS
-- -------------------------------
DELIMITER //
CREATE PROCEDURE Obtener_Citas_Pendientes_Cursor(
    IN p_hospital VARCHAR(255),
    IN p_departamento VARCHAR(255),
    IN p_fecha DATE  -- Cambiado a tipo DATE
)
BEGIN
    SELECT 
        c.Id_Cita, 
        c.Fecha, 
        DATE_FORMAT(c.Hora, '%H:%i:%s') AS Hora_Cita,  -- Formato para TIMESTAMP
        c.Id_Medico, 
        m.Nombre AS Nombre_Medico
    FROM 
        Cita c
        JOIN Medico m ON c.Id_medico = m.Id_medico
        JOIN Departamento d ON m.Id_departamento = d.Id_departamento
        JOIN Hospital h ON d.Id_hospital = h.Id_hospital
    WHERE 
        h.Nombre = p_hospital 
        AND d.Nombre = p_departamento 
        AND c.Estado = 'Paciente sin asignar'
        AND c.Fecha = p_fecha;  -- Usamos fecha directamente
END //
DELIMITER ;

-- -------------------------------
-- OBTENER CITAS
-- -------------------------------
DELIMITER //
CREATE PROCEDURE Obtener_Citas_Paciente(IN paciente_id INT)
BEGIN
    SELECT 
        c.Id_Cita,
        c.Fecha,
        TIME_FORMAT(c.Hora, '%H:%i:%s') AS Hora,
        m.Nombre AS Nombre_Medico,
        m.Apellidos AS Apellidos_Medico,
        d.Nombre AS Nombre_Departamento,
        h.Nombre AS Nombre_Hospital,
        c.Estado
    FROM 
        Cita c
        JOIN Medico m ON c.Id_medico = m.Id_medico
        JOIN Departamento d ON m.Id_departamento = d.Id_departamento
        JOIN Hospital h ON d.Id_hospital = h.Id_hospital
    WHERE 
        c.Id_paciente = paciente_id
    ORDER BY 
        c.Fecha DESC, c.Hora DESC;
END //
DELIMITER ;

DELIMITER //

-- -------------------------------
-- Verificar si una cita pertenece a un paciente
-- -------------------------------

CREATE FUNCTION Verificar_Cita_Paciente(
    cita_id INT,
    paciente_id INT
) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE existe BOOLEAN;
    
    SELECT COUNT(*) > 0 INTO existe
    FROM Cita
    WHERE Id_Cita = cita_id AND Id_paciente = paciente_id;
    
    RETURN existe;
END //

-- -------------------------------
-- Cancelar una cita
-- -------------------------------

CREATE PROCEDURE Cancelar_Cita(
    IN cita_id INT,
    IN paciente_id INT,
    OUT resultado VARCHAR(100)
)
BEGIN
    DECLARE cita_valida BOOLEAN;
    
    -- Verificar si la cita pertenece al paciente
    SET cita_valida = Verificar_Cita_Paciente(cita_id, paciente_id);
    
    IF NOT cita_valida THEN
        SET resultado = 'La cita no existe o no pertenece a este paciente';
    ELSE
        -- Actualizar el estado de la cita
        UPDATE Cita 
        SET Id_paciente = NULL, 
            Estado = 'Paciente sin asignar' 
        WHERE Id_Cita = cita_id;
        
        IF ROW_COUNT() > 0 THEN
            SET resultado = 'Cita cancelada correctamente';
        ELSE
            SET resultado = 'Error al cancelar la cita';
        END IF;
    END IF;
END //

DELIMITER ;

DELIMITER $$

-- -------------------------------
-- Editar paciente
-- -------------------------------

CREATE PROCEDURE Editar_Paciente(
    IN id_paciente_param INT,
    IN nombre_param VARCHAR(100),
    IN apellidos_param VARCHAR(100),
    IN telefono_param VARCHAR(20),
    IN fecha_nacimiento_param DATE,
    IN ciudad_param VARCHAR(100),
    IN calle_param VARCHAR(255),
    IN email_param VARCHAR(100),
    IN pin_param VARCHAR(50)
)
BEGIN
    DECLARE id_direccion_existente INT;

    -- Verificar si la dirección ya existe
    SELECT Id_direccion INTO id_direccion_existente
    FROM Direccion
    WHERE Ciudad = ciudad_param AND Calle = calle_param
    LIMIT 1;

    -- Si no existe, insertamos una nueva dirección
    IF id_direccion_existente IS NULL THEN
        INSERT INTO Direccion (Ciudad, Calle)
        VALUES (ciudad_param, calle_param);
        
        -- Obtener el ID de la nueva dirección
        SET id_direccion_existente = LAST_INSERT_ID();
    END IF;

    -- Actualizar los datos del paciente con la dirección correcta
    UPDATE Paciente 
    SET 
        Nombre = nombre_param,
        Apellidos = apellidos_param,
        Telefono = telefono_param,
        Fecha_nacimiento = fecha_nacimiento_param,
        Id_direccion = id_direccion_existente,
        Email = email_param,
        PIN = pin_param
    WHERE Id_paciente = id_paciente_param;
    
END $$

DELIMITER ;


-- -------------------------------
-- Editar médico
-- -------------------------------

DELIMITER $$

CREATE PROCEDURE Editar_Medico(
    IN id_medico_param INT,
    IN nombre_param VARCHAR(100),
    IN apellidos_param VARCHAR(100),
    IN telefono_param VARCHAR(20),
    IN fecha_nacimiento_param DATE,
    IN ciudad_param VARCHAR(100),
    IN calle_param VARCHAR(100),
    IN email_param VARCHAR(255),
    IN pin_param VARCHAR(50),
    IN departamento_param VARCHAR(100),
    IN hospital_param VARCHAR(100)
)
BEGIN
    DECLARE id_direccion_existente INT;
    DECLARE id_departamento_existente INT;
    DECLARE id_hospital_existente INT;

    -- Verificar si la dirección ya existe
    SELECT Id_direccion INTO id_direccion_existente
    FROM Direccion
    WHERE Ciudad = ciudad_param AND Calle = calle_param
    LIMIT 1;

    -- Si no existe, insertamos una nueva dirección
    IF id_direccion_existente IS NULL THEN
        INSERT INTO Direccion (Ciudad, Calle)
        VALUES (ciudad_param, calle_param);
        
        -- Obtener el ID de la nueva dirección
        SET id_direccion_existente = LAST_INSERT_ID();
    END IF;

    -- Verificar si el hospital existe
    SELECT Id_hospital INTO id_hospital_existente
    FROM Hospital
    WHERE Nombre = hospital_param
    LIMIT 1;

    IF id_hospital_existente IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El hospital no existe.';
    END IF;

    -- Verificar si el departamento existe y pertenece al hospital correspondiente
    SELECT Id_departamento INTO id_departamento_existente
    FROM Departamento
    WHERE Nombre = departamento_param AND Id_hospital = id_hospital_existente
    LIMIT 1;

    IF id_departamento_existente IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El departamento no existe o no corresponde al hospital especificado.';
    END IF;

    -- Actualizar los datos del médico con la dirección correcta y el departamento correspondiente
    UPDATE Medico 
    SET 
        Nombre = nombre_param,
        Apellidos = apellidos_param,
        Telefono = telefono_param,
        Fecha_nacimiento = fecha_nacimiento_param,
        Id_direccion = id_direccion_existente,
        Email = email_param,
        PIN = pin_param,
        Id_departamento = id_departamento_existente
    WHERE Id_medico = id_medico_param;
END $$

DELIMITER ;


-- -------------------------------
-- Editar departamento
-- -------------------------------

DELIMITER $$

CREATE PROCEDURE Editar_Departamento(
    IN p_id_departamento INT,
    IN p_nombre_hospital VARCHAR(255),
    IN p_nombre_departamento VARCHAR(255),
    IN p_ubicacion VARCHAR(255)
)
BEGIN
    DECLARE v_id_hospital INT;

    -- Verificar si el hospital existe en la base de datos
    SELECT Id_hospital INTO v_id_hospital
    FROM Hospital
    WHERE Nombre = p_nombre_hospital
    LIMIT 1;

    -- Si el hospital no existe, lanzar un error
    IF v_id_hospital IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hospital no encontrado';
    END IF;

    -- Actualizar los datos del departamento si el hospital existe
    UPDATE Departamento
    SET
        nombre = p_nombre_departamento,  -- Asegúrate de que 'nombre' sea el nombre correcto de la columna en tu tabla
        ubicacion = p_ubicacion,         -- Asegúrate de que 'ubicacion' sea el nombre correcto de la columna en tu tabla
        Id_hospital = v_id_hospital
    WHERE Id_departamento = p_id_departamento;

END$$

DELIMITER ;

-- -------------------------------
-- Editar hospital
-- -------------------------------

DELIMITER $$

CREATE PROCEDURE Editar_Hospital(
    IN p_Id_hospital INT,
    IN p_Nombre VARCHAR(255),
    IN p_Ciudad VARCHAR(255),
    IN p_Calle VARCHAR(255)
)
BEGIN
    DECLARE v_Id_direccion INT;
    
    -- Verificar si la dirección ya existe
    SELECT Id_direccion INTO v_Id_direccion 
    FROM direccion 
    WHERE Ciudad = p_Ciudad AND Calle = p_Calle
    LIMIT 1;
    
    -- Si no existe, insertar nueva dirección
    IF v_Id_direccion IS NULL THEN
        INSERT INTO direccion (Ciudad, Calle) VALUES (p_Ciudad, p_Calle);
        SET v_Id_direccion = LAST_INSERT_ID();
    END IF;
    
    -- Actualizar el hospital con el nuevo nombre y la dirección
    UPDATE hospital 
    SET Nombre = p_Nombre, Id_direccion = v_Id_direccion
    WHERE Id_hospital = p_Id_hospital;
END$$

DELIMITER ;
