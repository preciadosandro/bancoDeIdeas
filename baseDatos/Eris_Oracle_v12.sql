DROP TABLE TB_AprobacionEntrega CASCADE CONSTRAINTS ;

DROP TABLE TB_Auditoria CASCADE CONSTRAINTS ;

DROP TABLE TB_Calificacion CASCADE CONSTRAINTS ;

DROP TABLE TB_Entrega CASCADE CONSTRAINTS ;

DROP TABLE TB_Idea CASCADE CONSTRAINTS ;

DROP TABLE TB_Integrantes CASCADE CONSTRAINTS ;

DROP TABLE TB_Lineamiento CASCADE CONSTRAINTS ;

DROP TABLE TB_LineamientoDetalle CASCADE CONSTRAINTS ;

DROP TABLE TB_ListaValor CASCADE CONSTRAINTS ;

DROP TABLE TB_ListaValorDetalle CASCADE CONSTRAINTS ;

DROP TABLE TB_ObjetivoIdea CASCADE CONSTRAINTS ;

DROP TABLE TB_Proyecto CASCADE CONSTRAINTS ;

DROP TABLE TB_Rol CASCADE CONSTRAINTS ;

DROP TABLE TB_SeguimientoIdea CASCADE CONSTRAINTS ;

DROP TABLE TB_SolicitudIdea CASCADE CONSTRAINTS ;

DROP TABLE TB_SolicitudRol CASCADE CONSTRAINTS ;

DROP TABLE TB_Token CASCADE CONSTRAINTS ;

DROP TABLE TB_Usuario CASCADE CONSTRAINTS ;

DROP TABLE TB_UsuarioRol CASCADE CONSTRAINTS ;

DROP SEQUENCE SQ_TB_AprobacionEntrega ;

DROP SEQUENCE SQ_TB_Auditoria ;

DROP SEQUENCE SQ_TB_Calificacion ;

DROP SEQUENCE SQ_TB_Entrega ;

DROP SEQUENCE SQ_TB_Idea ;

DROP SEQUENCE SQ_TB_Integrantes ;

DROP SEQUENCE SQ_TB_Lineamiento ;

DROP SEQUENCE SQ_TB_LineamientoDetalle ;

DROP SEQUENCE SQ_TB_ListaValor ;

DROP SEQUENCE SQ_TB_ListaValorDetalle ;

DROP SEQUENCE SQ_TB_ObjetivoIdea ;

DROP SEQUENCE SQ_TB_Proyecto ;

DROP SEQUENCE SQ_TB_Rol ;

DROP SEQUENCE SQ_TB_SeguimientoIdea ;

DROP SEQUENCE SQ_TB_SolicitudIdea ;

DROP SEQUENCE SQ_TB_SolicitudRol ;

DROP SEQUENCE SQ_TB_Token ;

DROP SEQUENCE SQ_TB_Usuario ;

DROP SEQUENCE SQ_TB_UsuarioRol ;


CREATE SEQUENCE SQ_TB_AprobacionEntrega START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Auditoria START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Calificacion START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Entrega START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Idea START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Integrantes START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_ListaValor START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_ListaValorDetalle START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Lineamiento START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_LineamientoDetalle START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_ObjetivoIdea START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Proyecto START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Rol START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_SeguimientoIdea START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_SolicitudIdea START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_SolicitudRol START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Token START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_Usuario START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE SEQUENCE SQ_TB_UsuarioRol START WITH 1 INCREMENT BY 1 MINVALUE 1 CACHE 2 ORDER ;

CREATE TABLE TB_AprobacionEntrega
  (
    ID               NUMBER (10) NOT NULL ,
    ID_T_Entrega     NUMBER (10) NOT NULL ,
    ID_T_Usuario     NUMBER (10) NOT NULL ,
    EstadoAprobacion NUMBER (1) DEFAULT 0 NOT NULL ,
	CreadoPor        VARCHAR2 (50) NOT NULL ,
    CreadoEn         DATE DEFAULT SYSDATE ,
    ModificadoPor    VARCHAR2 (50) ,
    ModificadoEn     TIMESTAMP
  ) ;
ALTER TABLE TB_AprobacionEntrega ADD CONSTRAINT PK_TB_AprobacionEntrega PRIMARY KEY ( ID ) ;
ALTER TABLE TB_AprobacionEntrega ADD CONSTRAINT UN_TB_AprobacionEntrega_001 UNIQUE ( ID_T_Entrega , ID_T_Usuario ) ;

ALTER TABLE TB_AprobacionEntrega ADD CONSTRAINT CHK_TB_AprobacionEntrega_001 CHECK (EstadoAprobacion IN (0, 1)) ENABLE ;

COMMENT ON TABLE TB_AprobacionEntrega IS 'Tabla donde se registra la aprobacion de cada una de las entregas por cada uno de los usuarios que integran un proyecto';
COMMENT ON COLUMN TB_AprobacionEntrega.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_AprobacionEntrega.ID_T_Entrega IS 'Identificador unico de la tabla TB_Entrega';
COMMENT ON COLUMN TB_AprobacionEntrega.ID_T_Usuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_AprobacionEntrega.EstadoAprobacion IS 'Estado de aprobacion por parte de los usuarios en cada una de las entregas. Puede ser 0-No Aprobado 1-Aprobado. Por defecto es 0-No Aprobado. Cuando se actualiza cada uno de los registros por usuario asociado a la entrega, se actualiza el campo TB_Entrega.EstadoAprobacion';



