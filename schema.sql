-- =============================================================================
-- REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE 2026-I
-- Script de Creación e Inserción Inicial para Supabase PostgreSQL
-- Autor: Alessander Meza Garay (Código: r03396b)
-- =============================================================================

DROP TABLE IF EXISTS entregables CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS unidades CASCADE;

-- 1. Tabla de Unidades Académicas
CREATE TABLE unidades (
    id SERIAL PRIMARY KEY,
    numero INT UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT
);

-- 2. Tabla de Usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    clave VARCHAR(255) NOT NULL,
    foto_url TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Entregables (Soporta múltiples archivos por semana y título personalizado)
CREATE TABLE entregables (
    id SERIAL PRIMARY KEY,
    semana INT NOT NULL CHECK (semana BETWEEN 1 AND 16),
    unidad_id INT NOT NULL REFERENCES unidades(id) ON DELETE CASCADE,
    titulo_trabajo VARCHAR(255) NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    archivo_url TEXT NOT NULL,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Datos Semilla de Unidades
INSERT INTO unidades (numero, nombre, descripcion) VALUES 
(1, 'Fundamentos y Estándares de Arquitectura', 'Introducción, ISO/IEC 25010, Estilos y Vistas 4+1'),
(2, 'Modelado de Arquitecturas con POO y Vistas 4+1', 'Principios POO, Diagramas UML y Componentes'),
(3, 'Comunicación, Integración y Servicios Web REST', 'Protocolos de Integración, REST APIs y JSON/XML'),
(4, 'Frameworks Modernos y Despliegue en Cloud', 'Patrón Java EE MVC, Tomcat 9, Docker y Render');

-- Datos Semilla Iniciales de Trabajos
INSERT INTO entregables (semana, unidad_id, titulo_trabajo, nombre_archivo, archivo_url) VALUES 
(1, 1, 'Informe de Introducción a la Arquitectura', 'Semana_01_Patrones_Arquitectonicos_Alessander.pdf', 'https://upla.edu.pe/repositorio/docs/Semana_01_Patrones.pdf'),
(2, 1, 'Diagrama MVC y Caso de Estudio UPLA', 'Semana_02_Diagrama_MVC_UPLA.png', 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&auto=format&fit=crop&q=80');

-- Usuario Administrador Principal
INSERT INTO usuarios (nombre, usuario, clave, foto_url) VALUES 
('Alessander Meza Garay (Código: r03396b)', 'alessander', 'upla2026', 'img/alessander.jpg');
