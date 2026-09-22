-- =============================================================================
-- REPOSITY UPLA - ARQUITECTURA DE SOFTWARE
-- Script de Creación e Inserción Inicial (Seed) para Supabase PostgreSQL
-- Autor / Estudiante: Alessander (Ingeniería de Sistemas - UPLA)
-- Institución: Universidad Peruana Los Andes (UPLA)
-- =============================================================================

-- 1. Eliminar tablas si existen (Limpieza segura)
DROP TABLE IF EXISTS entregables CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS unidades CASCADE;

-- 2. Tabla de Unidades Académicas (4 Unidades)
CREATE TABLE unidades (
    id SERIAL PRIMARY KEY,
    numero INT UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- 3. Tabla de Usuarios (Administradores y Estudiantes)
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    clave VARCHAR(255) NOT NULL,
    foto_url TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabla de Entregables / Archivos por Semana (16 Semanas)
CREATE TABLE entregables (
    id SERIAL PRIMARY KEY,
    semana INT UNIQUE NOT NULL CHECK (semana BETWEEN 1 AND 16),
    unidad_id INT NOT NULL REFERENCES unidades(id) ON DELETE CASCADE,
    nombre_archivo VARCHAR(255),
    archivo_url TEXT,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- INSERCIÓN DE DATOS SEMILLA (SEED DATA)
-- =============================================================================

-- Inserción de las 4 Unidades Académicas
INSERT INTO unidades (numero, nombre, descripcion) VALUES 
(1, 'Unidad I: Fundamentos y Patrones Arquitectónicos', 'Introducción a la arquitectura de software, atributos de calidad y patrones de diseño iniciales.'),
(2, 'Unidad II: Arquitectura Orientada a Servicios (SOA) y Microservicios', 'Diseño de servicios RESTful, desacoplamiento, APIs y orquestación de sistemas distribuidos.'),
(3, 'Unidad III: Arquitectura de Datos y Persistencia', 'Patrón MVC, JDBC, ORM, Supabase PostgreSQL y gestión de almacenamiento en la nube.'),
(4, 'Unidad IV: Despliegue, DevOps y Contenedores', 'Dockerización con Tomcat 9, integración continua y despliegue automatizado en PaaS (Render).');

-- Inserción de las 16 Semanas registradas (Inicialmente sin archivo adjunto)
INSERT INTO entregables (semana, unidad_id, nombre_archivo, archivo_url) VALUES 
(1, 1, NULL, NULL),
(2, 1, NULL, NULL),
(3, 1, NULL, NULL),
(4, 1, NULL, NULL),
(5, 2, NULL, NULL),
(6, 2, NULL, NULL),
(7, 2, NULL, NULL),
(8, 2, NULL, NULL),
(9, 3, NULL, NULL),
(10, 3, NULL, NULL),
(11, 3, NULL, NULL),
(12, 3, NULL, NULL),
(13, 4, NULL, NULL),
(14, 4, NULL, NULL),
(15, 4, NULL, NULL),
(16, 4, NULL, NULL);

-- Inserción del Usuario Administrador Principal: Alessander (Ingeniería de Sistemas - UPLA)
-- Nota: La contraseña está almacenada como texto de demostración o hash
INSERT INTO usuarios (nombre, usuario, clave, foto_url) VALUES 
('Alessander (Ing. Sistemas - UPLA)', 'alessander', 'upla2026', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80');

-- Verificación de Inserción
SELECT * FROM unidades ORDER BY numero;
SELECT * FROM usuarios;
SELECT * FROM entregables ORDER BY semana;