CREATE TABLE TB_Auditoria
  (
    ID            NUMBER (10) NOT NULL ,
    NombreTabla   VARCHAR2 (30) ,
    CampoTabla    VARCHAR2 (30) ,
    DatoAntiguo   VARCHAR2 (700) ,
    DatoNuevo     VARCHAR2 (700) ,
    ModificadoPor VARCHAR2 (50) ,
    ModificadoEn  TIMESTAMP
  ) ;
ALTER TABLE TB_Auditoria ADD CONSTRAINT PK_TB_Auditoria PRIMARY KEY ( ID ) ;

COMMENT ON TABLE TB_Auditoria IS 'Tabla donde se registra cada uno de los movimientos de las tablas parametrizadas';
COMMENT ON COLUMN TB_Auditoria.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Auditoria.NombreTabla IS 'Nombre de la tabla que se modifica';
COMMENT ON COLUMN TB_Auditoria.CampoTabla IS 'Nombre del campo de la tabla que se modifica';
COMMENT ON COLUMN TB_Auditoria.DatoAntiguo IS 'Dato que habia antes de la modificacion';
COMMENT ON COLUMN TB_Auditoria.DatoNuevo IS 'Dato que hay despues de la modificacion';
COMMENT ON COLUMN TB_Auditoria.ModificadoPor IS 'Usuario que realiza la modificacion';
COMMENT ON COLUMN TB_Auditoria.ModificadoEn IS 'Fecha en la que se realiza la modificacion';



CREATE TABLE TB_Calificacion
  (
    ID                     NUMBER (10) NOT NULL ,
    ID_T_Proyecto          NUMBER (10) NOT NULL ,
    ID_T_Usuario           NUMBER (10) NOT NULL ,
    ID_T_LV_TipoEvaluacion NUMBER (10) NOT NULL ,
    Calificacion           NUMBER (3,2) NOT NULL ,
    Observacion            VARCHAR2 (700) ,
    CreadoPor              VARCHAR2 (50) NOT NULL ,
    CreadoEn               DATE DEFAULT SYSDATE ,
    ModificadoPor          VARCHAR2 (50) ,
    ModificadoEn           TIMESTAMP
  ) ;
ALTER TABLE TB_Calificacion ADD CONSTRAINT PK_TB_Calificacion PRIMARY KEY ( ID ) ;
ALTER TABLE TB_Calificacion ADD CONSTRAINT UN_TB_Calificacion_001 UNIQUE ( ID_T_Proyecto , ID_T_Usuario , ID_T_LV_TipoEvaluacion ) ;

COMMENT ON TABLE TB_Calificacion IS 'Tabla donde se registran las calificaciones de un proyecto por usuario y por el tipo de evaluacion';
COMMENT ON COLUMN TB_Calificacion.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Calificacion.ID_T_Proyecto IS 'Identificador unico de la tabla TB_Proyecto';
COMMENT ON COLUMN TB_Calificacion.ID_T_Usuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_Calificacion.ID_T_LV_TipoEvaluacion IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Calificacion.Calificacion IS 'Calificacion que registra cada evaluador por proyecto de acuerdo al tipo de evaluacion';


CREATE TABLE TB_Entrega
  (
    ID                     NUMBER (10) NOT NULL ,
    ID_T_Proyecto          NUMBER (10) NOT NULL ,
    ID_T_LV_PeriodoEntrega NUMBER (10) NOT NULL ,
	ID_T_LV_EstadoEntrega  NUMBER (10) NOT NULL ,
	EstadoAprobacion       NUMBER (1) DEFAULT 0 NOT NULL ,
    Calificacion           NUMBER (3,2) ,
    FechaEntrega           DATE NOT NULL ,
    RutaProyecto           VARCHAR2 (300) ,
    Observacion            VARCHAR2 (700) ,
    CreadoPor              VARCHAR2 (50) NOT NULL ,
    CreadoEn               DATE DEFAULT SYSDATE ,
    ModificadoPor          VARCHAR2 (50) ,
    ModificadoEn           TIMESTAMP
  ) ;
ALTER TABLE TB_Entrega ADD CONSTRAINT PK_TB_Entrega PRIMARY KEY ( ID ) ;
ALTER TABLE TB_Entrega ADD CONSTRAINT UN_TB_Entrega_001 UNIQUE ( ID_T_Proyecto , ID_T_LV_PeriodoEntrega ) ;

ALTER TABLE TB_Entrega ADD CONSTRAINT CHK_TB_Entrega_001 CHECK (EstadoAprobacion IN (0, 1)) ENABLE ;

