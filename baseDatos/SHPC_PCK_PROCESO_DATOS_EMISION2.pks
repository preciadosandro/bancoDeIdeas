CREATE OR REPLACE PACKAGE SHPC_PCK_PROCESO_DATOS_EMISION2 IS
  /*
    VERSION  FECHA     RESPONSABLE  EMPRESA     DESCRIPCION
    ------- ---------- ------------ ----------- ----------------------
      1.0   28/05/2015 mcolorado                Se incluye actualización TOMA_OPC_SUP = N  en los casos
                                                en los que OPCION_RC_SUP = 0
      1.1   03/06/2015 cjrodriguez  Asesoftware Ajuste en el manejo de
                                                invocacion de procedimiento  proc_procesar_riesgo
                                                en el procedimiento Proc_ServiceExpide, para transmilenio
      1.2   11/06/2015 cjrodriguez  Asesoftware Mantis-35572:  Se ajusta el procedimiento Proc_UpdatedelType invocando
                                               la nueva función SIM_PCK_FUNCION_GEN.obtenerValorDatNum.
      1.3   16/09/2015 mcolorado    Asesoftware Mantis-39256: Se incluye validacion por seccion 310 para
                                                que permita crear el tercero por la cotizacion de soat masivo Simon.
      1.4   14/10/2015 mcolorado    Asesoftware Mantis-25949: Se incluye sentencias para extraer renta diaria y
                                                renta por inmovilizacion. 
  
  
  */

  PGEN       SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
  SALIDAGEN  SIM_PCK_TIPOS_GENERALES.T_SALIDA;
  PROCESOGEN SIM_PCK_TIPOS_GENERALES.T_PROCESO;
  XMLGEN     SIM_PCK_TIPOS_GENERALES.T_CLOB;
  L_ERROR    SIM_TYP_ERROR;
  C_NOMBREPACKAGE CONSTANT SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO := 'Sim_Pck_Proceso_Datos_Emision2.';
  G_PROGRAMA    SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO := 'Sim_Pck_Proceso_Datos_Emision2.';
  G_SUBPROGRAMA SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO := NULL;
  L_PARAMFIND   SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;

  /* ******** CUMPLIMIENTO 2 ************* */
  G_DESC_POL VARCHAR2(120) := '';
  /* ******** CUMPLIMIENTO 2 ************* */

  /*TYPE R_Datos_def  IS RECORD (
    nivel_campo      sim_default_datos.nivel_campo%type,
    cod_campo        sim_default_datos.cod_campo%type,
    valor_default    sim_default_datos.valor_default%type,
    modifica_campo   sim_default_datos.modifica_campo%type,
    visualiza_campo  sim_default_datos.visualiza_campo%type);
  TYPE T_Datos_def IS TABLE OF r_datos_def INDEX BY binary_integer;  */

  PROCEDURE PROC_ENTIDAD_COLOCADORA(IP_ENTIDADCOLOCADORA IN SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO,
                                    IP_PROCESO           IN SIM_TYP_PROCESO,
                                    OP_RESULTADO         OUT NOCOPY NUMBER,
                                    OP_ARRERRORES        OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_CANALES(IP_CANAL      IN SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO,
                         IP_PROCESO    IN SIM_TYP_PROCESO,
                         OP_RESULTADO  OUT NOCOPY NUMBER,
                         OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_SISTEMA_ORIGEN(IP_SISTEMAORIGEN IN SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO,
                                IP_PROCESO       IN SIM_TYP_PROCESO,
                                OP_RESULTADO     OUT NOCOPY NUMBER,
                                OP_ARRERRORES    OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_RECUPERA_SUMAASEGVEH(IP_MARCA          IN NUMBER,
                                      IP_MODELO         IN NUMBER,
                                      OP_PORCMAXIMO     OUT NOCOPY NUMBER,
                                      OP_PORCMINIMO     OUT NOCOPY NUMBER,
                                      OP_SUMAASEGRIESGO OUT NOCOPY NUMBER,
                                      OP_SUMA0KM        OUT NOCOPY NUMBER,
                                      IP_VALIDACION     IN VARCHAR2,
                                      IP_ARRCONTEXTO    IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                      OP_ARRCONTEXTO    OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                      IP_PROCESO        IN SIM_TYP_PROCESO,
                                      OP_RESULTADO      OUT NOCOPY NUMBER,
                                      OP_ARRERRORES     OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_RECUPERA_SUMAACCESVEH(IP_ACCESORIO       IN NUMBER,
                                       OP_PORCMAXIMO      OUT NOCOPY NUMBER,
                                       OP_PORCMAXESPECIAL OUT NOCOPY NUMBER,
                                       OP_SUMAACCESORIO   OUT NOCOPY NUMBER,
                                       IP_VALIDACION      IN VARCHAR2,
                                       IP_ARRCONTEXTO     IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                       OP_ARRCONTEXTO     OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                       IP_PROCESO         IN SIM_TYP_PROCESO,
                                       OP_RESULTADO       OUT NOCOPY NUMBER,
                                       OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_VISUALIZA_COB_AGR(OP_VISUALIZA_COB OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_AGR OUT NOCOPY VARCHAR2,
                                   IP_VALIDACION    IN VARCHAR2,
                                   IP_ARRCONTEXTO   IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   OP_ARRCONTEXTO   OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   IP_PROCESO       IN SIM_TYP_PROCESO,
                                   OP_RESULTADO     OUT NOCOPY NUMBER,
                                   OP_ARRERRORES    OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_VISUALIZA_DET_COB(OP_VISUALIZA_SUMA_ASEG  OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_TASA       OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_TASA_TOTAL OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_PRIMA      OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_FECHAS_VIG OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_SUMA_ASEG   OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_TASA        OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_TASA_TOTAL  OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_PRIMA       OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_FECHAS_VIG  OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION           IN VARCHAR2,
                                   IP_ARRCONTEXTO          IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   OP_ARRCONTEXTO          OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   IP_PROCESO              IN SIM_TYP_PROCESO,
                                   OP_RESULTADO            OUT NOCOPY NUMBER,
                                   OP_ARRERRORES           OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_VISUALIZA_DET_COB1(OP_VISUALIZA_SUMA_ASEG     OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_TASA          OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_TASA_TOTAL    OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_PRIMA         OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_FECHAS_VIG    OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_INDICEVAR     OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_MCA_GRATUITA  OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_DATOS_ADICION OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_NOMINAS       OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_DEDUCIBLES    OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_SUMA_ASEG      OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_TASA           OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_TASA_TOTAL     OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_PRIMA          OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_FECHAS_VIG     OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_INDICEVAR      OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_MCA_GRATUITA   OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_DATOS_ADICION  OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_NOMINAS        OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_DEDUCIBLES     OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    IP_VALIDACION              IN VARCHAR2,
                                    IP_ARRCONTEXTO             IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO             OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO                 IN SIM_TYP_PROCESO,
                                    OP_RESULTADO               OUT NOCOPY NUMBER,
                                    OP_ARRERRORES              OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_REC_DEFAULT_POLIZA(OP_DEF_DATOS      OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_DATOS_DEF,
                                    OP_DEF_AGENTES    OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_AGENTES_DEF,
                                    OP_DEF_COBERTURAS OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_COBERTURAS_DEF,
                                    IP_VALIDACION     IN VARCHAR2,
                                    IP_ARRCONTEXTO    IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO    OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO        IN SIM_TYP_PROCESO,
                                    OP_RESULTADO      OUT NOCOPY NUMBER,
                                    OP_ARRERRORES     OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_CLIENTEESPECIAL(IP_TIPODOCUMENTO   IN VARCHAR2,
                                 IP_NRODOCUMENTO    IN NUMBER,
                                 OP_CLIENTEESPECIAL OUT NOCOPY VARCHAR2,
                                 IP_VALIDACION      IN VARCHAR2,
                                 IP_PROCESO         IN SIM_TYP_PROCESO,
                                 OP_RESULTADO       OUT NOCOPY NUMBER,
                                 OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_USUARIOHABRECAUDO(OP_HABILITARECAUDO OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION      IN VARCHAR2,
                                   IP_PROCESO         IN SIM_TYP_PROCESO,
                                   OP_RESULTADO       OUT NOCOPY NUMBER,
                                   OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_USUARIOHABENTREGA(OP_HABILITAENTREGA OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION      IN VARCHAR2,
                                   IP_PROCESO         IN SIM_TYP_PROCESO,
                                   OP_RESULTADO       OUT NOCOPY NUMBER,
                                   OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_TIPIFICACION_NEGOCIO(IP_NUMSECUPOL   IN SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA,
                                      OP_TIPIFICACION OUT NOCOPY VARCHAR2,
                                      IP_PROCESO      IN SIM_TYP_PROCESO,
                                      OP_RESULTADO    OUT NOCOPY NUMBER,
                                      OP_ARRERRORES   OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_USUARIOHABRECAUDOEND(IP_NUMSECUPOL      IN NUMBER,
                                      IP_NUMEND          IN NUMBER,
                                      OP_HABILITARECAUDO OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                      IP_VALIDACION      IN VARCHAR2,
                                      IP_PROCESO         IN SIM_TYP_PROCESO,
                                      OP_RESULTADO       OUT NOCOPY NUMBER,
                                      OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_RECUPERAPRIMAFACTURA(IP_NUMSECUPOL      IN NUMBER,
                                      IP_NUMEND          IN NUMBER,
                                      IP_REFERENCIA      IN VARCHAR2,
                                      IP_COTIZACION      IN VARCHAR2,
                                      OP_REFERENCIA      OUT NOCOPY VARCHAR2,
                                      OP_NUMFACTURA      OUT NOCOPY NUMBER,
                                      OP_PRIMANETA       OUT NOCOPY NUMBER,
                                      OP_PRIMAASISTENCIA OUT NOCOPY NUMBER,
                                      OP_IVA             OUT NOCOPY NUMBER,
                                      OP_IVAASISTENCIA   OUT NOCOPY NUMBER,
                                      OP_GASTOSADM       OUT NOCOPY NUMBER,
                                      OP_PRIMATOTAL      OUT NOCOPY NUMBER,
                                      OP_BASEIVA         OUT NOCOPY NUMBER,
                                      IP_VALIDACION      IN VARCHAR2,
                                      IP_PROCESO         IN SIM_TYP_PROCESO,
                                      OP_RESULTADO       OUT NOCOPY NUMBER,
                                      OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_RECUPERAPRIMAASISTENCIA(IP_NUMSECUPOL      IN NUMBER,
                                         IP_NUMEND          IN NUMBER,
                                         IP_MCAFACTURA      IN VARCHAR2,
                                         IP_NUMFACTURA      IN NUMBER,
                                         OP_PRIMAASISTENCIA OUT NOCOPY NUMBER,
                                         IP_VALIDACION      IN VARCHAR2,
                                         IP_PROCESO         IN SIM_TYP_PROCESO,
                                         OP_RESULTADO       OUT NOCOPY NUMBER,
                                         OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_USUARIOHABPROCESO(IP_CODIGOPROCESO   IN SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA,
                                   OP_HABILITAPROCESO OUT NOCOPY SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION      IN VARCHAR2,
                                   IP_PROCESO         IN SIM_TYP_PROCESO,
                                   OP_RESULTADO       OUT NOCOPY NUMBER,
                                   OP_ARRERRORES      OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_INICIALIZA_PASOS(IP_ARRCONTEXTO SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                  IP_PROCESODV   OUT NOCOPY VARCHAR2,
                                  IP_PROCESOCOB  OUT NOCOPY VARCHAR2,
                                  IP_EJECUTOCT   OUT NOCOPY VARCHAR2);

  PROCEDURE PROC_PRECAMPODVARIABLES(IP_NUMSECUPOL  IN NUMBER,
                                    IP_CODRIES     IN NUMBER,
                                    IP_CODCAMPO    IN VARCHAR2,
                                    IP_CODNIVEL    IN NUMBER,
                                    IP_CODCOB      IN NUMBER,
                                    IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO     IN SIM_TYP_PROCESO,
                                    OP_RESULTADO   OUT NOCOPY NUMBER,
                                    OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_PROCESAR_DV(IP_NUMSECUPOL  IN NUMBER,
                             IP_CODRIES     IN NUMBER,
                             IP_NIVEL       IN VARCHAR2,
                             IP_COBERTURA   IN NUMBER,
                             IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                             OP_ARRCONTEXTO OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                             IP_PROCESO     IN SIM_TYP_PROCESO,
                             OP_RESULTADO   OUT NOCOPY NUMBER,
                             OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_PROCESAR_RIESGO(IP_NUMSECUPOL  IN NUMBER,
                                 IP_CODRIES     IN NUMBER,
                                 IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                 OP_ARRCONTEXTO OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                 IP_PROCESO     IN SIM_TYP_PROCESO,
                                 OP_RESULTADO   OUT NOCOPY NUMBER,
                                 OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_SERVICEEXPIDE(IP_POLIZA      IN SIM_TYP_POLIZAGEN,
                               IP_TIPOPROCESO IN NUMBER,
                               OP_POLIZA      OUT NOCOPY SIM_TYP_POLIZAGEN,
                               IP_VALIDACION  IN VARCHAR2,
                               IP_PROCESO     IN SIM_TYP_PROCESO,
                               OP_RESULTADO   OUT NOCOPY NUMBER,
                               OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_UPDATEDELTYPE(IP_POLIZA     IN OUT NOCOPY SIM_TYP_POLIZAGEN,
                               IP_NUMSECUPOL IN NUMBER,
                               IP_NUMEND     IN NUMBER,
                               IP_PROCESO    IN SIM_TYP_PROCESO,
                               OP_RESULTADO  OUT NOCOPY NUMBER,
                               OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_UPDATEDINAMYC(IP_NUMSECUPOL IN NUMBER,
                               IP_NUMEND     IN NUMBER,
                               IP_PROCESO    IN SIM_TYP_PROCESO,
                               OP_RESULTADO  OUT NOCOPY NUMBER,
                               OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_UPDATETYPEDEX(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                               OP_POLIZA     OUT NOCOPY SIM_TYP_POLIZAGEN,
                               IP_NUMSECUPOL IN NUMBER,
                               IP_NUMEND     IN NUMBER,
                               IP_PROCESO    IN SIM_TYP_PROCESO,
                               OP_RESULTADO  OUT NOCOPY NUMBER,
                               OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_CONTEXTO_INS_TRANS(IP_NUMSECUPOL  IN NUMBER,
                                    IP_NUMEND      IN NUMBER,
                                    IP_VALIDACION  IN VARCHAR2,
                                    IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO     IN SIM_TYP_PROCESO,
                                    OP_RESULTADO   OUT NOCOPY NUMBER,
                                    OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  --Abuelvas: Se crea esta funcion para validar si la placa que viene es una placa por default                                    
  FUNCTION FUN_VALIDAR_PLACA_DEFAULT(PLACA IN A2000410.PAT_VEH%TYPE)
    RETURN VARCHAR2;

  PROCEDURE PROC_DEDUCIBLES(IP_NUMPOL1       IN NUMBER,
                            IP_CODRIES       IN NUMBER,
                            IP_CODCOB        IN NUMBER,
                            IP_NUMEND        IN NUMBER,
                            OP_ARRDEDUCIBLES OUT NOCOPY SIM_TYP_ARRAY_DEDUCIBLES,
                            IP_VALIDACION    IN VARCHAR2,
                            IP_ARRCONTEXTO   IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                            OP_ARRCONTEXTO   OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                            IP_PROCESO       IN SIM_TYP_PROCESO,
                            OP_RESULTADO     OUT NOCOPY NUMBER,
                            OP_ARRERRORES    OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_INTEGRAPREINS(IP_INSPECCION  IN NUMBER,
                               IP_PRESUPUESTO IN NUMBER,
                               OP_PRESINSPECC OUT NOCOPY SIM_TYP_PRESUPINSP,
                               IP_VALIDACION  IN VARCHAR2,
                               IP_PROCESO     IN SIM_TYP_PROCESO,
                               OP_RESULTADO   OUT NOCOPY NUMBER,
                               OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_CONSOBJPOL(IP_NUMPOL1    IN NUMBER,
                            IP_NUMEND     IN NUMBER,
                            IP_NUMSECUPOL IN NUMBER,
                            IP_TIPO       IN VARCHAR2 -- 'C' Cotizacion 'P' Poliza
                           ,
                            OP_OBJPOLIZA  OUT NOCOPY SIM_TYP_POLIZAGEN,
                            IP_VALIDACION IN VARCHAR2,
                            IP_PROCESO    IN SIM_TYP_PROCESO,
                            OP_RESULTADO  OUT NOCOPY NUMBER,
                            OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  FUNCTION FUN_TRAE_PRIMAXRIES(IP_NUMSECUPOL NUMBER,
                               IP_NUMEND     NUMBER,
                               IP_CODRIES    NUMBER) RETURN NUMBER;

  PROCEDURE PROC_IMPRIME_DOC1(OP_IMPRIME    OUT NOCOPY VARCHAR2,
                              IP_VALIDACION IN VARCHAR2,
                              IP_PROCESO    IN SIM_TYP_PROCESO,
                              OP_RESULTADO  OUT NOCOPY NUMBER,
                              OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_UPDATEDELTYPECOB(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                  IP_VALIDACION IN VARCHAR2,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NOCOPY NUMBER,
                                  OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_DETALLE_POLIZASNORENOV(IP_LISTAPOLIZAS IN SIM_TYP_ARRAY_LISTA,
                                        IP_TOMADOR      IN NUMBER,
                                        OP_ARRAYPOLIZAS OUT NOCOPY SIM_TYP_ARRAY_POLIZAGEN,
                                        IP_VALIDACION   IN VARCHAR2,
                                        IP_PROCESO      IN SIM_TYP_PROCESO,
                                        OP_RESULTADO    OUT NOCOPY NUMBER,
                                        OP_ARRERRORES   OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_RECUPERA_DETALLEPOL(IP_NUMPOL1    IN A2000030.NUM_POL1%TYPE,
                                     OP_POLIZA     OUT NOCOPY SIM_TYP_POLIZAGEN,
                                     IP_NUMSECUPOL IN NUMBER,
                                     IP_NUMEND     IN NUMBER,
                                     IP_VIGENTE    IN VARCHAR2,
                                     IP_PROCESO    IN SIM_TYP_PROCESO,
                                     OP_RESULTADO  OUT NOCOPY NUMBER,
                                     OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_EXISTE_INSPECCION_AUTOS(IP_PLACA      VARCHAR2,
                                         OP_CONCEPTO   OUT NOCOPY VARCHAR2,
                                         OP_RESULTADO  OUT NOCOPY NUMBER,
                                         OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_LISTA_CONVENIOSSEGUROS(OP_ARRAYCONVENIOS OUT NOCOPY SIM_TYP_ARRAY_LISTA,
                                        IP_VALIDACION     IN VARCHAR2,
                                        IP_PROCESO        IN SIM_TYP_PROCESO,
                                        OP_RESULTADO      OUT NOCOPY NUMBER,
                                        OP_ARRERRORES     OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  -- Proceso para realizar mapeo de textos hacia sim_x_textos.
  -- %author Ing. Lic. Stephen Guseph Pinto Morato - sgpinto@asesoftware.com
  -- %param ip_poliza        Objeto de póliza de entrada SIM_TYP_POLIZAGEN.
  -- %param ip_tipo_proceso  Tipo de proceso (1: Emisión, 2: Modificación)
  -- %param op_poliza        Objeto Póliza de salida tipo SIM_TYP_POLIZAGEN.
  -- %param ip_validacion    Variable de validación.
  -- %param ip_proceso       Type de proceso SIMON.
  -- %param op_resultado     Variable de control de resultado (0: OK, 1. Warning, -1: error)
  -- %param op_arrerrores    Array de errores.
  -- %version 1.2
  --
  -- Fecha        Versión  - Autor  - Cambios
  -- ---------------------------------------------------------------------------
  -- 27/08/2014    1.0     - Stephen Pinto (ASESOFTWARE) - Creación.
  -- 20/01/2015    1.1     - Stephen Pinto (ASESOFTWARE) - Cambio 001
  -- 16/03/2015    1.2     - Stephen Pinto (ASESOFTWARE) - Cambio 002
  PROCEDURE PROC_MAPEO_TEXTOS(IP_POLIZA      IN SIM_TYP_POLIZAGEN,
                              IP_NUMSECUPOL  IN NUMBER,
                              IP_TIPOPROCESO IN NUMBER,
                              OP_POLIZA      OUT NOCOPY SIM_TYP_POLIZAGEN,
                              IP_VALIDACION  IN VARCHAR2,
                              IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                              OP_ARRCONTEXTO OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                              IP_PROCESO     IN SIM_TYP_PROCESO,
                              OP_RESULTADO   OUT NOCOPY NUMBER,
                              OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  -- Función que realiza el mapeo de coaseguros y retorna el tipo de coaseguro realizado
  -- %author Ing. Lic. Stephen Guseph Pinto Morato - sgpinto@asesoftware.com
  -- %param ip_poliza        Objeto de póliza de entrada SIM_TYP_POLIZAGEN.
  -- %param ip_proceso       Type de proceso SIMON.
  -- %param op_resultado     Variable de control de resultado (0: OK, 1. Warning, -1: error)
  -- %param op_arrerrores    Array de errores
  -- %return código del coaseguro (0: rechazado, 1: cedido, 3: aceptado)
  -- %version 1.0
  --
  -- Fecha        Versión  - Autor  - Cambios
  -- ---------------------------------------------------------------------------
  -- 29/08/2014    1.0     - Stephen Pinto (ASESOFTWARE) -  Modificación algoritmo elaborado por
  --                                                        María Cristina González (Seguros Bolívar)
  FUNCTION FUN_MAPEO_COASEGUROS(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                IP_PROCESO    IN SIM_TYP_PROCESO,
                                OP_RESULTADO  OUT NOCOPY NUMBER,
                                OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR)
    RETURN NUMBER;

  -- Procedimiento para el mapeo de coberturas de cumplimiento en el service de expedición
  -- %author Ing. Lic. Stephen Guseph Pinto Morato - sgpinto@asesoftware.com
  -- %param ip_poliza     IN sim_typ_polizagen
  -- %param ip_numsecupol IN NUMBER
  -- %param ip_numend     IN NUMBER
  -- %param ip_proceso    IN sim_typ_proceso
  -- %param op_resultado  Out nocopy NUMBER
  -- %param op_arrerrores Out nocopy sim_typ_array_error
  -- %version 1.0
  --
  -- Fecha       - Versión  - Autor                     - Cambios
  -- ---------------------------------------------------------------------------
  -- 10/11/2014  - 1.0     - Stephen Pinto (ASESOFTWARE) - Creación.
  PROCEDURE PROC_MAPEO_COB_CUMP(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                IP_NUMSECUPOL IN NUMBER,
                                IP_NUMEND     IN NUMBER,
                                IP_PROCESO    IN SIM_TYP_PROCESO,
                                OP_RESULTADO  OUT NOCOPY NUMBER,
                                OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  -- Procedimiento principal para la modificación de póliza hija
  -- %author John Alexander Baquero Roncancio - jbaquero@asesoftware.com
  -- %version 1.0
  --
  -- Fecha        Versión  - Autor  - Cambios
  -- ---------------------------------------------------------------------------
  -- 21/08/2014    1.0     - John Baquero (ASESOFTWARE) - Creación.
  PROCEDURE PROC_SERVICE_MODIFICA_POLHIJA(IP_POLIZA      IN SIM_TYP_POLIZAGEN,
                                          IP_TIPOPROCESO IN NUMBER,
                                          IP_ARRCONTEXTO IN OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                          OP_ARRCONTEXTO OUT NOCOPY SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                          OP_POLIZA      OUT NOCOPY SIM_TYP_POLIZAGEN,
                                          IP_VALIDACION  IN VARCHAR2,
                                          IP_PROCESO     IN SIM_TYP_PROCESO,
                                          OP_RESULTADO   OUT NOCOPY NUMBER,
                                          OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);
  /* ******** CUMPLIMIENTO 2 ************* */
  -- Procedimiento para el mapeo de datos fijos de póliza hija
  -- %author John Alexander Baquero Roncancio - jbaquero@asesoftware.com
  -- %version 1.0
  --
  -- Fecha        Versión  - Autor  - Cambios
  -- ---------------------------------------------------------------------------
  -- 25/08/2014    1.0     - John Baquero (ASESOFTWARE) - Creación.
  PROCEDURE PROC_MAPEO_DFIJOS_POLHIJA(IP_POLIZA IN OUT NOCOPY SIM_TYP_POLIZAGEN,
                                      /* */
                                      IP_FECHAMINIMA IN VARCHAR2,
                                      IP_FECHAMAXIMA IN VARCHAR2,
                                      /* */
                                      IP_NUMSECUPOL IN NUMBER,
                                      IP_NUMEND     IN NUMBER,
                                      IP_PROCESO    IN SIM_TYP_PROCESO,
                                      OP_RESULTADO  OUT NOCOPY NUMBER,
                                      OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  -- Procedimiento para el mapeo de datos variables de póliza hija
  -- %author John Alexander Baquero Roncancio - jbaquero@asesoftware.com
  -- %version 1.0
  --
  -- Fecha        Versión  - Autor  - Cambios
  -- ---------------------------------------------------------------------------
  -- 25/08/2014    1.0     - John Baquero (ASESOFTWARE) - Creación.
  PROCEDURE PROC_MAPEO_DVARIABLES_POLHIJA(IP_POLIZA IN OUT NOCOPY SIM_TYP_POLIZAGEN,
                                          
                                          IP_NUMSECUPOL IN NUMBER,
                                          IP_NUMEND     IN NUMBER,
                                          IP_PROCESO    IN SIM_TYP_PROCESO,
                                          OP_RESULTADO  OUT NOCOPY NUMBER,
                                          OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);
  -- Procedimiento para el mapeo de datos variables de Riesgos de póliza hija
  -- %author John Alexander Baquero Roncancio - jbaquero@asesoftware.com
  -- %version 1.0

  --
  -- Fecha        Versión  - Autor  - Cambios
  -- ---------------------------------------------------------------------------
  -- 26/08/2014    1.0     - John Baquero (ASESOFTWARE) - Creación.
  PROCEDURE PROC_MAPEO_DVRIESGOS_POLHIJA(IP_POLIZA     IN OUT NOCOPY SIM_TYP_POLIZAGEN,
                                         IP_NUMSECUPOL IN NUMBER,
                                         IP_NUMEND     IN NUMBER,
                                         IP_PROCESO    IN SIM_TYP_PROCESO,
                                         OP_RESULTADO  OUT NOCOPY NUMBER,
                                         OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  -- Procedimiento para el mapeo de coberturas de Riesgos de póliza hija
  -- %author John Alexander Baquero Roncancio - jbaquero@asesoftware.com
  -- %version 1.0
  --
  -- Fecha        Versión  - Autor  - Cambios
  -- ---------------------------------------------------------------------------
  -- 26/08/2014    1.0     - John Baquero (ASESOFTWARE) - Creación.
  PROCEDURE PROC_MAPEO_COBRIESGOS_POLHIJA(IP_POLIZA     IN OUT NOCOPY SIM_TYP_POLIZAGEN,
                                          IP_NUMSECUPOL IN NUMBER,
                                          IP_NUMEND     IN NUMBER,
                                          IP_PROCESO    IN SIM_TYP_PROCESO,
                                          OP_RESULTADO  OUT NOCOPY NUMBER,
                                          OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_CONVIERTE_DESC_POL(IP_DESC_POL IN VARCHAR2,
                                    OP_DESC_POL OUT NOCOPY VARCHAR2);

  PROCEDURE PROC_IMPRIMEPPAL_DOC1(OP_IMPRIME    OUT NOCOPY VARCHAR2,
                                  IP_VALIDACION IN VARCHAR2,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NOCOPY NUMBER,
                                  OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_CREAARRAYASEG(IP_NUMSECUPOL   IN A2000030.NUM_SECU_POL%TYPE,
                               OP_ARRAYTERCERO OUT NOCOPY SIM_TYP_ARRAY_TERCEROGEN,
                               IP_PROCESO      IN SIM_TYP_PROCESO,
                               OP_RESULTADO    OUT NOCOPY NUMBER,
                               OP_ARRERRORES   OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_PLACAVIGENTE(IP_PLACA      IN VARCHAR2,
                              IP_NUMSECUPOL IN NUMBER,
                              IP_PROCESO    IN SIM_TYP_PROCESO,
                              OP_RESULTADO  OUT NOCOPY NUMBER,
                              OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  --BANCAN3-177 version para ser llamado en cotizaciones desde API
  PROCEDURE PROC_PLACAVIGENTE(IP_PLACA             IN VARCHAR2,
                              IP_NUMSECUPOL        IN NUMBER,
                              IP_PROCESO           IN SIM_TYP_PROCESO,
                              IP_NRO_DOCUMTO_ASEG  NUMBER,
                              IP_TIPP_DOCUMTO_ASEG VARCHAR2,
                              OP_RESULTADO         OUT NOCOPY NUMBER,
                              OP_ARRERRORES        OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_INSPECCIONVIGENTE(IP_PLACA         IN VARCHAR2,
                                   IP_CODMOD        IN A2040100.COD_MOD%TYPE,
                                   IP_CODMARCA      IN A2040100.COD_MARCA%TYPE,
                                   IP_CODUSO        IN A2040100.COD_USO%TYPE,
                                   OP_NROINSPECCION OUT NOCOPY NUMBER,
                                   IP_VALIDACION    IN VARCHAR2,
                                   IP_PROCESO       IN SIM_TYP_PROCESO,
                                   OP_RESULTADO     OUT NOCOPY NUMBER,
                                   OP_ARRERRORES    OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_EXISTECODIGOFAS(IP_MARCAFSECOLDA IN NUMBER,
                                 IP_DESCMARCA     IN VARCHAR2,
                                 OP_EXISTE        OUT NOCOPY VARCHAR2,
                                 IP_VALIDACION    IN VARCHAR2,
                                 IP_PROCESO       IN SIM_TYP_PROCESO,
                                 OP_RESULTADO     OUT NOCOPY NUMBER,
                                 OP_ARRERRORES    OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_VALIDAPROCPOLIZA(IP_NUMSECUPOL IN A2000030.NUM_SECU_POL%TYPE,
                                  OP_EXISTE     OUT NOCOPY VARCHAR2,
                                  IP_VALIDACION IN VARCHAR2,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NOCOPY NUMBER,
                                  OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);
  --intasi31 ATGC SALUD 07042016
  PROCEDURE PROC_CREAARRAYASEGSALUD(IP_NUMSECUPOL   IN A2000030.NUM_SECU_POL%TYPE,
                                    OP_ARRAYTERCERO OUT NOCOPY SIM_TYP_ARRAY_TERCEROGEN,
                                    IP_PROCESO      IN SIM_TYP_PROCESO,
                                    OP_RESULTADO    OUT NOCOPY NUMBER,
                                    OP_ARRERRORES   OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_UPDEMAIL(IP_NUMSECUPOL IN NUMBER,
                          IP_NUMEND     IN NUMBER,
                          IP_CODRIES    IN NUMBER,
                          IP_VALIDACION IN VARCHAR2,
                          IP_PROCESO    IN SIM_TYP_PROCESO,
                          OP_RESULTADO  OUT NOCOPY NUMBER,
                          OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  FUNCTION FUN_VLRASEG(IP_NUMSECUPOL IN A2040300.NUM_SECU_POL%TYPE,
                       IP_CODRIES    IN A2040300.COD_RIES%TYPE,
                       IP_TIPO       IN NUMBER) RETURN NUMBER;

  PROCEDURE PROC_ANULAREEMPLAZA_RENOV(IP_NUMSECUPOL   IN A2000030.NUM_SECU_POL%TYPE,
                                      IP_NUMEND       IN A2000030.NUM_END%TYPE,
                                      IP_CODRIES      IN A2000020.COD_RIES%TYPE,
                                      OP_ESANULAREEMP OUT NOCOPY VARCHAR2,
                                      IP_PROCESO      IN SIM_TYP_PROCESO,
                                      OP_RESULTADO    OUT NOCOPY NUMBER,
                                      OP_ARRERRORES   OUT NOCOPY SIM_TYP_ARRAY_ERROR);
  FUNCTION FUN_ES_ANULAREEMPLAZA(IP_NUMSECUPOL IN A2000030.NUM_SECU_POL%TYPE,
                                 IP_NUMEND     IN A2000030.NUM_END%TYPE,
                                 IP_CODRIES    IN A2000020.COD_RIES%TYPE,
                                 IP_PROCESO    IN SIM_TYP_PROCESO)
    RETURN VARCHAR2;
  PROCEDURE PROC_ACTUALIZA_DV(IP_NUM_SECU_POL IN A2000020.NUM_SECU_POL%TYPE,
                              IP_COD_RIES     IN A2000020.COD_RIES%TYPE,
                              IP_COD_CAMPO    IN A2000020.COD_CAMPO%TYPE,
                              IP_VALOR_CAMPO  IN A2000020.VALOR_CAMPO%TYPE);

  PROCEDURE PROC_UPDATETYPEDEXAPI(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                  OP_POLIZA     OUT NOCOPY SIM_TYP_POLIZAGEN,
                                  IP_NUMSECUPOL IN NUMBER,
                                  IP_NUMEND     IN NUMBER,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NOCOPY NUMBER,
                                  OP_ARRERRORES OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  PROCEDURE PROC_VALIDA_CHASIS(IP_TDOC_ASEG   IN A2000020.VALOR_CAMPO%TYPE,
                               IP_NUMDOC_ASEG IN A2000020.VALOR_CAMPO%TYPE,
                               IP_CHASIS      IN A2040100.CHASIS_VEH%TYPE,
                               IP_NUMSECUPOL  IN A2040100.NUM_SECU_POL%TYPE,
                               IP_PROCESO     IN SIM_TYP_PROCESO,
                               OP_RESULTADO   OUT NOCOPY NUMBER,
                               OP_ARRERRORES  OUT NOCOPY SIM_TYP_ARRAY_ERROR);

  FUNCTION FUN_VALPLACAGENSIMON(IP_PLACA  IN VARCHAR2,
                                OP_RETURN OUT NOCOPY NUMBER) RETURN NUMBER;

  PROCEDURE VALIDAROPCIONAUTOSELECTRICOS(PCA_INFO5          IN VARCHAR2,
                                         PNU_NUM_SECU_POL   IN NUMBER,
                                         PCA_COD_CAMPO      IN VARCHAR2,
                                         PNU_COD_RIES       IN NUMBER,
                                         PNU_SISTEMA_ORIGEN IN NUMBER,
                                         PCA_VALOR_CAMPO    IN OUT VARCHAR2);

  PROCEDURE PROC_UPDATE_DF_OFERTAS(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                   IP_NUMSECUPOL IN NUMBER,
                                   IP_NUMEND     IN NUMBER);
                                   
    Procedure proc_CT_Masivo_Digital (Ip_Numsecupol  in number,
                                    Ip_Proceso     sim_typ_proceso);

  Procedure Proc_actualiza_nomina (IP_NumSecupol number
                                ,Ip_Numend     number);
END SHPC_PCK_PROCESO_DATOS_EMISION2;
/
