-- Insertar direcciones
INSERT INTO Direccion (Ciudad, Calle) VALUES 
('Madrid', 'Gran Vía 1'),
('Barcelona', 'Diagonal 100'),
('Valencia', 'Avenida del Puerto 45');

-- Insertar hospitales
INSERT INTO Hospital (Nombre, Id_direccion) VALUES 
('Hospital Central', 1),
('Clínica Barcelona', 2),
('Hospital Valencia', 3);

-- Insertar departamentos
INSERT INTO Departamento (Id_hospital, Nombre, Ubicacion) VALUES 
(1, 'Cardiología', 'Piso 1'),
(1, 'Pediatría', 'Piso 2'),
(2, 'Traumatología', 'Piso 3');

-- Insertar pacientes
INSERT INTO Paciente (Nombre, Apellidos, Telefono, Fecha_nacimiento, Id_direccion, Email, PIN) VALUES 
('Juan', 'Pérez', 612345678, '1980-05-14', 1, 'juan.perez@mail.com', 1234),
('Ana', 'López', 622345678, '1992-07-22', 2, 'ana.lopez@mail.com', 5678),
('Carlos', 'Gómez', 632345678, '1985-10-30', 3, 'carlos.gomez@mail.com', 9101);

-- Insertar médicos
INSERT INTO Medico (Id_departamento, Nombre, Apellidos, Telefono, Fecha_nacimiento, Id_direccion, Email, PIN) VALUES 
(1, 'Laura', 'Fernández', 642345678, '1975-03-21', 1, 'laura.fernandez@mail.com', 4321),
(2, 'David', 'Martínez', 652345678, '1983-11-10', 2, 'david.martinez@mail.com', 8765),
(3, 'Sofía', 'Ruiz', 662345678, '1990-06-15', 3, 'sofia.ruiz@mail.com', 1112);