COMMENT ON TABLE TB_Entrega IS 'Tabla donde se registra cada una de las entregas por proyecto';
COMMENT ON COLUMN TB_Entrega.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Entrega.ID_T_Proyecto IS 'Identificador unico de la tabla TB_Proyecto';
COMMENT ON COLUMN TB_Entrega.ID_T_LV_PeriodoEntrega IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Entrega.ID_T_LV_EstadoEntrega IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Entrega.EstadoAprobacion IS 'Estado de aprobacion por parte de los usuarios. Puede ser 0-No Aprobado 1-Aprobado. Por defecto es 0-No Aprobado. Cuando se actualiza cada uno de los registros de la tabla TB_AprobacionEntrega por usuario asociado a la entrega, se actualiza este campo';
COMMENT ON COLUMN TB_Entrega.Calificacion IS 'Calificacion que registra cada evaluador por proyecto de acuerdo al tipo de evaluacion';
COMMENT ON COLUMN TB_Entrega.FechaEntrega IS 'Fecha en la que se debe realizar la entrega';
COMMENT ON COLUMN TB_Entrega.RutaProyecto IS 'Ruta en donde se encuentra el archivo de la entrega';


CREATE TABLE TB_Idea
  (
    ID                 NUMBER (10) NOT NULL ,
    ID_T_Usuario       NUMBER (10) NOT NULL ,
    Titulo             VARCHAR2 (100) NOT NULL ,
    Descripcion        VARCHAR2 (700) NOT NULL ,
    IdeaPrivada        NUMBER (1) DEFAULT 0 NOT NULL ,
    ID_T_LV_EstadoIdea NUMBER (10) NOT NULL ,
    PalabrasClave      VARCHAR2 (700) NOT NULL ,
    CreadoPor          VARCHAR2 (50) NOT NULL ,
    CreadoEn           DATE DEFAULT SYSDATE ,
    ModificadoPor      VARCHAR2 (50) ,
    ModificadoEn       TIMESTAMP
  ) ;
ALTER TABLE TB_Idea ADD CONSTRAINT PK_TB_Idea PRIMARY KEY ( ID ) ;

ALTER TABLE TB_Idea ADD CONSTRAINT CHK_TB_Idea_001 CHECK (IdeaPrivada IN (0, 1)) ENABLE ;

COMMENT ON TABLE TB_Idea IS 'Tabla donde se registra cada una de las ideas de un usuario';
COMMENT ON COLUMN TB_Idea.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Idea.ID_T_Usuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_Idea.Titulo IS 'Titulo del proyecto';
COMMENT ON COLUMN TB_Idea.Descripcion IS 'Descripcion general o detallada del proyecto';
COMMENT ON COLUMN TB_Idea.IdeaPrivada IS 'Privacidad de la idea. Puede ser 0-Publica 1-Privada. Por defecto es 0-Publica';
COMMENT ON COLUMN TB_Idea.ID_T_LV_EstadoIdea IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Idea.PalabrasClave IS 'Palabras claves que identifican el proyecto';


CREATE TABLE TB_Integrantes
  (
    ID                       NUMBER (10) NOT NULL ,
    ID_T_Proyecto            NUMBER (10) NOT NULL ,
    ID_T_Usuario             NUMBER (10) NOT NULL ,
    ID_T_LV_TipoIntegrante   NUMBER (10) NOT NULL ,
    ID_T_LV_EstadoIntegrante NUMBER (10) NOT NULL ,
    Observacion              VARCHAR2 (300) ,
    CreadoPor                VARCHAR2 (50) NOT NULL ,
    CreadoEn                 DATE DEFAULT SYSDATE ,
    ModificadoPor            VARCHAR2 (50) ,
    ModificadoEn             TIMESTAMP
  ) ;
ALTER TABLE TB_Integrantes ADD CONSTRAINT PK_TB_Integrantes PRIMARY KEY ( ID ) ;
ALTER TABLE TB_Integrantes ADD CONSTRAINT UN_TB_Integrantes_001 UNIQUE ( ID_T_Proyecto , ID_T_Usuario ) ;

COMMENT ON TABLE TB_Integrantes IS 'Tabla donde se registran los integrantes de un proyecto';
COMMENT ON COLUMN TB_Integrantes.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Integrantes.ID_T_Proyecto IS 'Identificador unico de la tabla TB_Proyecto';
COMMENT ON COLUMN TB_Integrantes.ID_T_Usuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_Integrantes.ID_T_LV_TipoIntegrante IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Integrantes.ID_T_LV_EstadoIntegrante IS 'Identificador unico de la tabla TB_ListaValorDetalle';


CREATE TABLE TB_ListaValor
  (
    ID            NUMBER (10) NOT NULL ,
    Agrupacion    VARCHAR2 (50) NOT NULL ,
    Descripcion   VARCHAR2 (100) NOT NULL ,
	Estado        NUMBER (1) DEFAULT 1 NOT NULL ,
    CreadoPor     VARCHAR2 (50) NOT NULL ,
    CreadoEn      DATE DEFAULT SYSDATE ,
    ModificadoPor VARCHAR2 (50) ,
    ModificadoEn  DATE 
  ) ;
ALTER TABLE TB_ListaValor ADD CONSTRAINT PK_TB_ListaValor PRIMARY KEY ( ID ) ;

ALTER TABLE TB_ListaValor ADD CONSTRAINT CHK_TB_ListaValor_001 CHECK (Estado IN (0, 1)) ENABLE ;

