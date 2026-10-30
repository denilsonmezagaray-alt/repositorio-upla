/* PEQUEÑOS EXPLORADORES LMS — SEMANA 07
   Diseño físico para Azure SQL Database (T-SQL).
   Script de diseño propuesto, NO evidencia de despliegue real.
   Ejecutar en una base Azure SQL Database ya creada, con usuario autorizado.
   Los datos INSERT son ficticios y solo para pruebas.
*/
SET NOCOUNT ON;
GO
CREATE TABLE dbo.instituciones (
 institucion_id INT IDENTITY(1,1) PRIMARY KEY,
 nombre NVARCHAR(180) NOT NULL,
 codigo NVARCHAR(30) NOT NULL UNIQUE,
 estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVA' CHECK (estado IN ('ACTIVA','INACTIVA')),
 creado_en DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE TABLE dbo.usuarios (
 usuario_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 institucion_id INT NULL REFERENCES dbo.instituciones(institucion_id),
 modalidad VARCHAR(15) NOT NULL CHECK (modalidad IN ('FAMILIAR','INSTITUCIONAL')),
 rol VARCHAR(20) NOT NULL CHECK (rol IN ('ADMIN','DOCENTE','APODERADO','FAMILIA')),
 nombre NVARCHAR(120) NOT NULL,
 correo NVARCHAR(254) NOT NULL,
 password_hash NVARCHAR(255) NOT NULL,
 estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','BLOQUEADO','INACTIVO')),
 creado_en DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 CONSTRAINT CK_usuario_modalidad CHECK ((modalidad='FAMILIAR' AND institucion_id IS NULL AND rol='FAMILIA') OR (modalidad='INSTITUCIONAL' AND institucion_id IS NOT NULL AND rol IN ('ADMIN','DOCENTE','APODERADO')))
);
GO
CREATE UNIQUE INDEX UX_usuarios_correo_modalidad_institucion ON dbo.usuarios(correo,modalidad,institucion_id) WHERE institucion_id IS NOT NULL;
CREATE UNIQUE INDEX UX_usuarios_correo_familiar ON dbo.usuarios(correo) WHERE modalidad='FAMILIAR';
GO
CREATE TABLE dbo.planes (
 plan_id INT IDENTITY(1,1) PRIMARY KEY,
 nombre NVARCHAR(80) NOT NULL UNIQUE,
 periodo VARCHAR(12) NOT NULL CHECK (periodo IN ('MENSUAL','ANUAL')),
 precio_pen DECIMAL(10,2) NOT NULL CHECK(precio_pen>=0),
 activo BIT NOT NULL DEFAULT 1
);
GO
CREATE TABLE dbo.suscripciones (
 suscripcion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 usuario_familia_id BIGINT NOT NULL REFERENCES dbo.usuarios(usuario_id),
 plan_id INT NOT NULL REFERENCES dbo.planes(plan_id),
 inicio DATE NOT NULL,
 fin DATE NOT NULL,
 estado VARCHAR(15) NOT NULL CHECK (estado IN ('PRUEBA','ACTIVA','VENCIDA','CANCELADA')),
 CONSTRAINT CK_suscripcion_fechas CHECK(fin>=inicio)
);
GO
CREATE TABLE dbo.aulas (
 aula_id INT IDENTITY(1,1) PRIMARY KEY,
 institucion_id INT NOT NULL REFERENCES dbo.instituciones(institucion_id),
 nombre NVARCHAR(100) NOT NULL,
 periodo NVARCHAR(30) NOT NULL,
 docente_id BIGINT NULL REFERENCES dbo.usuarios(usuario_id),
 CONSTRAINT UQ_aula_periodo UNIQUE(institucion_id,nombre,periodo)
);
GO
CREATE TABLE dbo.ninos (
 nino_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 modalidad VARCHAR(15) NOT NULL CHECK(modalidad IN ('FAMILIAR','INSTITUCIONAL')),
 institucion_id INT NULL REFERENCES dbo.instituciones(institucion_id),
 aula_id INT NULL REFERENCES dbo.aulas(aula_id),
 codigo_matricula NVARCHAR(35) NULL,
 alias NVARCHAR(70) NOT NULL,
 fecha_nacimiento DATE NULL,
 estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVO' CHECK(estado IN ('ACTIVO','INACTIVO')),
 creado_en DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 CONSTRAINT CK_nino_ambito CHECK ((modalidad='FAMILIAR' AND institucion_id IS NULL AND aula_id IS NULL AND codigo_matricula IS NULL) OR (modalidad='INSTITUCIONAL' AND institucion_id IS NOT NULL AND codigo_matricula IS NOT NULL))
);
GO
CREATE UNIQUE INDEX UX_ninos_matricula ON dbo.ninos(institucion_id,codigo_matricula) WHERE codigo_matricula IS NOT NULL;
GO
CREATE TABLE dbo.ninos_apoderados (
 nino_id BIGINT NOT NULL REFERENCES dbo.ninos(nino_id),
 usuario_id BIGINT NOT NULL REFERENCES dbo.usuarios(usuario_id),
 parentesco NVARCHAR(40) NOT NULL,
 responsable BIT NOT NULL DEFAULT 0,
 PRIMARY KEY(nino_id,usuario_id)
);
GO
CREATE TABLE dbo.actividades (
 actividad_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 institucion_id INT NULL REFERENCES dbo.instituciones(institucion_id),
 titulo NVARCHAR(160) NOT NULL,
 area NVARCHAR(60) NOT NULL,
 edad_min_meses TINYINT NOT NULL,
 edad_max_meses TINYINT NOT NULL,
 duracion_min SMALLINT NOT NULL CHECK(duracion_min BETWEEN 1 AND 120),
 instrucciones NVARCHAR(MAX) NULL,
 publicada BIT NOT NULL DEFAULT 0,
 CONSTRAINT CK_actividad_edad CHECK(edad_min_meses<=edad_max_meses AND edad_max_meses<=71)
);
GO
CREATE TABLE dbo.asignaciones (
 asignacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 actividad_id BIGINT NOT NULL REFERENCES dbo.actividades(actividad_id),
 aula_id INT NOT NULL REFERENCES dbo.aulas(aula_id),
 fecha_limite DATE NULL,
 creada_en DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
 CONSTRAINT UQ_asignacion UNIQUE(actividad_id,aula_id)
);
GO
CREATE TABLE dbo.intentos (
 intento_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 nino_id BIGINT NOT NULL REFERENCES dbo.ninos(nino_id),
 actividad_id BIGINT NOT NULL REFERENCES dbo.actividades(actividad_id),
 etapa VARCHAR(12) NOT NULL CHECK(etapa IN ('ELIJO','EXPLORO','INTENTO','DESCUBRO','CELEBRO')),
 completado BIT NOT NULL DEFAULT 0,
 segundos SMALLINT NULL CHECK(segundos>=0),
 realizado_en DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE TABLE dbo.evidencias (
 evidencia_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 intento_id BIGINT NOT NULL REFERENCES dbo.intentos(intento_id),
 registrado_por BIGINT NOT NULL REFERENCES dbo.usuarios(usuario_id),
 tipo VARCHAR(15) NOT NULL CHECK(tipo IN ('FOTO','AUDIO','VIDEO','DOCUMENTO')),
 blob_path NVARCHAR(500) NOT NULL,
 comentario NVARCHAR(800) NULL,
 creado_en DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE TABLE dbo.observaciones (
 observacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 nino_id BIGINT NOT NULL REFERENCES dbo.ninos(nino_id),
 docente_id BIGINT NOT NULL REFERENCES dbo.usuarios(usuario_id),
 texto NVARCHAR(1500) NOT NULL,
 fecha DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE TABLE dbo.mensajes (
 mensaje_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 institucion_id INT NOT NULL REFERENCES dbo.instituciones(institucion_id),
 emisor_id BIGINT NOT NULL REFERENCES dbo.usuarios(usuario_id),
 destinatario_id BIGINT NOT NULL REFERENCES dbo.usuarios(usuario_id),
 asunto NVARCHAR(140) NOT NULL,
 cuerpo NVARCHAR(MAX) NOT NULL,
 enviado_en DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE TABLE dbo.auditoria (
 auditoria_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 usuario_id BIGINT NULL REFERENCES dbo.usuarios(usuario_id),
 accion NVARCHAR(100) NOT NULL,
 entidad NVARCHAR(80) NOT NULL,
 entidad_id NVARCHAR(60) NULL,
 fecha DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
CREATE INDEX IX_ninos_aula ON dbo.ninos(aula_id) WHERE aula_id IS NOT NULL;
CREATE INDEX IX_intentos_nino_fecha ON dbo.intentos(nino_id,realizado_en DESC);
CREATE INDEX IX_asignaciones_aula ON dbo.asignaciones(aula_id,fecha_limite);
CREATE INDEX IX_observaciones_nino ON dbo.observaciones(nino_id,fecha DESC);
CREATE INDEX IX_suscripciones_usuario ON dbo.suscripciones(usuario_familia_id,estado);
GO
CREATE VIEW dbo.vw_resumen_progreso AS
 SELECT n.nino_id,n.alias,n.modalidad,COUNT(i.intento_id) AS intentos,
 SUM(CASE WHEN i.completado=1 THEN 1 ELSE 0 END) AS completados
 FROM dbo.ninos n LEFT JOIN dbo.intentos i ON i.nino_id=n.nino_id
 GROUP BY n.nino_id,n.alias,n.modalidad;
GO
/* DEMOSTRACIÓN CON DATOS FICTICIOS. No guardar contraseñas reales en este script.
   El valor de password_hash es una marca NO válida para autenticación. */
INSERT dbo.instituciones(nombre,codigo) VALUES(N'Institución Inicial Demostrativa',N'DEMO-001');
INSERT dbo.usuarios(institucion_id,modalidad,rol,nombre,correo,password_hash)
 VALUES(NULL,'FAMILIAR','FAMILIA',N'Familia de prueba',N'familia.demo@example.org',N'NO_VALIDO_DEMO'),
       (1,'INSTITUCIONAL','ADMIN',N'Administrador demo',N'admin.demo@example.org',N'NO_VALIDO_DEMO'),
       (1,'INSTITUCIONAL','DOCENTE',N'Docente demo',N'docente.demo@example.org',N'NO_VALIDO_DEMO'),
       (1,'INSTITUCIONAL','APODERADO',N'Apoderado demo',N'apoderado.demo@example.org',N'NO_VALIDO_DEMO');
INSERT dbo.planes(nombre,periodo,precio_pen) VALUES(N'Familiar mensual','MENSUAL',0),(N'Familiar anual','ANUAL',0);
INSERT dbo.aulas(institucion_id,nombre,periodo,docente_id) VALUES(1,N'Aula Arcoíris',N'2026-II',3);
INSERT dbo.ninos(modalidad,institucion_id,aula_id,codigo_matricula,alias) VALUES
 ('FAMILIAR',NULL,NULL,NULL,N'Explorador F'),('INSTITUCIONAL',1,1,N'DEMO-M001',N'Explorador I');
INSERT dbo.ninos_apoderados(nino_id,usuario_id,parentesco,responsable) VALUES(1,1,N'Familia',1),(2,4,N'Apoderado',1);
INSERT dbo.actividades(institucion_id,titulo,area,edad_min_meses,edad_max_meses,duracion_min,instrucciones,publicada)
 VALUES(NULL,N'Colores mágicos',N'Comunicación',36,71,10,N'Identificar colores con acompañamiento adulto.',1),
 (1,N'Contemos estrellas',N'Matemática',48,71,12,N'Contar elementos ilustrados.',1);
INSERT dbo.asignaciones(actividad_id,aula_id,fecha_limite) VALUES(2,1,'2026-12-15');
INSERT dbo.intentos(nino_id,actividad_id,etapa,completado,segundos) VALUES(1,1,'CELEBRO',1,480),(2,2,'EXPLORO',0,180);
GO
/* CONSULTAS DE VALIDACIÓN */
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME;
SELECT * FROM dbo.vw_resumen_progreso ORDER BY nino_id;
SELECT a.nombre AS aula,n.alias,ac.titulo AS actividad FROM dbo.aulas a
 JOIN dbo.ninos n ON n.aula_id=a.aula_id
 JOIN dbo.asignaciones x ON x.aula_id=a.aula_id
 JOIN dbo.actividades ac ON ac.actividad_id=x.actividad_id;
GO
/* NOTA DE SEGURIDAD: las relaciones entre modalidad/institución en tablas vinculadas
   deben reforzarse mediante políticas de acceso, procedimientos de aplicación,
   validaciones transaccionales y pruebas de aislamiento; las FK por sí solas no
   garantizan el aislamiento completo entre organizaciones. Los archivos de evidencia
   se almacenan fuera de SQL (p. ej., Azure Blob Storage) y aquí solo se registra la ruta. */
