-- Creación de la tabla Direccion
CREATE TABLE Direccion (
    Id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    Ciudad VARCHAR(50),
    Calle VARCHAR(50)
);

-- Creación de la tabla Hospital
CREATE TABLE Hospital (
    Id_hospital INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE,
    Id_direccion INT,
    FOREIGN KEY (Id_direccion) REFERENCES Direccion(Id_direccion)
);

-- Creación de la tabla Departamento
CREATE TABLE Departamento (
    Id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    Id_hospital INT,
    Nombre VARCHAR(50),
    Ubicacion VARCHAR(50),
    CONSTRAINT ak_departamento UNIQUE(Nombre, Id_hospital),
    FOREIGN KEY (Id_hospital) REFERENCES Hospital(Id_hospital)
);

-- Creación de la tabla Paciente
CREATE TABLE Paciente (
    Id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellidos VARCHAR(50),
    Telefono INT,
    Fecha_nacimiento DATE,
    Id_direccion INT,
    Email VARCHAR(50) UNIQUE,
    PIN INT,
    FOREIGN KEY (Id_direccion) REFERENCES Direccion(Id_direccion)
);

-- Creación de la tabla Medico
CREATE TABLE Medico (
    Id_medico INT AUTO_INCREMENT PRIMARY KEY,
    Id_departamento INT,
    Nombre VARCHAR(50),
    Apellidos VARCHAR(50),
    Telefono INT,
    Fecha_nacimiento DATE,
    Id_direccion INT,
    Email VARCHAR(50) UNIQUE,
    PIN INT,
    FOREIGN KEY (Id_departamento) REFERENCES Departamento(Id_departamento),
    FOREIGN KEY (Id_direccion) REFERENCES Direccion(Id_direccion)
);

-- Creación de la tabla Diagnostico
CREATE TABLE Diagnostico (
    Id_diagnostico INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(100),
    Recomendacion VARCHAR(100)
);

-- Creación de la tabla Cita
CREATE TABLE Cita (
    Id_cita INT AUTO_INCREMENT PRIMARY KEY,
    Id_medico INT,
    Id_paciente INT,
    Id_diagnostico INT,
    Fecha DATE,
    Hora TIMESTAMP,
    Estado VARCHAR(50),
    FOREIGN KEY (Id_medico) REFERENCES Medico(Id_medico),
    FOREIGN KEY (Id_paciente) REFERENCES Paciente(Id_paciente),
    FOREIGN KEY (Id_diagnostico) REFERENCES Diagnostico(Id_diagnostico)
);

-- Creación de la tabla Medicamento
CREATE TABLE Medicamento (
    Id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    Id_diagnostico INT,
    Nombre VARCHAR(50),
    Frecuencia VARCHAR(100),
    FOREIGN KEY (Id_diagnostico) REFERENCES Diagnostico(Id_diagnostico)
);