COMMENT ON TABLE TB_ListaValor IS 'Tabla donde se registran los maestros de los combos';
COMMENT ON COLUMN TB_ListaValor.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_ListaValor.Agrupacion IS 'Identificador unico del combo';
COMMENT ON COLUMN TB_ListaValor.Estado IS 'Estado del combo. Puede ser 0-Inactivo 1-Activo. Por defecto es 1-Activo';


CREATE TABLE TB_ListaValorDetalle
  (
    ID                NUMBER (10) NOT NULL ,
    ID_T_ListaValores NUMBER (10) NOT NULL ,
    Valor             VARCHAR2 (100) NOT NULL ,
	Estado            NUMBER (1) DEFAULT 1 NOT NULL ,
    CreadoPor         VARCHAR2 (50) NOT NULL ,
    CreadoEn          DATE DEFAULT SYSDATE ,
    ModificadoPor     VARCHAR2 (50) ,
    ModificadoEn      DATE 
  ) ;
ALTER TABLE TB_ListaValorDetalle ADD CONSTRAINT PK_TB_ListaValorDetalle PRIMARY KEY ( ID ) ;

ALTER TABLE TB_ListaValorDetalle ADD CONSTRAINT CHK_TB_ListaValor_001 CHECK (Estado IN (0, 1)) ENABLE ;

COMMENT ON TABLE TB_ListaValorDetalle IS 'Tabla donde se registra el detalle de cada uno de los combos de la tabla TB_ListaValor';
COMMENT ON COLUMN TB_ListaValorDetalle.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_ListaValorDetalle.ID_T_ListaValores IS 'Identificador unico de la tabla TB_ListaValor';
COMMENT ON COLUMN TB_ListaValorDetalle.Valor IS 'Valores que se mostraran al usuario cuando presione el combo';
COMMENT ON COLUMN TB_ListaValorDetalle.Estado IS 'Estado del detalle dentro del maestro. Puede ser 0-Inactivo 1-Activo. Por defecto es 1-Activo';


CREATE TABLE TB_Lineamiento
  (
    ID            NUMBER (10) NOT NULL ,
    Descripcion   VARCHAR2 (100) NOT NULL ,
    CreadoPor     VARCHAR2 (50) NOT NULL ,
    CreadoEn      DATE DEFAULT SYSDATE ,
    ModificadoPor VARCHAR2 (50) ,
    ModificadoEn  TIMESTAMP
  ) ;
ALTER TABLE TB_Lineamiento ADD CONSTRAINT PK_TB_Lineamiento PRIMARY KEY ( ID ) ;

COMMENT ON TABLE TB_Lineamiento IS 'Tabla donde se registran las diferentes plantillas de calificacion';
COMMENT ON COLUMN TB_Lineamiento.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Lineamiento.Descripcion IS 'Descripcion corta del lineamiento a registrar';


CREATE TABLE TB_LineamientoDetalle
  (
    ID               NUMBER (10) NOT NULL ,
    ID_T_Lineamiento NUMBER (10) NOT NULL ,
    Descripcion      VARCHAR2 (100) NOT NULL ,
	Porcentaje       NUMBER (5,2) NOT NULL ,
	Corte            NUMBER (10) NOT NULL ,
    CreadoPor        VARCHAR2 (50) NOT NULL ,
    CreadoEn         DATE DEFAULT SYSDATE ,
    ModificadoPor    VARCHAR2 (50) ,
    ModificadoEn     TIMESTAMP
  ) ;
ALTER TABLE TB_LineamientoDetalle ADD CONSTRAINT PK_TB_LineamientoDetalle PRIMARY KEY ( ID ) ;

COMMENT ON TABLE TB_LineamientoDetalle IS 'Tabla donde se registra el detalle de un lineamiento';
COMMENT ON COLUMN TB_LineamientoDetalle.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_LineamientoDetalle.ID_T_Lineamiento IS 'Identificador unico de la tabla TB_Lineamiento';
COMMENT ON COLUMN TB_LineamientoDetalle.Descripcion IS 'Descripcion corta del detalle del lineamiento a registrar';
COMMENT ON COLUMN TB_LineamientoDetalle.Porcentaje IS 'Porcentaje que representa el lineamiento';
COMMENT ON COLUMN TB_LineamientoDetalle.Corte IS 'Corte en el que se solicita el registro. 1-Primer Periodo 2-Segundo Periodo 3-Tercer Periodo';


CREATE TABLE TB_ObjetivoIdea
  (
    ID            NUMBER (10) NOT NULL ,
    ID_T_Idea     NUMBER (10) NOT NULL ,
    Descripcion   VARCHAR2 (700) NOT NULL ,
    CreadoPor     VARCHAR2 (50) NOT NULL ,
    CreadoEn      DATE DEFAULT SYSDATE ,
    ModificadoPor VARCHAR2 (50) ,
    ModificadoEn  TIMESTAMP
  ) ;
ALTER TABLE TB_ObjetivoIdea ADD CONSTRAINT PK_TB_ObjetivoIdea PRIMARY KEY ( ID ) ;

COMMENT ON TABLE TB_ObjetivoIdea IS 'Tabla donde -opcionalmente- se registran los objetivos de una idea';
COMMENT ON COLUMN TB_ObjetivoIdea.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_ObjetivoIdea.ID_T_Idea IS 'Identificador unico de la tabla TB_Idea';
COMMENT ON COLUMN TB_ObjetivoIdea.Descripcion IS 'Descripcion del objetivo';


