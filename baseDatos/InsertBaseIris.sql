Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('1','TipoIdentificacion','Tipo de identificacion del usuario |Cedula Ciudadania|Cedula Extranjeria|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('2','TipoIntegrante','Tipo de integrante dentro de un proyecto |Estudiante|Director|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('3','EstadoIntegrante','Estado de un integrante dentro de un grupo de un proyecto |Activo|Inactivo|Retirado|Remiso|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('4','EstadoProyecto','Estado del proyecto |Aceptado|Revisar|Aprobacion|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('5','TipoEvaluacion','Tipo de evaluacion al momento de hacer una calificacion |Documento|Exposicion|Aplicacion|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('6','PeriodoEntrega','Periodo para la realizacion de una entrega parcial o final |PrimerPeriodo|SegundoPeriodo|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('7','EstadoEntrega','Estado parcial o final de la entrega |Entregado|Pendiente|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('8','EstadoIdea','Estado de una idea |Aceptada|Revision|Negada|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('9','EstadoIdeaUsuario','Estado de una idea cuando es asignada a un usuario |Ejecucion|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('10','TipoUsuario','Tipo de usuario cuando se registra |Estudiante|Docente|Directivo|Empleado|Egresado|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('11','EstadoUsuario','Estado del usuario dentro de la aplicacion |Activo|Inactivo|Retirado|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('12','EstadoSolicitudRol','Estado de la solicitud cuando un usuario solicita cambiar de rol |Pendiente|Realizada|...|','1','raphael.lara',null,null);
Insert into TB_LISTAVALOR (ID,AGRUPACION,DESCRIPCION,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('13','EstadoUsuarioRol','Estado un rol asociado a un usuario |Activo|Inactivo|...|','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('1','1','Cedula de Ciudadania','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('2','1','Cedula de Extranjeria','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('3','1','Tarjeta de Identidad','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('4','2','Estudiante','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('5','2','Director','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('6','3','Activo','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('7','3','Inactivo','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('8','3','Retirado','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('9','3','Remiso','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('10','4','Aceptado','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('11','4','En Revision','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('12','4','Aprobado','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('13','5','Documento','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('14','5','Exposicion','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('15','5','Aplicacion','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('16','6','Primer Corte','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('17','6','Segundo Corte','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('18','6','Tercer Corte','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('19','7','Entregado','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('20','7','Pendiente','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('21','8','Aceptada','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('22','8','Revision','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('23','8','Negada','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('24','9','En Ejecucion','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('25','10','Estudiante','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('26','10','Docente','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('27','10','Directivo','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('28','10','Empleado','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('29','10','Egresado','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('30','11','Activo','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('31','11','Inactivo','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('32','11','Retirado','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('33','12','Pendiente','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('34','12','Realizada','1','raphael.lara',null,null);

Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('36','13','Activo','1','raphael.lara',null,null);
Insert into TB_LISTAVALORDETALLE (ID,ID_T_LISTAVALORES,VALOR,ESTADO,CREADOPOR,MODIFICADOPOR,MODIFICADOEN) values ('37','13','Inactivo','1','raphael.lara',null,null);