CREATE TABLE TB_Proyecto
  (
    ID                     NUMBER (10) NOT NULL ,
    ID_T_Idea              NUMBER (10) NOT NULL ,
    TituloProyecto         VARCHAR2 (100) NOT NULL ,
    ResumenProyecto        VARCHAR2 (700) NOT NULL ,
    ID_T_LV_EstadoProyecto NUMBER (10) NOT NULL ,
	ID_T_Lineamiento       NUMBER (10) NOT NULL ,
    RutaProyecto           VARCHAR2 (300) ,
    CreadoPor              VARCHAR2 (50) NOT NULL ,
    CreadoEn               DATE DEFAULT SYSDATE ,
    ModificadoPor          VARCHAR2 (50) ,
    ModificadoEn           TIMESTAMP
  ) ;
ALTER TABLE TB_Proyecto ADD CONSTRAINT PK_TB_Proyecto PRIMARY KEY ( ID ) ;

COMMENT ON TABLE TB_Proyecto IS 'Tabla donde se registran los proyectos';
COMMENT ON COLUMN TB_Proyecto.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Proyecto.ID_T_Idea IS 'Identificador unico de la tabla TB_Idea';
COMMENT ON COLUMN TB_Proyecto.TituloProyecto IS 'Titulo del proyecto';
COMMENT ON COLUMN TB_Proyecto.ResumenProyecto IS 'Resumen o descripcion del proyecto';
COMMENT ON COLUMN TB_Proyecto.ID_T_LV_EstadoProyecto IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Proyecto.ID_T_Lineamiento IS 'Identificador unico de la tabla TB_Lineamiento';
COMMENT ON COLUMN TB_Proyecto.RutaProyecto IS 'Ruta donde se encuentra alojado el documento del proyecto';


CREATE TABLE TB_Rol
  (
    ID            NUMBER (10) NOT NULL ,
    Descripcion   VARCHAR2 (50) NOT NULL ,
    Tipo          VARCHAR2 (1) NOT NULL,
    CreadoPor     VARCHAR2 (50) NOT NULL ,
    CreadoEn      DATE DEFAULT SYSDATE ,
    ModificadoPor VARCHAR2 (50) ,
    ModificadoEn  TIMESTAMP
  ) ;
ALTER TABLE TB_Rol ADD CONSTRAINT PK_TB_Rol PRIMARY KEY ( ID ) ;

ALTER TABLE TB_Rol ADD CONSTRAINT CHK_TB_Rol_001 CHECK (Tipo IN ('I','P')) ENABLE ;

COMMENT ON TABLE TB_Rol IS 'Tabla donde se registran los roles que haran parte del aplicativo';
COMMENT ON COLUMN TB_Rol.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Rol.Descripcion IS 'Descripcion del rol';
COMMENT ON COLUMN TB_Rol.Tipo IS 'Indica si el rol aplica para Banco de Ideas o Proyectos';


CREATE TABLE TB_SeguimientoIdea
  (
    ID                 NUMBER (10) NOT NULL ,
    ID_T_Idea          NUMBER (10) NOT NULL ,
    ID_T_LV_EstadoIdea NUMBER (10) NOT NULL ,
    Observacion        VARCHAR2 (300) ,
    CreadoPor          VARCHAR2 (50) NOT NULL ,
    CreadoEn           DATE DEFAULT SYSDATE
  ) ;
ALTER TABLE TB_SeguimientoIdea ADD CONSTRAINT PK_TB_SeguimientoIdea PRIMARY KEY ( ID ) ;

COMMENT ON TABLE TB_SeguimientoIdea IS 'Tabla donde se registra los cambios de estado que se realicen a una idea';
COMMENT ON COLUMN TB_SeguimientoIdea.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_SeguimientoIdea.ID_T_Idea IS 'Identificador unico de la tabla TB_Idea';
COMMENT ON COLUMN TB_SeguimientoIdea.ID_T_LV_EstadoIdea IS 'Identificador unico de la tabla TB_ListaValorDetalle';


CREATE TABLE TB_SolicitudIdea
  (
    ID                        NUMBER (10) NOT NULL ,
    ID_T_Idea                 NUMBER (10) NOT NULL ,
	ID_T_Proyecto             NUMBER (10) ,
    ID_T_Usuario              NUMBER (10) NOT NULL ,
    ID_T_LV_EstadoIdeaUsuario NUMBER (10) NOT NULL ,
    CreadoPor                 VARCHAR2 (50) NOT NULL ,
    CreadoEn                  DATE DEFAULT SYSDATE ,
    ModificadoPor             VARCHAR2 (50) ,
    ModificadoEn              TIMESTAMP
  ) ;
ALTER TABLE TB_SolicitudIdea ADD CONSTRAINT PK_TB_SolicitudIdea PRIMARY KEY ( ID ) ;
ALTER TABLE TB_SolicitudIdea ADD CONSTRAINT UN_TB_SolicitudIdea_001 UNIQUE ( ID_T_Idea , ID_T_Usuario ) ;
ALTER TABLE TB_SolicitudIdea ADD CONSTRAINT UN_TB_SolicitudIdea_002 UNIQUE ( ID_T_Proyecto ) ;

COMMENT ON TABLE TB_SolicitudIdea IS 'Tabla donde se registran cuando un usuario solicita trabajar con una idea';
COMMENT ON COLUMN TB_SolicitudIdea.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_SolicitudIdea.ID_T_Idea IS 'Identificador unico de la tabla TB_Idea';
COMMENT ON COLUMN TB_SolicitudIdea.ID_T_Proyecto IS 'Identificador unico de la tabla TB_Proyecto';
COMMENT ON COLUMN TB_SolicitudIdea.ID_T_Usuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_SolicitudIdea.ID_T_LV_EstadoIdeaUsuario IS 'Identificador unico de la tabla TB_ListaValorDetalle';


CREATE TABLE TB_SolicitudRol
  (
    ID             NUMBER (10) NOT NULL ,
    ID_T_Usuario   NUMBER (10) NOT NULL ,
    ID_T_Rol       NUMBER (10) NOT NULL ,
    FechaSolicitud DATE DEFAULT SYSDATE ,
	Estado         NUMBER (1) DEFAULT 1 NOT NULL ,
    CreadoPor      VARCHAR2 (50) NOT NULL ,
    CreadoEn       DATE DEFAULT SYSDATE ,
    ModificadoPor  VARCHAR2 (50) ,
    ModificadoEn   TIMESTAMP
  ) ;
ALTER TABLE TB_SolicitudRol ADD CONSTRAINT PK_TB_SolicitudRol PRIMARY KEY ( ID ) ;
ALTER TABLE TB_SolicitudRol ADD CONSTRAINT UN_TB_SolicitudRol_001 UNIQUE ( ID_T_Usuario , ID_T_Rol ) ;

ALTER TABLE TB_SolicitudRol ADD CONSTRAINT CHK_TB_SolicitudRol_001 CHECK (Estado IN (0, 1)) ENABLE ;

COMMENT ON TABLE TB_SolicitudRol IS 'Tabla donde se registran las solicitudes que hace un usuario al administrador para cambiar de rol';
COMMENT ON COLUMN TB_SolicitudRol.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_SolicitudRol.ID_T_Usuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_SolicitudRol.ID_T_Rol IS 'Identificador unico de la tabla TB_Rol';
COMMENT ON COLUMN TB_SolicitudRol.FechaSolicitud IS 'Fecha en que el usuario solicita el cambio de rol ';
COMMENT ON COLUMN TB_SolicitudRol.Estado IS 'Estado del procesamiento de la solicitud hecha por un usuario. Puede ser 0-Procesada 1-Pendiente. Por defecto es 1-Pendiente';


CREATE TABLE TB_Token
  (
    ID       NUMBER (10) NOT NULL ,
    Usuario  VARCHAR2 (50) NOT NULL ,
	Token    VARCHAR2 (100) NOT NULL ,
	Estado   NUMBER (1) DEFAULT 1 NOT NULL ,
    CreadoEn DATE DEFAULT SYSDATE 
  ) ;
ALTER TABLE TB_Token ADD CONSTRAINT PK_TB_Token PRIMARY KEY ( ID ) ;

ALTER TABLE TB_Token ADD CONSTRAINT CHK_TB_Token_001 CHECK (Estado IN (0, 1)) ENABLE ;

COMMENT ON TABLE TB_Token IS 'Tabla que guarda un token para generar una contrasena';
COMMENT ON COLUMN TB_Token.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Token.Usuario IS 'Identificador del campo Usuario de la tabla TB_Usuario';
COMMENT ON COLUMN TB_Token.Token IS 'Cadena alfanúmerica generada aleatoriamente al momento de ser insertada';
COMMENT ON COLUMN TB_Token.Estado IS 'Estado del Token que cambia cuando se actualiza la contrasena en la tabla TB_Usuario. Puede ser 0-Inactivo 1-Activo. Por defecto es 1-Activo';


CREATE TABLE TB_Usuario
  (
    ID                         NUMBER (10) NOT NULL ,
    ID_T_LV_TipoUsuario        NUMBER (10) NOT NULL ,
    ID_T_LV_EstadoUsuario      NUMBER (10) NOT NULL ,
    ID_T_LV_TipoIdentificacion NUMBER (10) NOT NULL ,
	NumIdentificacion          VARCHAR2 (20) NOT NULL ,
	PrimerNombre               VARCHAR2 (50) NOT NULL ,
	SegundoNombre              VARCHAR2 (50) ,
    PrimerApellido             VARCHAR2 (50) NOT NULL ,
    SegundoApellido            VARCHAR2 (50) ,
    FechaNacimiento            DATE NOT NULL ,
    Genero                     VARCHAR (1) NOT NULL ,
    TelefonoFijo               VARCHAR2 (50) ,
    TelefonoCelular            VARCHAR2 (50) ,
    Usuario                    VARCHAR2 (50) NOT NULL ,
    Contrasena                 VARCHAR2 (100) NOT NULL ,
    ID_T_LV_ProgramaAcedemico  NUMBER (10) NULL ,
    ID_T_LV_Dependencia        NUMBER (10) NULL ,
    CreadoPor                  VARCHAR2 (50) NOT NULL ,
    CreadoEn                   DATE DEFAULT SYSDATE ,
    ModificadoPor              VARCHAR2 (50) ,
    ModificadoEn               TIMESTAMP
  ) ;
ALTER TABLE TB_Usuario ADD CONSTRAINT PK_TB_Usuario PRIMARY KEY ( ID ) ;
ALTER TABLE TB_Usuario ADD CONSTRAINT UN_TB_Usuario_001 UNIQUE ( NumIdentificacion ) ;
ALTER TABLE TB_Usuario ADD CONSTRAINT UN_TB_Usuario_002 UNIQUE ( Usuario ) ;

ALTER TABLE TB_Usuario ADD CONSTRAINT CHK_TB_Usuario_001 CHECK (Genero IN ('M','F')) ENABLE ;

COMMENT ON TABLE TB_Usuario IS 'Tabla donde se registran todos los usuarios del sistema';
COMMENT ON COLUMN TB_Usuario.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_Usuario.ID_T_LV_TipoUsuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_Usuario.ID_T_LV_EstadoUsuario IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Usuario.ID_T_LV_TipoIdentificacion IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Usuario.NumIdentificacion IS 'Numero unico de identificacion del usuario';
COMMENT ON COLUMN TB_Usuario.PrimerNombre IS 'Primer nombre del usuario';
COMMENT ON COLUMN TB_Usuario.SegundoNombre IS 'Segundo nombre —opcional— del usuario';
COMMENT ON COLUMN TB_Usuario.PrimerApellido IS 'Primer apellido del usuario';
COMMENT ON COLUMN TB_Usuario.SegundoApellido IS 'Segundo apellido —opcional— del usuario';
COMMENT ON COLUMN TB_Usuario.FechaNacimiento IS 'Fecha de Nacimiento del usuario';
COMMENT ON COLUMN TB_Usuario.Genero IS 'Genero del usuario. Puede ser M-Masculino F-Femenino';
COMMENT ON COLUMN TB_Usuario.TelefonoFijo IS 'Telefono fijo del usuario';
COMMENT ON COLUMN TB_Usuario.TelefonoCelular IS 'Telefono celular del usuario';
COMMENT ON COLUMN TB_Usuario.Usuario IS 'Nombre unico del usuario. El nombre de usuario es el mismo Email';
COMMENT ON COLUMN TB_Usuario.Contrasena IS 'Contrasena del usuario';
COMMENT ON COLUMN TB_Usuario.ID_T_LV_ProgramaAcedemico IS 'Identificador unico de la tabla TB_ListaValorDetalle';
COMMENT ON COLUMN TB_Usuario.ID_T_LV_Dependencia IS 'Identificador unico de la tabla TB_ListaValorDetalle';


CREATE TABLE TB_UsuarioRol
  (
    ID                       NUMBER (10) NOT NULL ,
    ID_T_Usuario             NUMBER (10) NOT NULL ,
    ID_T_Rol                 NUMBER (10) NOT NULL ,
    ID_T_LV_EstadoUsuarioRol NUMBER (10) NOT NULL
  ) ;
ALTER TABLE TB_UsuarioRol ADD CONSTRAINT PK_TB_UsuarioRol PRIMARY KEY ( ID ) ;
ALTER TABLE TB_UsuarioRol ADD CONSTRAINT UN_TB_UsuarioRol_001 UNIQUE ( ID_T_Usuario , ID_T_Rol ) ;

COMMENT ON TABLE TB_UsuarioRol IS 'Tabla donde se registran todos los usuarios del sistema';
COMMENT ON COLUMN TB_UsuarioRol.ID IS 'Identificador unico de la tabla';
COMMENT ON COLUMN TB_UsuarioRol.ID_T_Usuario IS 'Identificador unico de la tabla TB_Usuario';
COMMENT ON COLUMN TB_UsuarioRol.ID_T_Rol IS 'Identificador unico de la tabla TB_Rol';
COMMENT ON COLUMN TB_UsuarioRol.ID_T_LV_EstadoUsuarioRol IS 'Identificador unico de la tabla TB_ListaValorDetalle';


ALTER TABLE TB_AprobacionEntrega ADD CONSTRAINT FK_TB_AprobacionEntrega_001 FOREIGN KEY ( ID_T_Entrega ) REFERENCES TB_Entrega ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_AprobacionEntrega ADD CONSTRAINT FK_TB_AprobacionEntrega_002 FOREIGN KEY ( ID_T_Usuario ) REFERENCES TB_Usuario ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Calificacion ADD CONSTRAINT FK_TB_Calificacion_001 FOREIGN KEY ( ID_T_Proyecto ) REFERENCES TB_Proyecto ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Calificacion ADD CONSTRAINT FK_TB_Calificacion_002 FOREIGN KEY ( ID_T_Usuario ) REFERENCES TB_Usuario ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Calificacion ADD CONSTRAINT FK_TB_Calificacion_003 FOREIGN KEY ( ID_T_LV_TipoEvaluacion ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Entrega ADD CONSTRAINT FK_TB_Entrega_001 FOREIGN KEY ( ID_T_Proyecto ) REFERENCES TB_Proyecto ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Entrega ADD CONSTRAINT FK_TB_Entrega_002 FOREIGN KEY ( ID_T_LV_PeriodoEntrega ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Entrega ADD CONSTRAINT FK_TB_Entrega_003 FOREIGN KEY ( ID_T_LV_EstadoEntrega ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Idea ADD CONSTRAINT FK_TB_Idea_001 FOREIGN KEY ( ID_T_Usuario ) REFERENCES TB_Usuario ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Idea ADD CONSTRAINT FK_TB_Idea_002 FOREIGN KEY ( ID_T_LV_EstadoIdea ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Integrantes ADD CONSTRAINT FK_TB_Integrantes_001 FOREIGN KEY ( ID_T_Proyecto ) REFERENCES TB_Proyecto ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Integrantes ADD CONSTRAINT FK_TB_Integrantes_002 FOREIGN KEY ( ID_T_Usuario ) REFERENCES TB_Usuario ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Integrantes ADD CONSTRAINT FK_TB_Integrantes_003 FOREIGN KEY ( ID_T_LV_TipoIntegrante ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Integrantes ADD CONSTRAINT FK_TB_Integrantes_004 FOREIGN KEY ( ID_T_LV_EstadoIntegrante ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_ListaValorDetalle ADD CONSTRAINT FK_TB_ListaValorDetalle_001 FOREIGN KEY ( ID_T_ListaValores ) REFERENCES TB_ListaValor ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_LineamientoDetalle ADD CONSTRAINT FK_TB_LineamientoDetalle_001 FOREIGN KEY ( ID_T_Lineamiento ) REFERENCES TB_Lineamiento ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_ObjetivoIdea ADD CONSTRAINT FK_TB_ObjetivoIdea_001 FOREIGN KEY ( ID_T_Idea ) REFERENCES TB_Idea ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Proyecto ADD CONSTRAINT FK_TB_Proyecto_001 FOREIGN KEY ( ID_T_Idea ) REFERENCES TB_Idea ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Proyecto ADD CONSTRAINT FK_TB_Proyecto_002 FOREIGN KEY ( ID_T_LV_EstadoProyecto ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Proyecto ADD CONSTRAINT FK_TB_Proyecto_003 FOREIGN KEY ( ID_T_Lineamiento ) REFERENCES TB_Lineamiento ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_SeguimientoIdea ADD CONSTRAINT FK_TB_SeguimientoIdea_001 FOREIGN KEY ( ID_T_Idea ) REFERENCES TB_Idea ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_SeguimientoIdea ADD CONSTRAINT FK_TB_SeguimientoIdea_002 FOREIGN KEY ( ID_T_LV_EstadoIdea ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_SolicitudIdea ADD CONSTRAINT FK_TB_SolicitudIdea_001 FOREIGN KEY ( ID_T_Idea ) REFERENCES TB_Idea ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_SolicitudIdea ADD CONSTRAINT FK_TB_SolicitudIdea_002 FOREIGN KEY ( ID_T_Usuario ) REFERENCES TB_Usuario ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_SolicitudIdea ADD CONSTRAINT FK_TB_SolicitudIdea_003 FOREIGN KEY ( ID_T_LV_EstadoIdeaUsuario ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_SolicitudRol ADD CONSTRAINT FK_TB_SolicitudRol_001 FOREIGN KEY ( ID_T_Usuario ) REFERENCES TB_Usuario ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_SolicitudRol ADD CONSTRAINT FK_TB_SolicitudRol_002 FOREIGN KEY ( ID_T_Rol ) REFERENCES TB_Rol ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Token ADD CONSTRAINT FK_TB_Token_001 FOREIGN KEY ( Usuario ) REFERENCES TB_Usuario ( Usuario ) NOT DEFERRABLE ;

ALTER TABLE TB_Usuario ADD CONSTRAINT FK_TB_Usuario_001 FOREIGN KEY ( ID_T_LV_TipoUsuario ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Usuario ADD CONSTRAINT FK_TB_Usuario_002 FOREIGN KEY ( ID_T_LV_EstadoUsuario ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Usuario ADD CONSTRAINT FK_TB_Usuario_003 FOREIGN KEY ( ID_T_LV_TipoIdentificacion ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Usuario ADD CONSTRAINT FK_TB_Usuario_004 FOREIGN KEY ( ID_T_LV_ProgramaAcedemico ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_Usuario ADD CONSTRAINT FK_TB_Usuario_005 FOREIGN KEY ( ID_T_LV_Dependencia ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_UsuarioRol ADD CONSTRAINT FK_TB_UsuarioRol_001 FOREIGN KEY ( ID_T_Usuario ) REFERENCES TB_Usuario ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_UsuarioRol ADD CONSTRAINT FK_TB_UsuarioRol_002 FOREIGN KEY ( ID_T_Rol ) REFERENCES TB_Rol ( ID ) NOT DEFERRABLE ;

ALTER TABLE TB_UsuarioRol ADD CONSTRAINT FK_TB_UsuarioRol_003 FOREIGN KEY ( ID_T_LV_EstadoUsuarioRol ) REFERENCES TB_ListaValorDetalle ( ID ) NOT DEFERRABLE ;
