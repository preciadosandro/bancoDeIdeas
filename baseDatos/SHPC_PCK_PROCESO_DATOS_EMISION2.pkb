CREATE OR REPLACE PACKAGE BODY SHPC_PCK_PROCESO_DATOS_EMISION2 IS
  /*
    VERSION  FECHA     RESPONSABLE  EMPRESA     DESCRIPCION
    ------- ---------- ------------ ----------- ----------------------
      1.0   28/05/2015                 Se incluye actualización TOMA_OPC_SUP = N  en los casos
                                                en los que OPCION_RC_SUP = 0
      1.1   03/06/2015 cjrodriguez  Asesoftware Ajuste en el manejo de
                                                invocacion de procedimiento  proc_procesar_riesgo
                                                en el procedimiento Proc_ServiceExpide para transmilenio
      1.2   11/06/2015 cjrodriguez  Asesoftware Mantis-35572:  Se ajusta el procedimiento Proc_UpdatedelType invocando
                                                la nueva función SIM_PCK_FUNCION_GEN.obtenerValorDatNum.
      1.3   16/09/2015 mcolorado    Asesoftware Mantis-39256: Se incluye validacion por seccion 310 para
                                                que permita crear el tercero por la cotizacion de soat masivo Simon.
      1.4   14/10/2015 mcolorado    Asesoftware Mantis-25949: Se incluye sentencias para extraer renta diaria y
                                                renta por inmovilizacion.
      1.5   04/08/2016 Juan González            modifica para permitir mostrar coberturas gratuitas sin importar
                                                el valor de la prima (Rcob.mca_gratuita='S')
      1.6   02/01/2016 Juan González            modifica para permitir grabar el correo del asegurado principla
                                                 producto  721- Davida : Simones Ventas
      1.7   01/03/2017 Patty Gonzalez           Se ajusta el procedimiento proc_ConsObjPol para que busque el
                                                estado actual de la póliza y no el endoso 0
  
      1.10.  31/07/2019  Benjamin Galindo       Para el objeto poliza se realiza consulta para polizas de pago con debito
                                                automatico para gargar Type Sim_Typ_datosDebitoGen y añadirlo al objeto poliza
    Version 2021
       2.1   30/07/2022 Rolf Winterfeldt SB      Se reestablece código borrado por una entrega realizada con la
                                                versión del paquete sacada de Produciión.
  */

  PROCEDURE PROC_ENTIDAD_COLOCADORA(IP_ENTIDADCOLOCADORA IN SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO,
                                    IP_PROCESO           IN SIM_TYP_PROCESO,
                                    OP_RESULTADO         OUT NUMBER,
                                    OP_ARRERRORES        OUT SIM_TYP_ARRAY_ERROR) IS
    PGEN       SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN  SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN     SIM_PCK_TIPOS_GENERALES.T_CLOB;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.ProcEntidadColocadora ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    PGEN := SIM_PCK_TIPOS_GENERALES.T_PARAMETRO(NULL);
    SALIDAGEN := SIM_PCK_TIPOS_GENERALES.T_SALIDA(NULL);
    PROCESOGEN := NULL;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_ENTCOLOCADORA';
    PGEN(PGEN.COUNT).OP_VALOR := IP_ENTIDADCOLOCADORA;
  
    PROCESOGEN.P_TIPOPROCESO  := SIM_PCK_TIPOS_GENERALES.C_LISTA;
    PROCESOGEN.P_TIPORECUPERO := NULL;
    SIM_PCK_LISTAS_EMISION.ENTIDAD_COLOCADORA(PGEN,
                                              SALIDAGEN,
                                              XMLGEN,
                                              PROCESOGEN);
  
    IF PROCESOGEN.P_CODERROR != SIM_PCK_TIPOS_GENERALES.C_CERO THEN
      L_ERROR := SIM_TYP_ERROR(PROCESOGEN.P_CODERROR,
                               PROCESOGEN.P_MSGERROR,
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    ELSE
      IF PROCESOGEN.P_NUMREG = SIM_PCK_TIPOS_GENERALES.C_CERO THEN
        L_ERROR := SIM_TYP_ERROR(-20002,
                                 'No Hay Datos para Entidad Colocadora',
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
      END IF;
    END IF;
  END PROC_ENTIDAD_COLOCADORA;

  /*---------------------------------------------------*/
  PROCEDURE PROC_CANALES(IP_CANAL      IN SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO,
                         IP_PROCESO    IN SIM_TYP_PROCESO,
                         OP_RESULTADO  OUT NUMBER,
                         OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    PGEN       SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN  SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN     SIM_PCK_TIPOS_GENERALES.T_CLOB;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.ProcCanal ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    PGEN := SIM_PCK_TIPOS_GENERALES.T_PARAMETRO(NULL);
    SALIDAGEN := SIM_PCK_TIPOS_GENERALES.T_SALIDA(NULL);
    PROCESOGEN := NULL;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_CANAL';
    PGEN(PGEN.COUNT).OP_VALOR := IP_CANAL;
  
    PROCESOGEN.P_TIPOPROCESO  := SIM_PCK_TIPOS_GENERALES.C_LISTA;
    PROCESOGEN.P_TIPORECUPERO := NULL;
    SIM_PCK_LISTAS_EMISION.CANALES(PGEN, SALIDAGEN, XMLGEN, PROCESOGEN);
  
    IF PROCESOGEN.P_CODERROR != SIM_PCK_TIPOS_GENERALES.C_CERO THEN
      L_ERROR := SIM_TYP_ERROR(PROCESOGEN.P_CODERROR,
                               PROCESOGEN.P_MSGERROR,
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    ELSE
      IF PROCESOGEN.P_NUMREG = SIM_PCK_TIPOS_GENERALES.C_CERO THEN
        L_ERROR := SIM_TYP_ERROR(-20002, 'No Hay Datos para Canal', 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
      END IF;
    END IF;
  END PROC_CANALES;

  /*--------------------------------------------------*/

  /*---------------------------------------------------*/
  PROCEDURE PROC_SISTEMA_ORIGEN(IP_SISTEMAORIGEN IN SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO,
                                IP_PROCESO       IN SIM_TYP_PROCESO,
                                OP_RESULTADO     OUT NUMBER,
                                OP_ARRERRORES    OUT SIM_TYP_ARRAY_ERROR) IS
    PGEN       SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN  SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN     SIM_PCK_TIPOS_GENERALES.T_CLOB;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.ProcSistema_Origen';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    PGEN := SIM_PCK_TIPOS_GENERALES.T_PARAMETRO(NULL);
    SALIDAGEN := SIM_PCK_TIPOS_GENERALES.T_SALIDA(NULL);
    PROCESOGEN := NULL;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_SISTEMAORIGEN';
    PGEN(PGEN.COUNT).OP_VALOR := IP_SISTEMAORIGEN;
  
    PROCESOGEN.P_TIPOPROCESO  := SIM_PCK_TIPOS_GENERALES.C_LISTA;
    PROCESOGEN.P_TIPORECUPERO := NULL;
    SIM_PCK_LISTAS_EMISION.SISTEMA_ORIGEN(PGEN,
                                          SALIDAGEN,
                                          XMLGEN,
                                          PROCESOGEN);
  
    IF PROCESOGEN.P_CODERROR != SIM_PCK_TIPOS_GENERALES.C_CERO THEN
      L_ERROR := SIM_TYP_ERROR(PROCESOGEN.P_CODERROR,
                               PROCESOGEN.P_MSGERROR,
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    ELSE
      IF PROCESOGEN.P_NUMREG = SIM_PCK_TIPOS_GENERALES.C_CERO THEN
        L_ERROR := SIM_TYP_ERROR(-20002,
                                 'No Hay Datos para Sistema Origen',
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
      END IF;
    END IF;
  END PROC_SISTEMA_ORIGEN;

  /*---------------------------------------------------*/
  PROCEDURE PROC_RECUPERA_SUMAASEGVEH(IP_MARCA          IN NUMBER,
                                      IP_MODELO         IN NUMBER,
                                      OP_PORCMAXIMO     OUT NUMBER,
                                      OP_PORCMINIMO     OUT NUMBER,
                                      OP_SUMAASEGRIESGO OUT NUMBER,
                                      OP_SUMA0KM        OUT NUMBER,
                                      IP_VALIDACION     IN VARCHAR2,
                                      IP_ARRCONTEXTO    IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                      OP_ARRCONTEXTO    OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                      IP_PROCESO        IN SIM_TYP_PROCESO,
                                      OP_RESULTADO      OUT NUMBER,
                                      OP_ARRERRORES     OUT SIM_TYP_ARRAY_ERROR) IS
    L_ERROR       SIM_TYP_ERROR;
    V_FECHA       SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    PGEN          SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN     SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN    SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN        SIM_PCK_TIPOS_GENERALES.T_CLOB;
    L_NUMEND      NUMBER;
    L_NUMSECUPOL  NUMBER;
    L_CODRIES     NUMBER;
    L_CODEND      NUMBER;
    L_SUBCODEND   NUMBER;
    L_CAMBIODATOS VARCHAR2(1);
  BEGIN
    G_SUBPROGRAMA := '.Proc_Recupera_SumaAsegVeh ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
  
    BEGIN
      L_NUMEND := SIM_PCK_REGLAS.G_PARAMETROS('B99_NUMEND');
    EXCEPTION
      WHEN OTHERS THEN
        L_NUMEND := 0;
    END;
  
    BEGIN
      L_NUMSECUPOL := SIM_PCK_REGLAS.G_PARAMETROS('B99_NUMSECUPOL');
    EXCEPTION
      WHEN OTHERS THEN
        L_NUMSECUPOL := 0;
    END;
  
    BEGIN
      L_CODRIES := SIM_PCK_REGLAS.G_PARAMETROS('B99_CODRIES');
    EXCEPTION
      WHEN OTHERS THEN
        L_CODRIES := 0;
    END;
  
    BEGIN
      V_FECHA := NULL;
    
      SELECT TO_CHAR(FECHA_VIG_POL, 'DD-Mon-YYYY'), COD_END, SUB_COD_END
        INTO V_FECHA, L_CODEND, L_SUBCODEND
        FROM X2000030
       WHERE NUM_SECU_POL = L_NUMSECUPOL;
    
      --2020-04-03 Sheila Uhia
      --Optimización 520 - Endosos de Modificación Masiva
      --Se agrega a l_Subcodend el 2 para los l_Codend = 506 y 711
      IF L_NUMEND > 0 THEN
        IF (L_CODEND = 506 AND L_SUBCODEND IN (0, 1, 2)) OR
           (L_CODEND = 703 AND L_SUBCODEND IN (0, 1)) OR
           (L_CODEND = 711 AND L_SUBCODEND IN (0, 1, 2)) OR
           (L_CODEND = 730 AND L_SUBCODEND IN (0, 1)) THEN
          L_CAMBIODATOS := 'S';
        ELSE
          SIM_PCK_CONTEXTO_EMISION.PROC_CAMBIODATOS_DELAUTO(L_NUMSECUPOL,
                                                            L_CODRIES,
                                                            IP_MODELO,
                                                            IP_MARCA,
                                                            L_CAMBIODATOS);
        END IF;
      
        IF L_CAMBIODATOS = 'N' THEN
          SELECT TO_CHAR(X.FECHA_VIG_END, 'DD-Mon-YYYY')
            INTO V_FECHA
            FROM A2000030 X
           WHERE X.NUM_SECU_POL = L_NUMSECUPOL
             AND X.NUM_END =
                 (SELECT MIN(Z.NUM_END)
                    FROM A2040100 Z
                   WHERE Z.NUM_SECU_POL = X.NUM_SECU_POL
                     AND Z.COD_RIES = L_CODRIES
                     AND (Z.COD_MARCA, Z.COD_MOD) IN
                         (SELECT T.COD_MARCA, T.COD_MOD
                            FROM X2040100 T
                           WHERE T.NUM_SECU_POL = Z.NUM_SECU_POL
                             AND T.COD_RIES = Z.COD_RIES));
          --         --sim_proc_log('RPR fecha recupera','nsp y Riesgo '||l_NumSecupol||'-'|| l_codRies);
        ELSE
          SELECT TO_CHAR(FECHA_VIG_END, 'DD-Mon-YYYY')
            INTO V_FECHA
            FROM X2000030
           WHERE NUM_SECU_POL = L_NUMSECUPOL;
        END IF;
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
  
    V_FECHA := NVL(V_FECHA, TO_CHAR(SYSDATE, 'DD-MON-YYYY'));
    --   sim_proc_log('RPR proceso fecha recupera suma ',v_fecha);
    /*
    BEGIN
      IF v_NumEnd = 0 THEN
         V_Fecha       := SIM_PCK_REGLAS.g_parametros('B99_FECHAVIGMOV');
      ELSE
         V_Fecha       := SIM_PCK_REGLAS.g_parametros('B1_FECHA_VIG_END');
      END IF;
    EXCEPTION WHEN OTHERS THEN
      V_Fecha := to_char(SYSDATE,'DD-MON-YYYY');
    END;
    */
    PGEN := SIM_PCK_TIPOS_GENERALES.T_PARAMETRO(NULL);
    SALIDAGEN := SIM_PCK_TIPOS_GENERALES.T_SALIDA(NULL);
    PROCESOGEN := NULL;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_COMPANIA';
    PGEN(PGEN.COUNT).OP_VALOR := IP_PROCESO.P_COD_CIA;
    PGEN.EXTEND;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_MARCA';
    PGEN(PGEN.COUNT).OP_VALOR := IP_MARCA;
    PGEN.EXTEND;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_MODELO';
    PGEN(PGEN.COUNT).OP_VALOR := IP_MODELO;
    PGEN.EXTEND;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_FECHAVIGMOV';
    PGEN(PGEN.COUNT).OP_VALOR := V_FECHA;
    PGEN.EXTEND;
    PROCESOGEN.P_TIPOPROCESO  := SIM_PCK_TIPOS_GENERALES.C_LISTA;
    PROCESOGEN.P_TIPORECUPERO := NULL;
    SIM_PCK_LISTAS_EMISION.MODELO_MARCA(PGEN,
                                        SALIDAGEN,
                                        XMLGEN,
                                        PROCESOGEN);
  
    IF PROCESOGEN.P_CODERROR != SIM_PCK_TIPOS_GENERALES.C_CERO THEN
      L_ERROR := SIM_TYP_ERROR(PROCESOGEN.P_CODERROR,
                               PROCESOGEN.P_MSGERROR,
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    ELSE
      IF PROCESOGEN.P_NUMREG = 0 THEN
        L_ERROR := SIM_TYP_ERROR(-20005,
                                 'No existen Sumas para Marca :' || IP_MARCA ||
                                 ' Modelo :' || IP_MODELO,
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
      ELSE
        IF SALIDAGEN.COUNT > 1 THEN
          L_ERROR := SIM_TYP_ERROR(-20005,
                                   'Marca :' || IP_MARCA || ' Modelo :' ||
                                   IP_MODELO ||
                                   ' con mas de un registro asociado en tabla fasecolda',
                                   'E');
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          OP_RESULTADO := -1;
        ELSE
          FOR I IN SALIDAGEN.FIRST .. SALIDAGEN.LAST LOOP
            OP_PORCMAXIMO     := SALIDAGEN(I).P_DESCRIPCION;
            OP_PORCMINIMO     := OP_PORCMAXIMO * -1;
            OP_SUMAASEGRIESGO := SALIDAGEN(I).P_CODIGO3;
            OP_SUMA0KM        := SALIDAGEN(I).P_CODIGO4;
          END LOOP;
        END IF;
      END IF;
    END IF;
  
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_VLR_FASECOLDA',
                                        OP_SUMAASEGRIESGO);
  
    /* Se quita porque la interfaz solo cambia respeta el valor de la x2040100
      seimpere que no hayan cambiado marca o modelo
    l_NumSecupol   := SIM_PCK_REGLAS.g_parametros('B99_NUMSECUPOL');
    l_NumEnd       := SIM_PCK_REGLAS.g_parametros('B99_NUMEND');
    l_CodRies      := SIM_PCK_REGLAS.g_parametros('B99_CODRIES');
    l_CodEnd       := SIM_PCK_REGLAS.g_parametros('B1_COD_END');
    l_SubCodEnd    := SIM_PCK_REGLAS.g_parametros('B1_SUB_COD_END');
    IF l_Numend > 0 THEN
       proc_Cambiodatos_delAuto (l_NumSecupol, l_CodRies, l_cambio);
       IF l_Cambio = 'N' AND l_codEnd != 711 AND l_Subcodend != 0 THEN
          select suma_aseg into Op_SumaAsegRiesgo
           from x2040100
          where num_secu_pol = l_Numsecupol and cod_ries = l_codries;
       END IF;
      EXCEPTION WHEN no_data_found THEN NULL;
      END;
    END IF;
    */
    --   sim_proc_log('RPR cambio Suma ? ',Op_SumaAsegRiesgo);
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Error en Proc_Recupera_SumaAsegVeh - ' ||
                                                          SQLERRM,
                                                          'E');
  END PROC_RECUPERA_SUMAASEGVEH;

  /*--------------------------------------------*/
  PROCEDURE PROC_RECUPERA_SUMAACCESVEH(IP_ACCESORIO       IN NUMBER,
                                       OP_PORCMAXIMO      OUT NUMBER,
                                       OP_PORCMAXESPECIAL OUT NUMBER,
                                       OP_SUMAACCESORIO   OUT NUMBER,
                                       IP_VALIDACION      IN VARCHAR2,
                                       IP_ARRCONTEXTO     IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                       OP_ARRCONTEXTO     OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                       IP_PROCESO         IN SIM_TYP_PROCESO,
                                       OP_RESULTADO       OUT NUMBER,
                                       OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_ERROR    SIM_TYP_ERROR;
    V_FECHA    SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    PGEN       SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN  SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN     SIM_PCK_TIPOS_GENERALES.T_CLOB;
    V_PORCMAX  NUMBER;
    V_TIPO     NUMBER;
  BEGIN
    G_SUBPROGRAMA := '.Proc_Recupera_SumaACcesVeh ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
  
    V_FECHA := SIM_PCK_REGLAS.G_PARAMETROS('B99_FECHAVIGMOV');
  
    PGEN := SIM_PCK_TIPOS_GENERALES.T_PARAMETRO(NULL);
    SALIDAGEN := SIM_PCK_TIPOS_GENERALES.T_SALIDA(NULL);
    PROCESOGEN := NULL;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_COMPANIA';
    PGEN(PGEN.COUNT).OP_VALOR := IP_PROCESO.P_COD_CIA;
    PGEN.EXTEND;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_ACCESORIO';
    PGEN(PGEN.COUNT).OP_VALOR := IP_ACCESORIO;
    PGEN.EXTEND;
    PGEN(PGEN.COUNT).IP_CAMPO := 'ID_FECHAVIGMOV';
    PGEN(PGEN.COUNT).OP_VALOR := V_FECHA;
    PGEN.EXTEND;
  
    PROCESOGEN.P_TIPOPROCESO  := SIM_PCK_TIPOS_GENERALES.C_LISTA;
    PROCESOGEN.P_TIPORECUPERO := NULL;
    SIM_PCK_LISTAS_EMISION2.VLR_ACCESORIOS_VEH(PGEN,
                                               SALIDAGEN,
                                               XMLGEN,
                                               PROCESOGEN);
  
    IF PROCESOGEN.P_CODERROR != SIM_PCK_TIPOS_GENERALES.C_CERO THEN
      L_ERROR := SIM_TYP_ERROR(PROCESOGEN.P_CODERROR,
                               PROCESOGEN.P_MSGERROR,
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    ELSE
      IF PROCESOGEN.P_NUMREG = 0 THEN
        OP_SUMAACCESORIO := 0;
        SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B45_VALOR_ACCES',
                                            OP_SUMAACCESORIO);
        SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B45_COD_ACCES', IP_ACCESORIO);
        SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTCODMONACC', 1);
        L_ERROR := SIM_TYP_ERROR(-20005,
                                 'No existen Sumas para Accesorio :' ||
                                 IP_ACCESORIO,
                                 'W');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := 1;
      ELSE
        IF SALIDAGEN.COUNT > 1 THEN
          L_ERROR := SIM_TYP_ERROR(-20005,
                                   'Accesorio :' || IP_ACCESORIO ||
                                   ' con mas de un registro asociado en Tabla Valores Accesorio',
                                   'E');
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          OP_RESULTADO := -1;
        ELSE
          FOR I IN SALIDAGEN.FIRST .. SALIDAGEN.LAST LOOP
            OP_SUMAACCESORIO := SALIDAGEN(I).P_CODIGO4;
            SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B45_VALOR_ACCES',
                                                OP_SUMAACCESORIO);
            SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B45_COD_ACCES',
                                                IP_ACCESORIO);
            SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTCODMONACC',
                                                SALIDAGEN(I).P_CODIGO3);
          END LOOP;
        
          BEGIN
            SIM_PCK_LISTAS_EMISION.ACCESORIOS_VEH(PGEN,
                                                  SALIDAGEN,
                                                  XMLGEN,
                                                  PROCESOGEN);
          END;
        
          IF PROCESOGEN.P_CODERROR != SIM_PCK_TIPOS_GENERALES.C_CERO THEN
            L_ERROR := SIM_TYP_ERROR(PROCESOGEN.P_CODERROR,
                                     PROCESOGEN.P_MSGERROR,
                                     'E');
            OP_ARRERRORES.EXTEND;
            OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
            OP_RESULTADO := -1;
          ELSE
            IF PROCESOGEN.P_NUMREG = 0 THEN
              L_ERROR := SIM_TYP_ERROR(-20005,
                                       'No existe Codigo de Accesorio :' ||
                                       IP_ACCESORIO,
                                       'E');
              OP_ARRERRORES.EXTEND;
              OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
              OP_RESULTADO := -1;
            ELSE
              IF SALIDAGEN.COUNT > 1 THEN
                L_ERROR := SIM_TYP_ERROR(-20005,
                                         'Accesorio :' || IP_ACCESORIO ||
                                         ' con mas de un registro asociado Accesorio de Vehiculos',
                                         'E');
                OP_ARRERRORES.EXTEND;
                OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                OP_RESULTADO := -1;
              ELSE
                FOR I IN SALIDAGEN.FIRST .. SALIDAGEN.LAST LOOP
                  V_TIPO := SALIDAGEN(I).P_CODIGO3;
                
                  BEGIN
                    SELECT CODIGO2
                      INTO V_PORCMAX
                      FROM C9999909
                     WHERE COD_TAB = 'PARAM_AUTOS'
                       AND CODIGO1 = V_TIPO
                       AND FECHA_BAJA IS NULL;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_ERROR := SIM_TYP_ERROR(SQLCODE,
                                               'Error: Recuperando Tipo ' ||
                                               SQLERRM,
                                               'E');
                      OP_ARRERRORES.EXTEND;
                      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                      OP_RESULTADO := -1;
                  END;
                
                  IF V_TIPO = 1 THEN
                    OP_PORCMAXIMO := V_PORCMAX;
                  ELSE
                    OP_PORCMAXESPECIAL := V_PORCMAX;
                  END IF;
                END LOOP;
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Error en Proc_Recupera_SumaAccesVeh - ' ||
                                                          SQLERRM,
                                                          'E');
  END PROC_RECUPERA_SUMAACCESVEH;

  /*--------------------------------------------*/
  PROCEDURE PROC_VISUALIZA_COB_AGR(OP_VISUALIZA_COB OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_AGR OUT VARCHAR2,
                                   IP_VALIDACION    IN VARCHAR2,
                                   IP_ARRCONTEXTO   IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   OP_ARRCONTEXTO   OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   IP_PROCESO       IN SIM_TYP_PROCESO,
                                   OP_RESULTADO     OUT NUMBER,
                                   OP_ARRERRORES    OUT SIM_TYP_ARRAY_ERROR) IS
    L_ERROR           SIM_TYP_ERROR;
    P_B99_CODBENEF    A2000030.NRO_DOCUMTO%TYPE;
    P_B99_TDOCTERCERO A2000030.TDOC_TERCERO%TYPE;
    PGEN              SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN         SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN        SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN            SIM_PCK_TIPOS_GENERALES.T_CLOB;
    L_EXISTE          NUMBER := 0;
    L_TIPOUSUARIO     SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_RESULTADO       NUMBER;
    L_ARRERRORES      SIM_TYP_ARRAY_ERROR;
    L_CODPROD         NUMBER;
  BEGIN
    G_SUBPROGRAMA := '.Proc_Visualiza_Coberturas_Agravantes ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
  
    BEGIN
      P_B99_CODBENEF    := SIM_PCK_REGLAS.G_PARAMETROS('B1_NRO_DOCUMTO');
      P_B99_TDOCTERCERO := SIM_PCK_REGLAS.G_PARAMETROS('B1_TDOC_TERCERO');
      L_CODPROD         := SIM_PCK_REGLAS.G_PARAMETROS('B1_COD_PROD');
    EXCEPTION
      WHEN OTHERS THEN
        L_ERROR := SIM_TYP_ERROR(SQLCODE,
                                 G_SUBPROGRAMA ||
                                 ' variable contexto B1_COD_PROD',
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
    END;
  
    IF OP_RESULTADO = 0 THEN
      OP_VISUALIZA_COB := 'S';
      OP_VISUALIZA_AGR := 'N';
    
      L_EXISTE := 0;
    
      BEGIN
        SIM_PCK_SEGURIDAD.PROC_VALIDATIPOUSUARIO(L_CODPROD,
                                                 'N',
                                                 IP_PROCESO,
                                                 L_TIPOUSUARIO,
                                                 L_RESULTADO,
                                                 L_ARRERRORES);
      EXCEPTION
        WHEN OTHERS THEN
          L_TIPOUSUARIO := 'E';
      END;
    
      --sim_proc_log('Test prueba ',l_TipoUsuario||'-'||Ip_proceso.p_cod_usr||'-'||Ip_proceso.p_info3);
      IF L_TIPOUSUARIO != 'A' THEN
        BEGIN
          SELECT COUNT(1)
            INTO L_EXISTE
            FROM A1002101 D
           WHERE D.COD_CIA = IP_PROCESO.P_COD_CIA
             AND D.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO;
        END;
      
        IF L_EXISTE > 0 THEN
          OP_VISUALIZA_AGR := 'S';
        END IF;
      
        /*      WHERE  a.compania                                        = Ip_proceso.p_cod_cia
              AND    a.seccion                                         = Ip_Proceso.p_cod_secc
              AND    nvl(a.cod_producto,Ip_proceso.p_cod_producto)     = Ip_proceso.p_cod_producto
              AND    a.cod_subproducto                                 = nvl(Ip_proceso.p_Subproducto,a.cod_subproducto)
              AND    nvl(a.sistema_origen,Ip_proceso.p_sistema_origen) = Ip_proceso.p_sistema_origen
              AND    nvl(a.canal,Ip_proceso.p_canal)                   = Ip_proceso.p_canal
              AND    nvl(a.tipo_negocio,Ip_proceso.p_modulo)           = Ip_proceso.p_modulo
              AND    nvl(a.numero_documento,P_B99_CODDOCUM)            = P_B99_CODDOCUM
              AND    nvl(a.tipo_documento,P_B99_TDOCTERCERO)           = P_B99_TDOCTERCERO
              AND    nvl(a.usuario_negocio,Ip_proceso.p_cod_usr)       = Ip_proceso.p_cod_usr;
        */
      
        BEGIN
          SELECT A.VISUALIZA_COBERTURA, A.VISUALIZA_AGRAVANTE
            INTO OP_VISUALIZA_COB, OP_VISUALIZA_AGR
            FROM SIM_PRIVILEGIOS_POLIZAS A
           WHERE A.COMPANIA = IP_PROCESO.P_COD_CIA
             AND A.SECCION = IP_PROCESO.P_COD_SECC
             AND NVL(A.COD_PRODUCTO, -1) =
                 NVL(IP_PROCESO.P_COD_PRODUCTO, -1)
             AND NVL(A.COD_SUBPRODUCTO, -1) =
                 NVL(IP_PROCESO.P_SUBPRODUCTO, -1)
             AND NVL(A.TIPO_DOCUMENTO, 'XX') = NVL(P_B99_TDOCTERCERO, 'XX')
             AND NVL(A.NUMERO_DOCUMENTO, -1) = NVL(P_B99_CODBENEF, -1)
             AND NVL(NVL(A.USUARIO_NEGOCIO, IP_PROCESO.P_COD_USR), 'XX') =
                 NVL(IP_PROCESO.P_COD_USR, 'XX')
             AND NVL(NVL(A.SISTEMA_ORIGEN, IP_PROCESO.P_SISTEMA_ORIGEN), -1) =
                 NVL(IP_PROCESO.P_SISTEMA_ORIGEN, -1)
             AND NVL(NVL(A.CANAL, IP_PROCESO.P_CANAL), -1) =
                 NVL(IP_PROCESO.P_CANAL, -1)
             AND NVL(NVL(A.TIPO_NEGOCIO, IP_PROCESO.P_MODULO), -1) =
                 NVL(IP_PROCESO.P_MODULO, -1);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
        END;
      END IF;
    END IF;
  
    --  sim_proc_log('Test prueba visualiza agravante ',Op_Visualiza_Agr);
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Error en Proc_Recupera_SumaAccesVeh - ' ||
                                                          SQLERRM,
                                                          'E');
  END PROC_VISUALIZA_COB_AGR;

  /*--------------------------------------------*/
  PROCEDURE PROC_VISUALIZA_DET_COB(OP_VISUALIZA_SUMA_ASEG  OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_TASA       OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_TASA_TOTAL OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_PRIMA      OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_VISUALIZA_FECHAS_VIG OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_SUMA_ASEG   OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_TASA        OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_TASA_TOTAL  OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_PRIMA       OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   OP_MODIFICA_FECHAS_VIG  OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION           IN VARCHAR2,
                                   IP_ARRCONTEXTO          IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   OP_ARRCONTEXTO          OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                   IP_PROCESO              IN SIM_TYP_PROCESO,
                                   OP_RESULTADO            OUT NUMBER,
                                   OP_ARRERRORES           OUT SIM_TYP_ARRAY_ERROR) IS
    L_ERROR SIM_TYP_ERROR;
  
    P_B99_CODBENEF    A2000030.NRO_DOCUMTO%TYPE;
    P_B99_TDOCTERCERO A2000030.TDOC_TERCERO%TYPE;
    PGEN              SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN         SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN        SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN            SIM_PCK_TIPOS_GENERALES.T_CLOB;
    L_ESPPAL          SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_TIPOUSR         SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_CODPROD         NUMBER;
  
    CURSOR DATOS IS
      SELECT B.VISUALIZA_SUMA_ASEG,
             B.VISUALIZA_TASA,
             B.VISUALIZA_PRIMA,
             B.VISUALIZA_FECHAS_VIG,
             B.MODIFICA_SUMA_ASEG,
             B.MODIFICA_TASA,
             B.MODIFICA_PRIMA,
             B.MODIFICA_FECHAS_VIG
        FROM SIM_PRIVILEGIOS_POLIZAS A, SIM_PRIVILEGIOS_COBERTURAS B
       WHERE A.COMPANIA = IP_PROCESO.P_COD_CIA
         AND A.SECCION = IP_PROCESO.P_COD_SECC
         AND NVL(A.COD_PRODUCTO, -1) = NVL(IP_PROCESO.P_COD_PRODUCTO, -1)
         AND NVL(A.COD_SUBPRODUCTO, -1) = NVL(IP_PROCESO.P_SUBPRODUCTO, -1)
         AND NVL(A.TIPO_DOCUMENTO, 'XX') IN
             (NVL(P_B99_TDOCTERCERO, 'XX'), 'XX')
         AND NVL(A.NUMERO_DOCUMENTO, -1) IN (NVL(P_B99_CODBENEF, -1), -1)
         AND NVL(NVL(A.USUARIO_NEGOCIO, IP_PROCESO.P_COD_USR), 'XX') =
             NVL(IP_PROCESO.P_COD_USR, 'XX')
         AND NVL(NVL(A.SISTEMA_ORIGEN, IP_PROCESO.P_SISTEMA_ORIGEN), -1) =
             NVL(IP_PROCESO.P_SISTEMA_ORIGEN, -1)
         AND NVL(NVL(A.CANAL, IP_PROCESO.P_CANAL), -1) =
             NVL(IP_PROCESO.P_CANAL, -1)
         AND NVL(NVL(A.TIPO_NEGOCIO, IP_PROCESO.P_MODULO), -1) =
             NVL(IP_PROCESO.P_MODULO, -1)
         AND A.SEC_PRIVILEGIO_POLIZA = B.SEC_PRIVILEGIO_POLIZA
       ORDER BY NVL(A.NUMERO_DOCUMENTO, 0) DESC;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_Visualiza_Det_Cob ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
  
    P_B99_CODBENEF          := SIM_PCK_REGLAS.G_PARAMETROS('B1_NRO_DOCUMTO'); -- wesv -- 20120530 Estaban como b99.coddocum
    P_B99_TDOCTERCERO       := SIM_PCK_REGLAS.G_PARAMETROS('B1_TDOC_TERCERO'); --wesv -- 20120530  y b99_tdoctercero
    L_CODPROD               := SIM_PCK_REGLAS.G_PARAMETROS('B1_COD_PROD');
    OP_VISUALIZA_SUMA_ASEG  := 'S';
    OP_VISUALIZA_TASA       := 'S';
    OP_VISUALIZA_TASA_TOTAL := 'S';
    OP_VISUALIZA_PRIMA      := 'S';
    OP_VISUALIZA_FECHAS_VIG := 'N';
    OP_MODIFICA_SUMA_ASEG   := 'S';
    OP_MODIFICA_TASA        := 'S';
    OP_MODIFICA_TASA_TOTAL  := 'S';
    OP_MODIFICA_PRIMA       := 'S';
    OP_MODIFICA_FECHAS_VIG  := 'N';
  
    BEGIN
      FOR B IN DATOS LOOP
        OP_VISUALIZA_SUMA_ASEG  := B.VISUALIZA_SUMA_ASEG;
        OP_VISUALIZA_TASA       := B.VISUALIZA_TASA;
        OP_VISUALIZA_PRIMA      := B.VISUALIZA_PRIMA;
        OP_VISUALIZA_FECHAS_VIG := B.VISUALIZA_FECHAS_VIG;
        OP_MODIFICA_SUMA_ASEG   := B.MODIFICA_SUMA_ASEG;
        OP_MODIFICA_TASA        := B.MODIFICA_TASA;
        OP_MODIFICA_PRIMA       := B.MODIFICA_PRIMA;
        OP_MODIFICA_FECHAS_VIG  := B.MODIFICA_FECHAS_VIG;
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        L_ERROR := SIM_TYP_ERROR(SQLCODE,
                                 G_SUBPROGRAMA || '.Msg:' || SQLERRM,
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
    END;
  
    L_ESPPAL := SIM_PCK_CONSULTA_EMISION.FUN_ESPRINCIPAL(IP_PROCESO.P_PROCESO,
                                                         IP_PROCESO.P_SUBPROCESO,
                                                         IP_PROCESO.P_MODULO);
  
    IF L_ESPPAL = 'N' THEN
      OP_VISUALIZA_FECHAS_VIG := SIM_PCK_TIPOS_GENERALES.C_NO;
      OP_MODIFICA_FECHAS_VIG  := SIM_PCK_TIPOS_GENERALES.C_NO;
    END IF;
  
    SIM_PCK_SEGURIDAD.PROC_VALIDATIPOUSUARIO(L_CODPROD,
                                             'S',
                                             IP_PROCESO,
                                             L_TIPOUSR,
                                             OP_RESULTADO,
                                             OP_ARRERRORES);
  
    IF L_TIPOUSR = 'A' THEN
      OP_VISUALIZA_SUMA_ASEG  := 'N';
      OP_VISUALIZA_TASA       := 'N';
      OP_VISUALIZA_PRIMA      := 'N';
      OP_VISUALIZA_FECHAS_VIG := 'N';
      OP_MODIFICA_SUMA_ASEG   := 'N';
      OP_MODIFICA_TASA        := 'N';
      OP_MODIFICA_PRIMA       := 'N';
      OP_MODIFICA_FECHAS_VIG  := 'N';
      OP_VISUALIZA_TASA_TOTAL := 'N';
      OP_MODIFICA_TASA_TOTAL  := 'N';
    END IF;
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Error en Proc_Visualiza_Det_Cob - ' ||
                                                          SQLERRM,
                                                          'E');
  END PROC_VISUALIZA_DET_COB;

  /*--------------------------------------------*/

  /*--------------------------------------------*/
  PROCEDURE PROC_VISUALIZA_DET_COB1(OP_VISUALIZA_SUMA_ASEG     OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_TASA          OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_TASA_TOTAL    OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_PRIMA         OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_FECHAS_VIG    OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_INDICEVAR     OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_MCA_GRATUITA  OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_DATOS_ADICION OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_NOMINAS       OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_VISUALIZA_DEDUCIBLES    OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_SUMA_ASEG      OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_TASA           OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_TASA_TOTAL     OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_PRIMA          OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_FECHAS_VIG     OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_INDICEVAR      OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_MCA_GRATUITA   OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_DATOS_ADICION  OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_NOMINAS        OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    OP_MODIFICA_DEDUCIBLES     OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                    IP_VALIDACION              IN VARCHAR2,
                                    IP_ARRCONTEXTO             IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO             OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO                 IN SIM_TYP_PROCESO,
                                    OP_RESULTADO               OUT NUMBER,
                                    OP_ARRERRORES              OUT SIM_TYP_ARRAY_ERROR) IS
    L_ERROR SIM_TYP_ERROR;
  
    P_B99_CODBENEF    A2000030.NRO_DOCUMTO%TYPE;
    P_B99_TDOCTERCERO A2000030.TDOC_TERCERO%TYPE;
    PGEN              SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN         SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN        SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN            SIM_PCK_TIPOS_GENERALES.T_CLOB;
    L_ESPPAL          SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_TIPOUSR         SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_CODPROD         NUMBER;
  
    CURSOR DATOS IS
      SELECT B.VISUALIZA_SUMA_ASEG,
             B.VISUALIZA_TASA,
             B.VISUALIZA_PRIMA,
             B.VISUALIZA_FECHAS_VIG,
             B.VISUALIZA_INDICEVAR,
             B.VISUALIZA_MCA_GRATUITA,
             B.VISUALIZA_DATOS_ADICION,
             B.VISUALIZA_NOMINAS,
             B.VISUALIZA_DEDUCIBLES,
             B.MODIFICA_SUMA_ASEG,
             B.MODIFICA_TASA,
             B.MODIFICA_PRIMA,
             B.MODIFICA_FECHAS_VIG,
             B.MODIFICA_INDICEVAR,
             B.MODIFICA_MCA_GRATUITA,
             B.MODIFICA_DATOS_ADICION,
             B.MODIFICA_NOMINAS,
             B.MODIFICA_DEDUCIBLES
        FROM SIM_PRIVILEGIOS_POLIZAS A, SIM_PRIVILEGIOS_COBERTURAS B
       WHERE A.COMPANIA = IP_PROCESO.P_COD_CIA
         AND A.SECCION = IP_PROCESO.P_COD_SECC
         AND NVL(A.COD_PRODUCTO, -1) = NVL(IP_PROCESO.P_COD_PRODUCTO, -1)
         AND NVL(A.COD_SUBPRODUCTO, -1) = NVL(IP_PROCESO.P_SUBPRODUCTO, -1)
         AND NVL(A.TIPO_DOCUMENTO, 'XX') IN
             (NVL(P_B99_TDOCTERCERO, 'XX'), 'XX')
         AND NVL(A.NUMERO_DOCUMENTO, -1) IN (NVL(P_B99_CODBENEF, -1), -1)
         AND NVL(NVL(A.USUARIO_NEGOCIO, IP_PROCESO.P_COD_USR), 'XX') =
             NVL(IP_PROCESO.P_COD_USR, 'XX')
         AND NVL(NVL(A.SISTEMA_ORIGEN, IP_PROCESO.P_SISTEMA_ORIGEN), -1) =
             NVL(IP_PROCESO.P_SISTEMA_ORIGEN, -1)
         AND NVL(NVL(A.CANAL, IP_PROCESO.P_CANAL), -1) =
             NVL(IP_PROCESO.P_CANAL, -1)
         AND NVL(NVL(A.TIPO_NEGOCIO, IP_PROCESO.P_MODULO), -1) =
             NVL(IP_PROCESO.P_MODULO, -1)
         AND A.SEC_PRIVILEGIO_POLIZA = B.SEC_PRIVILEGIO_POLIZA
       ORDER BY NVL(A.NUMERO_DOCUMENTO, 0) DESC;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_Visualiza_Det_Cob ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
  
    P_B99_CODBENEF             := SIM_PCK_REGLAS.G_PARAMETROS('B1_NRO_DOCUMTO'); -- wesv -- 20120530 Estaban como b99.coddocum
    P_B99_TDOCTERCERO          := SIM_PCK_REGLAS.G_PARAMETROS('B1_TDOC_TERCERO'); --wesv -- 20120530  y b99_tdoctercero
    L_CODPROD                  := SIM_PCK_REGLAS.G_PARAMETROS('B1_COD_PROD');
    OP_VISUALIZA_SUMA_ASEG     := 'S';
    OP_VISUALIZA_TASA          := 'S';
    OP_VISUALIZA_TASA_TOTAL    := 'S';
    OP_VISUALIZA_PRIMA         := 'S';
    OP_VISUALIZA_FECHAS_VIG    := 'N';
    OP_VISUALIZA_INDICEVAR     := 'S';
    OP_MODIFICA_SUMA_ASEG      := 'S';
    OP_MODIFICA_TASA           := 'S';
    OP_MODIFICA_TASA_TOTAL     := 'S';
    OP_MODIFICA_PRIMA          := 'S';
    OP_MODIFICA_FECHAS_VIG     := 'N';
    OP_MODIFICA_INDICEVAR      := 'S';
    OP_VISUALIZA_MCA_GRATUITA  := 'S';
    OP_VISUALIZA_DATOS_ADICION := 'S';
    OP_VISUALIZA_NOMINAS       := 'S';
    OP_VISUALIZA_DEDUCIBLES    := 'S';
    OP_MODIFICA_MCA_GRATUITA   := 'S';
    OP_MODIFICA_DATOS_ADICION  := 'S';
    OP_MODIFICA_NOMINAS        := 'S';
    OP_MODIFICA_DEDUCIBLES     := 'S';
  
    BEGIN
      FOR B IN DATOS LOOP
        OP_VISUALIZA_SUMA_ASEG     := B.VISUALIZA_SUMA_ASEG;
        OP_VISUALIZA_TASA          := B.VISUALIZA_TASA;
        OP_VISUALIZA_PRIMA         := B.VISUALIZA_PRIMA;
        OP_VISUALIZA_FECHAS_VIG    := B.VISUALIZA_FECHAS_VIG;
        OP_VISUALIZA_INDICEVAR     := B.VISUALIZA_INDICEVAR;
        OP_MODIFICA_SUMA_ASEG      := B.MODIFICA_SUMA_ASEG;
        OP_MODIFICA_TASA           := B.MODIFICA_TASA;
        OP_MODIFICA_PRIMA          := B.MODIFICA_PRIMA;
        OP_MODIFICA_FECHAS_VIG     := B.MODIFICA_FECHAS_VIG;
        OP_MODIFICA_INDICEVAR      := B.MODIFICA_INDICEVAR;
        OP_VISUALIZA_MCA_GRATUITA  := B.VISUALIZA_MCA_GRATUITA;
        OP_VISUALIZA_DATOS_ADICION := B.VISUALIZA_DATOS_ADICION;
        OP_VISUALIZA_NOMINAS       := B.VISUALIZA_NOMINAS;
        OP_VISUALIZA_DEDUCIBLES    := B.VISUALIZA_DEDUCIBLES;
        OP_MODIFICA_MCA_GRATUITA   := B.MODIFICA_MCA_GRATUITA;
        OP_MODIFICA_DATOS_ADICION  := B.MODIFICA_DATOS_ADICION;
        OP_MODIFICA_NOMINAS        := B.MODIFICA_NOMINAS;
        OP_MODIFICA_DEDUCIBLES     := B.MODIFICA_DEDUCIBLES;
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        L_ERROR := SIM_TYP_ERROR(SQLCODE,
                                 G_SUBPROGRAMA || '.Msg:' || SQLERRM,
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
    END;
  
    L_ESPPAL := SIM_PCK_CONSULTA_EMISION.FUN_ESPRINCIPAL(IP_PROCESO.P_PROCESO,
                                                         IP_PROCESO.P_SUBPROCESO,
                                                         IP_PROCESO.P_MODULO);
  
    IF L_ESPPAL = 'N' THEN
      OP_VISUALIZA_FECHAS_VIG := SIM_PCK_TIPOS_GENERALES.C_NO;
      OP_MODIFICA_FECHAS_VIG  := SIM_PCK_TIPOS_GENERALES.C_NO;
    END IF;
  
    SIM_PCK_SEGURIDAD.PROC_VALIDATIPOUSUARIO(L_CODPROD,
                                             'S',
                                             IP_PROCESO,
                                             L_TIPOUSR,
                                             OP_RESULTADO,
                                             OP_ARRERRORES);
  
    IF L_TIPOUSR = 'A' THEN
      OP_VISUALIZA_SUMA_ASEG     := 'S';
      OP_VISUALIZA_TASA          := 'S';
      OP_VISUALIZA_PRIMA         := 'S';
      OP_VISUALIZA_FECHAS_VIG    := 'N';
      OP_VISUALIZA_INDICEVAR     := 'N';
      OP_MODIFICA_SUMA_ASEG      := 'N';
      OP_MODIFICA_TASA           := 'N';
      OP_MODIFICA_PRIMA          := 'N';
      OP_MODIFICA_FECHAS_VIG     := 'N';
      OP_VISUALIZA_TASA_TOTAL    := 'N';
      OP_MODIFICA_TASA_TOTAL     := 'N';
      OP_MODIFICA_INDICEVAR      := 'N';
      OP_VISUALIZA_MCA_GRATUITA  := 'N';
      OP_VISUALIZA_DATOS_ADICION := 'N';
      OP_VISUALIZA_NOMINAS       := 'N';
      OP_VISUALIZA_DEDUCIBLES    := 'N';
      OP_MODIFICA_MCA_GRATUITA   := 'N';
      OP_MODIFICA_DATOS_ADICION  := 'N';
      OP_MODIFICA_NOMINAS        := 'N';
      OP_MODIFICA_DEDUCIBLES     := 'N';
    END IF;
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Error en Proc_Visualiza_Det_Cob - ' ||
                                                          SQLERRM,
                                                          'E');
  END PROC_VISUALIZA_DET_COB1;

  /*--------------------------------------------*/

  /*--------------------------------------------*/
  PROCEDURE PROC_REC_DEFAULT_POLIZA(OP_DEF_DATOS      OUT SIM_PCK_TIPOS_GENERALES.T_DATOS_DEF,
                                    OP_DEF_AGENTES    OUT SIM_PCK_TIPOS_GENERALES.T_AGENTES_DEF,
                                    OP_DEF_COBERTURAS OUT SIM_PCK_TIPOS_GENERALES.T_COBERTURAS_DEF,
                                    IP_VALIDACION     IN VARCHAR2,
                                    IP_ARRCONTEXTO    IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO    OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO        IN SIM_TYP_PROCESO,
                                    OP_RESULTADO      OUT NUMBER,
                                    OP_ARRERRORES     OUT SIM_TYP_ARRAY_ERROR) IS
    L_ERROR                   SIM_TYP_ERROR;
    PGEN                      SIM_PCK_TIPOS_GENERALES.T_PARAMETRO;
    SALIDAGEN                 SIM_PCK_TIPOS_GENERALES.T_SALIDA;
    PROCESOGEN                SIM_PCK_TIPOS_GENERALES.T_PROCESO;
    XMLGEN                    SIM_PCK_TIPOS_GENERALES.T_CLOB;
    P_B99_CODDOCUM            A2000030.NRO_DOCUMTO%TYPE;
    P_B99_TDOCTERCERO         A2000030.TDOC_TERCERO%TYPE;
    L_SPP                     SIM_PRIVILEGIOS_POLIZAS.SEC_PRIVILEGIO_POLIZA%TYPE;
    L_MANEJO_DATOS_ESPECIALES SIM_PRIVILEGIOS_POLIZAS.MANEJO_DATOS_ESPECIALES%TYPE;
    L_INDICE                  NUMBER;
  
    CURSOR C_DG(P_SPP NUMBER) IS
      SELECT A.NIVEL_CAMPO,
             A.COD_CAMPO,
             A.VALOR_DEFAULT,
             A.MODIFICA_CAMPO,
             A.VISUALIZA_CAMPO
        FROM SIM_DEFAULT_DATOS A
       WHERE A.SEC_PRIVILEGIO_POLIZA = P_SPP;
  
    CURSOR C_DA(P_SPP NUMBER) IS
      SELECT A.COD_AGENTE, A.MCA_LIDER, A.PORC_COMIS, A.PORC_PART
        FROM SIM_DEFAULT_AGENTES A
       WHERE A.SEC_PRIVILEGIO_POLIZA = P_SPP;
  
    CURSOR C_DC(P_SPP NUMBER) IS
      SELECT A.COD_COB,
             A.SUMA_ASEG_DEF,
             A.TASA_DEF,
             A.PRIMA_DEF,
             A.PRIMA_MINIMA_DEF
        FROM SIM_DEFAULT_COBERTURAS A
       WHERE A.SEC_PRIVILEGIO_POLIZA = P_SPP;
  BEGIN
    G_SUBPROGRAMA     := G_PROGRAMA || '.Proc_Rec_Default_Poliza ';
    L_ERROR           := NEW SIM_TYP_ERROR;
    OP_ARRERRORES     := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO      := SIM_PCK_TIPOS_GENERALES.C_CERO;
    P_B99_CODDOCUM    := SIM_PCK_REGLAS.G_PARAMETROS('B99_CODDOCUM');
    P_B99_TDOCTERCERO := SIM_PCK_REGLAS.G_PARAMETROS('B99_TDOCTERCERO');
  
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
  
    L_MANEJO_DATOS_ESPECIALES := 'N';
  
    BEGIN
      SELECT A.MANEJO_DATOS_ESPECIALES, A.SEC_PRIVILEGIO_POLIZA
        INTO L_MANEJO_DATOS_ESPECIALES, L_SPP
        FROM SIM_PRIVILEGIOS_POLIZAS A
       WHERE A.COMPANIA = IP_PROCESO.P_COD_CIA
         AND A.SECCION = IP_PROCESO.P_COD_SECC
         AND NVL(A.COD_PRODUCTO, -1) = NVL(IP_PROCESO.P_COD_PRODUCTO, -1)
         AND NVL(A.COD_SUBPRODUCTO, -1) = NVL(IP_PROCESO.P_SUBPRODUCTO, -1)
         AND NVL(A.TIPO_DOCUMENTO, 'XX') = NVL(P_B99_TDOCTERCERO, 'XX')
         AND NVL(A.NUMERO_DOCUMENTO, -1) = NVL(P_B99_CODDOCUM, -1)
         AND NVL(NVL(A.USUARIO_NEGOCIO, IP_PROCESO.P_COD_USR), 'XX') =
             NVL(IP_PROCESO.P_COD_USR, 'XX')
         AND NVL(NVL(A.SISTEMA_ORIGEN, IP_PROCESO.P_SISTEMA_ORIGEN), -1) =
             NVL(IP_PROCESO.P_SISTEMA_ORIGEN, -1)
         AND NVL(NVL(A.CANAL, IP_PROCESO.P_CANAL), -1) =
             NVL(IP_PROCESO.P_CANAL, -1)
         AND NVL(NVL(A.TIPO_NEGOCIO, IP_PROCESO.P_MODULO), -1) =
             NVL(IP_PROCESO.P_MODULO, -1);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        L_MANEJO_DATOS_ESPECIALES := 'N';
      WHEN OTHERS THEN
        L_MANEJO_DATOS_ESPECIALES := 'N';
        L_ERROR                   := SIM_TYP_ERROR(SQLCODE,
                                                   G_SUBPROGRAMA || '.Msg:' ||
                                                   SQLERRM,
                                                   'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
    END;
  
    IF L_MANEJO_DATOS_ESPECIALES = 'S' THEN
      L_INDICE := 0;
    
      FOR R_DG IN C_DG(L_SPP) LOOP
        L_INDICE := L_INDICE + 1;
        OP_DEF_DATOS(L_INDICE).NIVEL_CAMPO := R_DG.NIVEL_CAMPO;
        OP_DEF_DATOS(L_INDICE).COD_CAMPO := R_DG.COD_CAMPO;
        OP_DEF_DATOS(L_INDICE).VALOR_DEFAULT := R_DG.VALOR_DEFAULT;
        OP_DEF_DATOS(L_INDICE).MODIFICA_CAMPO := R_DG.MODIFICA_CAMPO;
        OP_DEF_DATOS(L_INDICE).VISUALIZA_CAMPO := R_DG.VISUALIZA_CAMPO;
      END LOOP;
    
      L_INDICE := 0;
    
      FOR R_DA IN C_DA(L_SPP) LOOP
        L_INDICE := L_INDICE + 1;
        OP_DEF_AGENTES(L_INDICE).COD_AGENTE := R_DA.COD_AGENTE;
        OP_DEF_AGENTES(L_INDICE).MCA_LIDER := R_DA.MCA_LIDER;
        OP_DEF_AGENTES(L_INDICE).PORC_COMIS := R_DA.PORC_COMIS;
        OP_DEF_AGENTES(L_INDICE).PORC_PART := R_DA.PORC_PART;
      END LOOP;
    
      L_INDICE := 0;
    
      FOR R_DC IN C_DC(L_SPP) LOOP
        L_INDICE := L_INDICE + 1;
        OP_DEF_COBERTURAS(L_INDICE).COD_COB := R_DC.COD_COB;
        OP_DEF_COBERTURAS(L_INDICE).SUMA_ASEG_DEF := R_DC.SUMA_ASEG_DEF;
        OP_DEF_COBERTURAS(L_INDICE).TASA_DEF := R_DC.TASA_DEF;
        OP_DEF_COBERTURAS(L_INDICE).PRIMA_DEF := R_DC.PRIMA_DEF;
        OP_DEF_COBERTURAS(L_INDICE).PRIMA_MINIMA_DEF := R_DC.PRIMA_MINIMA_DEF;
      END LOOP;
    END IF;
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Error en Proc_Rec_Default_Poliza - ' ||
                                                          SQLERRM,
                                                          'E');
  END PROC_REC_DEFAULT_POLIZA;

  PROCEDURE PROC_CLIENTEESPECIAL(IP_TIPODOCUMENTO   IN VARCHAR2,
                                 IP_NRODOCUMENTO    IN NUMBER,
                                 OP_CLIENTEESPECIAL OUT VARCHAR2,
                                 IP_VALIDACION      IN VARCHAR2,
                                 IP_PROCESO         IN SIM_TYP_PROCESO,
                                 OP_RESULTADO       OUT NUMBER,
                                 OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_CONTADOR NUMBER;
  BEGIN
    G_SUBPROGRAMA      := G_PROGRAMA || '.Proc_Visualiza_Det_Cob ';
    L_ERROR            := NEW SIM_TYP_ERROR;
    OP_ARRERRORES      := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO       := SIM_PCK_TIPOS_GENERALES.C_CERO;
    OP_CLIENTEESPECIAL := 'N';
  
    SELECT 'S'
      INTO OP_CLIENTEESPECIAL
      FROM SIM_PRIVILEGIOS_POLIZAS A
     WHERE A.COMPANIA = IP_PROCESO.P_COD_CIA
       AND A.SECCION = IP_PROCESO.P_COD_SECC
       AND NVL(A.COD_PRODUCTO, -1) IN
           (IP_PROCESO.P_COD_PRODUCTO, NVL(A.COD_PRODUCTO, -1))
       AND NVL(A.COD_SUBPRODUCTO, -1) IN
           (IP_PROCESO.P_SUBPRODUCTO, NVL(A.COD_SUBPRODUCTO, -1))
       AND A.TIPO_DOCUMENTO = IP_TIPODOCUMENTO
       AND A.NUMERO_DOCUMENTO = IP_NRODOCUMENTO HAVING COUNT(*) > 0;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;

  PROCEDURE PROC_USUARIOHABRECAUDO(OP_HABILITARECAUDO OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION      IN VARCHAR2,
                                   IP_PROCESO         IN SIM_TYP_PROCESO,
                                   OP_RESULTADO       OUT NUMBER,
                                   OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_CONTADOR   NUMBER;
    L_ARRLISTA   SIM_TYP_ARRAY_LISTA;
    L_PROCESO    SIM_TYP_PROCESO;
    L_ARRERRORES SIM_TYP_ARRAY_ERROR;
    L_RESULTADO  NUMBER;
  BEGIN
    G_SUBPROGRAMA            := G_PROGRAMA || '.Habilita_recaudo ';
    L_ERROR                  := NEW SIM_TYP_ERROR;
    OP_ARRERRORES            := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO             := SIM_PCK_TIPOS_GENERALES.C_CERO;
    OP_HABILITARECAUDO       := 'N';
    L_PROCESO                := NEW SIM_TYP_PROCESO;
    L_PROCESO.P_MODULO       := 2;
    L_PROCESO.P_PROCESO      := 550; -- Recaudo Soat
    L_PROCESO.P_COD_CIA      := IP_PROCESO.P_COD_CIA;
    L_PROCESO.P_COD_SECC     := IP_PROCESO.P_COD_SECC;
    L_PROCESO.P_COD_PRODUCTO := IP_PROCESO.P_COD_PRODUCTO;
    L_PROCESO.P_SUBPRODUCTO  := IP_PROCESO.P_SUBPRODUCTO;
    L_PROCESO.P_COD_USR      := IP_PROCESO.P_COD_USR;
    SIM_PCK_SEGURIDAD.PRODUCTOSPERMITIDOSUSRPROC('PRODUCTOS_NUEVO_NEGOCIO',
                                                 L_ARRLISTA,
                                                 'N',
                                                 L_PROCESO,
                                                 L_RESULTADO,
                                                 L_ARRERRORES);
  
    IF L_RESULTADO = 0 THEN
      IF L_ARRLISTA.COUNT > 0 THEN
        FOR I IN L_ARRLISTA.FIRST .. L_ARRLISTA.LAST LOOP
          OP_HABILITARECAUDO := 'S';
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_USUARIOHABENTREGA(OP_HABILITAENTREGA OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION      IN VARCHAR2,
                                   IP_PROCESO         IN SIM_TYP_PROCESO,
                                   OP_RESULTADO       OUT NUMBER,
                                   OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_CONTADOR   NUMBER;
    L_ARRLISTA   SIM_TYP_ARRAY_LISTA;
    L_PROCESO    SIM_TYP_PROCESO;
    L_ARRERRORES SIM_TYP_ARRAY_ERROR;
    L_RESULTADO  NUMBER;
  BEGIN
    G_SUBPROGRAMA            := G_PROGRAMA || '.Habilita_recaudo ';
    L_ERROR                  := NEW SIM_TYP_ERROR;
    OP_ARRERRORES            := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO             := SIM_PCK_TIPOS_GENERALES.C_CERO;
    OP_HABILITAENTREGA       := 'N';
    L_PROCESO                := NEW SIM_TYP_PROCESO;
    L_PROCESO.P_MODULO       := 2;
    L_PROCESO.P_PROCESO      := 555; -- Recaudo Soat
    L_PROCESO.P_COD_CIA      := IP_PROCESO.P_COD_CIA;
    L_PROCESO.P_COD_SECC     := IP_PROCESO.P_COD_SECC;
    L_PROCESO.P_COD_PRODUCTO := IP_PROCESO.P_COD_PRODUCTO;
    L_PROCESO.P_SUBPRODUCTO  := IP_PROCESO.P_SUBPRODUCTO;
    L_PROCESO.P_COD_USR      := IP_PROCESO.P_COD_USR;
    SIM_PCK_SEGURIDAD.PRODUCTOSPERMITIDOSUSRPROC('PRODUCTOS_NUEVO_NEGOCIO',
                                                 L_ARRLISTA,
                                                 'N',
                                                 L_PROCESO,
                                                 L_RESULTADO,
                                                 L_ARRERRORES);
  
    IF L_RESULTADO = 0 THEN
      IF L_ARRLISTA.COUNT > 0 THEN
        FOR I IN L_ARRLISTA.FIRST .. L_ARRLISTA.LAST LOOP
          OP_HABILITAENTREGA := 'S';
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_TIPIFICACION_NEGOCIO(IP_NUMSECUPOL   IN SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA,
                                      OP_TIPIFICACION OUT VARCHAR2,
                                      IP_PROCESO      IN SIM_TYP_PROCESO,
                                      OP_RESULTADO    OUT NUMBER,
                                      OP_ARRERRORES   OUT SIM_TYP_ARRAY_ERROR) IS
    L_PROCESO    SIM_TYP_PROCESO;
    L_ARRERRORES SIM_TYP_ARRAY_ERROR;
    L_RESULTADO  SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    OP_CODERROR  SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO;
    OP_MSGERROR  SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Tipificacion Negocio';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := -1;
  
    BEGIN
      L_RESULTADO := SIM_PCK_CONSULTA_EMISION.FUN_ESCOTIZACION(IP_NUMSECUPOL,
                                                               OP_CODERROR,
                                                               OP_MSGERROR);
    END;
  
    IF OP_CODERROR = 4 THEN
      OP_TIPIFICACION := OP_MSGERROR;
    ELSE
      IF L_RESULTADO = 'S' THEN
        OP_TIPIFICACION := 'COTIZACION';
        OP_RESULTADO    := 0;
      END IF;
    END IF;
  
    IF OP_RESULTADO != 0 THEN
      BEGIN
        L_RESULTADO := SIM_PCK_CONSULTA_EMISION.FUN_ESPRESUPUESTO(IP_NUMSECUPOL,
                                                                  OP_CODERROR,
                                                                  OP_MSGERROR);
      END;
    
      IF L_RESULTADO = 'S' THEN
        OP_TIPIFICACION := 'PRESUPUESTO';
        OP_RESULTADO    := 0;
      ELSE
        IF L_RESULTADO = 'N' THEN
          OP_TIPIFICACION := 'HIJA';
          OP_RESULTADO    := 0;
        END IF;
      END IF;
    
      IF L_RESULTADO IS NULL THEN
        BEGIN
          L_RESULTADO := SIM_PCK_CONSULTA_EMISION.FUN_ESPOLIZAPPAL(IP_NUMSECUPOL,
                                                                   OP_CODERROR,
                                                                   OP_MSGERROR);
        END;
      
        IF OP_CODERROR = 4 THEN
          OP_TIPIFICACION := 'NO EXISTE';
          OP_RESULTADO    := -1;
          RAISE_APPLICATION_ERROR(-20000,
                                  'Numero interno no existe en tablas');
        ELSE
          IF L_RESULTADO IN ('S') THEN
            OP_TIPIFICACION := 'PRINCIPAL';
            OP_RESULTADO    := 0;
          ELSE
            OP_TIPIFICACION := 'HIJA';
            OP_RESULTADO    := 0;
          END IF;
        END IF;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_USUARIOHABRECAUDOEND(IP_NUMSECUPOL      IN NUMBER,
                                      IP_NUMEND          IN NUMBER,
                                      OP_HABILITARECAUDO OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                      IP_VALIDACION      IN VARCHAR2,
                                      IP_PROCESO         IN SIM_TYP_PROCESO,
                                      OP_RESULTADO       OUT NUMBER,
                                      OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_FACTURA                 NUMBER;
    L_PRIMA                   NUMBER;
    L_GASTOSADMON             NUMBER;
    L_IMPUESTO                NUMBER;
    L_PRIMATOTAL              NUMBER;
    L_PRIMAANTERIOR           NUMBER;
    L_NUMFACTURA              NUMBER;
    L_PROGRAMASEGURO          NUMBER := 0;
    L_REFERENCIA              SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_MENSAJE                 SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_POLIZAANTERIOR          SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_RECIBOANTERIOR          SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_NROAUTORIZACIONANTERIOR SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_NUMSECUPOLANTERIOR      SIM_DATOSSOAT.NRO_AUTORIZACION%TYPE;
    L_TARJETAANTERIOR         SIM_DATOSSOAT.TIPO_TARJETA%TYPE;
    L_NUMPOL1                 A2000030.NUM_POL1%TYPE;
    L_ANTICIPADA              SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_ID_PRODUCTO             SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_PROVISORIO              VARCHAR2(1);
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Habilita_recaudo ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    /* valida provisoria mantis 20358*/
    SELECT NVL(MCA_PROVISORIO, 'N')
      INTO L_PROVISORIO
      FROM A2000030
     WHERE NUM_SECU_POL = IP_NUMSECUPOL
       AND NUM_END = IP_NUMEND;
  
    IF L_PROVISORIO = 'N' THEN
      PROC_USUARIOHABRECAUDO(OP_HABILITARECAUDO,
                             IP_VALIDACION,
                             IP_PROCESO,
                             OP_RESULTADO,
                             OP_ARRERRORES);
      L_ID_PRODUCTO := SIM_PCK_FUNCION_GEN.ID_PRODUCTO(IP_PROCESO.P_COD_CIA,
                                                       IP_PROCESO.P_COD_SECC,
                                                       IP_PROCESO.P_COD_PRODUCTO);
    
      IF OP_HABILITARECAUDO = 'S' THEN
        SELECT NVL(MAX(NUM_FACTURA), 0) + 1
          INTO L_NUMFACTURA
          FROM A2990700
         WHERE NUM_SECU_POL = IP_NUMSECUPOL;
      
        L_REFERENCIA := IP_NUMSECUPOL || LPAD(IP_NUMEND, 5, '0') ||
                        LPAD(L_NUMFACTURA, 5, '0');
      
        DELETE SIM_CONTROL_RECAUDOS G WHERE REFERENCIA = L_REFERENCIA;
        INSERT INTO SIM_CONTROL_RECAUDOS
          (REFERENCIA,
           NUM_SECU_POL,
           NUM_END,
           NUM_FACTURA,
           ESTADO,
           FECHA_CREACION,
           FECHA_SOLICITA_WS,
           FECHA_CONFIRMA_RECAUDO,
           USUARIO_CREACION)
        VALUES
          (L_REFERENCIA,
           IP_NUMSECUPOL,
           IP_NUMEND,
           L_NUMFACTURA,
           'SP',
           SYSDATE,
           NULL,
           NULL,
           IP_PROCESO.P_COD_USR);
      
        BEGIN
          BEGIN
            SELECT IMP_PRIMA_END,
                   NVL(IMP_IMPUESTO_E, 0),
                   NVL(IMP_DER_EMI_EN, 0),
                   PREMIO_END,
                   NVL(B.SIM_PAQUETE_SEGURO, 0)
              INTO L_PRIMA,
                   L_IMPUESTO,
                   L_GASTOSADMON,
                   L_PRIMATOTAL,
                   L_PROGRAMASEGURO
              FROM A2000030 B, A2000160 G
             WHERE G.NUM_SECU_POL = IP_NUMSECUPOL
               AND G.NUM_END = IP_NUMEND
               AND B.NUM_SECU_POL = G.NUM_SECU_POL
               AND B.NUM_END = G.NUM_END
               AND G.TIPO_REG = 'T'
               AND B.PERIODO_FACT = 12; -- Solo para las polizas y cotizaciones anuales
          END;
          ------    HENRY LAGUNA  10032016  SI EL ENDOSO LO HACE UN PUNTO DE VENTA
          IF NVL(L_PROGRAMASEGURO, 0) = 0 THEN
            L_PROGRAMASEGURO := PKG_SOAT_PTOS_VTA.FUN_CONVENIO_USUARIO(IP_PROCESO.P_COD_USR);
          END IF;
          ------    HENRY LAGUNA  10032016  SI EL ENDOSO LO HACE UN PUNTO DE VENTA
        
          BEGIN
            SELECT EMISION_ANTICIPADA
              INTO L_ANTICIPADA
              FROM SIM_CONVENIO_SEGUROS H
             WHERE ID_PRODUCTO = L_ID_PRODUCTO
               AND CONVENIO = L_PROGRAMASEGURO
               AND FECHA_BAJA IS NULL;
          EXCEPTION
            WHEN OTHERS THEN
              L_ANTICIPADA := 'N';
          END;
        
          IF IP_NUMEND > 0 THEN
            IF NVL(L_PROGRAMASEGURO, 0) = 0 THEN
              IF L_PRIMATOTAL <= 0 THEN
                UPDATE SIM_CONTROL_RECAUDOS
                   SET ESTADO = 'DP' -- Devolucion de Primas
                 WHERE REFERENCIA = L_REFERENCIA;
              
                OP_HABILITARECAUDO := 'N';
              END IF;
            ELSIF NVL(L_PROGRAMASEGURO, 0) <> 0 AND L_ANTICIPADA = 'S' THEN
              OP_HABILITARECAUDO := 'C';
            
              UPDATE SIM_DATOSSOAT A
                 SET A.ESTADO_IMPRESION = 'PND'
               WHERE NUM_SECU_POL = IP_NUMSECUPOL
                 AND NUM_END = IP_NUMEND;
            
              UPDATE SIM_ENTREGASOAT A
                 SET A.ESTADO = 'PND'
               WHERE NUM_SECU_POL = IP_NUMSECUPOL
                 AND NUM_END = IP_NUMEND;
            END IF;
          ELSIF NVL(L_PROGRAMASEGURO, 0) = 0 THEN
            /* Aplica recaudo si el proceso es reemplazo de poliza */
            BEGIN
              SELECT A.NUM_POL_ANT, NUM_POL1
                INTO L_POLIZAANTERIOR, L_NUMPOL1
                FROM A2000030 A
               WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                 AND A.NUM_END = IP_NUMEND
                 AND NVL(A.NUM_POL_ANT, 0) > 0
                 AND EXISTS
               (SELECT ''
                        FROM A2000030 B
                       WHERE B.NUM_POL1 = A.NUM_POL_ANT
                         AND B.COD_SECC = A.COD_SECC
                         AND NVL(MCA_PER_ANUL, 'N') = 'S');
            
              SELECT NVL(C.IMP_MON_PAIS, 0) +
                     NVL(C.IMP_IMPTOS_MON_LOCAL, 0),
                     RECIBO
                INTO L_PRIMAANTERIOR, L_RECIBOANTERIOR
                FROM A5021600 C
               WHERE C.COD_CIA = IP_PROCESO.P_COD_CIA
                 AND C.COD_SECC = IP_PROCESO.P_COD_SECC
                 AND C.NUM_POL1 = L_POLIZAANTERIOR
                 AND C.NUM_END = SIM_PCK_TIPOS_GENERALES.C_CERO;
            
              SIM_PCK_CONSULTA_EMISION.PROC_BUSCANUMEROSECUENCIA(L_POLIZAANTERIOR,
                                                                 NULL,
                                                                 IP_PROCESO.P_COD_SECC,
                                                                 L_NUMSECUPOLANTERIOR);
            
              SELECT NRO_AUTORIZACION, C.TIPO_TARJETA
                INTO L_NROAUTORIZACIONANTERIOR, L_TARJETAANTERIOR
                FROM SIM_DATOSSOAT C
               WHERE NUM_SECU_POL = L_NUMSECUPOLANTERIOR
                 AND C.NUM_END = SIM_PCK_TIPOS_GENERALES.C_CERO;
            
              IF L_NROAUTORIZACIONANTERIOR IS NOT NULL AND
                 L_POLIZAANTERIOR > 0 THEN
                IF L_PRIMATOTAL >= L_PRIMAANTERIOR THEN
                  BEGIN
                    PK_ANULA_RECIBO.ANULA(L_RECIBOANTERIOR, L_MENSAJE);
                    SIM_PCK_PROCESO_DML_EMISION2.PROC_LEGALIZA_RECAUDO(L_NUMPOL1,
                                                                       IP_NUMEND,
                                                                       NULL,
                                                                       L_NROAUTORIZACIONANTERIOR,
                                                                       NULL,
                                                                       L_TARJETAANTERIOR,
                                                                       IP_PROCESO,
                                                                       OP_RESULTADO,
                                                                       OP_ARRERRORES);
                  
                    IF OP_RESULTADO = 0 THEN
                      UPDATE SIM_CONTROL_RECAUDOS
                         SET ESTADO = 'AC' -- Anulado Cobro
                       WHERE REFERENCIA = L_NUMSECUPOLANTERIOR ||
                             LPAD(IP_NUMEND, 5, '0') ||
                             LPAD(L_NUMFACTURA, 5, '0');
                    
                      IF L_PRIMATOTAL = L_PRIMAANTERIOR THEN
                        OP_HABILITARECAUDO := 'N';
                      
                        UPDATE SIM_CONTROL_RECAUDOS
                           SET ESTADO     = 'OK',
                               REFERENCIA = L_NUMSECUPOLANTERIOR ||
                                            LPAD(IP_NUMEND, 5, '0') ||
                                            LPAD(L_NUMFACTURA, 5, '0')
                         WHERE REFERENCIA = L_REFERENCIA;
                      END IF;
                    END IF;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_ERROR := SIM_TYP_ERROR(-20010,
                                               'Reemplazo, error al trasladar recaudo poliza anterior ' ||
                                               SQLERRM,
                                               'E');
                      OP_ARRERRORES.EXTEND;
                      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                      OP_RESULTADO := -1;
                  END;
                ELSE
                  OP_HABILITARECAUDO := 'N';
                
                  UPDATE SIM_CONTROL_RECAUDOS
                     SET ESTADO = 'MR' -- Mayor Valor Recaudado poliza anterior
                   WHERE REFERENCIA = L_REFERENCIA;
                END IF;
              END IF;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          ELSIF NVL(L_PROGRAMASEGURO, 0) <> 0 AND IP_NUMEND = 0 THEN
            IF L_ANTICIPADA = 'S' THEN
              OP_HABILITARECAUDO := 'C';
            END IF;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            OP_HABILITARECAUDO := 'N';
          WHEN TOO_MANY_ROWS THEN
            NULL;
        END;
      END IF;
    ELSE
      /* Poliza provisoria */
      OP_HABILITARECAUDO := 'N';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_RECUPERAPRIMAFACTURA(IP_NUMSECUPOL      IN NUMBER,
                                      IP_NUMEND          IN NUMBER,
                                      IP_REFERENCIA      IN VARCHAR2,
                                      IP_COTIZACION      IN VARCHAR2,
                                      OP_REFERENCIA      OUT VARCHAR2,
                                      OP_NUMFACTURA      OUT NUMBER,
                                      OP_PRIMANETA       OUT NUMBER,
                                      OP_PRIMAASISTENCIA OUT NUMBER,
                                      OP_IVA             OUT NUMBER,
                                      OP_IVAASISTENCIA   OUT NUMBER,
                                      OP_GASTOSADM       OUT NUMBER,
                                      OP_PRIMATOTAL      OUT NUMBER,
                                      OP_BASEIVA         OUT NUMBER,
                                      IP_VALIDACION      IN VARCHAR2,
                                      IP_PROCESO         IN SIM_TYP_PROCESO,
                                      OP_RESULTADO       OUT NUMBER,
                                      OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_NUMFACTURA NUMBER;
    L_CONTADOR   NUMBER;
  BEGIN
    G_SUBPROGRAMA    := G_PROGRAMA || '.recuperafactura';
    L_ERROR          := NEW SIM_TYP_ERROR;
    OP_ARRERRORES    := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO     := SIM_PCK_TIPOS_GENERALES.C_CERO;
    OP_IVAASISTENCIA := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    IF IP_COTIZACION = 'N' THEN
      IF IP_REFERENCIA IS NOT NULL THEN
        L_CONTADOR   := LENGTH(IP_REFERENCIA);
        L_NUMFACTURA := SUBSTR(LPAD(IP_REFERENCIA, 25, '0'), 21, 5);
      
        SELECT NUM_FACTURA,
               IMP_PRIMA,
               NVL(IMP_IMPUESTO, 0),
               NVL(IMP_DER_EMI, 0),
               PREMIO
          INTO OP_NUMFACTURA,
               OP_PRIMANETA,
               OP_IVA,
               OP_GASTOSADM,
               OP_PRIMATOTAL
          FROM A2000163
         WHERE NUM_SECU_POL = IP_NUMSECUPOL
           AND NUM_FACTURA = L_NUMFACTURA
           AND COD_AGRUP_CONT = 'GENERICOS'
           AND TIPO_REG = 'T';
      ELSE
        SELECT NUM_FACTURA,
               IMP_PRIMA,
               NVL(IMP_IMPUESTO, 0),
               NVL(IMP_DER_EMI, 0),
               PREMIO
          INTO OP_NUMFACTURA,
               OP_PRIMANETA,
               OP_IVA,
               OP_GASTOSADM,
               OP_PRIMATOTAL
          FROM A2000163
         WHERE NUM_SECU_POL = IP_NUMSECUPOL
           AND NUM_END_REF = IP_NUMEND
           AND NUM_END IS NOT NULL
           AND COD_AGRUP_CONT = 'GENERICOS'
           AND TIPO_REG = 'T';
      
        OP_REFERENCIA := IP_NUMSECUPOL || LPAD(IP_NUMEND, 5, '0') ||
                         LPAD(OP_NUMFACTURA, 5, '0');
      END IF;
    
      BEGIN
        SELECT NVL(PRIMA_PROV, 0)
          INTO OP_BASEIVA
          FROM A2000191
         WHERE NUM_SECU_POL = IP_NUMSECUPOL
           AND NUM_FACTURA = OP_NUMFACTURA
           AND COD_AGRUP_CONT = 'GENERICOS'
           AND TIPO_REG = 'T'
           AND IMP_IMPUESTO != SIM_PCK_TIPOS_GENERALES.C_CERO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          OP_BASEIVA := SIM_PCK_TIPOS_GENERALES.C_CERO;
      END;
    
      PROC_RECUPERAPRIMAASISTENCIA(IP_NUMSECUPOL,
                                   IP_NUMEND,
                                   'S',
                                   OP_NUMFACTURA,
                                   OP_PRIMAASISTENCIA,
                                   IP_VALIDACION,
                                   IP_PROCESO,
                                   OP_RESULTADO,
                                   OP_ARRERRORES);
    
      --BEGIN
      --   SELECT imp_prima INTO Op_PrimaAsistencia
      --     FROM A2000163
      --    WHERE num_secu_pol = Ip_NumSecupol
      --      AND num_factura =  Op_Numfactura
      --      AND substr(cod_agrup_cont,4,3) = '888'
      --     AND tipo_reg ='T';
      --   EXCEPTION WHEN NO_DATA_FOUND THEN Op_PrimaAsistencia := 0;
      -- END;
      IF OP_BASEIVA != 0 AND OP_PRIMAASISTENCIA != 0 THEN
        BEGIN
          SELECT IMP_IMPUESTO
            INTO OP_IVAASISTENCIA
            FROM A2000191
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NUM_FACTURA = OP_NUMFACTURA
             AND SUBSTR(COD_AGRUP_CONT, 4, 3) = '888'
             AND TIPO_REG = 'T'
             AND IMP_IMPUESTO != SIM_PCK_TIPOS_GENERALES.C_CERO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            OP_IVAASISTENCIA := SIM_PCK_TIPOS_GENERALES.C_CERO;
        END;
      END IF;
    ELSE
      SELECT SIM_PCK_TIPOS_GENERALES.C_UNO,
             IMP_PRIMA,
             NVL(IMP_IMPUESTO, 0),
             NVL(IMP_DER_EMI, 0),
             PREMIO
        INTO OP_NUMFACTURA,
             OP_PRIMANETA,
             OP_IVA,
             OP_GASTOSADM,
             OP_PRIMATOTAL
        FROM A2000160
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND NUM_END = SIM_PCK_TIPOS_GENERALES.C_CERO
         AND TIPO_REG = 'T';
    
      BEGIN
        SELECT NVL(PRIMA_PROV, 0)
          INTO OP_BASEIVA
          FROM A2000190
         WHERE NUM_SECU_POL = IP_NUMSECUPOL
           AND NUM_END = SIM_PCK_TIPOS_GENERALES.C_CERO
           AND TIPO_REG = 'T'
           AND IMP_IMPUESTO != SIM_PCK_TIPOS_GENERALES.C_CERO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          OP_BASEIVA := SIM_PCK_TIPOS_GENERALES.C_CERO;
      END;
    
      PROC_RECUPERAPRIMAASISTENCIA(IP_NUMSECUPOL,
                                   0,
                                   'N',
                                   NULL,
                                   OP_PRIMAASISTENCIA,
                                   IP_VALIDACION,
                                   IP_PROCESO,
                                   OP_RESULTADO,
                                   OP_ARRERRORES);
    
      --BEGIN
      --  SELECT End_prima_cob INTO Op_PrimaAsistencia
      --    FROM A2000040
      --     WHERE num_secu_pol = Ip_NumSecupol
      --       AND num_end =   Sim_Pck_Tipos_Generales.c_Cero
      --       AND substr(cod_agrup_cont,4,3) = '888'
      --       AND tipo_reg ='T';
      --    EXCEPTION WHEN NO_DATA_FOUND THEN Op_PrimaAsistencia := 0;
      -- END;
      IF OP_BASEIVA != 0 AND OP_PRIMAASISTENCIA != 0 THEN
        BEGIN
          SELECT ROUND(OP_PRIMAASISTENCIA * (TASA_IMPUESTO / 100), 2)
            INTO OP_IVAASISTENCIA
            FROM A2000190 F
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NUM_END = SIM_PCK_TIPOS_GENERALES.C_CERO
             AND TIPO_REG = 'T'
             AND IMP_IMPUESTO != SIM_PCK_TIPOS_GENERALES.C_CERO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            OP_IVAASISTENCIA := SIM_PCK_TIPOS_GENERALES.C_CERO;
        END;
      END IF;
    END IF;
  
    OP_REFERENCIA := IP_NUMSECUPOL || LPAD(IP_NUMEND, 5, '0') ||
                     LPAD(OP_NUMFACTURA, 5, '0');
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      L_ERROR := SIM_TYP_ERROR(-20001,
                               'Existen varias facturas asociadas a la poliza/Endoso',
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_RECUPERAPRIMAASISTENCIA(IP_NUMSECUPOL      IN NUMBER,
                                         IP_NUMEND          IN NUMBER,
                                         IP_MCAFACTURA      IN VARCHAR2,
                                         IP_NUMFACTURA      IN NUMBER,
                                         OP_PRIMAASISTENCIA OUT NUMBER,
                                         IP_VALIDACION      IN VARCHAR2,
                                         IP_PROCESO         IN SIM_TYP_PROCESO,
                                         OP_RESULTADO       OUT NUMBER,
                                         OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_CONTADOR NUMBER;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.recuperafactura';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    IF IP_MCAFACTURA = 'S' AND IP_NUMFACTURA IS NOT NULL THEN
      BEGIN
        SELECT IMP_PRIMA
          INTO OP_PRIMAASISTENCIA
          FROM A2000163
         WHERE NUM_SECU_POL = IP_NUMSECUPOL
           AND NUM_FACTURA = IP_NUMFACTURA
           AND SUBSTR(COD_AGRUP_CONT, 4, 3) = '888'
           AND TIPO_REG = 'T';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          OP_PRIMAASISTENCIA := 0;
      END;
    ELSIF IP_MCAFACTURA = 'N' AND IP_NUMEND IS NOT NULL THEN
      BEGIN
        SELECT NVL(SUM(NVL(END_PRIMA_COB, 0)), 0)
          INTO OP_PRIMAASISTENCIA
          FROM A2000040
         WHERE NUM_SECU_POL = IP_NUMSECUPOL
           AND NUM_END = IP_NUMEND
           AND SUBSTR(COD_AGRUP_CONT, 4, 3) = '888'
           AND TIPO_REG = 'T';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          OP_PRIMAASISTENCIA := 0;
      END;
    ELSE
      L_ERROR := SIM_TYP_ERROR(-20005,
                               'Debe Enviar Endoso o Numero de factura',
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    END IF;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      L_ERROR := SIM_TYP_ERROR(-20001,
                               'Existen varias facturas asociadas a la poliza/Endoso',
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_USUARIOHABPROCESO(IP_CODIGOPROCESO   IN SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA,
                                   OP_HABILITAPROCESO OUT SIM_PCK_TIPOS_GENERALES.T_CARACTER,
                                   IP_VALIDACION      IN VARCHAR2,
                                   IP_PROCESO         IN SIM_TYP_PROCESO,
                                   OP_RESULTADO       OUT NUMBER,
                                   OP_ARRERRORES      OUT SIM_TYP_ARRAY_ERROR) IS
    L_CONTADOR   NUMBER;
    L_ARRLISTA   SIM_TYP_ARRAY_LISTA;
    L_PROCESO    SIM_TYP_PROCESO;
    L_ARRERRORES SIM_TYP_ARRAY_ERROR;
    L_RESULTADO  NUMBER;
  BEGIN
    G_SUBPROGRAMA            := G_PROGRAMA || '.Habilita_proceso ';
    L_ERROR                  := NEW SIM_TYP_ERROR;
    OP_ARRERRORES            := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO             := SIM_PCK_TIPOS_GENERALES.C_CERO;
    OP_HABILITAPROCESO       := 'N';
    L_PROCESO                := NEW SIM_TYP_PROCESO;
    L_PROCESO.P_MODULO       := SIM_PCK_TIPOS_GENERALES.C_DOS;
    L_PROCESO.P_PROCESO      := IP_CODIGOPROCESO;
    L_PROCESO.P_COD_CIA      := IP_PROCESO.P_COD_CIA;
    L_PROCESO.P_COD_SECC     := IP_PROCESO.P_COD_SECC;
    L_PROCESO.P_COD_PRODUCTO := IP_PROCESO.P_COD_PRODUCTO;
    L_PROCESO.P_SUBPRODUCTO  := IP_PROCESO.P_SUBPRODUCTO;
    L_PROCESO.P_COD_USR      := IP_PROCESO.P_COD_USR;
    SIM_PCK_SEGURIDAD.PRODUCTOSPERMITIDOSUSRPROC('PRODUCTOS_NUEVO_NEGOCIO',
                                                 L_ARRLISTA,
                                                 'N',
                                                 L_PROCESO,
                                                 L_RESULTADO,
                                                 L_ARRERRORES);
  
    IF L_RESULTADO = 0 THEN
      IF L_ARRLISTA.COUNT > 0 THEN
        FOR I IN L_ARRLISTA.FIRST .. L_ARRLISTA.LAST LOOP
          OP_HABILITAPROCESO := 'S';
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_INICIALIZA_PASOS(IP_ARRCONTEXTO SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                  IP_PROCESODV   OUT VARCHAR2,
                                  IP_PROCESOCOB  OUT VARCHAR2,
                                  IP_EJECUTOCT   OUT VARCHAR2) IS
  BEGIN
    BEGIN
      IP_PROCESODV := SIM_PCK_REGLAS.G_PARAMETROS('B99_PROCESO_DV');
    EXCEPTION
      WHEN OTHERS THEN
        IP_PROCESODV := 'S';
    END;
  
    BEGIN
      IP_PROCESOCOB := SIM_PCK_REGLAS.G_PARAMETROS('B99_PROCESO_COB');
    EXCEPTION
      WHEN OTHERS THEN
        IP_PROCESOCOB := 'S';
    END;
  
    BEGIN
      IP_EJECUTOCT := SIM_PCK_REGLAS.G_PARAMETROS('B99_EJECUTO_CT');
    EXCEPTION
      WHEN OTHERS THEN
        IP_EJECUTOCT := 'S';
    END;
  END;

  PROCEDURE PROC_PRECAMPODVARIABLES(IP_NUMSECUPOL  IN NUMBER,
                                    IP_CODRIES     IN NUMBER,
                                    IP_CODCAMPO    IN VARCHAR2,
                                    IP_CODNIVEL    IN NUMBER,
                                    IP_CODCOB      IN NUMBER,
                                    IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO     IN SIM_TYP_PROCESO,
                                    OP_RESULTADO   OUT NUMBER,
                                    OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    L_ESPPAL       SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_EJECUTOREGLA SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
  
    CURSOR REGLAS IS
      SELECT DISTINCT A.COD_CAMPO CODCAMPO,
                      T.REG_PRE_FIELD REGLAPRECAMPO,
                      DECODE(T.COD_NIVEL, 1, '299PRU016', '299PRU015') REGLAACTUALIZA,
                      T.NUM_SECU,
                      NVL(T.COD_COB, 0) COD_COB,
                      T.COD_NIVEL,
                      DECODE(T.ACEPTA_NULL,
                             'N',
                             DECODE(T.OBLIGATORIO, 'S', 'N', 'S'),
                             T.ACEPTA_NULL) MCA_HAB_MOD,
                      DECODE(L_ESPPAL,
                             'S',
                             'S',
                             DECODE(T.ACEPTA_NULL,
                                    'S',
                                    DECODE(T.OBLIGATORIO, 'S', 'S', 'N'),
                                    'S')) OBLIGATORIO,
                      NVL(T.MCA_HAB_MOD, 'N') DISABLE,
                      CLAUSULAS DESCRIPCION,
                      NVL(T.VALOR_CAMPO_EN, T.VALOR_DEFECTO) VALOR_CAMPO_EN,
                      T.MCA_VISIBLE MCA_VISIBLE
        FROM X2000020 T, SIM_G2000020 A
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND A.COD_CAMPO = T.COD_CAMPO
         AND A.COD_CIA = IP_PROCESO.P_COD_CIA
         AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND ((NVL(T.COD_RIES, 0) = 0 AND NVL(IP_CODRIES, 0) = 0) OR
             (T.COD_RIES = IP_CODRIES AND NVL(IP_CODRIES, 0) > 0))
         AND T.COD_CAMPO =
             DECODE(IP_CODCAMPO, NULL, T.COD_CAMPO, IP_CODCAMPO)
         AND T.COD_NIVEL =
             DECODE(IP_CODNIVEL, NULL, T.COD_NIVEL, IP_CODNIVEL)
         AND NVL(T.COD_COB, 0) =
             DECODE(T.COD_NIVEL, 3, IP_CODCOB, NVL(T.COD_COB, 0)) --decode(p_codcob,NULL,nvl(t.cod_cob,0),p_CodCob)
            --  AND t.mca_visible = 'S'
         AND (A.ESTADO = 'A' OR L_ESPPAL = 'S' OR IP_PROCESO.P_CANAL = 3)
         AND ((T.MCA_VISIBLE = 'S' AND IP_PROCESO.P_COD_SECC IN (922, 923)) OR -- SIMON API
             IP_PROCESO.P_COD_SECC NOT IN (922, 923))
       ORDER BY NVL(T.COD_COB, 0), T.COD_NIVEL, T.NUM_SECU;
  
    P_REGLA                SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    P_VALORCAMPO           SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    P_DISABLEDATO          SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    P_INCLUYE              SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    P_VISIBLE              SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO := 'S';
    P_DESCRIPCION          SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_ERROR                SIM_TYP_ERROR;
    L_VALORCAMPOENANTERIOR SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO; -- Wesv 20120803
    L_HABILITA_CACHE       VARCHAR2(1) := 'N';
    P_VALOR_CAMPO_CACHE    SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO := NULL;
    P_ENTRO                BOOLEAN := FALSE;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.RecuperaDatosVariables ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
    OP_ARRCONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    OP_RESULTADO   := 0;
  
    BEGIN
      L_ESPPAL := SIM_PCK_CONSULTA_EMISION.FUN_ESPRINCIPAL(IP_PROCESO.P_PROCESO,
                                                           IP_PROCESO.P_SUBPROCESO,
                                                           IP_PROCESO.P_MODULO);
    EXCEPTION
      WHEN OTHERS THEN
        L_ESPPAL := 'N';
    END;
  
    /* Logica */
    FOR I IN REGLAS LOOP
      SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODCAMPO', I.CODCAMPO); -- Wesv 20120817
      SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTVALORCAMPOEN',
                                          I.VALOR_CAMPO_EN); -- Wesv 20120817
      SIM_PCK_CONTEXTO_EMISION.PROC_CONTEXTODATOSVARIABLES(IP_NUMSECUPOL,
                                                           IP_CODRIES,
                                                           I.CODCAMPO);
      P_DESCRIPCION := SUBSTR(I.DESCRIPCION, 1, 50);
      P_DISABLEDATO := I.DISABLE;
      P_VALORCAMPO  := I.VALOR_CAMPO_EN; -- Valor para el campo actual de validacion
    
      SIM_PROC_LOG('AEEM_TERR',
                   'PDE2 2021 ' || IP_NUMSECUPOL || 'I.CODCAMPO ' ||
                   I.CODCAMPO || ' P_VALORCAMPO' || P_VALORCAMPO);
    
      --sim_proc_log('Proc_PreCampoDatosVariables','8');
      BEGIN
        L_VALORCAMPOENANTERIOR := I.VALOR_CAMPO_EN;
        L_EJECUTOREGLA         := 'N';
      
        IF I.REGLAPRECAMPO IS NOT NULL AND I.MCA_VISIBLE = 'S' THEN
          --IF i.reglaprecampo is NOT NULL THEN
          L_EJECUTOREGLA           := 'S';
          P_DESCRIPCION            := NULL;
          P_DISABLEDATO            := NULL;
          P_REGLA                  := I.REGLAPRECAMPO;
          SIM_PCK_REGLAS.G_TERMINA := 'N';
          SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTDESCRI', ' ');
          SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_INCLUYE', 'S');
          SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTSALTO', '');
        
          BEGIN
            -- DHH MASB obtener datos variables guardados en cache x sesion
            -- ESTCORE-10101
            IF IP_PROCESO.P_COD_SECC = 1 THEN
              P_ENTRO := SIM_PCK_CACHE_EMISION.FBLOBTDATOVARIABLE(IP_PROCESO      => IP_PROCESO,
                                                                  IP_NUMSECUPOL   => IP_NUMSECUPOL,
                                                                  IP_CODRIES      => IP_CODRIES,
                                                                  IP_CODCAMPO     => I.CODCAMPO,
                                                                  IP_CODNIVEL     => IP_CODNIVEL,
                                                                  IP_CODCOB       => IP_CODCOB,
                                                                  OP_VALORCAMPOEN => P_VALOR_CAMPO_CACHE);
            
              --P_VALORCAMPO := P_VALOR_CAMPO_CACHE;                                                  
            END IF;
            DBMS_OUTPUT.PUT_LINE('P_ENTRO : ' || I.CODCAMPO || ' ');
            IF SIM_PCK_FUNCION_GEN.DISPARAREGLA(IP_PROCESO,
                                                P_REGLA,
                                                I.CODCAMPO) = 'S' AND
               P_ENTRO = FALSE THEN
              SIM_PCK_REGLAS.INVOCARREGLA(P_REGLA);
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          IF I.CODCAMPO = 'SEL_TERREMOTO' THEN
            SIM_PROC_LOG('AEEM_TERR',
                         'PDE2 2047 ' || IP_NUMSECUPOL || 'I.CODCAMPO ' ||
                         I.CODCAMPO || ' P_VALORCAMPO' || P_VALORCAMPO);
          END IF;
        
          P_VALORCAMPO := SIM_PCK_REGLAS.G_PARAMETROS('B99_NTVALORCAMPOEN');
          SIM_PROC_LOG('AEEM_TERR',
                       'PDE2 2049 ' || IP_NUMSECUPOL || 'I.CODCAMPO ' ||
                       I.CODCAMPO || ' P_VALORCAMPO' || P_VALORCAMPO);
        
        ELSIF I.CODCAMPO IN ('COD_ASEG', 'TIPO_DOC_ASEG') AND
              IP_PROCESO.P_COD_SECC NOT IN (20, 21, 22, 29, 25, 18) THEN
          SIM_PCK_PROCESO_DATOS_EMISION.PROC_INICIALIZA_DV_ASEGURADO(IP_NUMSECUPOL,
                                                                     IP_CODRIES,
                                                                     IP_PROCESO);
        END IF;
      
        P_INCLUYE     := SIM_PCK_REGLAS.G_PARAMETROS('B99_INCLUYE');
        P_DESCRIPCION := SUBSTR(SIM_PCK_REGLAS.G_PARAMETROS('B99_NTDESCRI'),
                                1,
                                50);
        P_DISABLEDATO := SIM_PCK_REGLAS.G_PARAMETROS('B99_NTSALTO');
      
        IF P_DESCRIPCION = ' ' THEN
          P_DESCRIPCION := SUBSTR(I.DESCRIPCION, 1, 50);
        END IF;
      
        IF P_DISABLEDATO IS NOT NULL THEN
          P_DISABLEDATO := 'S';
        ELSE
          P_DISABLEDATO := 'N';
        END IF;
      
        /* BANCAN3-37: AJuste de liquidacion y Cotizacion de autos electricos */
      
        SIM_PCK_PROCESO_DATOS_EMISION2.VALIDAROPCIONAUTOSELECTRICOS(IP_PROCESO.P_INFO5,
                                                                    IP_NUMSECUPOL,
                                                                    I.CODCAMPO,
                                                                    IP_CODRIES,
                                                                    IP_PROCESO.P_SISTEMA_ORIGEN,
                                                                    P_VALORCAMPO);
      
        SIM_PROC_LOG('AEEM_TERR',
                     'PDE2 22081 ' || IP_NUMSECUPOL || 'I.CODCAMPO ' ||
                     I.CODCAMPO || ' P_VALORCAMPO' || P_VALORCAMPO);
        -- DHH MASB almacena informacion de datos variables para reutilizar en cotizacion autos             
        SIM_PCK_CACHE_EMISION.FACHADAALMDATOVARIABLE(IP_PROCESO      => IP_PROCESO,
                                                     IP_CODRIES      => IP_CODRIES,
                                                     IP_CODCAMPO     => I.CODCAMPO,
                                                     IP_VALORCAMPO   => P_VALORCAMPO,
                                                     IP_DISABLE      => P_DISABLEDATO,
                                                     IP_DESCRIPCION  => P_DESCRIPCION,
                                                     IP_INCLUYE      => P_INCLUYE,
                                                     IP_EJECUTOREGLA => L_EJECUTOREGLA);
        /* FINALIZA IDENTIFICACION OFERTA ELECTRICOS */
        IF P_ENTRO = FALSE THEN
          SIM_PCK_PROCESO_DATOS_EMISION.PROC_ACTUALIZA_PRECAMPO(L_EJECUTOREGLA,
                                                                I.CODCAMPO,
                                                                IP_NUMSECUPOL,
                                                                IP_CODRIES,
                                                                P_VALORCAMPO,
                                                                IP_CODCOB,
                                                                P_DISABLEDATO,
                                                                P_DESCRIPCION,
                                                                P_INCLUYE);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_PRECAMPODVARIABLES;

  PROCEDURE PROC_PROCESAR_DV(IP_NUMSECUPOL  IN NUMBER,
                             IP_CODRIES     IN NUMBER,
                             IP_NIVEL       IN VARCHAR2,
                             IP_COBERTURA   IN NUMBER,
                             IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                             OP_ARRCONTEXTO OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                             IP_PROCESO     IN SIM_TYP_PROCESO,
                             OP_RESULTADO   OUT NUMBER,
                             OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    L_TIPONEGOCIO  SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_PRECAMPO     SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_NULL         SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_CODCAMPO     SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_VALORCAMPOEN SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    LI_CONTEXTO    SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    LO_CONTEXTO    SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    L_DISABLE      SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_ANEXO        SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_VISIBLE      SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_BIEN         NUMBER; -- SIMON API
    CURSOR DATOS IS
      SELECT A.COD_CAMPO,
             COD_REG_VAL1,
             REG_PRE_FIELD,
             VALOR_CAMPO_EN,
             ACEPTA_NULL,
             OBLIGATORIO,
             T.NUM_SECU
        FROM X2000020 T, SIM_G2000020 A
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND A.COD_CAMPO = T.COD_CAMPO
         AND A.COD_CIA = IP_PROCESO.P_COD_CIA
         AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND ((NVL(T.COD_RIES, 0) = 0 AND NVL(IP_CODRIES, 0) = 0) OR
             (T.COD_RIES = IP_CODRIES AND NVL(IP_CODRIES, 0) > 0))
         AND T.COD_NIVEL = DECODE(IP_NIVEL, NULL, T.COD_NIVEL, IP_NIVEL)
         AND NVL(T.COD_COB, 0) =
             DECODE(T.COD_NIVEL, 3, IP_COBERTURA, NVL(T.COD_COB, 0)) --decode(p_codcob,NULL,nvl(t.cod_cob,0),p_CodCob)
         AND (T.MCA_VISIBLE = 'S' OR
             (IP_NIVEL = 3 AND IP_PROCESO.P_CANAL = 3))
         AND A.ESTADO = 'A'
         AND (L_BIEN = 0 OR
             (L_BIEN > 0 AND
             A.COD_CAMPO NOT IN
             (SELECT DISTINCT COD_CAMPO FROM SIMAPI_DATVAR_BIEN)))
      UNION
      SELECT A.COD_CAMPO,
             COD_REG_VAL1,
             REG_PRE_FIELD,
             VALOR_CAMPO_EN,
             ACEPTA_NULL,
             OBLIGATORIO,
             T.NUM_SECU
        FROM X2000020                   T,
             SIM_G2000020               A,
             SIMAPI_DATVAR_BIEN         H,
             SIMAPI_DATVAR_BIEN_EST_ENT I
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND A.COD_CAMPO = T.COD_CAMPO
         AND A.COD_CIA = IP_PROCESO.P_COD_CIA
         AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND ((NVL(T.COD_RIES, 0) = 0 AND NVL(IP_CODRIES, 0) = 0) OR
             (T.COD_RIES = IP_CODRIES AND NVL(IP_CODRIES, 0) > 0))
         AND T.COD_NIVEL = DECODE(IP_NIVEL, NULL, T.COD_NIVEL, IP_NIVEL)
         AND NVL(T.COD_COB, 0) =
             DECODE(T.COD_NIVEL, 3, IP_COBERTURA, NVL(T.COD_COB, 0)) --decode(p_codcob,NULL,nvl(t.cod_cob,0),p_CodCob)
         AND (T.MCA_VISIBLE = 'S' OR IP_PROCESO.P_CANAL = 7 OR
             (IP_PROCESO.P_CANAL = 2 AND I.VISIBLE = 'S') OR -- RPR Renovaciones Simon 3.0
             -- 30/07/2022 RW : Código revivido debido a un borrado. CTR-Cambios 10476
             (IP_NIVEL = 3 AND IP_PROCESO.P_CANAL = 3))
         AND A.ESTADO = 'A'
         AND H.ID_BIEN = L_BIEN
         AND H.COD_CAMPO = A.COD_CAMPO
            -- and i.cod_cia   = a.cod_cia /* DORIS RAMIREZ: EN OFERTAS-SIMON 3.0 LOS BIENES NO MANEJAN COMPANIA NI RAMO */
            -- and i.cod_ramo  = a.cod_ramo
         AND I.ID_BIEN = H.ID_BIEN
         AND I.COD_CAMPO = H.COD_CAMPO
         AND I.ESTADO = 'A'
         AND I.ENTIDAD_COLOCADORA = IP_PROCESO.P_ENTIDAD_COLOCADORA
         AND I.ID_ESTRATEGIA =
             (SELECT TO_NUMBER(VALOR_CAMPO)
                FROM X2000020 K
               WHERE K.NUM_SECU_POL = IP_NUMSECUPOL
                 AND K.COD_RIES IS NULL
                 AND K.COD_CAMPO = 'API_ESTRATEGIA'
                 AND K.VALOR_CAMPO IS NOT NULL)
         AND I.SIM_VERSION_EST =
             (SELECT MAX(J.SIM_VERSION_EST)
                FROM SIMAPI_ESTRATEGIA_ENT J
               WHERE I.ID_ESTRATEGIA = J.ID_ESTRATEGIA
                 AND I.ENTIDAD_COLOCADORA = J.ENTIDAD_COLOCADORA
                 AND J.MCA_AUTORIZACION = 'A'
                 AND J.ESTADO = 'A')
       ORDER BY 7;
    --WHERE  NUM_SECU_POl = IP_NumSecuPol
    --  AND  NVL(MCA_PPTO,'N') = DECODE(l_TipoNegocio, 2,'S',NVL(MCA_PPTO,'N'))
    --  AND ((COD_RIES  = IP_CodRies AND IP_CodRies is not null) Or
    --       (COD_RIES is Null and IP_CodRies is null))
    --  AND  NVL(MCA_VISIBLE,'S') = 'S'
    --  AND  MCA_TIPO_UTIL = IP_Nivel
    --  AND ((COD_COB IS NULL and IP_Nivel != 3) OR (COD_COB = IP_Cobertura AND IP_Nivel = 3))
    --  AND  (REG_PRE_FIELD IS NOT NULL OR COD_REG_VAL1 IS NOT NULL)
    --ORDER BY MCA_TIPO_UTIL, NUM_SECU;
  
  BEGIN
    G_SUBPROGRAMA := '.proc_Procesar_DatosVar ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
    OP_ARRCONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
  
    BEGIN
      L_TIPONEGOCIO := SIM_PCK_REGLAS.G_PARAMETROS('B99_NTPOLPRES');
    EXCEPTION
      WHEN OTHERS THEN
        L_TIPONEGOCIO := '1';
    END;
  
    BEGIN
      L_PRECAMPO := SIM_PCK_REGLAS.G_PARAMETROS('B99_EJECUTO_PRECAMPO');
    EXCEPTION
      WHEN OTHERS THEN
        L_PRECAMPO := 'S';
    END;
    -- SIMON API
    BEGIN
      IF IP_PROCESO.P_COD_SECC IN (922, 923) THEN
        L_BIEN := FUN_RESCATA_X2000020('BIEN_ASEGURADO',
                                       IP_NUMSECUPOL,
                                       IP_CODRIES);
        L_BIEN := NVL(L_BIEN, 0);
      ELSE
        L_BIEN := 0;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        L_BIEN := 0;
    END;
    -- SIMON API
  
    SIM_PROC_LOG('PROCESARDV', 'Ip_Numsecupol:' || IP_NUMSECUPOL);
    SIM_PROC_LOG('PROCESARDV',
                 'Ip_Proceso.p_Cod_Cia:' || IP_PROCESO.P_COD_CIA);
    SIM_PROC_LOG('PROCESARDV',
                 'Ip_Proceso.p_Cod_Producto.' || IP_PROCESO.P_COD_PRODUCTO);
    SIM_PROC_LOG('PROCESARDV', 'Ip_Codries:' || IP_CODRIES);
    SIM_PROC_LOG('PROCESARDV', 'Ip_Nivel:' || IP_NIVEL);
    SIM_PROC_LOG('PROCESARDV', 'Ip_Proceso.p_Canal:' || IP_PROCESO.P_CANAL);
    SIM_PROC_LOG('PROCESARDV', 'Ip_Cobertura:' || IP_COBERTURA);
  
    COMMIT;
  
    FOR I IN DATOS LOOP
      L_CODCAMPO     := I.COD_CAMPO;
      L_VALORCAMPOEN := I.VALOR_CAMPO_EN;
    
      /* IF i.cod_campo = 'CATEGORIA' THEN
            sim_proc_log('RT valordescries ',i.valor_campo_en);
         END IF;
      
         Dbms_Output.Put_Line('Precampo Dv ' || Ip_Numsecupol || '-' ||
                              i.Cod_Campo || ' valor ' || i.Valor_Campo_En || ',' ||
                              l_Precampo || '-' || i.Reg_Pre_Field);
      */
      -- INICIO CTR-Cambios 10476  30/07/2022 RW : Código revivido debido a un borrado.
      --Implementado por teodolfo / Juan Gonzalez : inserta en la variable de contexto el sexo_vip (15.10.2021): Oferta de valor
      IF IP_PROCESO.P_COD_PRODUCTO IN (950, 952, 960) THEN
        IF I.COD_CAMPO = 'SEXO_VIP' THEN
          SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_SEXO',
                                              I.VALOR_CAMPO_EN);
        END IF;
      END IF;
    
      --Implementado por teodolfo / Juan Gonzalez : inserta en la variable de contexto el sexo_vip (15.10.2021): Oferta de valor
      -- INICIA ODVVI-2278 Rwinter Se agregan los productos 956 y 958
      IF IP_PROCESO.P_COD_PRODUCTO IN (954, 956, 958) THEN
        -- FIN ODVVI-2278
        IF I.COD_CAMPO = 'SEXO_BONA' THEN
          SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_SEXO',
                                              I.VALOR_CAMPO_EN);
        END IF;
      END IF;
      -- FIN CTR-Cambios 10476
    
      SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTVALORCAMPOEN',
                                          L_VALORCAMPOEN);
    
      IF I.REG_PRE_FIELD IS NOT NULL AND L_PRECAMPO = 'S' THEN
        LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
        SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
      
        PROC_PRECAMPODVARIABLES(IP_NUMSECUPOL,
                                IP_CODRIES,
                                L_CODCAMPO,
                                IP_NIVEL,
                                IP_COBERTURA,
                                LI_CONTEXTO,
                                LO_CONTEXTO,
                                IP_PROCESO,
                                OP_RESULTADO,
                                OP_ARRERRORES);
      
        SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
        L_VALORCAMPOEN := SIM_PCK_REGLAS.G_PARAMETROS('B99_NTVALORCAMPOEN');
      END IF;
    
      IF OP_RESULTADO = 0 THEN
        IF I.COD_REG_VAL1 IS NOT NULL AND
           (L_VALORCAMPOEN IS NOT NULL OR
           (L_VALORCAMPOEN IS NULL AND I.OBLIGATORIO = 'S' AND
           I.ACEPTA_NULL = 'N')) THEN
          --          dbms_output.put_line('valida Dv '||i.cod_campo||' valor '||i.valor_campo_en);
          SELECT NVL(A.MCA_HAB_MOD, 'N'), B.RAMO_ANEXO, A.MCA_VISIBLE
            INTO L_DISABLE, L_ANEXO, L_VISIBLE
            FROM X2000020 A, G2000020 B
           WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
             AND A.COD_CAMPO = B.COD_CAMPO
             AND B.COD_CIA = IP_PROCESO.P_COD_CIA
             AND B.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
             AND NVL(A.COD_RIES, 0) = NVL(IP_CODRIES, 0)
             AND A.COD_CAMPO = L_CODCAMPO;
        
          IF L_ANEXO IS NOT NULL AND L_VISIBLE = 'N' THEN
            L_DISABLE := 'S';
          END IF;
        
          IF L_DISABLE = 'N' THEN
            --              dbms_output.put_line('valida no disable Dv '||i.cod_campo||' valor '||i.valor_campo_en);
            LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
            SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
          
            SIM_PCK_PROCESO_DATOS_EMISION.PROC_VALIDACION_DVARIABLES(IP_NUMSECUPOL,
                                                                     IP_CODRIES,
                                                                     L_CODCAMPO,
                                                                     L_VALORCAMPOEN,
                                                                     'N',
                                                                     LI_CONTEXTO,
                                                                     LO_CONTEXTO,
                                                                     IP_PROCESO,
                                                                     OP_RESULTADO,
                                                                     OP_ARRERRORES);
          
            SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
          END IF;
        
          IF OP_RESULTADO != 0 THEN
            EXIT;
          END IF;
        END IF;
      ELSE
        EXIT;
      END IF;
    END LOOP;
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  END;

  /*--------------------------------*/
  PROCEDURE PROC_PROCESAR_RIESGO(IP_NUMSECUPOL  IN NUMBER,
                                 IP_CODRIES     IN NUMBER,
                                 IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                 OP_ARRCONTEXTO OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                 IP_PROCESO     IN SIM_TYP_PROCESO,
                                 OP_RESULTADO   OUT NUMBER,
                                 OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    L_NULL              SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_CODNIVEL          SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO;
    L_PROCESODV         SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_PROCESOCOB        SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_EJECUTOCT         SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_NIVEL             NUMBER;
    L_COBERTURA         NUMBER;
    P_REGLA             SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    LI_CONTEXTO         SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    LO_CONTEXTO         SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    L_EXISTE            SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_NIVELCT           SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_ARRLISTA          SIM_TYP_ARRAY_LISTA;
    L_HABILITATABRIESGO SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_OPCION            NUMBER;
    L_OPCIONCAR         VARCHAR2(2);
    L_LLAMACTNIVEL1     SIM_PCK_TIPOS_GENERALES.T_CARACTER := SIM_PCK_TIPOS_GENERALES.C_SI;
    L_LLAMACTNIVEL4     SIM_PCK_TIPOS_GENERALES.T_CARACTER := SIM_PCK_TIPOS_GENERALES.C_SI;
    L_LLAMACTNIVELC     SIM_PCK_TIPOS_GENERALES.T_CARACTER := SIM_PCK_TIPOS_GENERALES.C_SI;
  BEGIN
    /*Autos Nomina Cumulos */
  
    G_SUBPROGRAMA := '.proc_Procesar_Riesgo ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
    /* Inicializa Pasos a Ejecutar segun variables de contexto */
    -- sim_proc_log('Total  procesar variable codries ','');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODRIES', IP_CODRIES);
  
    PROC_INICIALIZA_PASOS(IP_ARRCONTEXTO,
                          L_PROCESODV,
                          L_PROCESOCOB,
                          L_EJECUTOCT);
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
    /* Inicia proceso */
    P_REGLA := '299PCI015';
  
    BEGIN
      SIM_PCK_REGLAS.G_TERMINA := 'N';
      SIM_PCK_REGLAS.INVOCARREGLA(P_REGLA);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20000,
                                'Error Regla ' || P_REGLA || ' Riesgo ' ||
                                IP_CODRIES);
    END;
  
    -- sim_proc_log('Total  procesar Copia Datos V ','');
    /* Sincroniza datos variables*/
    SIM_PCK_PROCESO_DML_EMISION.PROC_COPIA_DVPOL_SIM_X_RIESGO(IP_NUMSECUPOL,
                                                              IP_CODRIES);
  
    --sim_proc_log('Total  procesar sale d ecopia DV ',ip_proceso.p_cod_secc||'-'||ip_proceso.p_cod_producto);
    IF SIM_PCK_FUNCION_GEN.ES_AUTOS(IP_PROCESO.P_COD_SECC,
                                    IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
      LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
      SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
      --    sim_proc_log('Total  contexto desde procesar riesgo ','');
      SIM_PCK_CONTEXTO_EMISION.PROC_CONTEXTODATOSAUTOS(IP_NUMSECUPOL,
                                                       IP_CODRIES,
                                                       LI_CONTEXTO,
                                                       LO_CONTEXTO,
                                                       IP_PROCESO,
                                                       OP_RESULTADO,
                                                       OP_ARRERRORES);
    
      /*If Op_Resultado = -1 Then
       Raise_Application_Error(-20000, 'Error en contexto datos autos');
      End If;*/
    
      SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
    END IF;
    IF OP_RESULTADO = 0 THEN
      BEGIN
        LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
        SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
        --sim_proc_log('Total  procesar Reglas selecciony precoberturas','');
        SIM_PCK_FUN_AGRUP_EMISION.PROC_VAL_ARRAYCAMPOSRIESGOVAL(IP_NUMSECUPOL,
                                                                IP_CODRIES,
                                                                LI_CONTEXTO,
                                                                LO_CONTEXTO,
                                                                IP_PROCESO,
                                                                OP_RESULTADO,
                                                                OP_ARRERRORES);
        SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
      END;
    
      IF L_PROCESODV = 'S' THEN
        L_NIVEL     := 2;
        LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
        SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
      
        IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
          L_OPCION := 0;
        
          BEGIN
            -- Call the procedure
            SIM_PCK_CONSULTA_EMISION2.PROC_CALCULAOPCVIDA(IP_NUMSECUPOL,
                                                          IP_CODRIES,
                                                          L_OPCION,
                                                          IP_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
          END;
        
          BEGIN
            UPDATE X2000020
               SET VALOR_CAMPO = L_OPCION, VALOR_CAMPO_EN = L_OPCION
             WHERE NUM_SECU_POL = IP_NUMSECUPOL
               AND COD_RIES = IP_CODRIES
               AND COD_CAMPO = 'OPCION_ASEG';
          END;
        END IF;
      
        PROC_PROCESAR_DV(IP_NUMSECUPOL,
                         IP_CODRIES,
                         L_NIVEL,
                         L_COBERTURA,
                         LI_CONTEXTO,
                         LO_CONTEXTO,
                         IP_PROCESO,
                         OP_RESULTADO,
                         OP_ARRERRORES);
        SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
      
        IF OP_RESULTADO = 0 THEN
          /* Manuel Orjuela 22-Abr-2015 para que seleccione la opcion de asegurabilidad
          en vida cuando viene de atgc */
          --If Ip_Proceso.p_Cod_Cia = 2 And  Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
          /*    If Sim_Pck_Funcion_Gen.Esproductoatgcvida(Ip_Proceso.p_Cod_Producto) = 'S' Then
                 l_Opcion := 0;
          
                 Begin
                  -- Call the procedure
                  Sim_Pck_Consulta_Emision2.Proc_Calculaopcvida(Ip_Numsecupol,
                                                                Ip_Codries,
                                                                l_Opcion,
                                                                Ip_Proceso,
                                                                Op_Resultado,
                                                                Op_Arrerrores);
                 End;
          
                 Begin
                  Update X2000020
                     Set Valor_Campo = l_Opcion, Valor_Campo_En = l_Opcion
                   Where Num_Secu_Pol = Ip_Numsecupol
                     And Cod_Ries = Ip_Codries
                     And Cod_Campo = 'OPCION_ASEG';
                 End;
                End If;
          */
          L_NIVEL     := 5;
          LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
          SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
          PROC_PROCESAR_DV(IP_NUMSECUPOL,
                           IP_CODRIES,
                           L_NIVEL,
                           L_COBERTURA,
                           LI_CONTEXTO,
                           LO_CONTEXTO,
                           IP_PROCESO,
                           OP_RESULTADO,
                           OP_ARRERRORES);
          SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
        END IF;
      END IF;
    END IF;
    IF OP_RESULTADO = 0 THEN
      /* Contexto de Riesgos */
    
      LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
      SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
      SIM_PCK_CONTEXTO_EMISION.PROC_CONTEXTODATOSRIESGO(IP_NUMSECUPOL,
                                                        IP_CODRIES,
                                                        LI_CONTEXTO,
                                                        LO_CONTEXTO,
                                                        IP_PROCESO,
                                                        OP_RESULTADO,
                                                        OP_ARRERRORES);
      SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
    
      --   If Op_Resultado = 0 Then   se ajusta para que ingrese con clientes PEP
      IF OP_RESULTADO != -1 THEN
      
        --sim_proc_log('Total  procesar coberturas codries ','');
      
        IF L_PROCESOCOB = 'S' THEN
          /*  regla de seleccion y calculo */
          LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
          SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
        
          SIM_PCK_FUN_AGRUP_EMISION.PROC_SELPRECOBERTURAPOL(IP_NUMSECUPOL,
                                                            IP_CODRIES,
                                                            LI_CONTEXTO,
                                                            LO_CONTEXTO,
                                                            IP_PROCESO,
                                                            OP_RESULTADO,
                                                            OP_ARRERRORES);
          SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
          --Commit;
          /* En vida, la regla de precobertura estó calculando valores iniciales
          y sobreescribiendo los valores que trae el cotizador. Deben actualizarse
          entonces los valores nuevamente de acuerdo a lo que traiga el cotizador
          Wesv 20131227*/
        
          --         IF ip_proceso.p_proceso IN (201,221,241)
          IF IP_PROCESO.P_COD_CIA = 2 AND
             IP_PROCESO.P_COD_SECC IN (46, 47, 48) THEN
            BEGIN
              UPDATE X2000040 A
                 SET A.SUMA_ASEG     = NVL(A.SUMA_ASEG_CONS, 0),
                     A.END_SUMA_ASEG = NVL(A.SUMA_ASEG_CONS, 0),
                     A.COD_SELECC    = 'S'
               WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                 AND A.COD_RIES = IP_CODRIES
                 AND NVL(A.SUMA_ASEG_CONS, 0) != 0;
            END;
          END IF;
        
          /*Se debe revisar para verificar en el procedimiento
          anterior que grabe cero en vez de nulo, por que al dejar
          nulo no hace disparar el siguiente procedimiento de regla*/
        
          BEGIN
            UPDATE X2000040 A
               SET A.SUMA_ASEG     = NVL(A.SUMA_ASEG, 0),
                   A.END_SUMA_ASEG = NVL(A.END_SUMA_ASEG, 0)
             WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
               AND A.COD_RIES = IP_CODRIES;
          END;
        
          /*Fin       ajuste vida*/
        
          IF OP_RESULTADO = 0 THEN
            /* Manuel Orjuela 22-Abr-2015 para que complete la información si liquida extraprima vida */
            --If Ip_Proceso.p_Cod_Cia = 2 And Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
            IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
            
              --Sim_Proc_Log('INGRESAEXTRAPRIMA', Ip_Numsecupol);
            
              BEGIN
                -- Coloca las tasas si tiene extraprima
                SIM_PCK_REGLASNEGOCIO.SIM_P230_PTV150(IP_NUMSECUPOL,
                                                      0,
                                                      IP_CODRIES,
                                                      IP_PROCESO.P_COD_PRODUCTO);
              END;
            
              L_OPCIONCAR := NULL;
            
              BEGIN
                SIM_PCK_CONSULTA_EMISION2.PROC_EVALUAOPCREASEG(IP_NUMSECUPOL,
                                                               IP_CODRIES,
                                                               L_OPCIONCAR,
                                                               IP_PROCESO,
                                                               OP_RESULTADO,
                                                               OP_ARRERRORES);
              END;
            
              BEGIN
                UPDATE X2000020
                   SET VALOR_CAMPO    = L_OPCIONCAR,
                       VALOR_CAMPO_EN = L_OPCIONCAR,
                       CLAUSULAS      = DECODE(L_OPCIONCAR,
                                               'ST',
                                               'STANDARD', --Juan González 03012018 Validacion para extraprimas Vida Individual
                                               'S1',
                                               'SUBNORMAL SALUD',
                                               'S2',
                                               'SUBNORMAL OCUPACION ',
                                               'S3',
                                               'SUBNORMAL L. V.')
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_RIES = IP_CODRIES
                   AND COD_CAMPO = 'TIPO_RIES';
              END;
            
              IF L_OPCIONCAR = 'S1' THEN
                BEGIN
                  UPDATE X2000020 N
                     SET N.VALOR_CAMPO    = 2,
                         N.VALOR_CAMPO_EN = 2,
                         N.CLAUSULAS      = 'SUBNORMAL SALUD'
                   WHERE NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_RIES = IP_CODRIES
                     AND COD_CAMPO = 'TIPO_RIES_RE';
                END;
              END IF;
            END IF;
          
            /*Fin 22-Abr-2015*/
            /*
             Vida Grupo extra premium calculation
             Seguros de Vida , TraQIQ_20200111
             starts
            */
            IF SIM_PCK_ATGC_VIDA_GRUPO.FUN_ESRAMOATGCVIDAGRUPO(IP_PROCESO.P_COD_CIA,
                                                               IP_PROCESO.P_COD_SECC,
                                                               IP_PROCESO.P_COD_PRODUCTO) = 'S' AND
               IP_PROCESO.P_COD_PRODUCTO NOT IN (721, 710, 793, 799) THEN
              BEGIN
                SIM_PCK_REGLASNEGOCIO.CALCULOEXTRAPRIMAVIDAGRUPO(IP_NUMSECUPOL,
                                                                 0,
                                                                 IP_CODRIES,
                                                                 IP_PROCESO.P_COD_PRODUCTO);
              END;
            END IF;
            /*
             Vida Grupo extra premium calculation
             Seguros de Vida , TraQIQ_20200111
             ends
            */
          
            /* Calculo prima cobertura */
            LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
            SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
          
            SIM_PCK_CONTEXTO_EMISION.PROC_CALCULAPRIMACOBERTURA(IP_NUMSECUPOL,
                                                                IP_CODRIES,
                                                                LI_CONTEXTO,
                                                                LO_CONTEXTO,
                                                                IP_PROCESO,
                                                                OP_RESULTADO,
                                                                OP_ARRERRORES);
            SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
          END IF;
        END IF;
      
        IF OP_RESULTADO = 0 THEN
          IF L_EJECUTOCT = 'S' THEN
            L_NIVELCT   := 'DC';
            LI_CONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
            SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_CONTEXTO);
          
            -->Inicia Modificacion para Cumplimiento. 11/09/2015 - jlrodriguez@asesoftware.com
            -->Control para ejecución de CT en expedición de hija de cotización
            BEGIN
              SELECT NVL(A.DAT_CAR, 'S'),
                     NVL(A.DAT_CAR2, 'S'),
                     NVL(A.DAT_CAR3, 'S')
                INTO L_LLAMACTNIVEL1, L_LLAMACTNIVELC, L_LLAMACTNIVEL4
                FROM C9999909 A
               WHERE A.COD_TAB = 'SIM_DISPARA_PROC'
                 AND A.COD_CIA = IP_PROCESO.P_COD_CIA
                 AND A.COD_SECC = IP_PROCESO.P_COD_SECC
                 AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                 AND A.CODIGO1 = IP_PROCESO.P_PROCESO;
            EXCEPTION
              WHEN OTHERS THEN
                L_LLAMACTNIVEL1 := SIM_PCK_TIPOS_GENERALES.C_SI;
                L_LLAMACTNIVEL4 := SIM_PCK_TIPOS_GENERALES.C_SI;
                L_LLAMACTNIVELC := SIM_PCK_TIPOS_GENERALES.C_SI;
            END;
          
            IF L_LLAMACTNIVELC = 'S' THEN
              -->Fin Modificacion para Cumplimiento. 11/09/2015 - jlrodriguez@asesoftware.com
              SIM_PCK_CONTROL_TECNICO.PROC_EJECUTA_CONTROL_TECNICO(IP_NUMSECUPOL,
                                                                   L_NIVELCT,
                                                                   L_EXISTE,
                                                                   'N',
                                                                   LI_CONTEXTO,
                                                                   LO_CONTEXTO,
                                                                   IP_PROCESO,
                                                                   OP_RESULTADO,
                                                                   OP_ARRERRORES);
              SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_CONTEXTO);
            END IF;
          
          END IF;
        END IF;
      END IF;
    END IF;
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
    
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_BORRARTABLASREALES(IP_NUMSECUPOL NUMBER) IS
    -- Procedimiento para reemplazar el codigo existente en 2 partes del programa
    -- Wilson Sacristan  -- 20160801
  BEGIN
    DELETE A2000030 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2000020 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2000040 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2000060 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE SIM_DEBITO_AUTOMATICO WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2000220 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2040100 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2040200 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2040300 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2040400 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2000160 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2000250 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2000190 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A2001300 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE A9990100 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE SIM_TERCEROS WHERE NUM_SECU_POL = IP_NUMSECUPOL;
  
    --intasi31-Rosario Puertas 06072016
    DELETE C2000251 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE SIM_RIESGO_POLIZA WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    --  DELETE Sim_x_Riesgo_Poliza WHERE num_secu_pol = ip_numSecuPol;
    -- fin intasi31 Rosario Puertas 06072016
    --Incluida por Wesv -- 2016 08 01
  
    DELETE SIM_CONTROL_DOCUMENTOS_PROCESO
     WHERE NUM_SECU_POL = IP_NUMSECUPOL;
  
  END;

  /*-------------------------------*/
  /* Abuelvas: Se crea funcion para obtener placas default */
  FUNCTION FUN_VALIDAR_PLACA_DEFAULT(PLACA IN A2000410.PAT_VEH%TYPE)
    RETURN VARCHAR2 IS
  
    V_EXISTE VARCHAR2(1);
  
  BEGIN
    SELECT DECODE(COUNT(1), 0, 'N', 'S')
      INTO V_EXISTE
      FROM C9999909 A, C9999910 B
     WHERE A.COD_TAB = B.COD_TAB
       AND B.ESTADO = 'A'
       AND A.DAT_CAR = PLACA
       AND A.COD_TAB = 'PLACAS_DEFAULT';
  
    RETURN V_EXISTE;
  END FUN_VALIDAR_PLACA_DEFAULT;

  PROCEDURE COMPLEMENTADATOSREQUEST(IP_POLIZA SIM_TYP_POLIZAGEN,
                                    OP_POLIZA OUT SIM_TYP_POLIZAGEN) IS
    -- procedimiento para complementar los datos de ip_poliza para el servicio
    -- de cotización de poliza desde el servivio web externo, teniendo en cuenta
    -- que solamente se reciben los datos del numSecuPol e información adicional
    -- del tercero. El objeto de salida será la entrada para el proceso de
    -- cotización -- Wesv 20200609
    REG_X2000030   X2000030%ROWTYPE;
    REG_X_TERCEROS SIM_X_TERCEROS%ROWTYPE;
    REG_X2000020   X2000020%ROWTYPE;
    REG_X2040400   X2040400%ROWTYPE;
    REG_X2040100   X2040100%ROWTYPE;
    L_TIPDOCTOM    REG_X_TERCEROS.TIPO_DOCUMENTO%TYPE;
    L_NUMDOCTOM    REG_X_TERCEROS.NUMERO_DOCUMENTO%TYPE;
    L_NUMSECUPOL   NUMBER;
    --Abuelvas: 12-03-2021: Se definen variables
    L_PLACAAUX    X2040100.PAT_VEH%TYPE;
    IP_VALIDACION VARCHAR2(16);
    OP_ARRERRORES SIM_TYP_ARRAY_ERROR;
    IP_PROCESO    SIM_TYP_PROCESO;
    OP_RESULTADO  NUMBER := 0;
    --WRLopez: Variable para dato variable
    L_VARIABLES1 SIM_TYP_DATOS_VARIABLESGEN;
  
  BEGIN
    OP_POLIZA    := IP_POLIZA;
    L_NUMSECUPOL := IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
    IF NVL(L_NUMSECUPOL, 0) = 0 THEN
      RAISE_APPLICATION_ERROR(-20601, 'Numero de secuencia inexistente');
    END IF;
    BEGIN
      SELECT R.*
        INTO REG_X2000030
        FROM X2000030 R
       WHERE R.NUM_SECU_POL = L_NUMSECUPOL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20602, 'Numero de secuencia inexistente');
    END;
    BEGIN
      -- verifica que la placa enviada corresponda al numsecuPol enviado
      BEGIN
        SELECT R.*
          INTO REG_X2040100
          FROM X2040100 R
         WHERE R.NUM_SECU_POL = L_NUMSECUPOL
              -- por ahora solo asume poliza individual
           AND R.PAT_VEH = OP_POLIZA.DATOSVEHICULOS(1).PAT_VEH;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20603,
                                  'Secuencia no válida para la placa enviada');
      END;
    END;
  
    BEGIN
      IF FUN_VALIDAR_PLACA_DEFAULT(OP_POLIZA.DATOSVEHICULOS(1).PAT_VEH) = 'S' THEN
        ------------------------------------------------------------
        SIM_PCK_ACCESO_SERVICIOS.PROC_RETORNAPLACAVEHNUEVO(L_PLACAAUX,
                                                           IP_VALIDACION,
                                                           IP_PROCESO,
                                                           OP_RESULTADO,
                                                           OP_ARRERRORES);
      
        UPDATE X2040100 D
           SET D.PAT_VEH = L_PLACAAUX
         WHERE D.NUM_SECU_POL = L_NUMSECUPOL;
        --commit;
      END IF;
      ---------------------------------------------------------------------
    END;
  
    FOR I IN 1 .. IP_POLIZA.DATOSTERCEROS.COUNT LOOP
      BEGIN
        SELECT *
          INTO REG_X_TERCEROS
          FROM SIM_X_TERCEROS SXT
         WHERE SXT.NUM_SECU_POL = L_NUMSECUPOL
           AND SXT.ROL = IP_POLIZA.DATOSTERCEROS(I).ROL;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
      END;
      IF IP_POLIZA.DATOSTERCEROS(I).ROL = 2 THEN
        L_TIPDOCTOM := REG_X_TERCEROS.TIPO_DOCUMENTO;
        L_NUMDOCTOM := REG_X_TERCEROS.NUMERO_DOCUMENTO;
      END IF;
      OP_POLIZA.DATOSTERCEROS(I).TIPO_DOCUMENTO := NVL(REG_X_TERCEROS.TIPO_DOCUMENTO,
                                                       L_TIPDOCTOM);
      OP_POLIZA.DATOSTERCEROS(I).NUMERO_DOCUMENTO := NVL(REG_X_TERCEROS.NUMERO_DOCUMENTO,
                                                         L_NUMDOCTOM);
      OP_POLIZA.DATOSTERCEROS(I).NOMBRES := REG_X_TERCEROS.NOMBRES;
      OP_POLIZA.DATOSTERCEROS(I).APELLIDOS := REG_X_TERCEROS.APELLIDOS;
      --      op_poliza.datosTerceros(i).direccion := se supone que llega
    --      op_poliza.datosTerceros(i).ciudad :=  se supone que llega
    --      op_poliza.datosTerceros(i).telefono :=  se supone que llega
    --      op_poliza.datosTerceros(i).celular :=  se supone que llega
    --       op_poliza.datosTerceros(i).mail :=  se supone que llega
    END LOOP;
  
    -- Actualiza datosFijosPoliza
    OP_POLIZA.DATOSFIJOS.COD_CIA.CODIGO        := REG_X2000030.COD_CIA;
    OP_POLIZA.DATOSFIJOS.COD_SECC.CODIGO       := REG_X2000030.COD_SECC;
    OP_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO       := REG_X2000030.COD_RAMO;
    OP_POLIZA.DATOSFIJOS.COD_PROD.CODIGO       := REG_X2000030.COD_PROD;
    OP_POLIZA.DATOSFIJOS.NUM_SECU_POL          := NULL; -- lo deja en null para cotixar
    OP_POLIZA.DATOSFIJOS.PERIODO_FACT.CODIGO   := REG_X2000030.PERIODO_FACT;
    OP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO    := REG_X2000030.NRO_DOCUMTO;
    OP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO   := REG_X2000030.TDOC_TERCERO;
    OP_POLIZA.DATOSFIJOS.SIM_TIPO_ENVIO.CODIGO := REG_X2000030.SIM_TIPO_ENVIO;
  
    -- Actualiza datosVariablesPoliza
    FOR I IN 1 .. OP_POLIZA.DV_POLIZA.COUNT LOOP
      OP_POLIZA.DV_POLIZA(I).NUM_SECU_POL := NULL;
      FOR C1 IN (SELECT *
                   FROM X2000020 X20
                  WHERE X20.NUM_SECU_POL = L_NUMSECUPOL
                    AND X20.COD_RIES = 0
                    AND X20.COD_CAMPO = OP_POLIZA.DV_POLIZA(I).COD_CAMPO) LOOP
        OP_POLIZA.DV_POLIZA(I).VALOR_CAMPO := C1.VALOR_CAMPO;
      END LOOP;
    
    END LOOP;
  
    --WRLopez: Si la liquidacion por WS se genero con pequeños accesorios se mantiene en los datos de poliza
    IF FUN_RESCATA_X2000020('OPC_PA', L_NUMSECUPOL, 1) = 'S' THEN
      L_VARIABLES1             := NEW SIM_TYP_DATOS_VARIABLESGEN();
      L_VARIABLES1.COD_RIES    := 1;
      L_VARIABLES1.NUM_END     := 0;
      L_VARIABLES1.COD_CAMPO   := 'OPC_PA';
      L_VARIABLES1.VALOR_CAMPO := 'S';
      OP_POLIZA.DATOSRIESGOS(1).DATOSVARIABLES.EXTEND;
      OP_POLIZA.DATOSRIESGOS(1).DATOSVARIABLES(OP_POLIZA.DATOSRIESGOS(1).DATOSVARIABLES.COUNT) := L_VARIABLES1;
    END IF;
    --
  
    -- Actualiza datosAdicionales
    BEGIN
      SELECT R.*
        INTO REG_X2040400
        FROM X2040400 R
       WHERE R.NUM_SECU_POL = L_NUMSECUPOL;
    
    END;
  
    FOR I IN 1 .. OP_POLIZA.DATOSADICIONAL.COUNT LOOP
      IF OP_POLIZA.DATOSADICIONAL(I).TIPO_ESTRUCTURA = 'X2040400' THEN
        CASE OP_POLIZA.DATOSADICIONAL(I).COD_CAMPO
          WHEN 'NOM_COND' THEN
            OP_POLIZA.DATOSADICIONAL(I).VALOR_CAMPO := REG_X2040400.NOM_COND;
          
          WHEN 'COD_SEXO' THEN
            NULL;
          
          WHEN 'FECHA_NAC_COND' THEN
            NULL;
          
          WHEN 'COD_PROF' THEN
            NULL;
          
          WHEN 'COD_EST_CIV' THEN
            NULL;
          
        END CASE;
      END IF;
    
    --      SE SUPONE QUE ESTOS DATOS VIENEN CORRECTOS
    END LOOP;
  
    FOR I IN 1 .. OP_POLIZA.DATOSRIESGOS.COUNT LOOP
      FOR J IN 1 .. OP_POLIZA.DATOSRIESGOS(I).DATOSVARIABLES.COUNT LOOP
        OP_POLIZA.DATOSRIESGOS(I).DATOSVARIABLES(J).VALOR_CAMPO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020(PNUMSCUPOL => L_NUMSECUPOL,
                                                                                                            PCODRIESGO => OP_POLIZA.DATOSRIESGOS(I).DATOSVARIABLES(J)
                                                                                                                          .COD_RIES,
                                                                                                            PCODCAMPO  => OP_POLIZA.DATOSRIESGOS(I).DATOSVARIABLES(J)
                                                                                                                          .COD_CAMPO);
      END LOOP;
      -- En el reques tno viene la opción, entonces la extrae del numSecuPol
      OP_POLIZA.DATOSRIESGOS(I).DATOSVARIABLES.EXTEND;
      OP_POLIZA.DATOSRIESGOS(I).DATOSVARIABLES(OP_POLIZA.DATOSRIESGOS(I).DATOSVARIABLES.COUNT) := NEW
                                                                                                  SIM_TYP_DATOS_VARIABLESGEN(NUM_SECU_POL => NULL,
                                                                                                                             COD_RIES     => 1,
                                                                                                                             NUM_END      => 0,
                                                                                                                             COD_CAMPO    => 'OPCION_AUTOS',
                                                                                                                             COD_NIVEL    => NULL,
                                                                                                                             COD_COB      => NULL,
                                                                                                                             TITULO       => NULL,
                                                                                                                             VALOR_CAMPO  => SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020(PNUMSCUPOL => L_NUMSECUPOL,
                                                                                                                                                                                      PCODRIESGO => 1,
                                                                                                                                                                                      PCODCAMPO  => 'OPCION_AUTOS'),
                                                                                                                             DESCRIPCION  => NULL);
    
    END LOOP;
  
    FOR I IN 1 .. OP_POLIZA.DATOSVEHICULOS.COUNT LOOP
      BEGIN
        SELECT *
          INTO REG_X2040100
          FROM X2040100 AUT
         WHERE AUT.NUM_SECU_POL = L_NUMSECUPOL
           AND AUT.COD_RIES = OP_POLIZA.DATOSVEHICULOS(I).COD_RIES;
      
      END;
    
      OP_POLIZA.DATOSVEHICULOS(I).COD_RAMO_VEH := REG_X2040100.COD_RAMO_VEH;
      OP_POLIZA.DATOSVEHICULOS(I).COD_MARCA.CODIGO := REG_X2040100.COD_MARCA;
      OP_POLIZA.DATOSVEHICULOS(I).COD_MOD := REG_X2040100.COD_MOD;
      OP_POLIZA.DATOSVEHICULOS(I).COD_USO.CODIGO := REG_X2040100.COD_USO;
      OP_POLIZA.DATOSVEHICULOS(I).PAT_VEH := REG_X2040100.PAT_VEH;
      OP_POLIZA.DATOSVEHICULOS(I).SUMA_ASEG := REG_X2040100.SUMA_ASEG;
      OP_POLIZA.DATOSVEHICULOS(I).SUMA_ACCES := REG_X2040100.SUMA_ACCES;
    END LOOP;
  
  END COMPLEMENTADATOSREQUEST;

  -- ======================================================================================
  -- Autor:
  -- Fecha:
  -- Descripcion: Procedimiento Service Expide
  -- Cambios:
  --   [Proc_Serviceexpide_1]: se agregan valores por defecto para servicio de
  --                           liquidaciones de prima cuando se realiza por el sistema
  --                           de origen 124
  -- xxxx
  -- ======================================================================================
  PROCEDURE PROC_SERVICEEXPIDE(IP_POLIZA      IN SIM_TYP_POLIZAGEN,
                               IP_TIPOPROCESO IN NUMBER,
                               OP_POLIZA      OUT SIM_TYP_POLIZAGEN,
                               IP_VALIDACION  IN VARCHAR2,
                               IP_PROCESO     IN SIM_TYP_PROCESO,
                               OP_RESULTADO   OUT NUMBER,
                               OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    /*
      VERSION  FECHA     RESPONSABLE  EMPRESA     DESCRIPCION
      ------- ---------- ------------ ----------- ----------------------
       1.1   03/06/2015 cjrodriguez  Asesoftware Ajuste en el manejo de
                                                  invocacion de procedimiento  proc_procesar_riesgo
                                                  en el procedimiento Proc_ServiceExpide,para transmilenio
    */
    --p_proceso      201 Simulacion    241 Emite Cotizacion -- 261-Emision Poliza  221-Presupuesto
    --p_subproceso   200 Simulacion    240 Cotizacion       -- 260 Poliza
    -- ip_tipoproceso        number  := 3;    --Inserta de Poliza Principal para 721 debe venir 3
  
    L_VALORCAMPO       A2000020.VALOR_CAMPO%TYPE;
    L_TPROCESO         NUMBER;
    L_TSUBPROCESO      NUMBER;
    L_TNTPOLPRES       VARCHAR2(10);
    L_NUMPOLCOTIZ      NUMBER;
    IP_NUMCOTIZACION   NUMBER;
    IP_CODSECCANTERIOR NUMBER;
    L_POLIZA           SIM_TYP_POLIZAGEN;
    L_NUMSECUPOL       NUMBER;
    L_NUMSECUPOLORG    NUMBER;
    L_NUMPOLCOTIZORG   NUMBER;
    L_NUMEND           NUMBER;
    L_RIESGO           NUMBER;
    L_NIVELCT          SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_EXISTE_CT        SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    IP_ARRCONTEXTO     SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    OP_ARRCONTEXTO     SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    L_MARCA            NUMBER;
    L_GRABAR           SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_EXISTE           SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_CANTIDAD         NUMBER;
    L_EXISTEX          SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_RESULTADO        SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR := 0;
    L_TIPOPROCESO      NUMBER;
    L_PROCESO          SIM_TYP_PROCESO;
    LVARIABLE222       NUMBER;
    L_ARRERRORES       SIM_TYP_ARRAY_ERROR;
  
    L_DIRECCION_ESTANDAR VARCHAR2(32767);
    L_MENSAJE_SALIDA     VARCHAR2(32767);
    L_CODIGO_SALIDA      NUMBER(10);
    L_CIAORG             A2000030.COD_CIA%TYPE;
    L_SECCORG            A2000030.COD_SECC%TYPE;
    L_PRODORG            A2000030.COD_RAMO%TYPE;
    L_NUMPOL1            A2000030.NUM_POL1%TYPE;
    L_MCACOTIZACION      A2000030.MCA_COTIZACION%TYPE;
    L_ENTRA              VARCHAR2(1);
    L_MCA_PROVISORIO     A2000030.MCA_PROVISORIO%TYPE;
    L_CT                 VARCHAR2(1);
  
    OP_NUMPOL1        A2000030.NUM_POL1%TYPE;
    OP_NUMEND         A2000020.NUM_END%TYPE;
    OP_MCA_PROVISORIA A2000030.MCA_PROVISORIO%TYPE;
    L_NROCERTIFICADO  NUMBER;
  
    L_LLAMACTNIVEL1 SIM_PCK_TIPOS_GENERALES.T_CARACTER := SIM_PCK_TIPOS_GENERALES.C_SI;
    L_LLAMACTNIVEL4 SIM_PCK_TIPOS_GENERALES.T_CARACTER := SIM_PCK_TIPOS_GENERALES.C_SI;
    L_LLAMACTNIVELC SIM_PCK_TIPOS_GENERALES.T_CARACTER := SIM_PCK_TIPOS_GENERALES.C_SI;
    L_DIASENTREGA   SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 0;
    C_CIASOAT       SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 3;
    C_SECCSOAT      SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 310;
    C_RAMOSOAT      SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 315;
    C_USRSOATONLINE SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO := '1234554321';
    -- codigo existente para documnento FACTURA PARA VEHICULOS CERO KILOMETROS
    C_DCTOFACTCEROKM SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 655;
  
    L_TIPDOC    SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_NUMDOC    SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_FECNAC    SIM_PCK_TIPOS_GENERALES.T_FECHA;
    L_GENERO    SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_NOMBRE    SIM_X_TERCEROS.NOMBRES%TYPE;
    L_APELLIDOS SIM_X_TERCEROS.APELLIDOS%TYPE;
  
    --DREYESAM: SE REALIZAN AJUSTES PARA QUE TOME DESCUENTOS DE SOAT.
    L_PLACA          VARCHAR2(20);
    V_PORCDESCTO_LEY NUMBER(10, 7) := 0;
    V_PORCDESCTO_ELE NUMBER(10, 7) := 0;
    V_USO            NUMBER := 0;
    V_ACTUALIZADV    NUMBER := 0; --AEEM
    -- VARIABLE DESCUENTO DE LEY 2128 POR TIPO DE COMBUSTIBLE
    V_TIENEDTO_TCOM NUMBER := 0;
    FECHA_EMI       DATE;
    CURSOR C_RIESGOS IS
      SELECT DISTINCT COD_RIES
        FROM X2000020
       WHERE NUM_SECU_POL = L_NUMSECUPOL
         AND COD_RIES IS NOT NULL
       ORDER BY NVL(COD_RIES, 0);
  
    CURSOR C_CT IS
      SELECT A.COD_ERROR, C.DESC_ERROR, A.COD_RECHAZO
        FROM X2000220 A, X2000030 B, G2000210 C
       WHERE A.NUM_SECU_POL = L_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.NUM_ORDEN = B.NUM_END
         AND C.COD_CIA = B.COD_CIA
         AND C.COD_ERROR = A.COD_ERROR;
    --  hlc 19092017
    CURSOR C_CT_SOAT IS
      SELECT A.COD_ERROR, C.DESC_ERROR, A.COD_RECHAZO
        FROM A2000220 A, A2000030 B, G2000210 C
       WHERE A.NUM_SECU_POL = L_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.NUM_ORDEN = B.NUM_END
         AND C.COD_CIA = B.COD_CIA
         AND C.COD_ERROR = A.COD_ERROR;
  
    -- Non-scalar parameters require additional processing
    OP_ARRLISTA          SIM_TYP_ARRAY_LISTA;
    OP_HABILITATABRIESGO VARCHAR2(100);
    L_ETAPA_ACTIVAR      VARCHAR2(1);
    L_REG                SIM_TYP_VAR_MOTORREGLAS;
  
    --Ini. Ver. 1.1 cjrodriguez: Transmilenio
    L_PROC_RIES    VARCHAR2(1);
    L_ERROR2       SIM_TYP_ERROR;
    L_ARRERRORES_2 SIM_TYP_ARRAY_ERROR;
    L_BANDERA      NUMBER := 0;
    --Fin Ver. 1.1 cjrodriguez: Transmilenio
    --05/03/2019 lberbesi: Se incluye variable para anulareemplaza en renovaciones
    L_ESANULAREEMP VARCHAR2(1);
    L_MENSAJEERROR VARCHAR2(400);
    -- Anula reemplazo Masivo Digital
    L_POLIZAANULA NUMBER;
    L_FECHAANULA  DATE;
    L_NUMENDANU   NUMBER;
    L_MCAANULA    VARCHAR2(1);
    L_VAR         NUMBER;
    L_LONGVAR     NUMBER;
  
    -- GD748-408 No enviar a Filenet si existe solo CT firma
    -- rosario.puertas@segurosbolivar.com sandro.preciado@segurosbolivar.com
    PROCEDURE PROC_VALIDA_ENVIO_FILENET(IP_NUMSECUPOL     NUMBER,
                                        IOP_MCAPROVISORIO IN OUT VARCHAR2,
                                        IP_PROCESO        SIM_TYP_PROCESO,
                                        OP_RESULTADO      IN OUT NUMBER,
                                        OP_ARRERRORES     IN OUT SIM_TYP_ARRAY_ERROR) IS
      L_CONTAFIRMA   NUMBER;
      L_CONTANOFIRMA NUMBER;
      L_CONTADOR     NUMBER;
      L_CODERROR     NUMBER;
    
    BEGIN
      SELECT DAT_NUM
        INTO L_CODERROR
        FROM C9999909
       WHERE COD_TAB = 'RAMOS_FIRMACLIENTECT'
         AND COD_CIA = IP_PROCESO.P_COD_CIA
         AND COD_SECC = IP_PROCESO.P_COD_SECC
         AND COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND FECHA_BAJA IS NULL
         AND ROWNUM <= 1;
      SELECT COUNT(1)
        INTO L_CONTAFIRMA
        FROM A2000220 A, A2000030 B
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.COD_ERROR = L_CODERROR
         AND A.COD_RECHAZO = 3
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND B.NUM_END = A.NUM_ORDEN
         AND B.NUM_POL1 IS NOT NULL;
      IF L_CONTAFIRMA > 0 THEN
      
        SELECT COUNT(1)
          INTO L_CONTADOR
          FROM C9999909
         WHERE COD_TAB = 'PROD_FIRMA_ELEC_X'
           AND COD_SECC = IP_PROCESO.P_COD_SECC
           AND COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
           AND FECHA_BAJA IS NULL;
      
        IF L_CONTADOR > 0 THEN
          SELECT COUNT(1)
            INTO L_CONTANOFIRMA
            FROM A2000220
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND COD_ERROR != L_CODERROR
             AND COD_ERROR != 924 --no se tiene en cuenta por se un control de reaseguros que se dispara por error
             AND COD_RECHAZO = 3;
          IF L_CONTANOFIRMA = 0 THEN
            IOP_MCAPROVISORIO := 'X';
            OP_RESULTADO      := 1;
            L_ERROR           := SIM_TYP_ERROR(-20000,
                                               'Esta Poliza es provisoria',
                                               'W');
            OP_ARRERRORES.EXTEND;
            OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          END IF;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  BEGIN
    IF IP_PROCESO.P_COD_PRODUCTO = 923 THEN
      SIM_PROC_LOG('LBCB_EXPIDECTA', 'LLEGA XD 2');
    END IF;
    -- Lectura de contexto Etapa a Activar (único para cumplimiento)
    IP_ARRCONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    OP_ARRCONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
  
    BEGIN
      L_ETAPA_ACTIVAR := SIM_PCK_REGLAS.G_PARAMETROS('B99_ETAPA_ACTIVADA');
    EXCEPTION
      WHEN OTHERS THEN
        L_ETAPA_ACTIVAR := NULL;
    END;
  
    --provisional mientras mannindia mapea para presupuesto
    L_PROCESO     := IP_PROCESO;
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_DavidaTablet';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_ARRERRORES  := NEW SIM_TYP_ARRAY_ERROR();
  
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_SIMUSUARIO',
                                        IP_PROCESO.P_COD_USR);
  
    L_POLIZA := IP_POLIZA;
  
    --LBCB 08032024 provisional maquinaria y equipo
    /*IF L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO = 153 THEN
        L_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO := IP_PROCESO.p_info1;
        L_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO := IP_PROCESO.p_info2;
    END IF;
    IF L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO = 109 or L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO = 153 THEN
    SIM_PROC_LOG('LBCB_109',
                         'L_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO: '||L_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO);
                         end if;*/
    SIM_PROC_LOG('DATOS_EMISION2.Proc_Serviceexpide', 'Start procedure');
    --[INICIO][Proc_Serviceexpide_1]
    /* Wesv 20200120 -- Para el canal 124, servicio web externo de autos,
    es necesario setear algunas variables que no son enviadas en el request*/
    BEGIN
    
      -- Se hace este ajuste, dado que para el canal 124 no viene el COD_USO. Sin embargo, este campo es usado para determinar si el
      -- cliente tiene vinculaciones, cuando el vehiculo es > x años de antiguedad. La validación se estó realizando antes de
      -- cargar los valores default de SIM_DEF_WEB -- Revisar con Manuel orjuela
    
      --- se verifica si el producto es Soat autor: IAFSERNA
      IF SIM_PCK_FUNCION_GEN.ES_SOAT(IP_SECCION => IP_PROCESO.P_COD_SECC) = 'N' THEN
      
        IF IP_PROCESO.P_SISTEMA_ORIGEN IN (124, 179) THEN
        
          -- si el canal es 124 y el num_secu_pol viene en el request
          -- se complementan los datos del objeto poliza teniendo en cuenta
          -- la información del numSecuPol recibido en el request
          -- Esto se implementa para evitar que desde el request de autos externos
          -- Tengan que enviar toda la info de la liquidación, minizando riesgos
          -- en la liquidación por webServices - Wesv 20200609
          IF NVL(L_POLIZA.DATOSFIJOS.NUM_SECU_POL, 0) > 0 AND
             IP_PROCESO.P_PROCESO = 241 THEN
            -- solo aplica para cotizacion
            SIM_PROC_LOG('Sim_pck_proceso_datos_emision2.complementadatosrequest',
                         'inicio');
            COMPLEMENTADATOSREQUEST(IP_POLIZA, L_POLIZA);
            SIM_PROC_LOG('Sim_pck_proceso_datos_emision2.complementadatosrequest',
                         'fin');
            -- Deja esta asignacion dado que el p_info5 debe ser numerico
            -- y es validado en un programa posterior -- Wesv 20200615
            L_PROCESO.P_INFO5 := L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO;
            -- temporal : graba log para revision de mapeo
          
            --          null;
          END IF;
        
          DECLARE
            L_SECUENCIA NUMBER;
          BEGIN
            BEGIN
              SELECT SIM_SEQ_LOG_WEBSERVICES.NEXTVAL
                INTO L_SECUENCIA
                FROM DUAL;
            END;
            SIM_PCK_ERRORES.GRABARLOGWS('SIM_PCK_PROCESO_DATOS_EMISION2.mapeodatos.' ||
                                        'Tipoproceso:' || IP_TIPOPROCESO,
                                        L_PROCESO,
                                        L_POLIZA,
                                        L_SECUENCIA);
          END;
        
          --        l_Poliza.Datosvehiculos(1).cod_uso.valor := 31;
          --        l_Poliza.Datosvehiculos(1).cod_uso.codigo := 31;
        
          -- Se identifica que el servicio web externo no está mapeando en forma
          -- correcta la fecha de nacimiento del tercero, cuando este existe en terceros
          -- Temporalmente, se hace select a terceros, y si el tercero existe, reescribe la fecha de
          -- nacimiento y el genero
          -- Wesv 2020-01-17
          FOR X IN 1 .. L_POLIZA.DATOSTERCEROS.COUNT LOOP
            IF L_POLIZA.DATOSTERCEROS(X).ROL = 2 THEN
              -- recupera el tipo y numero de doc
              L_TIPDOC := L_POLIZA.DATOSTERCEROS(X).TIPO_DOCUMENTO;
              L_NUMDOC := L_POLIZA.DATOSTERCEROS(X).NUMERO_DOCUMENTO;
            
              --Inicio cambio
              --20210713 Sheila Uhia: Se agregan nombres y apellidos para los asegurados
              --Si existe el asegurado en Terceros, no se tiene en cuenta el nombre enviado desde el servicio web, sino el de Terceros
              --JIRA ESTCORE-3882
              BEGIN
              
                SELECT SUBSTR(PRIMER_NOMBRE || ' ' || SEGUNDO_NOMBRE,
                              0,
                              119) NOMBRES,
                       SUBSTR(PRIMER_APELLIDO || ' ' || SEGUNDO_APELLIDO,
                              0,
                              59) APELLIDOS
                  INTO L_NOMBRE, L_APELLIDOS
                  FROM NATURALES N
                 WHERE N.TIPDOC_CODIGO = L_TIPDOC
                   AND N.NUMERO_DOCUMENTO = L_NUMDOC;
              
                L_POLIZA.DATOSTERCEROS(X).NOMBRES := L_NOMBRE;
                L_POLIZA.DATOSTERCEROS(X).APELLIDOS := L_APELLIDOS;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --Fin cambio
              --20210713 Sheila Uhia: Se agregan nombres y apellidos para los asegurados
              --Si existe el asegurado en Terceros, no se tiene en cuenta el nombre enviado desde el servicio web, sino el de Terceros
              --JIRA ESTCORE-3882
            
            END IF;
            IF L_POLIZA.DATOSTERCEROS(X).ROL = 4 THEN
              L_FECNAC := NULL;
              L_GENERO := NULL;
              BEGIN
                SELECT N.FECHA_NACIMIENTO, N.SEXO
                  INTO L_FECNAC, L_GENERO
                  FROM NATURALES N
                 WHERE N.TIPDOC_CODIGO = L_TIPDOC
                   AND N.NUMERO_DOCUMENTO = L_NUMDOC;
                L_POLIZA.DATOSTERCEROS(X).FECHA_NACIMIENTO := TO_CHAR(L_FECNAC,
                                                                      'dd-mon-yy');
                L_POLIZA.DATOSTERCEROS(X).SEXO := L_GENERO;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            END IF;
          END LOOP;
          -- Actualiza estructura de datosadicionales, donde vienen tambien los
          -- datos del conductor habitual
          FOR X IN 1 .. L_POLIZA.DATOSADICIONAL.COUNT LOOP
            IF L_POLIZA.DATOSADICIONAL(X)
             .COD_CAMPO = 'COD_SEXO' AND L_GENERO IS NOT NULL THEN
              L_POLIZA.DATOSADICIONAL(X).VALOR_CAMPO := L_GENERO;
            ELSIF L_POLIZA.DATOSADICIONAL(X)
             .COD_CAMPO = 'FECHA_NAC_COND' AND L_FECNAC IS NOT NULL THEN
              L_POLIZA.DATOSADICIONAL(X).VALOR_CAMPO := TO_CHAR(L_FECNAC,
                                                                'ddmmyyyy');
            END IF;
          END LOOP;
        END IF;
      END IF;
    END;
    --[FIN][Proc_Serviceexpide_1]
    SIM_PROC_LOG('VALIDA_ERROR_MAER', 'Proc_Serviceexpide_1');
    BEGIN
      SELECT DAT_CAR INTO L_CT FROM C9999909 WHERE COD_TAB = 'MAOR_CT';
    EXCEPTION
      WHEN OTHERS THEN
        L_CT := 'N';
    END;
    IF L_CT = 'S' THEN
      RAISE_APPLICATION_ERROR(-20000, 'Control Tecnico Rechazado');
    END IF;
  
    BEGIN
      -- Valida que exista el numSecuPol recibido como parametro en las
      -- tablas temporales, ya que en Davida Tablet se presentan problemas
      -- con el borre de las transitorias -- Wesv
      IF NVL(L_POLIZA.DATOSFIJOS.NUM_SECU_POL, 0) = 0 THEN
        IF IP_POLIZA.DATOSRIESGOS(1).DATOSVARIABLES.EXISTS(1) THEN
          FOR DV IN IP_POLIZA.DATOSRIESGOS(1).DATOSVARIABLES.FIRST .. IP_POLIZA.DATOSRIESGOS(1)
                                                                      .DATOSVARIABLES.LAST LOOP
            BEGIN
              SELECT NUM_SECU_POL
                INTO L_POLIZA.DATOSFIJOS.NUM_SECU_POL
                FROM A2000030
               WHERE NUM_POL_COTIZ = IP_POLIZA.DATOSRIESGOS(1).DATOSVARIABLES(DV)
                    .NUM_SECU_POL
                 AND COD_SECC = IP_PROCESO.P_COD_SECC;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
            EXIT;
          END LOOP;
        END IF;
      END IF;
    
      IF NVL(L_POLIZA.DATOSFIJOS.NUM_SECU_POL, 0) > 0 THEN
        L_NUMSECUPOLORG := L_POLIZA.DATOSFIJOS.NUM_SECU_POL;
        --se implementa en motor para recuperar el numero original de la cotizacion
        BEGIN
          SELECT NUM_POL_COTIZ
            INTO L_NUMPOLCOTIZORG
            FROM A2000030
           WHERE NUM_SECU_POL = L_NUMSECUPOLORG
             AND NUM_END = 0;
        EXCEPTION
          WHEN OTHERS THEN
            L_NUMPOLCOTIZORG := NULL;
          
        END;
      
        --    dbms_output.put_line('numsecpolorg'||l_numsecupolorg);
      
        SIM_PCK_CONSULTA_EMISION2.PROC_VAL_NUMSECUPOL(IP_NUMSECUPOL => L_NUMSECUPOLORG,
                                                      IP_TIPO       => 'X',
                                                      IP_VALIDACION => NULL,
                                                      IP_PROCESO    => SIM_TYP_PROCESO,
                                                      OP_RESULTADO  => OP_RESULTADO,
                                                      OP_ARRERRORES => OP_ARRERRORES);
        SIM_PROC_LOG('VALIDA_ERROR_MAER', 'SIM_PCK_CONSULTA_EMISION2');
      
        IF OP_RESULTADO = -1 THEN
          SIM_PCK_ERRORES.MANEJARERROR('NUMSECUPOL_NO_EXISTE',
                                       ' X2000030>>>>>',
                                       'Proc_Val_NumsecuPol');
        
        END IF;
        IF OP_RESULTADO != 0 THEN
          BEGIN
            SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
            OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
          END;
          L_RESULTADO := OP_RESULTADO;
        END IF;
      
        --END IF;
      
        L_NUMPOL1       := 0;
        L_MCACOTIZACION := 'N';
      
        BEGIN
          SELECT NVL(NUM_POL1, 0), NVL(MCA_COTIZACION, 'N')
            INTO L_NUMPOL1, L_MCACOTIZACION
            FROM A2000030
           WHERE NUM_SECU_POL = L_NUMSECUPOLORG
             AND NUM_END = 0;
        EXCEPTION
          WHEN OTHERS THEN
            L_NUMPOL1       := 0;
            L_MCACOTIZACION := 'N';
        END;
      
        IF L_NUMPOL1 > 0 AND L_MCACOTIZACION = 'N' THEN
          RAISE_APPLICATION_ERROR(-20099,
                                  'Negocio ya Generado con Numero Poliza: ' ||
                                  L_NUMPOL1);
        END IF;
      
        BEGIN
          SIM_PCK_PROCESO_DATOS_EMISION2.PROC_VALIDAPROCPOLIZA(L_NUMSECUPOLORG,
                                                               L_EXISTE,
                                                               IP_VALIDACION,
                                                               L_PROCESO,
                                                               OP_RESULTADO,
                                                               OP_ARRERRORES);
        END;
      
        SIM_PROC_LOG('DATOS_EMISION2.Proc_Serviceexpide',
                     'Start procedure 1');
        -- If Ip_Proceso.p_Proceso = 270 Then
        IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' THEN
          IF L_EXISTE = 'S' THEN
            RAISE_APPLICATION_ERROR(-20000,
                                    'Negocio se esta procesando en este momento');
          END IF;
        END IF;
        IF OP_RESULTADO != 0 THEN
          BEGIN
            SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
            OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
          END;
          L_RESULTADO := OP_RESULTADO;
        END IF;
      END IF;
    END;
  
    BEGIN
      SELECT 1
        INTO L_MARCA
        FROM SIM_PRODUCTOS A
       WHERE A.COD_CIA = L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO
         AND A.COD_SECC = L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO
         AND A.COD_PRODUCTO = L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20099,
                                'Producto : ' ||
                                L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO ||
                                ' Inexistente para la Seccion : ' ||
                                L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO ||
                                ' Compania :' ||
                                L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO);
    END;
  
    L_MARCA := NULL;
  
    BEGIN
      /* ****** INICIO-TRANSMASIVO ****** */
      /*Prc999_Autos_Cltvas_Grabalog(Ip_Nombre_Objeto => 'TMP_PCK_PROCESO_DATOS_EMISION2',
      Ip_Consulta      => 'PROCESO ' ||
                          l_Proceso.p_Proceso ||
                          ', SUPPROCESO ' ||
                          l_Proceso.p_Subproceso ||
                          ', MODULO ' ||
                          l_Proceso.p_Modulo);    */
      /* ****** FIN-TRANSMASIVO ****** */
      SELECT NVL(F.TIPO_NEGOCIO_TRONADOR, 1)
        INTO L_MARCA
        FROM SIM_PROCESOS F
       WHERE F.ID_PROCESO = L_PROCESO.P_PROCESO
         AND NVL(F.ID_PROCESO_PADRE, -1) = NVL(L_PROCESO.P_SUBPROCESO, -1)
         AND F.MODULO = L_PROCESO.P_MODULO;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20099,
                                'Tipo de negocio Inexistente Proceso' ||
                                L_PROCESO.P_PROCESO || '*' ||
                                L_PROCESO.P_SUBPROCESO || '*' ||
                                L_PROCESO.P_MODULO);
    END;
  
    -- 1-DatosFijos  2-5  Riesgo   C-Cobertura 4-Premio
    BEGIN
      SELECT NVL(A.DAT_CAR, 'S'),
             NVL(A.DAT_CAR2, 'S'),
             NVL(A.DAT_CAR3, 'S')
        INTO L_LLAMACTNIVEL1, L_LLAMACTNIVELC, L_LLAMACTNIVEL4
        FROM C9999909 A
       WHERE A.COD_TAB = 'SIM_DISPARA_PROC'
         AND A.COD_CIA = L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO
         AND A.COD_SECC = L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO
         AND A.COD_RAMO = L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO
         AND A.CODIGO1 = L_PROCESO.P_PROCESO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    SIM_PROC_LOG('SIM_DISPARA_PROC - 1: ' || L_LLAMACTNIVEL1 || ' - C: ' ||
                 L_LLAMACTNIVELC || ' - 4: ' || L_LLAMACTNIVEL4,
                 'Parametrización SIM_DISPARA_PROC');
  
    IF L_ETAPA_ACTIVAR IS NOT NULL THEN
      BEGIN
        L_REG        := NEW SIM_TYP_VAR_MOTORREGLAS();
        L_REG.CODIGO := 'B99_ETAPA_ACTIVADA';
        L_REG.VALOR  := L_ETAPA_ACTIVAR;
      END;
    
      IP_ARRCONTEXTO.EXTEND;
      IP_ARRCONTEXTO(IP_ARRCONTEXTO.COUNT) := L_REG;
      --
      SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
    END IF;
  
    --  sim_pck_reglas.inicializaParametros('B99_PROGRAMA_SEGURO',Ip_poliza.DatosFijos.sim_paquete_seguro);
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
  
    L_NUMSECUPOL := L_POLIZA.DATOSFIJOS.NUM_SECU_POL;
    BEGIN
      SIM_PROC_LOG('SIM_PCK_PROCESO_DATOS_EMISION2.Proc_Serviceexpide L_POLIZA.DATOSFIJOS.NUM_SECU_POL',
                   L_POLIZA.DATOSFIJOS.NUM_SECU_POL);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    L_TIPOPROCESO := IP_TIPOPROCESO;
  
    --    If Ip_Proceso.p_Proceso = 270 Then
    IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' THEN
    
      L_TIPOPROCESO := 1;
    END IF;
    IF NVL(L_POLIZA.DATOSFIJOS.NUM_SECU_POL, 0) = 0 THEN
      --If l_Proceso.p_Proceso = 270 Then
      IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' THEN
        --se incluye para que recupere de P
        L_NUMPOLCOTIZ := L_POLIZA.DATOSFIJOS.NUM_POL1;
        L_TIPOPROCESO := 4;
        --       l_tipoproceso := Ip_tipoproceso;
      ELSE
        L_TIPOPROCESO := IP_TIPOPROCESO;
      END IF;
    
      BEGIN
        SIM_PCK_ACCESO_DATOS_EMISION.PROC_INSERTATRANSITORIAS(L_POLIZA.DATOSFIJOS.NUM_POL_FLOT,
                                                              L_NUMPOLCOTIZ,
                                                              IP_CODSECCANTERIOR,
                                                              L_TIPOPROCESO,
                                                              L_NUMSECUPOL,
                                                              L_NUMEND,
                                                              IP_VALIDACION,
                                                              IP_ARRCONTEXTO,
                                                              OP_ARRCONTEXTO,
                                                              L_PROCESO,
                                                              OP_RESULTADO,
                                                              OP_ARRERRORES);
        SIM_PROC_LOG('VALIDA_ERROR_MAER',
                     'SIM_PCK_ACCESO_DATOS_EMISION-3542' || OP_RESULTADO);
      
      END;
      IF OP_RESULTADO != 0 THEN
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
        L_RESULTADO := OP_RESULTADO;
      END IF;
    ELSE
      L_NUMPOL1     := 0;
      L_NUMPOLCOTIZ := L_NUMPOLCOTIZORG;
      L_CIAORG      := 0;
      L_SECCORG     := 0;
      L_PRODORG     := 0;
      L_EXISTEX     := 'S';
    
      BEGIN
        SELECT A.COD_CIA, A.COD_SECC, A.COD_RAMO
          INTO L_CIAORG, L_SECCORG, L_PRODORG
          FROM X2000030 A
         WHERE NUM_SECU_POL = L_NUMSECUPOL;
      EXCEPTION
        WHEN OTHERS THEN
          L_EXISTEX := 'N';
          --       raise_application_error(-20099,'No existe información para esta poliza numsecupol:'||l_numsecupol);
      END;
    
      IF L_CIAORG = IP_PROCESO.P_COD_CIA AND
         L_SECCORG = IP_PROCESO.P_COD_SECC AND
         L_PRODORG = IP_PROCESO.P_COD_PRODUCTO AND L_EXISTEX = 'S' THEN
        L_NUMEND := 0;
      
        BEGIN
          SIM_PCK_PROCESO_DATOS_EMISION2.PROC_CONTEXTO_INS_TRANS(L_NUMSECUPOL,
                                                                 L_NUMEND,
                                                                 IP_VALIDACION,
                                                                 IP_ARRCONTEXTO,
                                                                 OP_ARRCONTEXTO,
                                                                 L_PROCESO,
                                                                 OP_RESULTADO,
                                                                 OP_ARRERRORES);
          SIM_PROC_LOG('VALIDA_ERROR_MAER',
                       'SIM_PCK_PROCESO_DATOS_EMISION2-3585');
        END;
        IF OP_RESULTADO != 0 THEN
          BEGIN
            SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
            OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
          END;
          L_RESULTADO := OP_RESULTADO;
        END IF;
      ELSE
        BEGIN
          L_NUMPOL1     := 0;
          L_NUMPOLCOTIZ := 0;
        
          BEGIN
            SELECT NUM_POL1, NUM_POL_COTIZ
              INTO L_NUMPOL1, L_NUMPOLCOTIZ
              FROM A2000030
             WHERE NUM_SECU_POL = L_NUMSECUPOL
               AND NUM_END = 0;
          EXCEPTION
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20099,
                                      'No existe información para esta poliza numsecupol:' ||
                                      L_NUMSECUPOL);
          END;
        END;
      
        --l_numsecupol := 0;
      
        BEGIN
          SIM_PCK_ACCESO_DATOS_EMISION.PROC_INSERTATRANSITORIAS(L_POLIZA.DATOSFIJOS.NUM_POL_FLOT,
                                                                L_NUMPOLCOTIZ,
                                                                IP_CODSECCANTERIOR,
                                                                L_TIPOPROCESO,
                                                                L_NUMSECUPOL,
                                                                L_NUMEND,
                                                                IP_VALIDACION,
                                                                IP_ARRCONTEXTO,
                                                                OP_ARRCONTEXTO,
                                                                L_PROCESO,
                                                                OP_RESULTADO,
                                                                OP_ARRERRORES);
          SIM_PROC_LOG('VALIDA_ERROR_MAER',
                       'SIM_PCK_ACCESO_DATOS_EMISION-3628');
        END;
        IF OP_RESULTADO != 0 THEN
          BEGIN
            SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
            OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
          END;
          L_RESULTADO := OP_RESULTADO;
        END IF;
      END IF;
    END IF;
  
    IF OP_RESULTADO = -1 THEN
      --RETURN;
      IF L_ARRERRORES.COUNT > 0 THEN
        FOR I IN L_ARRERRORES.FIRST .. L_ARRERRORES.LAST LOOP
          L_MENSAJEERROR := SUBSTR(L_ARRERRORES(I).DESC_ERROR, 1, 400);
          RAISE_APPLICATION_ERROR(L_ARRERRORES(I).ID_ERROR, L_MENSAJEERROR);
        END LOOP;
      END IF;
      --Raise_Application_Error(-20000, 'Fallo Insertar transitorias');
      --RPR Ajuste para visualizar el error real
    END IF;
    DBMS_OUTPUT.PUT_LINE(L_NUMSECUPOL);
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
    /* morj9052 08 may 2019, se coloca condicion para que en renovacion no se pierda
    la poliza base de la renovacion */
    /* JIR-GD717-336: Adiciono 445 y 446 para nuevo proceso renovacion polizas hijas - 06-10-2023 */
    IF IP_PROCESO.P_PROCESO NOT IN (440, 441, 442, 445, 446) THEN
      IF IP_PROCESO.P_PROCESO IN (270, 260, 261) THEN
        --Manejo motor
        L_POLIZA.DATOSFIJOS.SIM_NUM_COTIZ_ANT := L_NUMPOLCOTIZORG;
      END IF;
      L_POLIZA.DATOSFIJOS.NUM_POL1 := NULL;
    END IF;
  
    -- Modificacion WESV -- 20130705
    -- Debe incluir la información del tercero en la tabla SIM_X_TERCERO, de acuerdo a la
    -- información enviada en el tipo DatosTomador. En cotizaciones, no necesariamente existe
    -- el tercero en la base de datos de terceros.
    BEGIN
      IF IP_POLIZA.DATOSTERCEROS.EXISTS(1) THEN
        IF IP_POLIZA.DATOSTERCEROS.COUNT > 0 THEN
          BEGIN
            DELETE SIM_X_TERCEROS WHERE NUM_SECU_POL = L_NUMSECUPOL;
            ---MIGUEL MANRIQUE se agrega este commit para manejar el error de concurrencia que se presenta con los jobs
            COMMIT;
            IF IP_PROCESO.P_PROCESO != 201 THEN
              DELETE SIM_TERCEROS WHERE NUM_SECU_POL = L_NUMSECUPOL;
            END IF;
          END;
          SIM_PROC_LOG('VALIDA_ERROR_MAER',
                       'antes SIM_PCK_PROCESO_DML_EMISION2');
        
          SIM_PCK_PROCESO_DML_EMISION2.PROC_CREAR_SIM_X_TERCERO(L_NUMSECUPOL,
                                                                L_NUMEND,
                                                                L_POLIZA.DATOSTERCEROS,
                                                                L_PROCESO,
                                                                OP_RESULTADO,
                                                                OP_ARRERRORES);
          SIM_PROC_LOG('VALIDA_ERROR_MAER',
                       'SIM_PCK_PROCESO_DML_EMISION2-3690: ' ||
                       OP_RESULTADO);
        
          IF OP_RESULTADO <> 0 THEN
            --RETURN;
            RAISE_APPLICATION_ERROR(-20800,
                                    'Error al insertar la informacion del tercero:' ||
                                    OP_RESULTADO);
          END IF;
          IF OP_RESULTADO != 0 THEN
            BEGIN
              SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
              OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            END;
            L_RESULTADO := OP_RESULTADO;
          END IF;
        
          /*INICIO1:Juan Gonzalez, se incluye codigo inicialmente para rappi,
          para crear terceros cuando es emisión*/
        
          BEGIN
            SIM_PCK_PROCESO_DATOS_EMISION3.PROC_CREATERCERO(L_POLIZA,
                                                            L_NUMSECUPOL,
                                                            L_NUMEND,
                                                            IP_PROCESO,
                                                            OP_RESULTADO,
                                                            OP_ARRERRORES);
            SIM_PROC_LOG('VALIDA_ERROR_MAER',
                         'SIM_PCK_PROCESO_DML_EMISION3-3716: ' ||
                         OP_RESULTADO);
          EXCEPTION
            WHEN OTHERS THEN
              OP_RESULTADO := -1;
              RAISE_APPLICATION_ERROR(-20000,
                                      'Fallo Crear Tercero en Servicio ' ||
                                      SQLCODE || ' - ' || SQLERRM);
          END;
          IF OP_RESULTADO != 0 THEN
            BEGIN
              SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
              OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            END;
            L_RESULTADO := OP_RESULTADO;
            DBMS_OUTPUT.PUT_LINE('Resultado' || L_RESULTADO);
            L_RESULTADO := -1;
            IF L_RESULTADO = -1 THEN
              --return;
              RAISE_APPLICATION_ERROR(-20000,
                                      '*Fallo Crear Tercero en Servicio ');
            END IF;
          END IF;
          /*FIN1:::*/
        
        END IF;
      END IF;
    
    END;
  
    IF OP_RESULTADO = -1 THEN
      --RETURN;
      RAISE_APPLICATION_ERROR(-20000, 'Fallo Proc_Crear_Sim_X_tercero ');
    END IF;
  
    --================INSERCION Y ACTUALIZACION TABLAS X
    BEGIN
      UPDATE A2000030
         SET FECHA_MOVI = NVL(FECHA_MOVI, FECHA_VIG_POL)
       WHERE NUM_SECU_POL = L_POLIZA.DATOSFIJOS.NUM_SECU_POL; -- Se agrega para que la fecha movi no quede nula
    
      /*Sim_Proc_Log('COTIZ nuevo ',
      l_Numsecupol || ' antes ' || l_Numsecupolorg);*/
      UPDATE C2990003
         SET NUM_SECU_POL = L_NUMSECUPOL
       WHERE NUM_SECU_POL = L_NUMSECUPOLORG;
      /*If Sql%Notfound Then
       Sim_Proc_Log('COTIZ no actualizo ', '');
      End If;*/
    
      SIM_PCK_PROCESO_DATOS_EMISION2.PROC_UPDATEDELTYPE(L_POLIZA,
                                                        L_NUMSECUPOL,
                                                        L_NUMEND,
                                                        L_PROCESO,
                                                        OP_RESULTADO,
                                                        OP_ARRERRORES);
    
    END;
    --      COMMIT;
    IF OP_RESULTADO = -1 THEN
      --RETURN;
      RAISE_APPLICATION_ERROR(-20000, 'Fallo update type');
    END IF;
    IF OP_RESULTADO != 0 THEN
      BEGIN
        SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
        OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
      END;
      L_RESULTADO := OP_RESULTADO;
    END IF;
  
    --================ACTUALIZACION TABLAS X  DESDE DEFAULT C9999909 SIM_DEF_WEB
  
    --==MORJ31MAR2019 ACTUALIZACIONES PARTICULARES POR PRODUCTO LUEGO DE DAR PERSISTENCIA A LAS X DEL TYPE
    BEGIN
      SIM_PCK_PROCESO_DATOS_EMISION3.PROC_UPDATEXPORPROD(L_POLIZA,
                                                         L_NUMSECUPOL,
                                                         L_NUMEND,
                                                         L_PROCESO,
                                                         OP_RESULTADO,
                                                         OP_ARRERRORES);
    END;
    COMMIT;
  
    IF OP_RESULTADO = -1 THEN
      --RETURN;
      RAISE_APPLICATION_ERROR(-20000, 'Fallo update por producto');
    END IF;
    IF OP_RESULTADO != 0 THEN
      BEGIN
        SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
        OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
      END;
      L_RESULTADO := OP_RESULTADO;
    END IF;
    --===MORJ31MAR2019 ACTUALIZACIONES PARTICULARES POR PRODUCTO
  
    --================ACTUALIZACION TABLAS X  DESDE DEFAULT C9999909 SIM_DEF_WEB
  
    L_EXISTE := 0;
  
    BEGIN
      SELECT COUNT(1)
        INTO L_EXISTE
        FROM C9999909 T
       WHERE T.COD_TAB = 'SIM_DEF_WEB'
         AND T.COD_CIA = L_PROCESO.P_COD_CIA
         AND T.COD_SECC = L_PROCESO.P_COD_SECC
         AND T.COD_RAMO = L_PROCESO.P_COD_PRODUCTO;
    END;
  
    IF L_EXISTE > 0 THEN
      BEGIN
        SIM_PCK_PROCESO_DATOS_EMISION2.PROC_UPDATEDINAMYC(L_NUMSECUPOL,
                                                          L_NUMEND,
                                                          L_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
      END;
      IF OP_RESULTADO = -1 THEN
        --RETURN;
        RAISE_APPLICATION_ERROR(-20000, 'Fallo UpdateDinamyc');
      END IF;
      IF OP_RESULTADO != 0 THEN
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
        L_RESULTADO := OP_RESULTADO;
      END IF;
    
    END IF;
  
    --      COMMIT;
    BEGIN
      -- Wesv 2018. Para BUPA, se calcula el valor dependiendo de los riesgos incluidos
      -- en la a200020, para incluir en el campo GRP_FAMILIAR
    
      IF IP_PROCESO.P_COD_CIA = 2 AND IP_PROCESO.P_COD_SECC = 34 AND
         IP_PROCESO.P_COD_PRODUCTO IN (66, 67) THEN
        -- debe actualizar el campo grupo familiar para los riesgos que tengan parentesco 3
        PCK234_SALUD.ACTGRUPOFAMILIAR(L_NUMSECUPOL, IP_PROCESO);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    SIM_PROC_LOG('VALIDA_ERROR_MAER', 'antes reglas -3863');
    --================EJECUCION REGLAS DEL NEGOCIO
    IF L_PROCESO.P_PROCESO = 261 THEN
      BEGIN
        PKG299_DATOS_GEN_MC.DEFAULT_OTRAS_TRANSITORIAS(L_NUMSECUPOL,
                                                       L_PROCESO.P_COD_PRODUCTO,
                                                       'N',
                                                       'S',
                                                       'N');
      END;
    END IF;
  
    --================EJECUCION REGLAS DEL NEGOCIO
    --DATOS FIJOS
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_VALIDACION', 'N');
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
  
    BEGIN
      SIM_PCK_CONTEXTO_EMISION.PROC_CONTEXTODATOSFIJOS(L_NUMSECUPOL,
                                                       IP_ARRCONTEXTO,
                                                       OP_ARRCONTEXTO,
                                                       L_PROCESO,
                                                       OP_RESULTADO,
                                                       OP_ARRERRORES);
    END;
  
    IF OP_RESULTADO = -1 THEN
      --RETURN;
      RAISE_APPLICATION_ERROR(-20000, 'Fallo contexto datos fijos');
    END IF;
    IF OP_RESULTADO != 0 THEN
      BEGIN
        SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
        OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
      END;
      L_RESULTADO := OP_RESULTADO;
    END IF;
  
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
  
    --      COMMIT;
  
    IF NVL(IP_VALIDACION, 'S') = 'S' AND L_PROCESO.P_PROCESO != 202 THEN
      SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
    
      DECLARE
        L_ENTIDAD     NUMBER;
        L_CANAL       NUMBER;
        L_CUENTA      SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
        L_FECHAVTO    DATE;
        L_VALCUOTAS   VARCHAR2(100);
        L_PERIODOFACT NUMBER;
        L_NROCUOTAS   NUMBER;
      BEGIN
        L_PERIODOFACT := SIM_PCK_REGLAS.G_PARAMETROS('B1_PERIODO_FACT');
      
        BEGIN
          L_ENTIDAD := SIM_PCK_REGLAS.G_PARAMETROS('B75_COD_ENTIDAD');
        EXCEPTION
          WHEN OTHERS THEN
            L_ENTIDAD := 0;
        END;
      
        --LBCB VALIDA TIPO COBRO
        SIMAPI_VALIDA_CANAL(L_NUMSECUPOL,
                            L_PROCESO.P_COD_PRODUCTO,
                            L_ENTIDAD);
      
        IF NVL(L_ENTIDAD, 0) > 0 AND
           NVL(L_POLIZA.DATOSFIJOS.FOR_COBRO.CODIGO, 'CC') = 'DB' THEN
          L_CANAL  := SIM_PCK_REGLAS.G_PARAMETROS('B75_CANAL_DESCUENTO');
          L_CUENTA := SIM_PCK_REGLAS.G_PARAMETROS('B75_SIM_NRO_CUENTA');
        
          SIM_PCK_ACCESO_DATOS_EMISION.PROC_VALIDACONFIGURACIONCTA(L_ENTIDAD,
                                                                   L_CANAL,
                                                                   L_CUENTA,
                                                                   IP_VALIDACION,
                                                                   IP_ARRCONTEXTO,
                                                                   OP_ARRCONTEXTO,
                                                                   IP_PROCESO,
                                                                   OP_RESULTADO,
                                                                   OP_ARRERRORES);
          SIM_PROC_LOG('VALIDA_ERROR_MAER',
                       'SIM_PCK_ACCESO_DATOS_EMISION -3939: ' ||
                       OP_RESULTADO);
          IF OP_RESULTADO = -1 THEN
            RAISE_APPLICATION_ERROR(-20000,
                                    'Fallo validacion Riesgo Cuenta Debito Automatico');
          END IF;
          IF OP_RESULTADO != 0 THEN
            BEGIN
              SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
              OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            END;
            L_RESULTADO := OP_RESULTADO;
          END IF;
        
          SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
        
          IF L_CANAL = 1 THEN
            --Tarjeta de credito
            L_FECHAVTO := TO_DATE(SIM_PCK_REGLAS.G_PARAMETROS('B75_FECHA_VTO'),
                                  'YYYYMM');
          
            BEGIN
              -- Call the procedure
              SIM_PCK_VALIDA_DATOS_EMISION.PROC_VALIDAFECHATARJETACREDITO(L_FECHAVTO,
                                                                          IP_PROCESO,
                                                                          OP_RESULTADO,
                                                                          OP_ARRERRORES);
            END;
          
            IF OP_RESULTADO = -1 THEN
              RAISE_APPLICATION_ERROR(-20000,
                                      'Fallo validacion Riesgo Fecha Tarjeta Debito');
            END IF;
            IF OP_RESULTADO != 0 THEN
              BEGIN
                SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
                OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
              END;
              L_RESULTADO := OP_RESULTADO;
            END IF;
          
            --          l_periodofact := sim_pck_reglas.g_parametros('B1_PERIODO_FACT');
            L_NROCUOTAS := SIM_PCK_REGLAS.G_PARAMETROS('B75_TC_NRO_CUOTAS');
          
            BEGIN
              L_VALCUOTAS := SIM_PCK_FUNCION_GEN.NUMEROCUOTASDB(L_PERIODOFACT,
                                                                L_NROCUOTAS);
            
              IF L_VALCUOTAS IS NOT NULL THEN
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000, L_VALCUOTAS);
              END IF;
            EXCEPTION
              WHEN OTHERS THEN
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000,
                                        'Error en Riesgo Cantidad de Cuotas Debito');
            END;
          END IF;
        END IF;
      
        --Validacion Debito cuando trae Ahorro
        BEGIN
          BEGIN
            SELECT SXD.COD_ENTIDAD,
                   SXD.CANAL_DESCTO,
                   SXD.SIM_NRO_CUENTA,
                   SXD.FECHA_VTO,
                   SXD.TC_NRO_CUOTAS
              INTO L_ENTIDAD, L_CANAL, L_CUENTA, L_FECHAVTO, L_NROCUOTAS
              FROM SIM_XDEBITO_AUTOMATICO SXD
             WHERE SXD.NUM_SECU_POL = L_NUMSECUPOL
               AND SXD.NUM_END = L_NUMEND;
          EXCEPTION
            WHEN OTHERS THEN
              L_ENTIDAD := 0;
          END;
        
          IF L_ENTIDAD > 0 THEN
            BEGIN
              SIM_PCK_ACCESO_DATOS_EMISION.PROC_VALIDACONFIGURACIONCTA(L_ENTIDAD --ip_entidad
                                                                      ,
                                                                       L_CANAL --ip_canaldescto
                                                                      ,
                                                                       L_CUENTA --ip_nrocuenta,
                                                                      ,
                                                                       IP_VALIDACION,
                                                                       IP_ARRCONTEXTO,
                                                                       OP_ARRCONTEXTO,
                                                                       IP_PROCESO,
                                                                       OP_RESULTADO,
                                                                       OP_ARRERRORES);
            END;
          
            IF OP_RESULTADO = -1 THEN
              RAISE_APPLICATION_ERROR(-20000,
                                      'Fallo validacion Ahorro Cuenta Debito Automatico');
            END IF;
            IF OP_RESULTADO != 0 THEN
              BEGIN
                SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
                OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
              END;
              L_RESULTADO := OP_RESULTADO;
            END IF;
          
            SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
          
            IF L_CANAL = 1 THEN
              --Tarjeta de credito
              BEGIN
                -- Call the procedure
                SIM_PCK_VALIDA_DATOS_EMISION.PROC_VALIDAFECHATARJETACREDITO(L_FECHAVTO,
                                                                            IP_PROCESO,
                                                                            OP_RESULTADO,
                                                                            OP_ARRERRORES);
              END;
            
              IF OP_RESULTADO = -1 THEN
                RAISE_APPLICATION_ERROR(-20000,
                                        'Fallo validacion Ahorro Fecha Tarjeta Debito');
              END IF;
              IF OP_RESULTADO != 0 THEN
                BEGIN
                  SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
                  OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                END;
                L_RESULTADO := OP_RESULTADO;
              END IF;
            
              BEGIN
                L_VALCUOTAS := SIM_PCK_FUNCION_GEN.NUMEROCUOTASDB(L_PERIODOFACT,
                                                                  L_NROCUOTAS);
              
                IF L_VALCUOTAS IS NOT NULL THEN
                  OP_RESULTADO := -1;
                  RAISE_APPLICATION_ERROR(-20000, L_VALCUOTAS);
                END IF;
                IF OP_RESULTADO != 0 THEN
                  L_RESULTADO := OP_RESULTADO;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                  OP_RESULTADO := -1;
                  RAISE_APPLICATION_ERROR(-20000,
                                          'Error en Ahorro Cantidad de Cuotas Debito');
              END;
            END IF;
          END IF;
        END;
      END;
    ELSE
      SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_EJECUTO_CT', 'N');
    END IF;
  
    --      COMMIT;
  
    --REGLAS CT
    IF L_LLAMACTNIVEL1 = 'S' THEN
      SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
      L_NIVELCT := '1'; -- 1-DatosFijos  C-Cobertura   4-Premio
    
      BEGIN
        SIM_PCK_CONTROL_TECNICO.PROC_EJECUTA_CONTROL_TECNICO(L_NUMSECUPOL,
                                                             L_NIVELCT,
                                                             L_EXISTE_CT,
                                                             IP_VALIDACION,
                                                             IP_ARRCONTEXTO,
                                                             OP_ARRCONTEXTO,
                                                             L_PROCESO,
                                                             OP_RESULTADO,
                                                             OP_ARRERRORES);
      END;
      IF OP_RESULTADO = -1 THEN
        --RETURN;
        RAISE_APPLICATION_ERROR(-20000, 'Fallo Controles Tecnicos');
      END IF;
      IF OP_RESULTADO != 0 THEN
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
        L_RESULTADO := OP_RESULTADO;
      END IF;
      SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
    END IF;
  
    --      COMMIT;
  
    --DATOS VARIABLES Y COBERTURAS
    --Dispare datos variables a nivel poliza
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
  
    BEGIN
      SIM_PCK_PROCESO_DATOS_EMISION2.PROC_PROCESAR_DV(L_NUMSECUPOL,
                                                      NULL,
                                                      1,
                                                      NULL,
                                                      IP_ARRCONTEXTO,
                                                      OP_ARRCONTEXTO,
                                                      L_PROCESO,
                                                      OP_RESULTADO,
                                                      OP_ARRERRORES);
    END;
    IF OP_RESULTADO = -1 THEN
      --RETURN;
      RAISE_APPLICATION_ERROR(-20000, 'Fallo Proc_Procesar_DV');
    END IF;
    IF OP_RESULTADO != 0 THEN
      BEGIN
        SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
        OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
      END;
      L_RESULTADO := OP_RESULTADO;
    END IF;
  
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
  
    --      COMMIT;
  
    --Ini Version 1.1 cjrodriguez: Transmilenio
    L_ERROR2       := NEW SIM_TYP_ERROR;
    L_ARRERRORES_2 := NEW SIM_TYP_ARRAY_ERROR();
  
    BEGIN
      L_PROC_RIES := NVL(SIM_PCK_REGLAS.G_PARAMETROS('B99_PROC_RIES_TOT'),
                         'N');
    EXCEPTION
      WHEN OTHERS THEN
        L_PROC_RIES := 'S';
    END;
  
    --Fin Version 1.1 cjrodriguez:: Transmilenio
  
    FOR REG_R IN C_RIESGOS LOOP
      SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODRIES', REG_R.COD_RIES);
      SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
    
      BEGIN
        SIM_PCK_PROCESO_DATOS_EMISION2.PROC_PROCESAR_RIESGO(L_NUMSECUPOL,
                                                            REG_R.COD_RIES,
                                                            IP_ARRCONTEXTO,
                                                            OP_ARRCONTEXTO,
                                                            L_PROCESO,
                                                            OP_RESULTADO,
                                                            OP_ARRERRORES);
      END;
      IF OP_RESULTADO = -1 THEN
        --Ini Version 1.1 cjrodriguez: Transmilenio
        IF L_PROC_RIES = 'S' THEN
          FOR I IN OP_ARRERRORES.FIRST .. OP_ARRERRORES.LAST LOOP
            L_ERROR2 := SIM_TYP_ERROR(OP_ARRERRORES(I).ID_ERROR,
                                      SUBSTR(OP_ARRERRORES(I).DESC_ERROR,
                                             1,
                                             200),
                                      OP_ARRERRORES(I).TIPO_ERROR);
            L_ARRERRORES_2.EXTEND;
            L_ARRERRORES_2(L_ARRERRORES_2.COUNT) := L_ERROR2;
            L_BANDERA := 1;
          END LOOP;
        ELSE
          --Fin Version 1.1 cjrodriguez: Transmilenio
          --RETURN;
          RAISE_APPLICATION_ERROR(-20000, 'Fallo Proc_procesar_riesgo');
        END IF; -- Version 1.1 cjrodriguez: Transmilenio
      END IF;
      IF OP_RESULTADO != 0 THEN
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
        L_RESULTADO := OP_RESULTADO;
      END IF;
    
      SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
    END LOOP;
  
    --PREMIO
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
  
    --Ini Version 1.1 cjrodriguez: Transmilenio
    IF L_BANDERA = 1 THEN
      OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
      OP_ARRERRORES := L_ARRERRORES_2;
      --RETURN;
      RAISE_APPLICATION_ERROR(-20000,
                              'La expedicion termino con errores  - Favor revisar');
    END IF;
  
    --Fin Version 1.1 cjrodriguez: Transmilenio
  
    --      COMMIT;
  
    --
    --DREYESAM: SE REALIZA AJUSTE PARA QUE TOME EL % DE DESCUENTO
    --
    IF SIM_PCK_FUNCION_GEN.ES_SOAT(IP_SECCION => IP_PROCESO.P_COD_SECC) = 'S' AND
       L_NUMEND = 0 THEN
      BEGIN
      
        BEGIN
        
          SELECT X.FECHA_EMI
            INTO FECHA_EMI
            FROM X2000030 X
           WHERE X.NUM_SECU_POL = L_NUMSECUPOL
             AND X.NUM_END = L_NUMEND;
        
          IF IP_POLIZA.DATOSADICIONAL.EXISTS(1) THEN
          
            IF IP_POLIZA.DATOSADICIONAL.COUNT > 0 THEN
            
              FOR I IN IP_POLIZA.DATOSADICIONAL.FIRST .. IP_POLIZA.DATOSADICIONAL.LAST LOOP
                IF IP_POLIZA.DATOSADICIONAL(I).COD_CAMPO = 'PAT_VEH' THEN
                  L_PLACA := IP_POLIZA.DATOSADICIONAL(I).VALOR_CAMPO;
                
                END IF;
              END LOOP;
            END IF;
          END IF;
        
        END;
        /*
          select decode(h.tipo_combustible,5,61,0)
          into v_uso -- VALIDO SI ES ELECTRICO.
          from sim_informacion_runt h
          where h.ig_pat_veh = L_PLACA;
          exception when no_data_found then
            v_uso := 0;
            WHEN OTHERS THEN
              v_uso := 0;
        END;*/
        --DREYESAM: MODIFICO PARA QUE VALIDE POR TIPO COMBUSTIBLE, PARA VALIDAR DESCUENTO.
        BEGIN
          SELECT NVL(H.TIPO_COMBUSTIBLE, 0)
            INTO V_TIENEDTO_TCOM
            FROM SIM_INFORMACION_RUNT H
           WHERE H.IG_PAT_VEH = L_PLACA
             AND NVL(H.TIPO_COMBUSTIBLE, 0) IN
                 (SELECT CODIGO
                    FROM C9999909
                   WHERE COD_TAB = 'SOAT_DCTO_TIPCOMB');
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_TIENEDTO_TCOM := 0;
        END;
        -- END DREYESAM 1
      
        -- DREYESAM: CAMBIO LOGICA PARA VALIDAR SI EL TIPO DE COMBUSTIBLE APLICA PARA DESCUENTO
        -- LOS CUALES SON LOS QUE ESTAN EN LA TABLA C9999909 POR COD_TAB=SOAT_DCTO_TIPCOMB
        -- SI SE ENCUENTRA EN ESA TABLA APLICO EL PORCENTAJE DE DESCUENTO DEL 10%
        IF V_TIENEDTO_TCOM != 0 THEN
          -- DREYESAM: ES TIPO COMBUSTIBLE CON DESCUENTO (5,2,9)
          V_PORCDESCTO_ELE := 10;
          BEGIN
            UPDATE X2000020
               SET VALOR_CAMPO_EN = V_PORCDESCTO_ELE
             WHERE COD_CAMPO = 'PORC_ANTICIPO'
               AND NUM_SECU_POL = L_NUMSECUPOL;
          EXCEPTION
            WHEN OTHERS THEN
              V_PORCDESCTO_ELE := 0;
          END;
        END IF;
      
        --VALIDO EL PORCENTAJE DE DESCUENTO DE LEY.
        V_PORCDESCTO_LEY := PKG_SOAT_PTOS_VTA.FUN_VALIDAR_DSCTO_SOAT(L_PLACA,
                                                                     FECHA_EMI);
        IF NVL(V_PORCDESCTO_LEY, 0) > 0 THEN
          BEGIN
            UPDATE X2000020
               SET VALOR_CAMPO_EN = V_PORCDESCTO_LEY
             WHERE COD_CAMPO = 'DTO_COMERCIAL'
               AND NUM_SECU_POL = L_NUMSECUPOL;
          END;
        END IF;
      
      END;
    END IF;
    -- FIN VALIDACION DESCUENTOS.
    BEGIN
      SIM_PCK_ACCESO_DATOS_EMISION.PROC_CALCULAPRIMATOTAL(L_NUMSECUPOL,
                                                          L_NUMEND,
                                                          IP_ARRCONTEXTO,
                                                          OP_ARRCONTEXTO,
                                                          L_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
      SIM_PROC_LOG('VALIDA_ERROR_MAER',
                   'SIM_PCK_ACCESO_DATOS_EMISION -4330: ' || OP_RESULTADO);
    END;
    --      COMMIT;
    IF OP_RESULTADO = -1 THEN
      --RETURN;
      RAISE_APPLICATION_ERROR(-20000, 'Fallo Calcula Prima Total');
    END IF;
    IF OP_RESULTADO != 0 THEN
      BEGIN
        SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
      END;
      L_RESULTADO := OP_RESULTADO;
    END IF;
  
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
  
    --REGLAS CT
    IF L_LLAMACTNIVEL4 = 'S' THEN
      SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
      L_NIVELCT := '4'; -- 1-DatosFijos  2-5  Riesgo   C-Cobertura 4-Premio
    
      BEGIN
        SIM_PCK_CONTROL_TECNICO.PROC_EJECUTA_CONTROL_TECNICO(L_NUMSECUPOL,
                                                             L_NIVELCT,
                                                             L_EXISTE_CT,
                                                             IP_VALIDACION,
                                                             IP_ARRCONTEXTO,
                                                             OP_ARRCONTEXTO,
                                                             L_PROCESO,
                                                             OP_RESULTADO,
                                                             OP_ARRERRORES);
      END;
    
      IF OP_RESULTADO = -1 THEN
        --RETURN;
        RAISE_APPLICATION_ERROR(-20000, 'Fallo Controles Tecnicos Premio');
      END IF;
      IF OP_RESULTADO != 0 THEN
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
        L_RESULTADO := OP_RESULTADO;
      END IF;
    
      SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
    END IF;
  
    /*Evalua si requiere agendamiento por examenes medicos para vida*/
    --  If Ip_Proceso.p_Cod_Cia = 2 And  Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944,948) Then
    IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
      --Sim_Proc_Log('REQAGENDA2', l_Numsecupol);
    
      BEGIN
        SIM_PCK_REGLASNEGOCIO.SIM_P230_CTT002(L_NUMSECUPOL);
      END;
    END IF;
  
    IF SIM_PCK_REGLAS.G_PARAMETROS('B99_NTPOLPRES') IN (2, 4) THEN
    
      --NTPOLPRES = 4 = SIMULACION
      /*Si no se graba pero es vida 940,942,946 debe mostrar los mensajes de CT*/
      --intasi31 15022016 atgc salud incluye ramos de salud control tecnio 975
      --IF ip_proceso.p_cod_cia = 2 AND ip_proceso.p_cod_producto IN (940,942,946) THEN
      -- INICIA ODVVI-2278 Rwinter Se agregan los productos 956 y 958
    
      IF IP_PROCESO.P_COD_CIA = 2 AND
         IP_PROCESO.P_COD_PRODUCTO IN (942, 960, 952, 954, 956, 958) THEN
        -- FIN ODVVI-2278
        -- inclusion producto 960 juan gonzalez 03.08.2021
        -- Inclusion productos 952 y 954 portafolio vida hqq/jcg 03-03-2022
        -- 30/07/2022 RW : Código revivido debido a un borrado. CTR-Cambios 10476
        DECLARE
          --maor aplica preferente
          L_DESCERROR     VARCHAR2(200);
          L_IPPOLIZAPREF  SIM_TYP_POLIZAGEN;
          L_OPPOLIZAPREF  SIM_TYP_POLIZAGEN;
          L_OPARRERRORES  SIM_TYP_ARRAY_ERROR;
          L_OPRESULTADO   NUMBER;
          L_IPPROCESO     SIM_TYP_PROCESO;
          L_PRIMA942      NUMBER;
          L_PRIMA944      NUMBER;
          L_IPTIPOPROCESO NUMBER := 4;
          L_PRODUCTOPREF  NUMBER;
        BEGIN
          BEGIN
            DBMS_OUTPUT.PUT_LINE('---->l_Numsecupol:::' || L_NUMSECUPOL);
            SELECT 'Bienvenido! Usted ha sido seleccionado para hacer parte de Nuestro ' ||
                   'selecto grupo de clientes preferentes. '
              INTO L_DESCERROR
              FROM A2000020
             WHERE NUM_SECU_POL = L_NUMSECUPOL
               AND COD_RIES IS NULL
               AND NUM_END = 0
               AND VALOR_CAMPO = 'S'
               AND COD_CAMPO = 'APLICA_944';
          
          EXCEPTION
            WHEN OTHERS THEN
              L_DESCERROR := '';
          END;
          -- 30/07/2022 RW : Código revivido debido a un borrado. CTR-Cambios 10476
          --01-INI-juan gonzalez 03.08.2021 , nuevo producto preferente(950)
          IF IP_PROCESO.P_COD_PRODUCTO = 942 THEN
            L_PRODUCTOPREF := 944;
          ELSIF IP_PROCESO.P_COD_PRODUCTO = 960 THEN
            L_PRODUCTOPREF := 950;
          END IF;
          --01-FIN-juan gonzalez 03.08.2021 , nuevo producto preferente(950)
        
          IF L_DESCERROR IS NOT NULL THEN
            L_IPPOLIZAPREF := NEW SIM_TYP_POLIZAGEN();
            L_IPPOLIZAPREF := IP_POLIZA;
            L_OPPOLIZAPREF := NEW SIM_TYP_POLIZAGEN();
            L_OPARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            L_IPPROCESO    := NEW SIM_TYP_PROCESO();
            L_IPPROCESO    := IP_PROCESO;
            -- ODVVI-2285 RWinter 14/10/2022 INICIO
            -- Se cambia el valor quedamo por la variable
            L_IPPROCESO.P_COD_PRODUCTO := L_PRODUCTOPREF;
            -- ODVVI-2285 RWinter 14/10/2022 FIN
            L_IPPROCESO.P_PROCESO                  := 201;
            L_IPPROCESO.P_SUBPROCESO               := 200;
            L_IPPOLIZAPREF.DATOSFIJOS.NUM_SECU_POL := L_NUMSECUPOLORG;
            -- ODVVI-2285 RWinter 14/10/2022 INICIO
            -- Se cambia el valor quedamo por la variable
            L_IPPOLIZAPREF.DATOSFIJOS.COD_RAMO.CODIGO := L_PRODUCTOPREF;
            -- ODVVI-2285 RWinter 14/10/2022 FIN
            L_IPPOLIZAPREF.DATOSFIJOS.NUM_POL1 := NULL;
            --Commit;
            SIM_PCK_ACCESO_SERVICIOS.PROC_SERVICEEXPIDE(L_IPPOLIZAPREF,
                                                        L_IPTIPOPROCESO,
                                                        L_OPPOLIZAPREF,
                                                        IP_VALIDACION,
                                                        L_IPPROCESO,
                                                        L_OPRESULTADO,
                                                        L_OPARRERRORES);
          
            L_ERROR := SIM_TYP_ERROR(-20000, L_DESCERROR, 'W');
            OP_ARRERRORES.EXTEND;
            OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          
            L_DESCERROR := 'Nota: Tenga en cuenta que si realiza incremento de valor asegurado al amparo básico ' ||
                           'su solicitud podría entrar a estudio por parte de la compañia';
            L_ERROR     := SIM_TYP_ERROR(-20000, L_DESCERROR, 'W');
            OP_ARRERRORES.EXTEND;
            OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
            L_RESULTADO := 1;
            BEGIN
              SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
              OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            END;
          
            BEGIN
              SELECT A.PREMIO_END
                INTO L_PRIMA942
                FROM A2000160 A
               WHERE A.NUM_SECU_POL = L_NUMSECUPOL
                 AND A.NUM_END = 0
                 AND A.TIPO_REG = 'T';
            EXCEPTION
              WHEN OTHERS THEN
                L_PRIMA942 := 0;
            END;
            L_PRIMA944 := L_OPPOLIZAPREF.PRIMA.PREMIO;
            --Added spaces By TraQIQ, Poject Operaciones 2020-10-22, Added spaces and comma between l_Descerror string for vida decl popup
            -- ODVVI-2285 RWinter 14/10/2022 INICIO
            -- Se cambia el mensaje de PREF para el producto 960
            IF IP_PROCESO.P_COD_PRODUCTO = 960 THEN
              L_DESCERROR := 'Bienvenido! Usted ha sido seleccionado para hacer parte de Nuestro selecto grupo de clientes preferentes.' ||
                             CHR(13) || 'Valor Inicial: ' || L_PRIMA942 ||
                             ' Valor Reliquidado: ' || L_PRIMA944;
            ELSE
              L_DESCERROR := 'Valor Inicial: ' || L_PRIMA942 ||
                             ' Valor Reliquidado: ' || L_PRIMA944;
            END IF;
            -- ODVVI-2285 RWinter 14/10/2022 FIN
            L_ERROR := SIM_TYP_ERROR(-20000, L_DESCERROR, 'W');
            OP_ARRERRORES.EXTEND;
            OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
            L_RESULTADO := 1;
            BEGIN
              SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
              OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            END;
          END IF;
        END;
      
        -- fin intasi31 15022016
      
        FOR REG_C_CT IN C_CT LOOP
        
          SIM_PROC_LOG('NVZ 03042024', '1');
          IF REG_C_CT.COD_ERROR IN (975) THEN
            DECLARE
              L_PREMIOA   NUMBER := 0;
              L_PREMIOX   NUMBER := 0;
              L_DESCERROR VARCHAR2(200) := REG_C_CT.DESC_ERROR;
            BEGIN
              BEGIN
                SELECT A.PREMIO_END
                  INTO L_PREMIOA
                  FROM A2000160 A
                 WHERE A.NUM_SECU_POL = L_NUMSECUPOL
                   AND A.NUM_END = 0
                   AND A.TIPO_REG = 'T';
              EXCEPTION
                WHEN OTHERS THEN
                  L_PREMIOA := 0;
              END;
            
              BEGIN
                SELECT B.PREMIO_END
                  INTO L_PREMIOX
                  FROM X2000160 B
                 WHERE B.NUM_SECU_POL = L_NUMSECUPOL
                   AND B.TIPO_REG = 'T';
              EXCEPTION
                WHEN OTHERS THEN
                  L_PREMIOX := 0;
              END;
            
              --intasi31 ATGC SALUD 11052016
              IF SIM_PCK_ATGC_SALUD.FUN_ESRAMOATGCSALUD(IP_PROCESO.P_COD_CIA,
                                                        IP_PROCESO.P_COD_SECC,
                                                        IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
                L_DESCERROR := 'Diferencia en Recalculo de Primas Vr.Inicial:' ||
                               TO_CHAR(L_PREMIOA, '999,999,999') ||
                               ' Vr.Reliquidado:' ||
                               TO_CHAR(L_PREMIOX, '999,999,999') ||
                               ' No se Puede Emitir La Poliza, Debe Usar la' ||
                               ' Opcion Copiar Cotizacion';
              ELSE
                L_DESCERROR := 'Valor Inicial:' || L_PREMIOA ||
                               ' Valor Reliquidado:' || L_PREMIOX;
              END IF;
            
              --Control Tecnico de Prima diferente 975
              IF REG_C_CT.COD_RECHAZO = 1 THEN
                --control tecnico observado
                L_ERROR := SIM_TYP_ERROR(-20000,
                                         REG_C_CT.COD_ERROR || '-' ||
                                         L_DESCERROR,
                                         'W');
                OP_ARRERRORES.EXTEND;
                OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                L_RESULTADO := 1;
                BEGIN
                  SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
                  OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                END;
              
              END IF;
            
              IF REG_C_CT.COD_RECHAZO = 3 THEN
                -- control tecnico a autorica
                L_ERROR := SIM_TYP_ERROR(-20000,
                                         REG_C_CT.COD_ERROR || '-' ||
                                         L_DESCERROR,
                                         'W');
                OP_ARRERRORES.EXTEND;
                OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                L_RESULTADO := 1;
                BEGIN
                  SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
                  OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                END;
              
              END IF;
            
              IF REG_C_CT.COD_RECHAZO = 2 THEN
                -- control tecnico rechazado
                L_ERROR := SIM_TYP_ERROR(-20000,
                                         REG_C_CT.COD_ERROR || '-' ||
                                         L_DESCERROR,
                                         'E');
                OP_ARRERRORES.EXTEND;
                OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000, L_DESCERROR);
              END IF;
            END;
          END IF;
        END LOOP;
      END IF;
      -- se agrega control tecnico 145 valores erroneos en liquidación
      FOR REG_C_CT IN C_CT LOOP
        IF REG_C_CT.COD_ERROR IN (145) THEN
          L_GRABAR := 'N';
          L_ERROR  := SIM_TYP_ERROR(-20000,
                                    'Control Tecnico Rechazado ' ||
                                    REG_C_CT.COD_ERROR || '-' ||
                                    REG_C_CT.DESC_ERROR,
                                    'E');
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          OP_RESULTADO := -1;
          RAISE_APPLICATION_ERROR(-20000, 'Control Tecnico Rechazado');
        END IF;
      END LOOP;
      -- sgpinto 22112016: Integración manejo multirriesgo con "huecos" en códigos de riesgo
      -- 18/08/2016 sgpm: Adición de llamado a función de resecuencia de riesgos
      BEGIN
      
        PRC299_CAMBIO_COD_RIES(IP_NUM_SECU_POL => L_NUMSECUPOL,
                               IP_NUM_END      => L_NUMEND,
                               IP_POLIZA       => L_POLIZA,
                               OP_POLIZA       => OP_POLIZA,
                               IP_VALIDACION   => IP_VALIDACION,
                               IP_PROCESO      => IP_PROCESO,
                               OP_RESULTADO    => OP_RESULTADO,
                               OP_ARRERRORES   => OP_ARRERRORES);
        SIM_PROC_LOG('VALIDA_ERROR_MAER',
                     'PRC299_CAMBIO_COD_RIES -4623: ' || OP_RESULTADO);
        IF OP_RESULTADO = -1 THEN
          RETURN;
        END IF;
        IF OP_RESULTADO != 0 THEN
          BEGIN
            SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
            OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
          END;
          L_RESULTADO := OP_RESULTADO;
        END IF;
        L_POLIZA := OP_POLIZA;
      END;
      --
    ELSE
      L_GRABAR := 'S';
      -- Masivo Digital actualiza valor credito en la nomina vida y 
      -- valida pol. debe quedar provisoria
      IF IP_PROCESO.P_CANAL = 6 THEN
        PROC_ACTUALIZA_NOMINA(L_NUMSECUPOL, L_NUMEND);
        SELECT NVL(INSTR(IP_PROCESO.P_INFO1, ';'), 0),
               LENGTH(IP_PROCESO.P_INFO1)
          INTO L_VAR, L_LONGVAR
          FROM DUAL;
        IF IP_PROCESO.P_INFO1 IS NOT NULL AND L_NUMEND = 0 AND L_VAR > 0 THEN
          PROC_CT_MASIVO_DIGITAL(L_NUMSECUPOL, L_PROCESO);
        END IF;
      END IF;
      FOR REG_C_CT IN C_CT LOOP
        IF REG_C_CT.COD_RECHAZO = 2 THEN
        
          L_GRABAR := 'N';
          L_ERROR  := SIM_TYP_ERROR(-20000,
                                    'Control Tecnico Rechazado ' ||
                                    REG_C_CT.COD_ERROR || '-' ||
                                    REG_C_CT.DESC_ERROR,
                                    'E');
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          OP_RESULTADO := -1;
          RAISE_APPLICATION_ERROR(-20000, 'Control Tecnico Rechazado');
        END IF;
      END LOOP;
    
      -- sgpinto 22112016: Integración manejo multirriesgo con "huecos" en códigos de riesgo
      -- 18/08/2016 sgpm: Adición de llamado a función de resecuencia de riesgos
      BEGIN
        PRC299_CAMBIO_COD_RIES(IP_NUM_SECU_POL => L_NUMSECUPOL,
                               IP_NUM_END      => L_NUMEND,
                               IP_POLIZA       => L_POLIZA,
                               OP_POLIZA       => OP_POLIZA,
                               IP_VALIDACION   => IP_VALIDACION,
                               IP_PROCESO      => IP_PROCESO,
                               OP_RESULTADO    => OP_RESULTADO,
                               OP_ARRERRORES   => OP_ARRERRORES);
        SIM_PROC_LOG('VALIDA_ERROR_MAER',
                     'PRC299_CAMBIO_COD_RIES -4674: ' || OP_RESULTADO);
        IF OP_RESULTADO = -1 THEN
          RETURN;
        END IF;
        IF OP_RESULTADO != 0 THEN
          BEGIN
            SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
            OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
          END;
          L_RESULTADO := OP_RESULTADO;
        END IF;
      END;
    
      L_POLIZA := OP_POLIZA;
      -- 18/08/2016 sgpm.
    
      IF L_GRABAR = 'S' THEN
        BEGIN
          UPDATE X2000030
             SET SIM_TIPO_NEGOCIO = SIM_PCK_REGLAS.G_PARAMETROS('B99_NTPOLPRES')
           WHERE NUM_SECU_POL = L_NUMSECUPOL
             AND NUM_END = L_NUMEND;
        END;
      
        L_TPROCESO    := L_PROCESO.P_PROCESO;
        L_TSUBPROCESO := L_PROCESO.P_SUBPROCESO;
        L_TNTPOLPRES  := SIM_PCK_REGLAS.G_PARAMETROS('B99_NTPOLPRES');
      
        BEGIN
          UPDATE X2000020
             SET VALOR_CAMPO = 'S', VALOR_CAMPO_EN = 'S'
           WHERE NUM_SECU_POL = L_NUMSECUPOL
             AND COD_CAMPO = 'DEDUCIBLE_ALT';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        --        If l_Tproceso In ( 270, 261,260) Then
        --06/06/2019 lberbesi: Se incluye función para verificar que aplique formalización para el 274 desde Simón Web.
        IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' OR
           FUN201_FORMALIZA_274_SIMONWEB(L_PROCESO) = 'S' THEN
          BEGIN
            SELECT NUM_POL_COTIZ
              INTO L_NUMPOLCOTIZ
              FROM A2000030
             WHERE NUM_SECU_POL = L_NUMSECUPOL
               AND NUM_END = 0;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        
          --Delete sim_decl_aseg_pol Where num_secu_pol = l_numsecupol;
        
          --Ya debe disparar de forma automatica el control tecnico de mesa de control
          --Disparando la regla 299CTT001
          IF SIM_PCK_FUNCION_GEN.ES_AUTOS(IP_PROCESO.P_COD_SECC,
                                          IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
            --            If Ip_Proceso.p_Canal = 3 And Ip_Proceso.p_Proceso != 270 Then
            IF IP_PROCESO.P_CANAL = 3 AND
               IP_PROCESO.P_PROCESO NOT IN (270, 260, 261) THEN
              UPDATE X2040100 Z
                 SET Z.SUMA_ASEG     = Z.SUMA_ASEG - Z.SUMA_ACCES,
                     Z.SUMA_ASEG_V   = Z.SUMA_ASEG_V - Z.SUMA_ACCES,
                     Z.SUMA_ASEG_0KM = Z.SUMA_ASEG_0KM - Z.SUMA_ACCES,
                     Z.MCA_ACCESORIO = DECODE(NVL(Z.SUMA_ACCES, 0),
                                              0,
                                              'N',
                                              'S')
               WHERE Z.NUM_SECU_POL = L_NUMSECUPOL;
            END IF;
          
            --Control Tecnico Mesa de Control
          
            IF (SIM_PCK_FUNCION_GEN.AGENTE_ESATGC(SIM_PCK_REGLAS.G_PARAMETROS('B1_COD_PROD'),
                                                  IP_PROCESO.P_COD_CIA,
                                                  IP_PROCESO.P_COD_SECC,
                                                  IP_PROCESO.P_COD_PRODUCTO,
                                                  IP_PROCESO.P_SUBPRODUCTO) = 0 AND
               IP_PROCESO.P_CANAL = 3) OR
               (IP_PROCESO.P_PROCESO = 270 AND IP_PROCESO.P_CANAL = 1) THEN
              BEGIN
                SELECT 'S'
                  INTO L_VALORCAMPO
                  FROM X2000220 B
                 WHERE B.NUM_SECU_POL = L_NUMSECUPOL
                   AND B.COD_ERROR = 600;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    -- Call the procedure
                    SIM_PCK_REGLASNEGOCIO.SIM_P201_CTM001(L_NUMSECUPOL,
                                                          IP_PROCESO.P_COD_SECC,
                                                          IP_PROCESO.P_COD_CIA,
                                                          L_NUMEND);
                  END;
                WHEN OTHERS THEN
                  NULL;
              END;
            
              BEGIN
                UPDATE A2000030 C
                   SET C.MCA_PROVISORIO = 'S'
                 WHERE NUM_SECU_POL = L_NUMSECUPOL;
              END;
            END IF;
          END IF;
        
          IF OP_RESULTADO = -1 THEN
            --RETURN;
            RAISE_APPLICATION_ERROR(-20000, 'Fallo ');
          END IF;
        END IF;
      
        SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
      
        --
        -- CUMPLIMIENTO: INICIO DE MAPEO DE TEXTOS
        --
        BEGIN
          SIM_PCK_PROCESO_DATOS_EMISION2.PROC_MAPEO_TEXTOS(IP_POLIZA      => L_POLIZA,
                                                           IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                           IP_TIPOPROCESO => IP_TIPOPROCESO,
                                                           OP_POLIZA      => OP_POLIZA,
                                                           IP_VALIDACION  => IP_VALIDACION,
                                                           IP_ARRCONTEXTO => IP_ARRCONTEXTO,
                                                           OP_ARRCONTEXTO => OP_ARRCONTEXTO,
                                                           IP_PROCESO     => IP_PROCESO,
                                                           OP_RESULTADO   => OP_RESULTADO,
                                                           OP_ARRERRORES  => OP_ARRERRORES);
          SIM_PROC_LOG('VALIDA_ERROR_MAER',
                       'SIM_PCK_PROCESO_DATOS_EMISION2 -4806: ' ||
                       OP_RESULTADO);
        
          IF OP_RESULTADO = -1 THEN
            --RETURN;
            RAISE_APPLICATION_ERROR(-20000, 'Fallo Mapeo textos');
          END IF;
          IF OP_RESULTADO != 0 THEN
            BEGIN
              SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
              OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            END;
            L_RESULTADO := OP_RESULTADO;
          END IF;
        END;
      
        /*           DELETE A2000030 WHERE num_secu_pol = l_numsecupol;
        DELETE A2000020 WHERE num_secu_pol = l_numsecupol;
        DELETE A2000040 WHERE num_secu_pol = l_numsecupol;
        DELETE A2000060 WHERE num_secu_pol = l_numsecupol;
        DELETE sim_debito_automatico  WHERE num_secu_pol = l_numsecupol;
        DELETE A2000220 WHERE num_secu_pol = l_numsecupol;
        DELETE A2040100 WHERE num_secu_pol = l_numsecupol;
        DELETE A2040200 WHERE num_secu_pol = l_numsecupol;
        DELETE A2040300 WHERE num_secu_pol = l_numsecupol;
        DELETE A2040400 WHERE num_secu_pol = l_numsecupol;
        DELETE A2000160 WHERE num_secu_pol = l_numsecupol;
        DELETE A2000250 WHERE num_secu_pol = l_numsecupol;
        DELETE A2000190 WHERE num_secu_pol = l_numsecupol;
        DELETE A2001300 WHERE num_secu_pol = l_numsecupol;
        --intasi31-Rosario Puertas 06072016
        DELETE c2000251 WHERE num_secu_pol = l_numsecupol;
        DELETE Sim_Riesgo_Poliza WHERE num_secu_pol = l_numsecupol;
        --DELETE Sim_x_Riesgo_Poliza WHERE num_secu_pol = l_numsecupol;
        --fin intasi31-Rosario Puertas 06072016
        DELETE SIM_TERCEROS WHERE num_secu_pol = l_numsecupol; */
      
        -- se reemplaza el codigo anterior por el llamado a un
        -- nuevo procedimiento  -- Wesv 20160801
        SIM_PROC_LOG('MPGL ANTES DE BORRAR REALES 1 - antes de proc_updmail ',
                     L_NUMSECUPOL);
        PROC_BORRARTABLASREALES(L_NUMSECUPOL);
      
        IF IP_PROCESO.P_PROCESO = 270 THEN
        
          BEGIN
            SIM_PCK_PROCESO_DATOS_EMISION2.PROC_UPDEMAIL(L_NUMSECUPOL,
                                                         L_NUMEND,
                                                         NULL,
                                                         IP_VALIDACION,
                                                         IP_PROCESO,
                                                         OP_RESULTADO,
                                                         OP_ARRERRORES);
          END;
          IF OP_RESULTADO = -1 THEN
            NULL;
          END IF;
          IF OP_RESULTADO != 0 THEN
            BEGIN
              SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
              OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
            
            END;
            L_RESULTADO := OP_RESULTADO;
          END IF;
        
        END IF;
      
        BEGIN
          -- Call the procedure
          --  pkg299_multicompania.inserta_log(l_Numsecupol,1,'va a graba');
          --04/03/2019 lberbesi: Se incluye manejo de anula-reemplaza en renovaciones de autos
          ---------------------------------INICIO---------------------------------------------
          --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
          IF IP_PROCESO.P_COD_SECC = 1 AND IP_PROCESO.P_COD_PRODUCTO = 250 AND
             IP_PROCESO.P_PROCESO = 270 AND IP_PROCESO.P_SUBPROCESO = 260 AND
             IP_PROCESO.P_SUBPRODUCTO IN (251, 263, 274, 360) AND
             IP_PROCESO.P_CANAL = 3 AND IP_PROCESO.P_SISTEMA_ORIGEN = 101 THEN
            FOR RIES IN C_RIESGOS LOOP
              PROC_ANULAREEMPLAZA_RENOV(IP_NUMSECUPOL   => L_NUMSECUPOL,
                                        IP_NUMEND       => L_NUMEND,
                                        IP_CODRIES      => RIES.COD_RIES,
                                        OP_ESANULAREEMP => L_ESANULAREEMP,
                                        IP_PROCESO      => L_PROCESO,
                                        OP_RESULTADO    => OP_RESULTADO,
                                        OP_ARRERRORES   => OP_ARRERRORES);
              IF OP_RESULTADO = -1 THEN
                RAISE_APPLICATION_ERROR(-20008,
                                        'Error en anula-reemplaza renov');
              END IF;
            END LOOP;
          ELSIF IP_PROCESO.P_CANAL = 6 AND IP_PROCESO.P_INFO1 IS NOT NULL AND
                L_VAR = 0 AND L_LONGVAR = 13 AND IP_PROCESO.P_PROCESO = 270 THEN
            DECLARE
              L_PROCESOANULA SIM_TYP_PROCESO; -- HU GD889-141
            BEGIN
              L_PROCESOANULA              := NEW SIM_TYP_PROCESO;
              L_PROCESOANULA              := IP_PROCESO;
              L_PROCESOANULA.P_PROCESO    := 351;
              L_PROCESOANULA.P_SUBPROCESO := 350;
              L_POLIZAANULA               := IP_PROCESO.P_INFO1;
            
              SELECT FECHA_VIG_POL
                INTO L_FECHAANULA
                FROM A2000030 B
               WHERE NUM_POL1 = L_POLIZAANULA
                 AND COD_SECC = IP_PROCESO.P_COD_SECC
                 AND NUM_END =
                     (SELECT MAX(NUM_END)
                        FROM A2000030
                       WHERE NUM_SECU_POL = B.NUM_SECU_POL)
                 AND NVL(MCA_ANU_POL, 'N') = 'N';
              SIM_PCK_VALIDA_DATOS_EMISION.PROC_ANULA_POLIZA(L_POLIZAANULA,
                                                             L_FECHAANULA,
                                                             L_NUMENDANU,
                                                             L_MCAANULA,
                                                             IP_VALIDACION,
                                                             L_PROCESOANULA,
                                                             L_RESULTADO,
                                                             L_ARRERRORES);
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                OP_RESULTADO := 0;
              WHEN OTHERS THEN
                OP_RESULTADO := -1;
                OP_ARRERRORES.EXTEND;
                OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                                    'Error anula Reemp masivo Digital ' ||
                                                                    SQLERRM,
                                                                    'e');
            END;
          END IF;
        
          ----------------------------------FIN-----------------------------------------------
          IF OP_RESULTADO != -1 THEN
            SIM_PCK_PROCESO_DML_EMISION.PROC_GRABA_POLIZA_COT(L_NUMSECUPOL,
                                                              L_NROCERTIFICADO,
                                                              OP_NUMPOL1,
                                                              OP_NUMEND,
                                                              OP_MCA_PROVISORIA,
                                                              IP_VALIDACION,
                                                              IP_ARRCONTEXTO,
                                                              OP_ARRCONTEXTO,
                                                              L_PROCESO,
                                                              OP_RESULTADO,
                                                              OP_ARRERRORES);
          
          END IF;
        
          --pkg299_multicompania.inserta_log(l_Numsecupol,1,'sale a graba'||op_resultado);
          IF OP_RESULTADO = -1 THEN
            ROLLBACK;
            --            If Ip_Proceso.p_Proceso = 270 Then
            IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' THEN
              DELETE SIM_EXPEDICION_ENLINEA C
               WHERE C.NUM_SECU_POL = L_NUMSECUPOL
                 AND C.PROCESO = IP_PROCESO.P_PROCESO;
            
            END IF;
          
            RAISE_APPLICATION_ERROR(-20000, 'Fallo Graba poliza');
          ELSE
            IF OP_RESULTADO != 0 THEN
              BEGIN
                SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
                OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
              END;
            
              L_RESULTADO := OP_RESULTADO;
            END IF;
          
            --Commit;
          
          END IF;
        
          --04/03/2019 lberbesi: Se incluye manejo de anula reemplaza en renovaciones de autos
          ----------------------------------INICIO--------------------------------------------
          IF L_PROCESO.P_COD_SECC = 1 AND
             L_ESANULAREEMP = SIM_PCK_TIPOS_GENERALES.C_SI AND
             IP_PROCESO.P_PROCESO = 270 AND IP_PROCESO.P_SUBPROCESO = 260 AND
             IP_PROCESO.P_CANAL = 3 AND IP_PROCESO.P_SISTEMA_ORIGEN = 101 THEN
            DECLARE
              L_CODEND      A2000030.COD_END%TYPE;
              L_SUBCODEND   A2000030.SUB_COD_END%TYPE;
              L_OBSERVACION VARCHAR2(50);
              L_NUMEND      A2000030.NUM_END%TYPE;
              L_NUM_POLIZA  A2000030.NUM_POL1%TYPE;
              L_FECHAVIG    A2000030.FECHA_VIG_POL%TYPE;
              L_NSP         A2000030.NUM_SECU_POL%TYPE;
            
            BEGIN
              L_CODEND               := 100;
              L_SUBCODEND            := 1;
              L_OBSERVACION          := 'Anula reemplazo por conversión a opciones';
              L_PROCESO.P_PROCESO    := 350;
              L_PROCESO.P_SUBPROCESO := 351;
              BEGIN
                SELECT A30.NUM_SECU_POL, A30.FECHA_VIG_POL
                  INTO L_NSP, L_FECHAVIG
                  FROM A2000030 A30
                 WHERE NUM_POL1 = (SELECT NUM_POL_ANT
                                     FROM A2000030
                                    WHERE NUM_SECU_POL = L_NUMSECUPOL
                                      AND NUM_END = 0)
                   AND NUM_END = 0
                   AND COD_CIA = L_PROCESO.P_COD_CIA
                   AND COD_RAMO = L_PROCESO.P_COD_PRODUCTO;
              
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  OP_RESULTADO := -1;
                  OP_ARRERRORES.EXTEND;
                  OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                                      'No encontró datos para anula-reemplaza',
                                                                      'e');
                WHEN OTHERS THEN
                  OP_RESULTADO := -1;
                  OP_ARRERRORES.EXTEND;
                  OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                                      'Error recuperando datos para anula-reemplaza',
                                                                      'e');
                
              END;
            
              --09/05/2019 lberbesi: Se incluye actualización de renovada_por
              DECLARE
                L_POL_NVA A2000030.NUM_POL1%TYPE;
              
              BEGIN
                BEGIN
                  SELECT NUM_POL1
                    INTO L_POL_NVA
                    FROM A2000030
                   WHERE NUM_SECU_POL = L_NUMSECUPOL;
                
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    L_POL_NVA := NULL;
                  
                END;
              
                UPDATE A2000030
                   SET RENOVADA_POR = L_POL_NVA
                 WHERE NUM_SECU_POL = L_NSP;
              
              END;
            
              IF L_NSP IS NOT NULL AND L_FECHAVIG IS NOT NULL THEN
                SIM_PCK_PROCESO_DML_EMISION_F2.PROC_SERVICEANULA_POLIZA(IP_NUMSECUPOL  => L_NSP,
                                                                        IP_FECHAVIGEND => L_FECHAVIG,
                                                                        IP_CODEND      => L_CODEND,
                                                                        IP_SUBCODEND   => L_SUBCODEND,
                                                                        IP_OBSERVACION => L_OBSERVACION,
                                                                        OP_NUMEND      => L_NUMEND,
                                                                        IP_PROCESO     => L_PROCESO,
                                                                        OP_RESULTADO   => OP_RESULTADO,
                                                                        OP_ARRERRORES  => OP_ARRERRORES);
                IF OP_RESULTADO <> 0 THEN
                  FOR ERR IN OP_ARRERRORES.FIRST .. OP_ARRERRORES.LAST LOOP
                    RAISE_APPLICATION_ERROR(-20005,
                                            'Error en anulación de póliza: ' || OP_ARRERRORES(ERR)
                                            .DESC_ERROR);
                  END LOOP;
                
                END IF;
              
              END IF;
            
            END;
          
          END IF;
        
          -----------------------------------FIN----------------------------------------------
          L_POLIZA.DATOSFIJOS.NUM_POL1 := OP_NUMPOL1;
          L_NUMEND                     := OP_NUMEND;
          IF L_PROCESO.P_COD_PRODUCTO = 777 AND
             L_PROCESO.P_PROCESO IN (270, 260, 261) THEN
            --morj 04Mayo2018
            L_PROCESO.P_PROCESO    := 261;
            L_PROCESO.P_SUBPROCESO := 260;
            --        l_resultado := Op_Resultado;
            --        l_Arrerrores := op_arrerrores;
            /*            Begin
              Sim_Pck_Errores.Manejarerror(l_Arrerrores, Op_Arrerrores);
              Op_Arrerrores := New Sim_Typ_Array_Error();
            End;*/
          
            BEGIN
              UPDATE A2000030
                 SET MCA_COTIZACION = 'N'
               WHERE NUM_SECU_POL = L_NUMSECUPOL
                 AND NUM_END = 0;
            
            END;
          
            BEGIN
              SIM_PCK_PROCESO_DATOS_EMISION3.PRC_LLAMARSERVEXPONLINE(L_PROCESO,
                                                                     L_NUMEND,
                                                                     L_POLIZA.DATOSFIJOS.NUM_POL1,
                                                                     0,
                                                                     L_NUMSECUPOL,
                                                                     'P',
                                                                     OP_RESULTADO,
                                                                     L_ARRERRORES);
            EXCEPTION
              WHEN OTHERS THEN
                OP_RESULTADO := 0;
              
            END;
          
          END IF;
        
          BEGIN
            --Inserta documentos requeridos siempre y cuando esten parametrizados
            INSERT INTO SIM_CONTROL_DOCUMENTOS_PROCESO
              (SECUENCIA,
               NUM_SECU_POL,
               NUM_END,
               ID_CARPETA,
               ID_DOCUMENTO,
               FECHA_SOLICITUD,
               ESTADO,
               USUARIO_CREACION,
               FECHA_CREACION)
              SELECT SIM_SEQ_CTRL_DOCS_EMISION.NEXTVAL,
                     L_NUMSECUPOL,
                     L_NUMEND,
                     A.ID_CARPETA,
                     A.ID_DOCUMENTO,
                     SYSDATE,
                     'P',
                     IP_PROCESO.P_COD_USR,
                     SYSDATE
                FROM SIM_DOCUMENTOS_CARPETA A,
                     SIM_CARPETAS_PRODUCTOS B,
                     SIM_PRODUCTOS          C
               WHERE B.ID_PRODUCTO = C.ID_PRODUCTO
                 AND C.COD_PRODUCTO = IP_PROCESO.P_COD_PRODUCTO
                 AND B.ID_PROCESO = IP_PROCESO.P_PROCESO
                 AND NVL(B.ID_SUBPRODUCTO, -1) =
                     NVL(IP_PROCESO.P_SUBPRODUCTO, -1)
                 AND A.ID_CARPETA = B.ID_CARPETA
                    --incluido por wesv 20160803 para no insertar registro
                    -- de factura 0 km para vehiculos nuevos
                 AND DECODE(A.ID_DOCUMENTO, C_DCTOFACTCEROKM, 'NEW', 'ALL') =
                     DECODE(A.ID_DOCUMENTO,
                            C_DCTOFACTCEROKM,
                            DECODE(SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('CERO_KM',
                                                                            L_NUMSECUPOL,
                                                                            1),
                                   'S',
                                   'NEW',
                                   'OLD'),
                            'ALL')
              
              ;
          
          END;
        
          BEGIN
            SELECT COUNT(1)
              INTO L_EXISTE
              FROM A2000163
             WHERE NUM_SECU_POL = L_NUMSECUPOLORG;
          
          END;
        
          IF L_EXISTE = 0 THEN
            BEGIN
              SELECT COUNT(1)
                INTO L_EXISTE
                FROM A2000030
               WHERE NUM_SECU_POL = L_NUMSECUPOLORG
                 AND NUM_POL1 IS NULL
                 AND NVL(MCA_COTIZACION, 'S') = 'S';
            
            END;
          
            IF L_EXISTE > 0 AND L_TPROCESO IN (270, 261, 260) THEN
              SIM_PROC_LOG('MPGL ANTES DE BORRAR REALES ' || L_TPROCESO,
                           L_NUMSECUPOLORG);
            
              /*                  DELETE A2000030 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2000020 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2000040 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2000060 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE sim_debito_automatico  WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2000220 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2040100 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2040200 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2040300 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2040400 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2000160 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2000250 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2000190 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE A2001300 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE SIM_TERCEROS WHERE num_secu_pol = l_numsecupolorg;
                                --intasi31-Rosario Puertas 06072016
                                DELETE c2000251 WHERE num_secu_pol = l_numsecupolorg;
                                DELETE Sim_Riesgo_Poliza WHERE num_secu_pol = l_numsecupolorg;
                                --DELETE Sim_x_Riesgo_Poliza WHERE num_secu_pol = l_numsecupolorg;
                                --fin intasi31-Rosario Puertas 06072016
              */
            
              -- se reemplaza el codigo anterior por el llamado a un
              -- nuevo procedimiento  -- Wesv 20160801
              PROC_BORRARTABLASREALES(L_NUMSECUPOLORG);
              /* RPR actualiza nsp original*/
            
            END IF;
          
          END IF;
        
          /* 24 Feb 2016, se deja en comentario
              y se deja la marca datos minimos solo para
              canal 3, sistema origen 101,
              procesos que vienen de Simon Quotation
           IF ip_proceso.p_cod_producto != 315
           Then
          
              BEGIN
                 UPDATE A2000030
                    SET mca_datos_min = 'S'
                  WHERE     num_secu_pol = l_numsecupol
                        AND num_end = l_numend
                        AND num_pol1 IS NULL
                        AND NVL (mca_cotizacion, 'N') = 'S';
              END;
          
           END IF;
          
           --  INICIO-TRANSMASIVO
           IF ip_proceso.p_cod_producto = 250 AND
              ip_proceso.p_subproducto = 363 THEN
              BEGIN
                  UPDATE a2000030
                     SET mca_datos_min = 'N'
                   WHERE num_secu_pol = l_numsecupol
                     AND num_end = l_numend
                     AND num_pol1 IS NULL
                     AND nvl(mca_cotizacion, 'N') = 'S';
              END;
           END IF;
          --   FIN-TRANSMASIVO
          */
        
          BEGIN
            --pkg299_multicompania.inserta_log(l_Numsecupol,1,' emision2 act datos minimos');
            --               And Ip_Proceso.p_Sistema_Origen = 101;
          
            UPDATE A2000030
               SET MCA_DATOS_MIN = 'S'
             WHERE NUM_SECU_POL = L_NUMSECUPOL
               AND NUM_END = L_NUMEND
               AND NUM_POL1 IS NULL
               AND NVL(MCA_COTIZACION, 'N') = 'S'
               AND IP_PROCESO.P_CANAL = 3
               AND EXISTS
             (SELECT DAT_NUM
                      FROM C9999909
                     WHERE COD_TAB = 'MCA_DATOS_MIN'
                       AND DAT_NUM = IP_PROCESO.P_SISTEMA_ORIGEN
                       AND DAT_CAR = 'S');
          
          END;
        
          BEGIN
            UPDATE A2000030
               SET NUM_POL_COTIZ = L_NUMPOLCOTIZ, MCA_DATOS_MIN = NULL
             WHERE NUM_SECU_POL = L_NUMSECUPOL
               AND NUM_END = L_NUMEND
               AND NUM_POL1 IS NOT NULL
               AND NVL(MCA_COTIZACION, 'N') = 'N';
          
            IF SQL%FOUND THEN
              UPDATE P2000030
                 SET SIM_NUM_COTIZ_ANT = L_NUMPOLCOTIZ
               WHERE NUM_SECU_POL = L_NUMSECUPOL;
            
            END IF;
          
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
            
          END;
        
          --          If l_Tproceso = 270 Then
          IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' THEN
            IF SIM_PCK_FUNCION_GEN.ES_AUTOS(IP_PROCESO.P_COD_SECC,
                                            IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
              BEGIN
                SELECT MCA_PROVISORIO
                  INTO L_MCA_PROVISORIO
                  FROM A2000030
                 WHERE NUM_SECU_POL = L_NUMSECUPOL
                   AND NUM_END = L_NUMEND;
              
              EXCEPTION
                WHEN OTHERS THEN
                  L_MCA_PROVISORIO := 'N';
                
              END;
            
              IF L_MCA_PROVISORIO = 'S' AND IP_PROCESO.P_CANAL = 1 THEN
                /*si es provisorio y el canal es 1, quiere decir que es la opcion de formalizacion
                existente en simon en donde se cruza la cotizacion y la inspeccion y la realizan los
                agentes, este mensaje es solo para esa opcion */
              
                L_ERROR := SIM_TYP_ERROR(-20000,
                                         'Tiempo de Respuesta 15 minutos ',
                                         'W');
                OP_ARRERRORES.EXTEND;
                OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                L_RESULTADO := 1;
                BEGIN
                  SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
                  OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                END;
              
              END IF;
            
            END IF;
          
          END IF;
        
        END;
      
        SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(OP_ARRCONTEXTO);
      
        --    If Ip_Proceso.p_Cod_Cia = 2 And Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
        IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
          NULL;
        ELSE
          /*
           For Reg_c_Ct In c_Ct Loop
            If Ip_Proceso.p_Proceso Not In (240, 241) Then
             If Reg_c_Ct.Cod_Rechazo = 1 Then
              l_Error := Sim_Typ_Error(-20000,
                                       'Control Tecnico Observado ' ||
                                       Reg_c_Ct.Cod_Error || '-' ||
                                       Reg_c_Ct.Desc_Error,
                                       'W');
              Op_Arrerrores.Extend;
              Op_Arrerrores(Op_Arrerrores.Count) := l_Error;
              Op_Resultado := 1;
             End If;
          
             If Reg_c_Ct.Cod_Rechazo = 3 Then
              l_Error := Sim_Typ_Error(-20000,
                                       'Control Tecnico Autorizar ' ||
                                       Reg_c_Ct.Cod_Error || '-' ||
                                       Reg_c_Ct.Desc_Error,
                                       'W');
              Op_Arrerrores.Extend;
              Op_Arrerrores(Op_Arrerrores.Count) := l_Error;
              Op_Resultado := 1;
             End If;
            End If;
          
            If Reg_c_Ct.Cod_Rechazo = 2 Then
             l_Error := Sim_Typ_Error(-20000,
                                      'Control Tecnico Rechazado ' ||
                                      Reg_c_Ct.Cod_Error || '-' ||
                                      Reg_c_Ct.Desc_Error,
                                      'E');
             Op_Arrerrores.Extend;
             Op_Arrerrores(Op_Arrerrores.Count) := l_Error;
             Op_Resultado := -1;
            End If;
           End Loop;
          */
        
          FOR REG_C_CT IN C_CT LOOP
            IF IP_PROCESO.P_COD_PRODUCTO = 777 THEN
              CASE
                WHEN REG_C_CT.COD_RECHAZO = 1 THEN
                  L_ERROR := SIM_TYP_ERROR(-20000,
                                           'Control Tecnico Observado ' ||
                                           REG_C_CT.COD_ERROR || '-' ||
                                           REG_C_CT.DESC_ERROR,
                                           'W');
                  OP_ARRERRORES.EXTEND;
                  OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                  IF L_RESULTADO != -1 THEN
                    L_RESULTADO := 1;
                  END IF;
                
                  BEGIN
                    SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES,
                                                 OP_ARRERRORES);
                    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                  END;
                
                WHEN REG_C_CT.COD_RECHAZO = 3 THEN
                  L_ERROR := SIM_TYP_ERROR(-20000,
                                           'Control Tecnico Autorizar ' ||
                                           REG_C_CT.COD_ERROR || '-' ||
                                           REG_C_CT.DESC_ERROR,
                                           'W');
                  OP_ARRERRORES.EXTEND;
                  OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                  IF L_RESULTADO != -1 THEN
                    L_RESULTADO := 1;
                  END IF;
                
                  BEGIN
                    SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES,
                                                 OP_ARRERRORES);
                    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                  END;
                
                WHEN REG_C_CT.COD_RECHAZO = 2 THEN
                
                  SIM_PROC_LOG('NVZ 02042024', '2');
                  L_ERROR := SIM_TYP_ERROR(-20000,
                                           'Control Tecnico Rechazado ' ||
                                           REG_C_CT.COD_ERROR || '-' ||
                                           REG_C_CT.DESC_ERROR,
                                           'E');
                  OP_ARRERRORES.EXTEND;
                  OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                  OP_RESULTADO := -1;
                  RAISE_APPLICATION_ERROR(-20000, REG_C_CT.DESC_ERROR);
                
              /*                  Begin
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Sim_Pck_Errores.Manejarerror(l_Arrerrores,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Op_Arrerrores);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Op_Arrerrores := New Sim_Typ_Array_Error();
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  End;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                */
              
              END CASE;
            
            ELSE
              IF IP_PROCESO.P_PROCESO NOT IN (240, 241) THEN
                IF REG_C_CT.COD_RECHAZO = 1 THEN
                  L_ERROR := SIM_TYP_ERROR(-20000,
                                           'Control Tecnico Observado ' ||
                                           REG_C_CT.COD_ERROR || '-' ||
                                           REG_C_CT.DESC_ERROR,
                                           'W');
                  OP_ARRERRORES.EXTEND;
                  OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                  IF L_RESULTADO != -1 THEN
                    L_RESULTADO := 1;
                  END IF;
                
                  BEGIN
                    SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES,
                                                 OP_ARRERRORES);
                    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                  END;
                
                END IF;
              
                IF REG_C_CT.COD_RECHAZO = 3 THEN
                  L_ERROR := SIM_TYP_ERROR(-20000,
                                           'Control Tecnico Autorizar ' ||
                                           REG_C_CT.COD_ERROR || '-' ||
                                           REG_C_CT.DESC_ERROR,
                                           'W');
                  OP_ARRERRORES.EXTEND;
                  OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                  IF L_RESULTADO != -1 THEN
                    L_RESULTADO := 1;
                  END IF;
                
                  BEGIN
                    SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES,
                                                 OP_ARRERRORES);
                    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
                  END;
                
                END IF;
              
              END IF;
            
              IF REG_C_CT.COD_RECHAZO = 2 THEN
              
                SIM_PROC_LOG('NVZ 02042024', '1');
                L_ERROR := SIM_TYP_ERROR(-20000,
                                         'Control Tecnico Rechazado ' ||
                                         REG_C_CT.COD_ERROR || '-' ||
                                         REG_C_CT.DESC_ERROR,
                                         'E');
                OP_ARRERRORES.EXTEND;
                OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000, REG_C_CT.DESC_ERROR);
                /*                Begin
                                  Sim_Pck_Errores.Manejarerror(l_Arrerrores, Op_Arrerrores);
                                  Op_Arrerrores := New Sim_Typ_Array_Error();
                                End;
                */
              
              END IF;
            
            END IF;
          
          END LOOP;
        
        END IF;
      
      END IF;
    
    END IF;
  
    -- pkg299_multicompania.inserta_log(l_Numsecupol,1,' emision2 update del typex');
  
    BEGIN
      IF IP_PROCESO.P_CANAL = 7 THEN
        -- SIMON API
        PROC_UPDATETYPEDEXAPI(L_POLIZA,
                              OP_POLIZA,
                              L_NUMSECUPOL,
                              L_NUMEND,
                              IP_PROCESO,
                              OP_RESULTADO,
                              OP_ARRERRORES);
      ELSE
        SIM_PCK_PROCESO_DATOS_EMISION2.PROC_UPDATETYPEDEX(L_POLIZA,
                                                          OP_POLIZA,
                                                          L_NUMSECUPOL,
                                                          L_NUMEND,
                                                          IP_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
      
      END IF;
    
      IF OP_RESULTADO = -1 THEN
        --RETURN;
        RAISE_APPLICATION_ERROR(-20000,
                                'Fallo Procedimiento proc_updatetypedex');
      END IF;
    
      IF OP_RESULTADO != 0 THEN
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
      
        IF L_RESULTADO != -1 THEN
          L_RESULTADO := OP_RESULTADO;
        END IF;
      
      END IF;
    
    END;
  
    BEGIN
      -- Esta sentencia es para reescribir el default que ha insertado
      -- el procedimiento de grabacion de poliza y colocar los datos
      -- de la estructura que viene
      IF IP_PROCESO.P_COD_CIA = 3 AND IP_PROCESO.P_COD_SECC = 310 AND
         IP_PROCESO.P_COD_PRODUCTO = 315 AND IP_PROCESO.P_INFO4 = 'X' THEN
        DELETE SIM_ENTREGASOAT
         WHERE NUM_SECU_POL = L_NUMSECUPOL
           AND NRO_SOAT IS NULL;
      
        -- Adicionalmente, actualiza entregaSoat.observacion, colocando el numero
        -- de dias para entrega
      END IF;
    
      IF IP_PROCESO.P_COD_CIA = C_CIASOAT AND
         IP_PROCESO.P_COD_SECC = C_SECCSOAT AND
         IP_PROCESO.P_COD_PRODUCTO = C_RAMOSOAT AND
         IP_PROCESO.P_COD_USR = C_USRSOATONLINE THEN
        BEGIN
          BEGIN
            UPDATE SIM_DATOSSOAT X
               SET SECUENCIA =
                   (SELECT MIN(A.SECUENCIA)
                      FROM C3150007 A
                     WHERE A.COD_LINEA_RUNT = X.LINEA
                       AND A.COD_MARCA_RUNT = X.MARCA_RUNT)
             WHERE X.NUM_SECU_POL = L_NUMSECUPOL
               AND X.NUM_END = 0;
          
            --        AND x.pat_veh = xxxxx
          END;
        
          -- Select para traer los datos de numero de dias de entrega del soat online
          -- Según la localidad
          BEGIN
            SELECT DAT_NUM
              INTO L_DIASENTREGA
              FROM C9999909 C
             WHERE C.COD_TAB = 'DIAS_ENTREGASOAT'
               AND DAT_CAR =
                   (SELECT MIN(SES.CIU_ENTREGA)
                      FROM SIM_ENTREGASOAT SES
                     WHERE SES.NUM_SECU_POL = L_NUMSECUPOL);
          
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              L_DIASENTREGA := 3;
            WHEN OTHERS THEN
              SIM_PROC_LOG('Error Proc_serviceExpide:', SQLERRM);
            
          END;
        
          UPDATE SIM_ENTREGASOAT SES
             SET SES.OBSERVACION = L_DIASENTREGA || ' dia(s) hábil(es)'
           WHERE NUM_SECU_POL = L_NUMSECUPOL;
        
          OP_POLIZA.DATOSADICIONAL.EXTEND;
          OP_POLIZA.DATOSADICIONAL(OP_POLIZA.DATOSADICIONAL.COUNT) := NEW
                                                                      SIM_TYP_DATOS_ADIC(L_NUMSECUPOL,
                                                                                         L_NUMEND,
                                                                                         0 --l_codries
                                                                                        ,
                                                                                         NULL,
                                                                                         1,
                                                                                         'OBSERVACION',
                                                                                         6,
                                                                                         'SIM_DATOSSOAT',
                                                                                         L_DIASENTREGA ||
                                                                                         ' dia(s) hábil(es)');
        
        END;
      
      END IF;
    
    END;
  
    --  If Ip_Proceso.p_Cod_Cia = 2 And Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
    IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
      IF IP_PROCESO.P_PROCESO = 201 THEN
        L_CANTIDAD := 0;
      
        BEGIN
          SELECT COUNT(1)
            INTO L_CANTIDAD
            FROM SIM_DECL_ASEG_POL
           WHERE NUM_SECU_POL = L_NUMSECUPOL
             AND ID_PREDECASE IN (30000306)
             AND NVL(VALOR, 'N') = 'NO';
        
        END;
      
        IF L_CANTIDAD = 0 THEN
          BEGIN
            SELECT COUNT(1)
              INTO L_CANTIDAD
              FROM SIM_DECL_ASEG_POL
             WHERE NUM_SECU_POL = L_NUMSECUPOL
               AND ID_PREDECASE IN (30000314, 30000294)
               AND NVL(VALOR, 'N') = 'SI';
          
          END;
        
        END IF;
      
        IF L_CANTIDAD > 0 THEN
          OP_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'N';
        END IF;
      
      END IF;
    
      IF IP_PROCESO.P_PROCESO = 241 THEN
        FOR REG_C_CT IN C_CT LOOP
          IF REG_C_CT.COD_ERROR IN (975, 863, 927, 868, 861, 862, 860, 698) THEN
            --Actividad actual en control tecnico
            --control tecnico por Ocupacion 861 - 862 autorizaar y rechazado
            --Actividades en control tecnicio 868
            --Control Tecnico de Servicod publico 927
            --Control Tecnico de Prima diferente 975
            --Valor asegurado minimo no permitido 863
            IF REG_C_CT.COD_ERROR = 863 THEN
              OP_RESULTADO := -1;
              RAISE_APPLICATION_ERROR(-20000,
                                      'El valor asegurado no corresponde al minimo asignado a la localidad, debe cotizar como producto Vida Individual Básico ');
              --RETURN;
            END IF;
          
            IF REG_C_CT.COD_RECHAZO = 2 THEN
              -- control tecnico rechazado
              L_ERROR := SIM_TYP_ERROR(-20000,
                                       REG_C_CT.COD_ERROR || '-' ||
                                       REG_C_CT.DESC_ERROR,
                                       'E');
              OP_ARRERRORES.EXTEND;
              OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
              OP_RESULTADO := -1;
              RAISE_APPLICATION_ERROR(-20000, REG_C_CT.DESC_ERROR);
              /*              Begin
                              Sim_Pck_Errores.Manejarerror(l_Arrerrores, Op_Arrerrores);
                              Op_Arrerrores := New Sim_Typ_Array_Error();
                            End;
              */
            
            END IF;
          
          END IF;
        
        END LOOP;
      
      END IF;
    
    END IF;
  
    --Valida correo de asegurado principal para ATGC Simones ventas.
    IF IP_PROCESO.P_PROCESO = 270 AND IP_PROCESO.P_COD_PRODUCTO = 721 THEN
      IF SIM_PCK_ATGC_VIDA_GRUPO.FUN_ESRAMOATGCVIDAGRUPO(IP_PROCESO.P_COD_CIA,
                                                         IP_PROCESO.P_COD_SECC,
                                                         IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
      
        SIM_PCK_ATGC_VIDA_GRUPO.FUN_GRABACORREOASEGURADOS(IP_POLIZA.DATOSTERCEROS(1)
                                                          .TIPO_DOCUMENTO,
                                                          IP_POLIZA.DATOSTERCEROS(1)
                                                          .NUMERO_DOCUMENTO,
                                                          IP_POLIZA.DATOSTERCEROS(1)
                                                          .EMAIL,
                                                          1,
                                                          IP_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
      END IF;
    
      IF OP_RESULTADO != 0 THEN
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
      
        IF L_RESULTADO != -1 THEN
          L_RESULTADO := OP_RESULTADO;
        END IF;
      
      END IF;
    
    END IF;
  
    --intasi31 ATGC SALUD 26052016. technoPhone
    IF SIM_PCK_ATGC_SALUD.FUN_ESRAMOATGCSALUD(IP_PROCESO.P_COD_CIA,
                                              IP_PROCESO.P_COD_SECC,
                                              IP_PROCESO.P_COD_PRODUCTO) = 'S' AND
       IP_PROCESO.P_PROCESO = 270 THEN
      DECLARE
        L_DESCERROR VARCHAR2(500);
        TP_ATGC     SIM_PCK_ATGC_SALUD.R_ATGC%TYPE;
      
      BEGIN
        TP_ATGC.NUMSECUPOL := L_NUMSECUPOL;
        TP_ATGC.CODCAMPO   := 'EMISION_POLIZA';
        SIM_PCK_ATGC_SALUD.PRC_TEXTOMENSAJES(TP_ATGC);
        L_DESCERROR := TP_ATGC.MSGERROR;
        L_ERROR     := SIM_TYP_ERROR(-20022, L_DESCERROR, 'W');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := 1;
        IF L_RESULTADO != -1 THEN
          L_RESULTADO := OP_RESULTADO;
        END IF;
      
        BEGIN
          SIM_PCK_ERRORES.MANEJARERROR(L_ARRERRORES, OP_ARRERRORES);
          OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
        END;
      
      END;
    
    END IF;
  
    --fin intasi31 ATGC SALUD 26052016. technoPhone
    /*CT DE POLIZAS PROVISORIAS DE SOAT  HLC  18092017*/
  
    IF SIM_PCK_FUNCION_GEN.ES_SOAT(IP_SECCION => IP_PROCESO.P_COD_SECC) = 'S' THEN
    
      DECLARE
        L_DESCERROR VARCHAR2(200) := NULL;
        L_TIPERROR  VARCHAR2(1) := 'W';
        L_NIVERROR  NUMBER := 1;
      
      BEGIN
        FOR REG_C_CT_SOAT IN C_CT_SOAT LOOP
          SIM_PROC_LOG('hlc 18092017 ' || REG_C_CT_SOAT.DESC_ERROR, '');
          IF REG_C_CT_SOAT.COD_RECHAZO = 2 THEN
            L_TIPERROR := 'E';
            L_NIVERROR := -1;
          END IF;
        
          L_DESCERROR := REG_C_CT_SOAT.DESC_ERROR;
          L_ERROR     := SIM_TYP_ERROR(-20000,
                                       REG_C_CT_SOAT.COD_ERROR || '-' ||
                                       L_DESCERROR,
                                       L_TIPERROR);
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          IF L_NIVERROR != 0 THEN
            L_RESULTADO := L_NIVERROR;
          END IF;
        
          IF L_NIVERROR = -1 THEN
            OP_RESULTADO := -1;
            RAISE_APPLICATION_ERROR(-20000, L_DESCERROR);
          END IF;
        
        /*          Begin
                                                              Sim_Pck_Errores.Manejarerror(l_Arrerrores, Op_Arrerrores);
                                                              Op_Arrerrores := New Sim_Typ_Array_Error();
                                                            End;
                                                  */
        
        END LOOP;
      
      END;
    
    END IF;
  
    --pkg299_multicompania.inserta_log(l_Numsecupol,1,' emision2 falla');
  
    IF L_RESULTADO = -1 THEN
      ROLLBACK;
      --      If Ip_Proceso.p_Proceso = 270 Then
      IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' THEN
        DELETE SIM_EXPEDICION_ENLINEA C
         WHERE C.NUM_SECU_POL = L_NUMSECUPOL
           AND C.PROCESO = IP_PROCESO.P_PROCESO;
      
      END IF;
    
    ELSE
      OP_RESULTADO  := L_RESULTADO;
      OP_ARRERRORES := L_ARRERRORES;
      -- Proteccion Creditos - Canal 6
      -- No se requiere envio a filenet
      IF IP_PROCESO.P_CANAL <> 6 THEN
        PROC_VALIDA_ENVIO_FILENET(L_NUMSECUPOL,
                                  OP_POLIZA.DATOSFIJOS.MCA_PROVISORIO,
                                  IP_PROCESO,
                                  OP_RESULTADO,
                                  OP_ARRERRORES);
        COMMIT;
      END IF;
    
    END IF;
  
    -- AEEM ACTUALIZA DATOS FIJOS PARA OFERTAS
    BEGIN
      SELECT COUNT(1)
        INTO V_ACTUALIZADV
        FROM SIMAPI_PARAMETROS_ESTRATEGIA T, X2000030 X
       WHERE T.COD_TAB = 'ACTUALIZA_DF'
         AND X.NUM_SECU_POL = L_NUMSECUPOL
         AND T.COD_OFERTA = X.SIM_ESTRATEGIAS
         AND T.COD_RAMO = X.COD_RAMO
         AND X.NUM_POL_ANT IS NULL;
    
      SIM_PROC_LOG('AEEM_DEBITO', 'V_ACTUALIZADV ' || V_ACTUALIZADV);
      IF V_ACTUALIZADV > 0 THEN
        SIM_PCK_PROCESO_DATOS_EMISION2.PROC_UPDATE_DF_OFERTAS(IP_POLIZA,
                                                              L_NUMSECUPOL,
                                                              L_NUMEND);
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
      
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      -- pkg299_multicompania.inserta_log(l_Numsecupol,1,' emision2 error '||substr(Sqlerrm,1,100));
      --      If Ip_Proceso.p_Proceso = 270 Then
      IF FUN201_FORMALIZA_S360_DAV(L_PROCESO) = 'S' THEN
        DELETE SIM_EXPEDICION_ENLINEA C
         WHERE C.NUM_SECU_POL = L_NUMSECUPOL
           AND C.PROCESO = IP_PROCESO.P_PROCESO;
      
      END IF;
    
      IF IP_PROCESO.P_COD_CIA = C_CIASOAT AND
         IP_PROCESO.P_COD_SECC = C_SECCSOAT AND
         IP_PROCESO.P_COD_PRODUCTO = C_RAMOSOAT AND
         IP_PROCESO.P_PROCESO = 241 AND IP_PROCESO.P_CANAL = 3 AND
         IP_PROCESO.P_COD_USR = C_USRSOATONLINE THEN
        --Dbms_Output.Put_Line('Entra por error para cotizacion Soat');
        L_ERROR := SIM_TYP_ERROR(-20002,
                                 'En este momento no podemos atender su solicitud',
                                 'E');
      ELSE
        L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      
      END IF;
    
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    
  END PROC_SERVICEEXPIDE;

  /*---------------------------------------------------*/

  PROCEDURE PROC_UPDATEDELTYPE(IP_POLIZA     IN OUT SIM_TYP_POLIZAGEN,
                               IP_NUMSECUPOL IN NUMBER,
                               IP_NUMEND     IN NUMBER,
                               IP_PROCESO    IN SIM_TYP_PROCESO,
                               OP_RESULTADO  OUT NUMBER,
                               OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    /*
      VERSION  FECHA     RESPONSABLE  EMPRESA     DESCRIPCION
      ------- ---------- ------------ ----------- ----------------------
       1.2   11/06/2015 cjrodriguez  Asesoftware Mantis-35572:  Se ajusta el procedimiento Proc_UpdatedelType invocando
                                                 la nueva función SIM_PCK_FUNCION_GEN.obtenerValorDatNum.
    */
  
    L_VALIDACION         SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_RIESGO             SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_STRINGQUERY        SIM_PCK_TIPOS_GENERALES.T_VAR_EXTRALARGO;
    L_DESCRIPCION        SIM_PCK_TIPOS_GENERALES.T_VAR_EXTRALARGO;
    L_STRINGINSERT       SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_STRINGVALUE        SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_COD_RIES           SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_NOMCAMPO           SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    IP_TABLA             SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO := 'X9990100';
    L_TYPDATO            SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_COM                SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO := '''';
    L_VALCAMPO           SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_PRICAR             SIM_PCK_TIPOS_GENERALES.T_CARACTER := ' ';
    L_ITEM               SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    NRO_ITEM             SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_EXISTE             SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_EXISTERC           SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_MAXRIES            SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR := NULL;
    L_EXISTECAMPOEND     SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_EXISTECAMPORIE     SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_AGENTE             A2000250.COD_AGENTE%TYPE;
    L_AGENTEORI          A2000250.COD_AGENTE%TYPE;
    L_AGENTEDIR          A2000250.COD_AGENTE%TYPE;
    L_CODTIPO            A1040400.COD_TIPO%TYPE;
    L_VALORCAMPO         A2000020.VALOR_CAMPO%TYPE;
    L_CODCAMPO           A2000020.COD_CAMPO%TYPE;
    L_LONGITUD           SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_TDOCBENE           SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_IDASEG             SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_TDOCASEG           SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_IDBENEF            SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_MCA_ACCESORIO      SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_SUMAACCES          A2040200.VALOR_ACCES%TYPE;
    L_SUMAASEG           A2040300.SUMA_ASEG%TYPE;
    L_SUMAASEG0K         A2040300.SUMA_ASEG_0KM%TYPE;
    L_CANTMESES          NUMBER;
    L_FECHAEMI           DATE;
    L_FECHAVIGPOL        DATE;
    L_FECHAVENCPOL       DATE;
    L_FECHAVENCPOLORG    DATE;
    L_SUBPRODUCTO        NUMBER;
    L_RENTA              X2000020.COD_CAMPO%TYPE := NULL;
    L_MCABANCA           C1010791.MCA_BANCASEGUROS%TYPE := 'N';
    L_MCATAR             A2040200.MCA_TAR%TYPE;
    L_SARLAFTACT         SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_OPCIONRCSUP        NUMBER;
    L_TDOCONEROSO        SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_ESONEROSO          SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_OPCION371          SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_OPCION372          SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_OPCION374          SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_SUMAACCESTOT       SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_CEROOK             SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_DTOTECNICO         NUMBER := 0;
    L_DTOCOMERCIAL       NUMBER := 0;
    L_APLICADTOTECNICO   VARCHAR2(1);
    L_APLICADTOCOMERCIAL VARCHAR2(1);
    V_DESCTO_MAX         NUMBER := 0;
    L_BONUSMALUS         NUMBER;
    L_BONUMSALUSEN       NUMBER;
    L_NUMSECUPOLORG      NUMBER;
    L_TOMAOPCSUPORG      VARCHAR2(1);
    L_OPCIONRCSUPORG     NUMBER;
    L_VALORDV            VARCHAR2(100);
  
    P_DIRECCION            VARCHAR2(32767);
    P_DIRECCION_ESTANDAR   VARCHAR2(32767);
    P_MENSAJE_SALIDA       VARCHAR2(32767);
    P_CODIGO_SALIDA        NUMBER(10);
    L_TOMADOR              SIM_TYP_TERCEROGEN;
    L_PROPIETARIO          SIM_TYP_TERCEROGEN;
    C_ROLTOMADOR           SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 1;
    C_ROLPROPIETARIO       SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 6;
    L_TOMADORESPROPIETARIO SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_COD_COA              NUMBER(1);
    L_CANTIDAD             NUMBER;
    L_NOMINA               VARCHAR2(10) := 'VNUE';
    L_NOMINAHOGAR          VARCHAR2(10) := 'HOG1';
    L_CODCOB               X9990100.COD_COB%TYPE;
    L_CODCOBANT            X9990100.COD_COB%TYPE := 0;
    L_CLAUSULAS            X2000020.CLAUSULAS%TYPE;
    L_TIPODEB              NUMBER;
    L_TOMAOPSUP            X2000020.VALOR_CAMPO%TYPE;
    -- l_numpolcotiz            Number; --morj ajuste error fecnac
    -- 15122016 sgpinto: Adición variable para Conductor Habitual
    L_NUMCONDHAB  X2040400.NUM_COND%TYPE;
    L_PRODANEXO   NUMBER;
    L_RIESGOAPI   SIM_TYP_DATOSRIESGO; -- Simon Api RPR
    L_OFERTAAUTOS NUMBER;
  
    --intasi31 20220817 PortafolioVida
    L_NOMINAAP      VARCHAR2(10) := 'ACCI';
    L_CODCOBAP      NUMBER;
    L_CODRIESAP     NUMBER;
    L_NROREGISTROAP NUMBER;
    --fin intasi31 20220817 PortafolioVida
  BEGIN
    G_SUBPROGRAMA   := G_PROGRAMA || '.Proc_UpdatedelType';
    L_ERROR         := NEW SIM_TYP_ERROR;
    OP_ARRERRORES   := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO    := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_NUMSECUPOLORG := IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
    L_RIESGOAPI     := NEW SIM_TYP_DATOSRIESGO; -- Simon Api RPR
    DELETE X2000220 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
    DELETE X2000220 WHERE NUM_SECU_POL = L_NUMSECUPOLORG;
  
    --================INSERCION Y ACTUALIZAZION TABLAS X
    --    If Ip_Proceso.p_Proceso = 270 Then
    IF FUN201_FORMALIZA_S360_DAV(IP_PROCESO) = 'S' THEN
      BEGIN
        SELECT X.FECHA_VENC_POL, X.FECHA_VIG_POL, X.COD_PROD
          INTO L_FECHAVENCPOL, L_FECHAVIGPOL, L_AGENTE
          FROM A2000030 X
         WHERE X.NUM_SECU_POL = IP_NUMSECUPOL
           AND X.NUM_END = IP_NUMEND;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    ELSE
      BEGIN
        SELECT X.FECHA_VENC_POL, X.FECHA_VIG_POL, X.COD_PROD
          INTO L_FECHAVENCPOL, L_FECHAVIGPOL, L_AGENTE
          FROM X2000030 X
         WHERE X.NUM_SECU_POL = IP_NUMSECUPOL
           AND X.NUM_END = IP_NUMEND;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    IF SIM_PCK_FUNCION_GEN.ES_AUTOS(IP_PROCESO.P_COD_SECC,
                                    IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
      L_SUBPRODUCTO := IP_PROCESO.P_SUBPRODUCTO;
      L_AGENTEDIR   := NULL;
    
      BEGIN
        SELECT CODIGO
          INTO L_AGENTEDIR
          FROM C9999909
         WHERE COD_TAB = 'SUBPRODCLAVEDIR'
           AND DAT_NUM = L_SUBPRODUCTO
           AND COD_RAMO = NVL(IP_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO, 0)
           AND FECHA_BAJA IS NULL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    L_AGENTEORI := IP_POLIZA.DATOSFIJOS.COD_PROD.CODIGO;
  
    IF L_AGENTEDIR IS NOT NULL THEN
      L_AGENTEORI := L_AGENTEDIR;
    END IF;
  
    IF L_AGENTEORI IS NULL THEN
      L_AGENTEORI := L_AGENTE;
    END IF;
  
    IF NVL(L_AGENTEORI, 0) = 0 THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000, 'No viene informacion de Agente');
    END IF;
  
    DELETE X2000253 X WHERE NUM_SECU_POL = IP_NUMSECUPOL;
  
    PCK299_CALC_COMISION.INSERTA_X2000253(IP_NUMSECUPOL,
                                          L_AGENTEORI,
                                          100,
                                          'S');
    L_EXISTE := 0;
  
    BEGIN
      SELECT COUNT(1)
        INTO L_EXISTE
        FROM X2000253 X
       WHERE X.NUM_SECU_POL = IP_NUMSECUPOL;
    END;
  
    IF L_EXISTE = 0 THEN
      PCK299_CALC_COMISION.INSERTA_X2000253(IP_NUMSECUPOL,
                                            L_AGENTEORI,
                                            100,
                                            'S');
    END IF;
  
    IP_POLIZA.DATOSFIJOS.NUM_SECU_POL := IP_NUMSECUPOL;
    IP_POLIZA.DATOSFIJOS.NUM_END      := IP_NUMEND;
  
    --    If Ip_Proceso.p_Proceso != 270 Then
    IF IP_PROCESO.P_PROCESO NOT IN (270, 261, 260) THEN
      IF IP_POLIZA.DATOSFIJOS.FECHA_VIG_POL IS NULL THEN
        IF L_FECHAVIGPOL IS NULL THEN
          L_FECHAVIGPOL := TRUNC(SYSDATE);
        END IF;
      ELSE
        L_FECHAVIGPOL := IP_POLIZA.DATOSFIJOS.FECHA_VIG_POL;
      END IF;
    END IF;
  
    IF IP_POLIZA.DATOSFIJOS.FECHA_VENC_POL IS NULL THEN
      IF L_FECHAVENCPOL IS NULL THEN
        --PGT  Autos x recorridos Dic 7/2020
        IF IP_PROCESO.P_SUBPRODUCTO = 376 THEN
          L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 1);
        ELSE
          L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 12);
        END IF;
      END IF;
    ELSE
      L_FECHAVENCPOL := IP_POLIZA.DATOSFIJOS.FECHA_VENC_POL;
    END IF;
  
    IF IP_POLIZA.DATOSFIJOS.COD_PLAN_PAGO IS NOT NULL THEN
      L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL,
                                   IP_POLIZA.DATOSFIJOS.COD_PLAN_PAGO);
    END IF;
  
    IF IP_PROCESO.P_COD_PRODUCTO = 721 THEN
      L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 12);
    END IF;
  
    L_FECHAEMI := IP_POLIZA.DATOSFIJOS.FECHA_EMI;
    IF IP_PROCESO.P_COD_SECC = 1 THEN
    
      L_FECHAEMI    := TRUNC(SYSDATE);
      L_FECHAVIGPOL := IP_POLIZA.DATOSFIJOS.FECHA_VIG_POL;
    
      /* ****** INICIO-TRANSMASIVO ****** */
      IF NVL(FCN999_CONS_MCA_PRORRATA(P_COD_CIA     => IP_PROCESO.P_COD_CIA,
                                      P_COD_SECC    => IP_PROCESO.P_COD_SECC,
                                      P_COD_RAMO    => IP_PROCESO.P_COD_PRODUCTO,
                                      P_SUBPRODUCTO => IP_PROCESO.P_SUBPRODUCTO),
             'N') = 'N' THEN
        L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 12);
      END IF;
      --PGT Dic 2020  Autos x Recorridos
      IF IP_PROCESO.P_SUBPRODUCTO = 376 THEN
        L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 1);
      END IF;
      /* ****** FIN-TRANSMASIVO ****** */
    
    ELSIF IP_PROCESO.P_COD_SECC = 23 THEN
      L_FECHAEMI    := TRUNC(SYSDATE);
      L_FECHAVIGPOL := IP_POLIZA.DATOSFIJOS.FECHA_VIG_POL;
      /* RPR Se deja fecha vencimiento a aun año. Excepto anexo hogar respeta venc. lider*/
      L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 12);
      SELECT COUNT(*)
        INTO L_PRODANEXO
        FROM C1999300 F
       WHERE F.PRODUCTO_ANEXO = IP_PROCESO.P_COD_PRODUCTO
         AND F.RAMO_ANEXO = IP_PROCESO.P_COD_SECC;
    
      IF L_PRODANEXO > 0 THEN
        --Juan Gonzalez (Ajuste Anexo Hogar- respete la fecha que hereda de la pol lider)
        IF IP_POLIZA.DATOSFIJOS.FECHA_VENC_POL IS NULL THEN
          L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 12);
        ELSE
          L_FECHAVENCPOL := IP_POLIZA.DATOSFIJOS.FECHA_VENC_POL;
        END IF;
      END IF;
    END IF;
  
    --Cristian Pascumal(GD841-92) Se respeta la fecha de vigencia proporcionada para el produco 153
  
    IF IP_PROCESO.P_COD_SECC = 14 AND IP_PROCESO.P_COD_PRODUCTO = 153 THEN
      L_FECHAEMI     := TRUNC(SYSDATE);
      L_FECHAVIGPOL  := IP_POLIZA.DATOSFIJOS.FECHA_VIG_POL;
      L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 12);
    
    END IF;
  
    -----------------------------------------------
  
    IF SIM_PCK_FUNCION_GEN.ES_SOAT(IP_SECCION => IP_PROCESO.P_COD_SECC) = 'S' THEN
      L_FECHAVIGPOL := IP_POLIZA.DATOSFIJOS.FECHA_VIG_POL;
      IF IP_POLIZA.DATOSFIJOS.FECHA_VENC_POL IS NULL THEN
        L_FECHAVENCPOL := ADD_MONTHS(L_FECHAVIGPOL, 12) - 1;
      ELSE
        L_FECHAVENCPOL := IP_POLIZA.DATOSFIJOS.FECHA_VENC_POL;
      END IF;
    END IF;
  
    IF IP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO IS NOT NULL THEN
      L_VALIDACION := 'S';
    
      BEGIN
        IF IP_PROCESO.P_PROCESO IN (201, 200, 220, 221, 240, 241, 242) AND
           IP_PROCESO.P_CANAL = 3 THEN
          NULL; -- En cotizaciones no es necesario que el tercero exista en terceros . Wesv 20140427
        ELSE
          --Ini 1.3 mcolorado:  16/09/2015
          IF IP_PROCESO.P_COD_SECC <> 310 THEN
            --Fin 1.3 mcolorado:  16/09/2015
            SIM_PCK_PROCESO_DATOS_EMISION.VAL_TERCERO(IP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO,
                                                      IP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO,
                                                      L_VALIDACION,
                                                      IP_PROCESO,
                                                      OP_RESULTADO,
                                                      OP_ARRERRORES);
            --Ini 1.3 mcolorado:  16/09/2015
          END IF;
          --Fin 1.3 mcolorado:  16/09/2015
        END IF;
      
        IF OP_RESULTADO = -1 THEN
          --RETURN;
          RAISE_APPLICATION_ERROR(-20000, 'Fallo Validacion Tercero');
        
        END IF;
      END;
    
      IF IP_PROCESO.P_PROCESO = 270 THEN
        L_SARLAFTACT  := 'N';
        L_DESCRIPCION := NULL;
        --se coloca en comentarios el llamado al procedimiento de validacion de sarlaft
        /*      Begin
          Sim_Pck_Consulta_Emision2.Proc_Val_Cliente_Sarlaft(Ip_Poliza.Datosfijos.Tdoc_Tercero.Codigo,
                                                             Ip_Poliza.Datosfijos.Nro_Documto.Codigo,
                                                             l_Sarlaftact,
                                                             l_Descripcion,
                                                             Op_Resultado,
                                                             Op_Arrerrores);
        End; */
        L_SARLAFTACT := 'S';
      
        --intasi31 22022016. ATGC SALUD.
        --los ramos de salud no validan sarlaft.
        IF SIM_PCK_ATGC_SALUD.FUN_ESRAMOATGCSALUD(IP_PROCESO.P_COD_CIA,
                                                  IP_PROCESO.P_COD_SECC,
                                                  IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
          OP_RESULTADO := 0;
          L_SARLAFTACT := 'S';
        END IF;
      
        IF OP_RESULTADO = -1 THEN
          --RETURN;
          RAISE_APPLICATION_ERROR(-20000, 'Fallo Validacion Sarlaft');
        
        END IF;
      
        IF L_SARLAFTACT = 'N' THEN
          OP_RESULTADO := -1;
          RAISE_APPLICATION_ERROR(-20000,
                                  'Tomador no esta actualizado en Sarlaft');
        END IF;
      END IF;
    END IF;
  
    -- CUMMPLIMIENTO
    /* ************** INICIO-COASEGUROS *************** */
    BEGIN
      L_COD_COA := SIM_PCK_PROCESO_DATOS_EMISION2.FUN_MAPEO_COASEGUROS(IP_POLIZA     => IP_POLIZA,
                                                                       IP_PROCESO    => IP_PROCESO,
                                                                       OP_RESULTADO  => OP_RESULTADO,
                                                                       OP_ARRERRORES => OP_ARRERRORES);
    
      IF L_COD_COA = 0 AND (OP_RESULTADO = -1 OR OP_RESULTADO = 1) THEN
        OP_RESULTADO := -1;
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                            'Hubo un error desconocido al momento de mapear los textos.' ||
                                                            SQLERRM,
                                                            'E');
        RETURN;
      END IF;
    END;
  
    /* ************** FIN-COASEGUROS *************** */
    --Dbms_Output.Put_Line('A2000030 *****');
  
    /* limpia tablas temporales */
    DELETE SIM_X_REFERENCIAS_POL WHERE NUM_SECU_POL = IP_NUMSECUPOL;
  
    UPDATE X2000030
       SET COD_CIA             = NVL(IP_POLIZA.DATOSFIJOS.COD_CIA.CODIGO,
                                     COD_CIA),
           COD_SECC            = NVL(IP_POLIZA.DATOSFIJOS.COD_SECC.CODIGO,
                                     COD_SECC),
           NUM_POL_FLOT        = NVL(IP_POLIZA.DATOSFIJOS.NUM_POL1,
                                     NUM_POL_FLOT),
           FECHA_EMI           = NVL(L_FECHAEMI, FECHA_EMI),
           FECHA_VIG_POL       = NVL(L_FECHAVIGPOL, FECHA_VIG_POL),
           FECHA_VENC_POL      = NVL(L_FECHAVENCPOL, FECHA_VENC_POL),
           FECHA_MOVI          = NVL(FECHA_MOVI,
                                     NVL(L_FECHAVIGPOL, FECHA_VIG_POL)),
           COD_PROD            = NVL(L_AGENTEORI, COD_PROD),
           NUM_POL_ANT         = NVL(IP_POLIZA.DATOSFIJOS.NUM_POL_ANT,
                                     NUM_POL_ANT),
           NRO_DOCUMTO         = NVL(IP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO,
                                     NRO_DOCUMTO),
           COD_RAMO            = NVL(IP_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO,
                                     COD_RAMO),
           MCA_ANU_POL         = NVL(IP_POLIZA.DATOSFIJOS.MCA_ANU_POL,
                                     MCA_ANU_POL),
           DESC_POL            = NVL(IP_POLIZA.DATOSFIJOS.DESC_POL, DESC_POL),
           NUM_END             = NVL(IP_POLIZA.DATOSFIJOS.NUM_END, NUM_END),
           COD_END             = NVL(IP_POLIZA.DATOSFIJOS.COD_END, COD_END),
           SUB_COD_END         = NVL(IP_POLIZA.DATOSFIJOS.SUB_COD_END,
                                     SUB_COD_END),
           TIPO_END            = NVL(IP_POLIZA.DATOSFIJOS.TIPO_END.CODIGO,
                                     TIPO_END),
           FEC_ANU_POL         = NVL(IP_POLIZA.DATOSFIJOS.FEC_ANU_POL,
                                     FEC_ANU_POL),
           COD_USR             = NVL(IP_POLIZA.DATOSFIJOS.COD_USR, COD_USR),
           COD_DURACION        = NVL(IP_POLIZA.DATOSFIJOS.COD_DURACION,
                                     COD_DURACION),
           COD_MON             = NVL(IP_POLIZA.DATOSFIJOS.COD_MON.CODIGO,
                                     COD_MON),
           PERIODO_FACT        = NVL(IP_POLIZA.DATOSFIJOS.PERIODO_FACT.CODIGO,
                                     PERIODO_FACT),
           FOR_COBRO           = NVL(IP_POLIZA.DATOSFIJOS.FOR_COBRO.CODIGO,
                                     FOR_COBRO),
           COD_PLAN_PAGO       = NVL(IP_POLIZA.DATOSFIJOS.COD_PLAN_PAGO,
                                     COD_PLAN_PAGO),
           MCA_PROVISORIO      = NVL(IP_POLIZA.DATOSFIJOS.MCA_PROVISORIO,
                                     MCA_PROVISORIO),
           TDOC_TERCERO        = NVL(IP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO,
                                     TDOC_TERCERO),
           SEC_TERCERO         = NVL(IP_POLIZA.DATOSFIJOS.SEC_TERCERO,
                                     SEC_TERCERO),
           SUC_TERCERO         = NVL(IP_POLIZA.DATOSFIJOS.SUC_TERCERO,
                                     SUC_TERCERO),
           SIM_SUBPRODUCTO     = NVL(IP_POLIZA.DATOSFIJOS.SUBPRODUCTO.CODIGO,
                                     IP_PROCESO.P_SUBPRODUCTO),
           SIM_NUMERO_STELLENT = NVL(IP_POLIZA.DATOSFIJOS.NUMERO_STALLENT,
                                     SIM_NUMERO_STELLENT),
           SIM_REFERIDO        = NVL(IP_POLIZA.DATOSFIJOS.REFERIDO,
                                     SIM_REFERIDO),
           SIM_PAQUETE_SEGURO  = NVL(IP_POLIZA.DATOSFIJOS.SIM_PAQUETE_SEGURO,
                                     SIM_PAQUETE_SEGURO),
           COD_COA             = L_COD_COA -- CUMPLIMIENTO: Código de coaseguros
          ,
           SIM_TIPO_ENVIO      = NVL(IP_POLIZA.DATOSFIJOS.SIM_TIPO_ENVIO.CODIGO,
                                     SIM_TIPO_ENVIO) -- SGPM Cumplimiento. Mapeo de tipo de envío
          ,
           NUM_POL_CLI         = NVL(SUBSTR(TO_CHAR(IP_POLIZA.DATOSFIJOS.NUM_POL_CLI),
                                            5,
                                            7),
                                     NUM_POL_CLI) -- SGPM Cumplimiento: cotizaciones basadas
          ,
           CANT_ANUAL          = NVL(IP_POLIZA.DATOSFIJOS.CANT_ANUAL,
                                     CANT_ANUAL) -- 26/11/2015 SGPM Transmasivo: Renovación de pólizas
          ,
           SIM_COLECTIVA       = NVL(IP_POLIZA.DATOSFIJOS.SIM_COLECTIVA,
                                     SIM_COLECTIVA) -- 27/11/2015 SGPM Transmasivo: Manejo de retroactividad y prospectividad
          ,
           SIM_TIPO_COLECTIVA  = NVL(IP_POLIZA.DATOSFIJOS.SIM_TIPO_COLECTIVA,
                                     SIM_TIPO_COLECTIVA) -- 27/11/2015 SGPM Transmasivo: Manejo de retroactividad y prospectividad
     WHERE NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
  
    --     if ip_proceso.p_proceso = 270 then
  
    -- Mcga 2019/10/01 se vuelve a colocar linea perdida para manejo de formalizacion
    -- en todos los procesos de formalización de automóviles.  Se instaló el 01/08/2019
    -- se adiciona también dos líneas por parte de Benjamin Galindo
  
    IF IP_PROCESO.P_PROCESO IN (270, 260, 261) THEN
      --motor
      UPDATE X2000030 J
         SET J.SIM_NUM_COTIZ_ANT = IP_POLIZA.DATOSFIJOS.SIM_NUM_COTIZ_ANT
       WHERE NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
    END IF;
  
    IF IP_PROCESO.P_COD_PRODUCTO = 721 AND IP_PROCESO.P_PROCESO = 202 THEN
      BEGIN
        UPDATE X2000030
           SET FOR_COBRO = 'CC'
         WHERE NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
      END;
    END IF;
  
    --VANESSA AGOSTO 8 2024
    IF IP_PROCESO.P_COD_PRODUCTO = 90 AND IP_PROCESO.P_COD_SECC = 34 THEN
      IF IP_POLIZA.DATOSTERCEROS.EXISTS(1) THEN
        IF IP_POLIZA.DATOSTERCEROS.COUNT > 0 THEN
          FOR I IN 1 .. IP_POLIZA.DATOSTERCEROS.COUNT LOOP
            L_TOMADOR := IP_POLIZA.DATOSTERCEROS(I);
          END LOOP;
          BEGIN
            UPDATE X2000030 X30
               SET X30.NRO_DOCUMTO  = L_TOMADOR.NUMERO_DOCUMENTO,
                   X30.TDOC_TERCERO = L_TOMADOR.TIPO_DOCUMENTO
             WHERE X30.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
          EXCEPTION
            WHEN OTHERS THEN
              L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
              OP_ARRERRORES.EXTEND;
              OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
              OP_RESULTADO := -1;
          END;
        END IF;
      END IF;
    END IF;
  
    ------------------------------------------------------------
    --  Mcga Condiciones del subproducto 376 autos por recorridos
    --  Subproducto Mensual
    --  Revisar cambio de 30 dias por add_months(l_Fechavigpol,1)
    ------------------------------------------------------------
  
    IF IP_PROCESO.P_SUBPRODUCTO = 376 THEN
      UPDATE X2000030
         SET FECHA_VENC_POL = ADD_MONTHS(NVL(L_FECHAVIGPOL, FECHA_VIG_POL),
                                         1),
             FECHA_VENC_END = ADD_MONTHS(NVL(L_FECHAVIGPOL, FECHA_VIG_POL),
                                         1),
             FECHA_VENC_PER = ADD_MONTHS(NVL(L_FECHAVIGPOL, FECHA_VIG_POL),
                                         1),
             COD_DURACION   = 2,
             MCA_PRORRATA   = 'P'
       WHERE NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
    END IF;
  
    --Dbms_Output.Put_Line('El producto es:' || Ip_Proceso.p_Cod_Producto);
    --  If Ip_Poliza.Datosfijos.Cod_Ramo.Codigo In (940, 942, 946, 944, 948)
    IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' OR
      --intasi31 ATGC SALUD 06072015
       (SIM_PCK_ATGC_SALUD.FUN_ESRAMOATGCSALUD(IP_PROCESO.P_COD_CIA,
                                               IP_PROCESO.P_COD_SECC,
                                               IP_PROCESO.P_COD_PRODUCTO) = 'S')
    --  Ip_poliza.DatosFijos.COD_RAMO.codigo IN (19,23,87) -- Manejo de clave compartida para salud Wesv - 20160706
     THEN
      IF IP_POLIZA.AGENTES.EXISTS(1) THEN
        IF IP_POLIZA.AGENTES.COUNT > 0 THEN
          FOR I IN IP_POLIZA.AGENTES.FIRST .. IP_POLIZA.AGENTES.LAST LOOP
            IF NVL(IP_POLIZA.AGENTES(I).LIDER, 'N') = 'N' THEN
              BEGIN
                PCK299_CALC_COMISION.INSERTA_X2000253(IP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                      IP_POLIZA.AGENTES(I)
                                                      .COD_AGENTE.CODIGO,
                                                      IP_POLIZA.AGENTES(I)
                                                      .PORC_PART,
                                                      NVL(IP_POLIZA.AGENTES(I)
                                                          .LIDER,
                                                          'N'));
              END;
            
              BEGIN
                UPDATE X2000253 N
                   SET N.PORC_COMI = NVL(IP_POLIZA.AGENTES(I).PORC_COMISION,
                                         PORC_COMI)
                 WHERE N.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                   AND N.COD_AGENTE = IP_POLIZA.AGENTES(I)
                      .COD_AGENTE.CODIGO;
              END;
            END IF;
          END LOOP;
        
          UPDATE X2000253 N
             SET N.MCA_BASE = 'S'
           WHERE N.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
             AND N.COD_AGENTE = IP_POLIZA.DATOSFIJOS.COD_PROD.CODIGO;
        END IF;
      END IF;
    ELSE
      IF IP_POLIZA.AGENTES.EXISTS(1) THEN
        IF IP_POLIZA.AGENTES.COUNT > 0 THEN
          FOR I IN IP_POLIZA.AGENTES.FIRST .. IP_POLIZA.AGENTES.LAST LOOP
            BEGIN
              PCK299_CALC_COMISION.INSERTA_X2000253(IP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                    IP_POLIZA.AGENTES                (I)
                                                    .COD_AGENTE.CODIGO,
                                                    IP_POLIZA.AGENTES                (I)
                                                    .PORC_PART,
                                                    IP_POLIZA.AGENTES                (I)
                                                    .LIDER);
            END;
          
            BEGIN
              UPDATE X2000253 N
                 SET N.PORC_COMI = NVL(IP_POLIZA.AGENTES(I).PORC_COMISION,
                                       PORC_COMI)
               WHERE N.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                 AND N.COD_AGENTE = IP_POLIZA.AGENTES(I).COD_AGENTE.CODIGO;
            END;
          END LOOP;
        END IF;
      END IF;
    END IF;
  
    -- ini Mantis  56164  -  Modificaciones Autos Fase II Riesgos fuera de politicas
    UPDATE X2000253 N
       SET N.MCA_BASE = 'S'
     WHERE N.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
       AND N.COD_AGENTE = IP_POLIZA.DATOSFIJOS.COD_PROD.CODIGO;
    -- fin Mantis  56164  -  Modificaciones Autos Fase II Riesgos fuera de politicas
  
    -- Arreglo hecho por Wilson Sacristan para manejo de Datos Asegurado y propietario para SOAT
    -- 20140903
    IF SIM_PCK_FUNCION_GEN.ES_SOAT(IP_POLIZA.DATOSFIJOS.COD_SECC.CODIGO) =
       SIM_PCK_TIPOS_GENERALES.C_SI THEN
      IF IP_POLIZA.DATOSTERCEROS.EXISTS(1) THEN
        IF IP_POLIZA.DATOSTERCEROS.COUNT > 0 THEN
          FOR I IN 1 .. IP_POLIZA.DATOSTERCEROS.COUNT LOOP
            IF IP_POLIZA.DATOSTERCEROS(I).ROL = C_ROLTOMADOR THEN
              L_TOMADOR := IP_POLIZA.DATOSTERCEROS(I);
            ELSIF IP_POLIZA.DATOSTERCEROS(I).ROL = C_ROLPROPIETARIO THEN
              L_PROPIETARIO := IP_POLIZA.DATOSTERCEROS(I);
            END IF;
          END LOOP;
        
          L_TOMADORESPROPIETARIO := 'N';
        
          IF (L_PROPIETARIO.NUMERO_DOCUMENTO = L_TOMADOR.NUMERO_DOCUMENTO AND
             L_PROPIETARIO.TIPO_DOCUMENTO = L_TOMADOR.TIPO_DOCUMENTO) OR
             (IP_PROCESO.P_SISTEMA_ORIGEN = 120 OR
             IP_PROCESO.P_SISTEMA_ORIGEN = 179) THEN
            --Estabilizacion de ambientes 18092017 Stiven Benavides
            L_TOMADORESPROPIETARIO := 'S';
          END IF;
        
          UPDATE X2000020 B
             SET B.VALOR_CAMPO_EN = L_TOMADORESPROPIETARIO,
                 B.VALOR_CAMPO    = L_TOMADORESPROPIETARIO
           WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(B.COD_RIES, -1) = -1
             AND B.COD_CAMPO = 'ES_PROPIETARIO';
        
          UPDATE X2000020 B
             SET B.VALOR_CAMPO_EN = L_PROPIETARIO.NUMERO_DOCUMENTO,
                 B.VALOR_CAMPO    = L_PROPIETARIO.NUMERO_DOCUMENTO
           WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(B.COD_RIES, -1) = -1
             AND B.COD_CAMPO = 'COD_ASEG1';
        
          UPDATE X2000020 B
             SET B.VALOR_CAMPO_EN = SUBSTR(L_PROPIETARIO.NOMBRES || ' ' ||
                                           L_PROPIETARIO.APELLIDOS,
                                           1,
                                           60),
                 B.VALOR_CAMPO    = SUBSTR(L_PROPIETARIO.NOMBRES || ' ' ||
                                           L_PROPIETARIO.APELLIDOS,
                                           1,
                                           60)
           WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(B.COD_RIES, -1) = -1
             AND B.COD_CAMPO = 'NOM_ASEG1';
        
          UPDATE X2000020 B
             SET B.VALOR_CAMPO_EN = L_PROPIETARIO.TELEFONO,
                 B.VALOR_CAMPO    = L_PROPIETARIO.TELEFONO
           WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(B.COD_RIES, -1) = -1
             AND B.COD_CAMPO = 'TEL_ASEG1';
        END IF;
      END IF;
    END IF;
  
    -- Termina arreglo SOAT
    --Dbms_Output.Put_Line('DEBITO *****');
  
    DELETE SIM_XDEBITO_AUTOMATICO A WHERE A.NUM_SECU_POL = IP_NUMSECUPOL;
  
    IF IP_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO != 121 THEN
      --- multicia no se debe borrar
      DELETE X2000060 A WHERE A.NUM_SECU_POL = IP_NUMSECUPOL;
    END IF;
  
    IF IP_POLIZA.DEBITOAUT.EXISTS(1) THEN
      IF IP_POLIZA.DEBITOAUT.COUNT > 0 THEN
        FOR I IN IP_POLIZA.DEBITOAUT.FIRST .. IP_POLIZA.DEBITOAUT.LAST LOOP
          IP_POLIZA.DEBITOAUT(I).NUM_SECU_POL := IP_NUMSECUPOL;
          IP_POLIZA.DEBITOAUT(I).NUM_END := IP_NUMEND;
          /*Sim_Proc_Log('NUMSECUPOL DEBITO',
          Ip_Poliza.Debitoaut(i)
          .Cod_Entidad.Codigo || '*' || Ip_Poliza.Debitoaut(i)
          .Canal_Descto.Codigo || '*' || Ip_Poliza.Debitoaut(i)
          .Nro_Cuenta || '*' || Ip_Poliza.Debitoaut(i)
          .Cod_Identif.Codigo || '*' || Ip_Poliza.Debitoaut(i)
          .Fecha_Vto || '*' || Ip_Poliza.Debitoaut(i)
          .Tipdoc_Ctahabiente.Codigo || '*' || Ip_Poliza.Debitoaut(i)
          .Tc_Nro_Cuotas || '*' || Ip_Poliza.Debitoaut(i).Nro_Cuenta || '*' || Ip_Poliza.Debitoaut(i)
          .Nombre_Iden || '*' || Ip_Poliza.Debitoaut(i)
          .Direccion_Iden || '*' || Ip_Poliza.Debitoaut(i)
          .Telefono_Iden || '*' || Ip_Poliza.Debitoaut(i)
          .Ciudad_Iden.Codigo || '*' || Ip_Poliza.Debitoaut(i).Email);*/
          BEGIN
            SELECT COUNT(1)
              INTO L_CANTIDAD
              FROM X2000060 C
             WHERE C.NUM_SECU_POL = IP_NUMSECUPOL;
          END;
        
          --SIM_PROC_LOG('NUMSECUPOL DEBITO','I:'||I||'*cantidad:'||l_cantidad);
          --     If Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
          IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
            IF IP_POLIZA.DEBITOAUT(I).CANAL_DESCTO.VALOR = 'R' THEN
              L_TIPODEB := 1;
            ELSE
              L_TIPODEB := 2;
            END IF;
          ELSE
            L_TIPODEB := I;
          END IF;
        
          IF L_TIPODEB = 1 THEN
            BEGIN
              UPDATE X2000030
                 SET FOR_COBRO = 'DB'
               WHERE NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
            END;
          
            IF L_CANTIDAD = 0 THEN
              INSERT INTO X2000060
                (NUM_SECU_POL,
                 NUM_END,
                 COD_ENTIDAD,
                 CANAL_DESCTO,
                 NRO_CUENTA,
                 COD_IDENTIF,
                 FECHA_VTO,
                 TIPDOC_CTAHABIENTE,
                 TC_NRO_CUOTAS,
                 SIM_NRO_CUENTA,
                 NOMBRE_IDEN,
                 DIRECCION_IDEN,
                 CIUDAD_IDEN,
                 EMAIL,
                 TELEFONO_IDEN)
              VALUES
                (IP_NUMSECUPOL,
                 IP_NUMEND,
                 IP_POLIZA.DEBITOAUT(I).COD_ENTIDAD.CODIGO,
                 IP_POLIZA.DEBITOAUT(I).CANAL_DESCTO.CODIGO,
                 IP_POLIZA.DEBITOAUT(I).NRO_CUENTA,
                 IP_POLIZA.DEBITOAUT(I).COD_IDENTIF.CODIGO,
                 IP_POLIZA.DEBITOAUT(I).FECHA_VTO,
                 IP_POLIZA.DEBITOAUT(I).TIPDOC_CTAHABIENTE.CODIGO,
                 IP_POLIZA.DEBITOAUT(I).TC_NRO_CUOTAS,
                 IP_POLIZA.DEBITOAUT(I).NRO_CUENTA,
                 SUBSTR(IP_POLIZA.DEBITOAUT(I).NOMBRE_IDEN, 1, 35),
                 SUBSTR(IP_POLIZA.DEBITOAUT(I).DIRECCION_IDEN, 1, 35),
                 IP_POLIZA.DEBITOAUT(I).CIUDAD_IDEN.CODIGO,
                 IP_POLIZA.DEBITOAUT(I).EMAIL,
                 IP_POLIZA.DEBITOAUT(I).TELEFONO_IDEN);
            END IF;
          
            IF L_CANTIDAD = 1 THEN
              BEGIN
                UPDATE X2000060 C
                   SET C.COD_ENTIDAD        = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .COD_ENTIDAD.CODIGO,
                                                  C.COD_ENTIDAD),
                       C.CANAL_DESCTO       = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .CANAL_DESCTO.CODIGO,
                                                  C.CANAL_DESCTO),
                       C.NRO_CUENTA         = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .NRO_CUENTA,
                                                  C.NRO_CUENTA),
                       C.COD_IDENTIF        = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .COD_IDENTIF.CODIGO,
                                                  C.COD_IDENTIF),
                       C.FECHA_VTO          = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .FECHA_VTO,
                                                  C.FECHA_VTO),
                       C.TIPDOC_CTAHABIENTE = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .TIPDOC_CTAHABIENTE.CODIGO,
                                                  C.TIPDOC_CTAHABIENTE),
                       C.TC_NRO_CUOTAS      = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .TC_NRO_CUOTAS,
                                                  C.TC_NRO_CUOTAS),
                       C.SIM_NRO_CUENTA     = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .NRO_CUENTA,
                                                  C.SIM_NRO_CUENTA),
                       C.EMAIL              = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .EMAIL,
                                                  C.EMAIL),
                       C.NOMBRE_IDEN        = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .NOMBRE_IDEN,
                                                  C.NOMBRE_IDEN),
                       C.DIRECCION_IDEN     = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .DIRECCION_IDEN,
                                                  C.DIRECCION_IDEN),
                       C.CIUDAD_IDEN        = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .CIUDAD_IDEN.CODIGO,
                                                  C.CIUDAD_IDEN),
                       C.TELEFONO_IDEN      = NVL(IP_POLIZA.DEBITOAUT(I)
                                                  .TELEFONO_IDEN,
                                                  C.TELEFONO_IDEN)
                 WHERE C.NUM_SECU_POL = IP_NUMSECUPOL;
              END;
            END IF;
          END IF;
        
          IF L_TIPODEB = 2 THEN
            --          If ip_poliza.DebitoAut(i).canal_descto.valor = 'A' Then
            INSERT INTO SIM_XDEBITO_AUTOMATICO
              (NUM_SECU_POL,
               NUM_END,
               COD_ENTIDAD,
               CANAL_DESCTO,
               NRO_CUENTA,
               COD_IDENTIF,
               FECHA_VTO,
               TIPDOC_CTAHABIENTE,
               TC_NRO_CUOTAS,
               SIM_NRO_CUENTA,
               SECUENCIA,
               NOMBRE_IDEN,
               DIRECCION_IDEN,
               CIUDAD_IDEN,
               EMAIL,
               TELEFONO_IDEN)
            VALUES
              (IP_NUMSECUPOL,
               IP_NUMEND,
               IP_POLIZA.DEBITOAUT(I).COD_ENTIDAD.CODIGO,
               IP_POLIZA.DEBITOAUT(I).CANAL_DESCTO.CODIGO,
               IP_POLIZA.DEBITOAUT(I).NRO_CUENTA,
               IP_POLIZA.DEBITOAUT(I).COD_IDENTIF.CODIGO,
               IP_POLIZA.DEBITOAUT(I).FECHA_VTO,
               IP_POLIZA.DEBITOAUT(I).TIPDOC_CTAHABIENTE.CODIGO,
               IP_POLIZA.DEBITOAUT(I).TC_NRO_CUOTAS,
               IP_POLIZA.DEBITOAUT(I).NRO_CUENTA,
               1,
               IP_POLIZA.DEBITOAUT(I).NOMBRE_IDEN,
               IP_POLIZA.DEBITOAUT(I).DIRECCION_IDEN,
               IP_POLIZA.DEBITOAUT(I).CIUDAD_IDEN.CODIGO,
               IP_POLIZA.DEBITOAUT(I).EMAIL,
               IP_POLIZA.DEBITOAUT(I).TELEFONO_IDEN);
          END IF;
        END LOOP;
      END IF;
    END IF;
  
    --      COMMIT;
  
    IF IP_POLIZA.DV_POLIZA.EXISTS(1) THEN
      IF IP_POLIZA.DV_POLIZA.COUNT > 0 THEN
        FOR I IN IP_POLIZA.DV_POLIZA.FIRST .. IP_POLIZA.DV_POLIZA.LAST LOOP
          L_VALORDV := IP_POLIZA.DV_POLIZA(I).VALOR_CAMPO;
          /*Rocio Mananero eliminacion caracter especial*/
          BEGIN
            L_VALORDV := SIM_PCK_GENERALES.FUN_ELIMINACHAR(L_VALORDV);
          END;
        
          IF UPPER(L_VALORDV) = 'NULL' THEN
            L_VALORDV := NULL;
          END IF;
        
          L_MCABANCA := 'N';
        
          BEGIN
            SELECT A.MCA_BANCASEGUROS
              INTO L_MCABANCA
              FROM C1010791 A
             WHERE A.COD_RAMO = IP_PROCESO.P_SUBPRODUCTO;
          EXCEPTION
            WHEN OTHERS THEN
              L_MCABANCA := 'N';
          END;
        
          IF IP_POLIZA.DV_POLIZA(I).COD_CAMPO = 'COD_OFI_DAVI' THEN
            IF L_MCABANCA = 'S' THEN
              IF NVL(L_VALORDV, 0) < 1 THEN
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000,
                                        'Codigo Oficina Davivienda es obligatorio ');
              END IF;
            END IF;
          END IF;
        
          IF IP_POLIZA.DV_POLIZA(I).COD_CAMPO = 'PROMOTOR_DA' THEN
            IF L_MCABANCA = 'S' THEN
              IF NVL(L_VALORDV, 0) < 1 THEN
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000,
                                        'Codigo Promotor Davivienda es obligatorio ');
              END IF;
            END IF;
          END IF;
        
          --       l_valordv := ip_poliza.dv_poliza(i).valor_campo;
        
          IF IP_POLIZA.DV_POLIZA(I).COD_CAMPO = 'PERIO_PAGO_AHO' THEN
            IF L_VALORDV IN (360, 180, 60, 30) THEN
              L_VALORDV := L_VALORDV / 30;
            END IF;
          END IF;
        
          IP_POLIZA.DV_POLIZA(I).NUM_SECU_POL := IP_NUMSECUPOL;
          IP_POLIZA.DV_POLIZA(I).NUM_END := IP_NUMEND;
        
          IF IP_POLIZA.DV_POLIZA(I)
           .COD_CAMPO IN
              ('PORC_DESCOMERC', 'PORC_DESCOMRE2', 'PORC_DESCOMRE1') THEN
            L_VALORDV := NULL;
          END IF;
        
          BEGIN
            UPDATE X2000020 B
               SET B.VALOR_CAMPO_EN = NVL(L_VALORDV, B.VALOR_CAMPO_EN),
                   B.VALOR_CAMPO    = NVL(L_VALORDV, B.VALOR_CAMPO)
             WHERE B.NUM_SECU_POL = IP_POLIZA.DV_POLIZA(I).NUM_SECU_POL
               AND NVL(B.COD_RIES, -1) =
                   NVL(IP_POLIZA.DV_POLIZA(I).COD_RIES, -1)
               AND B.COD_CAMPO = IP_POLIZA.DV_POLIZA(I).COD_CAMPO;
          
            DBMS_OUTPUT.PUT_LINE('COD_CAMPO :' || IP_POLIZA.DV_POLIZA(I)
                                 .COD_CAMPO || 'L_VALORDV :' || L_VALORDV);
          
            IF SQL%NOTFOUND THEN
              DBMS_OUTPUT.PUT_LINE('COD_CAMPO :' || IP_POLIZA.DV_POLIZA(I)
                                   .COD_CAMPO || 'L_VALORDV :' || L_VALORDV);
            
              INSERT INTO X2000020
                (NUM_SECU_POL,
                 COD_CAMPO,
                 VALOR_CAMPO,
                 VALOR_CAMPO_EN,
                 NUM_SECU,
                 COD_NIVEL)
              VALUES
                (IP_POLIZA.DV_POLIZA(I).NUM_SECU_POL,
                 IP_POLIZA.DV_POLIZA(I).COD_CAMPO,
                 L_VALORDV,
                 L_VALORDV,
                 -1,
                 -1);
            END IF;
          END;
          -- SIMON API RPR
          IF IP_POLIZA.DV_POLIZA(I)
           .COD_CAMPO = 'API_ESTRATEGIA' AND L_VALORDV IS NOT NULL THEN
            UPDATE X2000030 NN
               SET NN.SIM_ESTRATEGIAS = L_VALORDV,
                   NN.NUM_TARJETA     = IP_POLIZA.DATOSFIJOS.CANT_SINI4
             WHERE NN.NUM_SECU_POL = IP_NUMSECUPOL;
          ELSIF IP_POLIZA.DV_POLIZA(I)
           .COD_CAMPO = 'API_AGREGADOR' AND L_VALORDV IS NOT NULL THEN
            UPDATE X2000030 NN
               SET NN.SIM_ENTIDAD_COLOCADORA = L_VALORDV
             WHERE NN.NUM_SECU_POL = IP_NUMSECUPOL;
          END IF;
        END LOOP;
      END IF;
    END IF;
  
    IF IP_PROCESO.P_SUBPRODUCTO IS NOT NULL THEN
      BEGIN
        UPDATE X2000020 B
           SET B.VALOR_CAMPO_EN = IP_PROCESO.P_SUBPRODUCTO,
               B.VALOR_CAMPO    = IP_PROCESO.P_SUBPRODUCTO
         WHERE B.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
           AND B.COD_RIES IS NULL
           AND B.COD_CAMPO IN ('SUB_PRODUCTO', 'PRODUCTOS');
      
        IF SQL%NOTFOUND THEN
          INSERT INTO X2000020
            (NUM_SECU_POL,
             COD_CAMPO,
             VALOR_CAMPO,
             VALOR_CAMPO_EN,
             NUM_SECU,
             COD_NIVEL)
          
            SELECT IP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                   
                   COD_CAMPO,
                   IP_PROCESO.P_SUBPRODUCTO,
                   IP_PROCESO.P_SUBPRODUCTO,
                   -1,
                   
                   -1
              FROM G2000020
             WHERE COD_CIA = IP_POLIZA.DATOSFIJOS.COD_CIA.VALOR
               AND COD_RAMO = IP_POLIZA.DATOSFIJOS.COD_RAMO.VALOR
               AND NVL(MCA_BAJA, 'N') = 'N'
               AND COD_CAMPO IN ('SUB_PRODUCTO', 'PRODUCTOS');
        END IF;
      END;
    END IF;
  
    -- Riesgos
    IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
      IF IP_POLIZA.DATOSRIESGOS.COUNT > 0 THEN
        FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
          L_MAXRIES   := R;
          L_RIESGOAPI := IP_POLIZA.DATOSRIESGOS(R).DATOSRIESGO;
          L_EXISTE    := 0;
        
          BEGIN
            L_EXISTE := 0;
          
            BEGIN
              SELECT COUNT(*)
                INTO L_EXISTE
                FROM X2000020
               WHERE NUM_SECU_POL = IP_NUMSECUPOL
                 AND COD_RIES = R;
            END;
          
            IF L_EXISTE = 0 THEN
              --Insertando Riesgo
              -- SIMON API
              IF IP_PROCESO.P_CANAL = 7 THEN
                L_RIESGO  := NVL(L_RIESGOAPI.COD_RIES, R);
                L_MAXRIES := L_RIESGO;
              ELSE
                L_RIESGO := R;
              END IF;
            
              BEGIN
                SIM_PCK_PROCESO_DML_EMISION.PROC_INSERTANUEVORIESGO(IP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                                    IP_POLIZA.DATOSFIJOS.NUM_END, --numend
                                                                    L_RIESGO,
                                                                    L_VALIDACION,
                                                                    IP_PROCESO,
                                                                    OP_RESULTADO,
                                                                    OP_ARRERRORES);
              END;
            END IF;
          END;
        
          --Datos Variables Riesgos
          L_TDOCONEROSO  := NULL;
          L_ESONEROSO    := 'N';
          L_OPCION374    := NULL;
          L_OPCION371    := NULL;
          L_OPCION372    := NULL;
          L_DTOTECNICO   := 0;
          L_DTOCOMERCIAL := 0;
          --  l_numpolcotiz := Null;
        
          IF IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES.EXISTS(1) THEN
            FOR DV IN IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                        .DATOSVARIABLES.LAST LOOP
              /*  If l_numpolcotiz Is Null Then
                l_numpolcotiz := ip_poliza.DatosRiesgos (R).DatosVariables(DV).num_secu_pol;
              End If;*/
              L_VALORCAMPO := IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                              .VALOR_CAMPO;
              /* Eliminacion caracteres especiales rocio mananero*/
            
              /*If l_Codcampo In ('DIRECC_RIES', 'MANZANA') Then
               Sim_Proc_Log('DV1 Ant', l_Codcampo || '*' || l_Valorcampo);
              End If;*/
            
              BEGIN
                L_VALORCAMPO := SIM_PCK_GENERALES.FUN_ELIMINACHAR(L_VALORCAMPO);
              END;
            
              L_CODCAMPO := IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                            .COD_CAMPO;
            
              /*If l_Codcampo In ('DIRECC_RIES', 'MANZANA') Then
               Sim_Proc_Log('DV1 Des', l_Codcampo || '*' || l_Valorcampo);
              End If;*/
            
              IF UPPER(L_VALORCAMPO) = 'NULL' THEN
                L_VALORCAMPO := NULL;
              END IF;
            
              IF L_CODCAMPO IN ('ZON_RADIC_RIES', 'CPOS_RIES') THEN
                L_VALORCAMPO := LPAD(TO_NUMBER(L_VALORCAMPO), 5, '0');
              END IF;
            
              L_CLAUSULAS := NULL;
            
              --       If Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
              IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
                IF IP_PROCESO.P_PROCESO = 270 THEN
                  L_COD_RIES := NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                                    .COD_RIES,
                                    -1);
                
                  IF L_CODCAMPO = 'SEXO_VIP' THEN
                    IF SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('SEXO_VIP',
                                                                IP_NUMSECUPOL,
                                                                L_COD_RIES) !=
                       L_VALORCAMPO THEN
                      RAISE_APPLICATION_ERROR(-20001,
                                              'Error Sexo de Asegurado diferente del informado en Cotización');
                    END IF;
                  END IF;
                
                  IF L_CODCAMPO = 'FEC_NACIMIENTO' THEN
                    IF SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('FEC_NACIMIENTO',
                                                                IP_NUMSECUPOL,
                                                                L_COD_RIES) !=
                       L_VALORCAMPO THEN
                      RAISE_APPLICATION_ERROR(-20001,
                                              'Error Fecha de nacimiento diferente de informada en cotizacion');
                    END IF;
                  END IF;
                END IF;
              
                IF L_CODCAMPO = 'COD_OCU_ATGC' THEN
                  IF INSTR(L_VALORCAMPO, '-') > 0 THEN
                    L_CLAUSULAS  := SUBSTR(L_VALORCAMPO,
                                           INSTR(L_VALORCAMPO, '-') + 1,
                                           LENGTH(L_VALORCAMPO));
                    L_VALORCAMPO := TO_NUMBER(SUBSTR(L_VALORCAMPO,
                                                     1,
                                                     INSTR(L_VALORCAMPO, '-') - 1));
                  END IF;
                
                  BEGIN
                    SELECT SUBSTR(A.DESCRIPCION, 1, 60)
                      INTO L_CLAUSULAS
                      FROM SIM_OCUPACION A
                     WHERE A.COD_CIA = IP_PROCESO.P_COD_CIA
                       AND A.COD_SECC = IP_PROCESO.P_COD_SECC
                       AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                       AND A.FECHA_BAJA IS NULL
                       AND A.COD_OCUPACION = L_VALORCAMPO
                       AND ROWNUM = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                END IF;
              
                IF L_CODCAMPO = 'ACTIVIDAD_ACT' THEN
                  IF INSTR(L_VALORCAMPO, '-') > 0 THEN
                    L_CLAUSULAS  := SUBSTR(L_VALORCAMPO,
                                           INSTR(L_VALORCAMPO, '-') + 1,
                                           LENGTH(L_VALORCAMPO));
                    L_VALORCAMPO := TO_NUMBER(SUBSTR(L_VALORCAMPO,
                                                     1,
                                                     INSTR(L_VALORCAMPO, '-') - 1));
                  END IF;
                
                  BEGIN
                    SELECT SUBSTR(A.DESCRIPCION, 1, 60)
                      INTO L_CLAUSULAS
                      FROM SIM_ACTIVIDAD A
                     WHERE A.COD_CIA = IP_PROCESO.P_COD_CIA
                       AND A.COD_SECC = IP_PROCESO.P_COD_SECC
                       AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                       AND A.COD_ACTIVIDAD = L_VALORCAMPO;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                END IF;
              END IF;
            
              --Vida Grupo Simones Ventas -Juan González / 28/10/2016
              -- (Valida que a la emision no se cambien datos de los terceros nuevos)
              IF SIM_PCK_ATGC_VIDA_GRUPO.FUN_ESRAMOATGCVIDAGRUPO(IP_PROCESO.P_COD_CIA,
                                                                 IP_PROCESO.P_COD_SECC,
                                                                 IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
              
                IF IP_PROCESO.P_PROCESO = 270 THEN
                  L_COD_RIES := NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                                    .COD_RIES,
                                    -1);
                
                  IF L_CODCAMPO IN ('FECHA_NCMNTO', 'SEXO_BONA') THEN
                    IF SIM_PCK_ATGC_VIDA_GRUPO.FUN_VALIDATERNUEVOEMISION(L_COD_RIES,
                                                                         IP_NUMSECUPOL,
                                                                         IP_PROCESO,
                                                                         OP_ARRERRORES) = 'N' THEN
                      RAISE_APPLICATION_ERROR(-20001,
                                              'Error Sexo / Fecha de Nacimiento del Asegurado es diferente del informado en Cotización (Riesgo ' ||
                                              L_COD_RIES || ')');
                    END IF;
                  
                  END IF;
                END IF;
              END IF;
            
              BEGIN
                SELECT NVL(A.APLICA_DTO_TECNICO, 'N'),
                       NVL(A.APLICA_DTO_COMERCIAL, 'N')
                  INTO L_APLICADTOTECNICO, L_APLICADTOCOMERCIAL
                  FROM C1010791 A
                 WHERE A.COD_RAMO = IP_PROCESO.P_SUBPRODUCTO;
              EXCEPTION
                WHEN OTHERS THEN
                  L_APLICADTOTECNICO   := 'N';
                  L_APLICADTOCOMERCIAL := 'N';
              END;
            
              IF L_APLICADTOTECNICO = 'S' THEN
                IF L_CODCAMPO = 'DTO_TECNICO' THEN
                  L_DTOTECNICO := L_VALORCAMPO;
                END IF;
              END IF;
            
              IF L_APLICADTOCOMERCIAL = 'S' THEN
                IF L_CODCAMPO = 'DTO_COMERCIAL' THEN
                  L_DTOCOMERCIAL := L_VALORCAMPO;
                END IF;
              END IF;
            
              IF L_CODCAMPO = 'BENEF_ONEROSO' THEN
                L_ESONEROSO := L_VALORCAMPO;
              END IF;
            
              IF L_CODCAMPO = 'OPCION_374' THEN
                L_OPCION374 := L_VALORCAMPO;
              END IF;
            
              IF L_CODCAMPO = 'OPCION_371' THEN
                L_OPCION371 := L_VALORCAMPO;
              END IF;
            
              IF L_CODCAMPO = 'OPCION_372' THEN
                L_OPCION372 := L_VALORCAMPO;
              END IF;
            
              IF L_CODCAMPO = 'CERO_KM' THEN
                L_CEROOK := L_VALORCAMPO;
              END IF;
            
              -- mcolorado: mantis 36453: 28/05/2015: las actualizacines se realizan al finalizar el recorrido --
              /* If ip_proceso.p_proceso != 270 Then
               If l_codcampo = 'OPCION_RC_SUP' Then
                 l_opcionrcsup := 0;
              
                 If  l_valorcampo = 0 Then
                  l_valorcampo := Null;
                  Update X2000020 b
                  Set     b.valor_Campo_en = 'N'
                         ,b.valor_campo      = 'N'
                  where  b.num_secu_pol     = Ip_numsecupol
                  and    nvl(b.cod_ries,-1) = nvl(ip_poliza.DatosRiesgos(R).DatosVariables(DV).cod_ries,-1)
                  and    b.cod_campo        = 'TOMA_OPC_SUP';
                 Else
                   l_opcionrcsup := l_valorcampo;
                 End If;
               End If;
              End If;*/
            
              IF L_CODCAMPO = 'MODO_IMPRIME' AND L_VALORCAMPO IS NOT NULL THEN
                IF SIM_PCK_FUNCION_GEN.FUN_POLIZA_ELECTRONICA(IP_PROCESO.P_COD_CIA,
                                                              IP_PROCESO.P_COD_SECC,
                                                              IP_PROCESO.P_COD_PRODUCTO,
                                                              IP_PROCESO.P_SUBPRODUCTO) = 'S' THEN
                  UPDATE X2000030 NN
                     SET NN.SIM_TIPO_ENVIO = L_VALORCAMPO
                   WHERE NN.NUM_SECU_POL = IP_NUMSECUPOL;
                
                  L_VALORCAMPO := NULL;
                END IF;
              END IF;
            
              IF SIM_PCK_FUNCION_GEN.FUN_ES_DIRECCION(L_CODCAMPO,
                                                      IP_PROCESO.P_COD_CIA,
                                                      IP_PROCESO.P_COD_SECC,
                                                      IP_PROCESO.P_COD_PRODUCTO) THEN
                P_DIRECCION          := L_VALORCAMPO;
                P_DIRECCION_ESTANDAR := NULL;
                P_CODIGO_SALIDA      := NULL;
                P_MENSAJE_SALIDA     := NULL;
              
                PKG_VALIDACIONES_TER.PRC_VALIDAR_DIRECCION(P_DIRECCION,
                                                           P_DIRECCION_ESTANDAR,
                                                           P_CODIGO_SALIDA,
                                                           P_MENSAJE_SALIDA);
              
                IF TRIM(P_DIRECCION_ESTANDAR) IS NOT NULL THEN
                  L_VALORCAMPO := P_DIRECCION_ESTANDAR;
                ELSE
                  L_VALORCAMPO := P_DIRECCION || '- No homologada';
                END IF;
              END IF;
            
              IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).NUM_SECU_POL := IP_NUMSECUPOL;
              IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).NUM_END := IP_NUMEND;
            
              L_CODCAMPO := IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                            .COD_CAMPO;
              L_COD_RIES := NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                                .COD_RIES,
                                -1);
              IF L_CODCAMPO = 'VLR_VTASANUAL' THEN
                L_COD_RIES := -1;
              END IF;
            
              BEGIN
                UPDATE X2000020 B
                   SET B.VALOR_CAMPO_EN = NVL(L_VALORCAMPO, B.VALOR_CAMPO_EN),
                       B.VALOR_CAMPO    = NVL(L_VALORCAMPO, B.VALOR_CAMPO),
                       B.CLAUSULAS      = L_CLAUSULAS,
                       B.CLAVE_COBERT   = 'S'
                 WHERE B.NUM_SECU_POL = IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                      .NUM_SECU_POL
                   AND NVL(B.COD_RIES, -1) = L_COD_RIES
                   AND B.COD_CAMPO = L_CODCAMPO;
              
                DBMS_OUTPUT.PUT_LINE('proceso_datos_emision2[7003] COD_CAMPO :' ||
                                     L_CODCAMPO || ' L_VALORCAMPO :' ||
                                     L_VALORCAMPO);
                --AEEM
                IF L_CODCAMPO = 'SEL_TERREMOTO' OR
                   L_CODCAMPO = 'BIEN_ASEGURADO' THEN
                  DBMS_OUTPUT.PUT_LINE('proceso_datos_emision2[7003] COD_CAMPO :' ||
                                       L_CODCAMPO || ' L_VALORCAMPO :' ||
                                       L_VALORCAMPO);
                  DBMS_OUTPUT.PUT_LINE('proceso_datos_emision2[7003] COD_CAMPO :' ||
                                       L_CODCAMPO || ' L_VALORCAMPO :' ||
                                       L_VALORCAMPO);
                END IF;
                --dbms_output.put_line('Actualizo cantidad:'||Sql%Rowcount);
                IF SQL%NOTFOUND THEN
                  DBMS_OUTPUT.PUT_LINE('proceso_datos_emision2[7007] COD_CAMPO :' || IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                                       .COD_CAMPO || ' L_VALORCAMPO :' ||
                                       L_VALORCAMPO);
                  INSERT INTO X2000020
                    (NUM_SECU_POL,
                     COD_CAMPO,
                     COD_RIES,
                     VALOR_CAMPO,
                     VALOR_CAMPO_EN,
                     NUM_SECU,
                     CLAVE_COBERT,
                     COD_NIVEL,
                     CLAUSULAS)
                  VALUES
                    (IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                     .NUM_SECU_POL,
                     IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).COD_CAMPO,
                     IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).COD_RIES,
                     L_VALORCAMPO,
                     L_VALORCAMPO,
                     -1,
                     'S',
                     -1,
                     L_CLAUSULAS);
                END IF;
              END;
            
            END LOOP;
          END IF;
        
          --Mantis 25949
          DECLARE
            L_OPCIONRENTA441 NUMBER;
          BEGIN
            BEGIN
              SELECT NVL(C.VALOR_CAMPO_EN, 0)
                INTO L_OPCIONRENTA441
                FROM X2000020 C
               WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
                 AND C.COD_CAMPO = 'RENTA';
            EXCEPTION
              WHEN OTHERS THEN
                L_OPCIONRENTA441 := 0;
            END;
            IF L_OPCIONRENTA441 != 0 THEN
              BEGIN
                UPDATE X2000020 A
                   SET A.VALOR_CAMPO = 'S', A.VALOR_CAMPO_EN = 'S'
                 WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                   AND A.COD_CAMPO = 'TOMA_RENTA';
              END;
            
              DECLARE
                L_UNIDLIMITE NUMBER;
                L_PERIODOIND NUMBER;
                L_DEDRENTA   NUMBER;
              BEGIN
                BEGIN
                  SELECT SIM_PERIODO_INDEM, SIM_DEDUCIBLE_RENTA, UNIDAD
                    INTO L_PERIODOIND, L_DEDRENTA, L_UNIDLIMITE
                    FROM C1010843
                   WHERE COD_CIA = IP_PROCESO.P_COD_CIA
                     AND COD_SECC = IP_PROCESO.P_COD_SECC
                     AND COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                     AND SUB_RAMO = IP_PROCESO.P_SUBPRODUCTO
                     AND LIMITE = L_OPCIONRENTA441
                     AND COD_COB = 441
                     AND FECHA_BAJA IS NULL;
                EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
                END;
              
                UPDATE X2000020 A
                   SET A.VALOR_CAMPO    = L_PERIODOIND, --'30',
                       A.VALOR_CAMPO_EN = L_PERIODOIND --'30'
                 WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                   AND A.COD_CAMPO = 'PERIODO_INMOB';
              
                UPDATE X2000020 A
                   SET A.VALOR_CAMPO    = L_DEDRENTA, --'10',
                       A.VALOR_CAMPO_EN = L_DEDRENTA --'10'
                 WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                   AND A.COD_CAMPO = 'DED_RENTA_I';
              END;
            
            END IF;
          END;
          --fin     Mantis 25949
        
          IF SIM_PCK_FUNCION_GEN.ES_AUTOS(IP_PROCESO.P_COD_SECC,
                                          IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
            V_DESCTO_MAX := SIM_PCK_DESCUENTOS.FNC_OBTENERPARAMETRODESCUENTO('PARAM_COT_AUTO',
                                                                             IP_PROCESO,
                                                                             OP_RESULTADO,
                                                                             OP_ARRERRORES);
          
            IF OP_RESULTADO = -1 THEN
              /*Raise_Application_Error(-20001,
              'Error al obtener el descuento máximo permitido');*/
              -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
              RAISE_APPLICATION_ERROR(-20001,
                                      'Riesgo ' || R ||
                                      '. Error al obtener el descuento máximo permitido');
            END IF;
          
            IF V_DESCTO_MAX < (L_DTOTECNICO - L_DTOCOMERCIAL) * -1 THEN
              OP_RESULTADO := -1;
              RAISE_APPLICATION_ERROR(-20001,
                                      'suma de Descuento supera el descuento máximo permitido');
            END IF;
          
            IF L_OPCION371 || L_OPCION372 || L_OPCION374 = '000' THEN
              BEGIN
                UPDATE X2000020
                   SET VALOR_CAMPO = 'N', VALOR_CAMPO_EN = 'N'
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'DEDUCIBLE_ALT';
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            ELSE
              BEGIN
                UPDATE X2000020
                   SET VALOR_CAMPO = 'S', VALOR_CAMPO_EN = 'S'
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'DEDUCIBLE_ALT';
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            END IF;
          
            L_ESONEROSO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('BENEF_ONEROSO',
                                                                    IP_NUMSECUPOL,
                                                                    1);
          
            IF NVL(L_ESONEROSO, 'N') = 'S' THEN
              L_TDOCONEROSO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_BENEF',
                                                                        IP_NUMSECUPOL,
                                                                        1);
            
              IF L_TDOCONEROSO != 'NT' THEN
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000,
                                        'Tipo de Documento invalido para oneroso solo se permite NIT');
              END IF;
              /*                 morj
              Se debe permitir opcion de deducible cero para todo mundo
               ELSE
                IF l_opcion371 = 118
                THEN
                   op_resultado := -1;
                   raise_application_error (
                      -20000,
                      'Opcion de Deducible de Perdida total No Valida');
                END IF;
              
                IF l_opcion374 = 118
                THEN
                   op_resultado := -1;
                   raise_application_error (
                      -20000,
                      'Opcion de Deducible de Perdida Hurto No Valida');
                END IF;*/
            END IF;
          
            IF IP_POLIZA.DV_POLIZA.EXISTS(1) THEN
              IF IP_POLIZA.DV_POLIZA.COUNT > 0 THEN
                FOR I IN IP_POLIZA.DV_POLIZA.FIRST .. IP_POLIZA.DV_POLIZA.LAST LOOP
                  IF IP_POLIZA.DV_POLIZA(I).COD_CAMPO = 'LIMITE_RENTA' AND IP_POLIZA.DV_POLIZA(I)
                     .VALOR_CAMPO != 0 THEN
                    /* ****** INICIO-TRANSMASIVO ****** */
                    --17112015 lberbesi: Se filtra por subproducto. Update de estos DV no aplican para colectivas.
                    /*If Ip_Proceso.p_Subproducto != 363 Then*/
                    -- 17112016 sgpinto: Integración Modificación función de validación
                    IF FNC299_VALIDA_ES_CLTVA_AUTOS(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                    IP_NUM_END      => IP_NUMEND,
                                                    IP_PROCESO      => IP_PROCESO) = 'N' THEN
                      /* ****** FIN-TRANSMASIVO ****** */
                      BEGIN
                        UPDATE X2000020 A
                           SET A.VALOR_CAMPO = 'S', A.VALOR_CAMPO_EN = 'S'
                         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                           AND A.COD_CAMPO = 'TOMA_RENTA_I'
                           AND EXISTS
                         (SELECT 'S'
                                  FROM X2000020 C
                                 WHERE C.NUM_SECU_POL = A.NUM_SECU_POL
                                   AND C.COD_CAMPO = 'LIMITE_RENTA'
                                   AND NVL(C.VALOR_CAMPO_EN, -1) != -1);
                      END;
                    
                      --Mantis 25949
                      DECLARE
                        L_UNIDLIMITE NUMBER;
                        L_PERIODOIND NUMBER;
                        L_DEDRENTA   NUMBER;
                      BEGIN
                        BEGIN
                          SELECT SIM_PERIODO_INDEM,
                                 SIM_DEDUCIBLE_RENTA,
                                 UNIDAD
                            INTO L_PERIODOIND, L_DEDRENTA, L_UNIDLIMITE
                            FROM C1010843
                           WHERE COD_CIA = IP_PROCESO.P_COD_CIA
                             AND COD_SECC = IP_PROCESO.P_COD_SECC
                             AND COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                             AND SUB_RAMO = IP_PROCESO.P_SUBPRODUCTO
                             AND LIMITE = IP_POLIZA.DV_POLIZA(I)
                                .VALOR_CAMPO
                             AND COD_COB = 41
                             AND FECHA_BAJA IS NULL;
                        EXCEPTION
                          WHEN OTHERS THEN
                            NULL;
                        END;
                        UPDATE X2000020 A
                           SET A.VALOR_CAMPO    = L_UNIDLIMITE, --'3',
                               A.VALOR_CAMPO_EN = L_UNIDLIMITE --'3'
                         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                           AND A.COD_CAMPO = 'UNIDAD_LIMITE';
                      
                        UPDATE X2000020 A
                           SET A.VALOR_CAMPO    = L_PERIODOIND, --'30',
                               A.VALOR_CAMPO_EN = L_PERIODOIND --'30'
                         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                           AND A.COD_CAMPO = 'PERIODO_INDEM';
                      
                        UPDATE X2000020 A
                           SET A.VALOR_CAMPO    = L_DEDRENTA, --'10',
                               A.VALOR_CAMPO_EN = L_DEDRENTA --'10'
                         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                           AND A.COD_CAMPO = 'DED_RENTA';
                      END;
                      --Mantis 25949
                    
                      IF IP_PROCESO.P_SUBPRODUCTO IN (311, 350) THEN
                        BEGIN
                          SELECT VALOR_CAMPO
                            INTO L_RENTA
                            FROM X2000020 A
                           WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                             AND A.COD_CAMPO = 'RENTA';
                        EXCEPTION
                          WHEN OTHERS THEN
                            NULL;
                        END;
                      
                        UPDATE X2000020 A
                           SET A.VALOR_CAMPO    = L_RENTA,
                               A.VALOR_CAMPO_EN = L_RENTA
                         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                           AND A.COD_CAMPO = 'LIMITE_RENTA';
                      END IF;
                      /* ****** INICIO-TRANSMASIVO ****** */
                    END IF;
                    /* ****** FIN-TRANSMASIVO ****** */
                  END IF;
                END LOOP;
              END IF;
            END IF;
          
            -- Ini: mcolorado: mantis 36453: 28/05/2015: Se actualiza los campos de RC suplementaria para cuando no se ingresa datos
          
            BEGIN
              SELECT NVL(A.VALOR_CAMPO, 0)
                INTO L_TOMAOPSUP
                FROM X2000020 A
               WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                 AND A.COD_CAMPO = 'OPCION_RC_SUP'
                    /* ****** INICIO-TRANSMASIVO ****** */
                 AND A.COD_RIES =
                     (SELECT MAX(B.COD_RIES)
                        FROM X2000020 B
                       WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
                         AND B.COD_CAMPO = 'OPCION_RC_SUP');
              /* ****** FIN-TRANSMASIVO ****** */
            
              IF L_TOMAOPSUP = 0 THEN
                UPDATE X2000020 B
                   SET B.VALOR_CAMPO_EN = 'N', B.VALOR_CAMPO = 'N'
                 WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
                   AND B.COD_CAMPO = 'TOMA_OPC_SUP';
              ELSE
                UPDATE X2000020 B
                   SET B.VALOR_CAMPO_EN = 'S', B.VALOR_CAMPO = 'S'
                 WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
                   AND B.COD_CAMPO = 'TOMA_OPC_SUP';
              END IF;
            END;
          END IF;
        
          IF IP_POLIZA.DATOSRIESGOS(1).RECARGODCTO.EXISTS(1) THEN
            IF IP_POLIZA.DATOSRIESGOS(1).RECARGODCTO.COUNT > 0 THEN
              FOR I IN IP_POLIZA.DATOSRIESGOS(1).RECARGODCTO.FIRST .. IP_POLIZA.DATOSRIESGOS(1)
                                                                      .RECARGODCTO.LAST LOOP
                BEGIN
                  UPDATE X2990800 Z
                     SET Z.MCA_AGRAVANTE = '*'
                   WHERE Z.NUM_SECU_POL = IP_NUMSECUPOL
                     AND Z.COD_AGRAVANTE = IP_POLIZA.DATOSRIESGOS(1).RECARGODCTO(I)
                        .COD_AGRAVANTE;
                END;
              END LOOP;
            END IF;
          END IF;
        
          -- Manejo Nominas
          L_STRINGINSERT := NULL;
          L_STRINGVALUE  := NULL;
          L_PRICAR       := ' ';
          L_ITEM         := 0;
        
          DELETE X9990100 J
           WHERE J.NUM_SECU_POL = IP_NUMSECUPOL
             AND J.COD_RIES = R;
        
          IF IP_POLIZA.DATOSRIESGOS(R).NOMINAS.EXISTS(1) THEN
            IF IP_POLIZA.DATOSRIESGOS(R).NOMINAS.COUNT > 0 THEN
            
              FOR NM IN IP_POLIZA.DATOSRIESGOS(R).NOMINAS.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                   .NOMINAS.LAST LOOP
                NRO_ITEM   := IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                              .NRO_REGISTRO;
                L_COD_RIES := IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM).COD_RIES;
              
                IF L_ITEM = 0 THEN
                  L_ITEM         := NRO_ITEM;
                  L_STRINGQUERY  := NULL;
                  L_STRINGINSERT := NULL;
                  L_STRINGVALUE  := NULL;
                
                  IF IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                   .TIPO_ESTRUCTURA IS NOT NULL THEN
                    IP_TABLA := IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                                .TIPO_ESTRUCTURA;
                  ELSE
                    IP_TABLA := 'X9990100';
                  END IF;
                ELSE
                  IF L_ITEM != NRO_ITEM OR
                     IP_TABLA != NVL(IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                                     .TIPO_ESTRUCTURA,
                                     IP_TABLA) THEN
                    L_EXISTECAMPOEND := 0;
                    L_EXISTECAMPORIE := 0;
                    BEGIN
                      SELECT COUNT(1)
                        INTO L_EXISTECAMPOEND
                        FROM ALL_TAB_COLUMNS TS
                       WHERE TS.TABLE_NAME = IP_TABLA
                         AND TS.COLUMN_NAME = 'NUM_END';
                    END;
                  
                    BEGIN
                      SELECT COUNT(1)
                        INTO L_EXISTECAMPORIE
                        FROM ALL_TAB_COLUMNS TS
                       WHERE TS.TABLE_NAME = IP_TABLA
                         AND TS.COLUMN_NAME = 'COD_RIES';
                    END;
                  
                    L_STRINGQUERY := 'Insert into ' || IP_TABLA || '(' ||
                                     CHR(10);
                    L_STRINGQUERY := L_STRINGQUERY || 'NUM_SECU_POL,';
                  
                    IF L_EXISTECAMPOEND > 0 THEN
                      L_STRINGQUERY := L_STRINGQUERY || 'NUM_END,';
                    END IF;
                  
                    IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                      L_STRINGQUERY := L_STRINGQUERY || 'COD_RIES,';
                    END IF;
                  
                    L_STRINGQUERY := L_STRINGQUERY || L_STRINGINSERT || ')' ||
                                     CHR(10);
                    L_STRINGQUERY := L_STRINGQUERY || ' Values (' ||
                                     CHR(10);
                    L_STRINGQUERY := L_STRINGQUERY || IP_NUMSECUPOL || ',';
                  
                    IF L_EXISTECAMPOEND > 0 THEN
                      L_STRINGQUERY := L_STRINGQUERY || IP_NUMEND || ',';
                    END IF;
                  
                    IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                      L_STRINGQUERY := L_STRINGQUERY || L_COD_RIES || ',';
                    END IF;
                  
                    L_STRINGQUERY := L_STRINGQUERY || L_STRINGVALUE || ')' ||
                                     CHR(10);
                  
                    --Sim_Proc_Log(' 1 Nominas ', l_Stringquery);
                    BEGIN
                      EXECUTE IMMEDIATE L_STRINGQUERY;
                    EXCEPTION
                      WHEN OTHERS THEN
                        OP_RESULTADO := -1;
                        RAISE;
                    END;
                  
                    L_ITEM := NRO_ITEM;
                  
                    IF IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                     .TIPO_ESTRUCTURA IS NOT NULL THEN
                      IP_TABLA := IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                                  .TIPO_ESTRUCTURA;
                    ELSE
                      IP_TABLA := 'X9990100';
                    END IF;
                  
                    L_PRICAR       := ' ';
                    L_STRINGQUERY  := NULL;
                    L_STRINGINSERT := NULL;
                    L_STRINGVALUE  := NULL;
                  END IF;
                END IF;
              
                IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM).NUM_SECU_POL := IP_NUMSECUPOL;
                IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM).NUM_END := IP_NUMEND;
                L_NOMCAMPO := IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                              .COD_CAMPO;
                L_VALCAMPO := IP_POLIZA.DATOSRIESGOS(R).NOMINAS(NM)
                              .VALOR_CAMPO;
              
                L_TYPDATO  := NULL;
                L_LONGITUD := NULL;
              
                BEGIN
                  SELECT TS.DATA_TYPE,
                         DECODE(TS.DATA_TYPE,
                                'NUMBER',
                                TS.DATA_PRECISION,
                                TS.DATA_LENGTH)
                    INTO L_TYPDATO, L_LONGITUD
                    FROM ALL_TAB_COLUMNS TS
                   WHERE TS.TABLE_NAME = IP_TABLA
                     AND TS.COLUMN_NAME = L_NOMCAMPO;
                EXCEPTION
                  WHEN OTHERS THEN
                    OP_RESULTADO := -1;
                    RAISE_APPLICATION_ERROR(-20000,
                                            'Fallo al recuperar campo: ' ||
                                            L_NOMCAMPO || ' De la tabla:' ||
                                            IP_TABLA);
                END;
              
                L_LONGITUD := NVL(L_LONGITUD, 0);
              
                CASE
                  WHEN L_TYPDATO = 'DATE' THEN
                    L_VALCAMPO := 'to_date(' || L_COM || L_VALCAMPO ||
                                  L_COM || ',' || L_COM || 'ddmmyyyy' ||
                                  L_COM || ') ';
                  WHEN L_TYPDATO = 'VARCHAR2' THEN
                    L_VALCAMPO := L_COM ||
                                  SUBSTR(L_VALCAMPO, 1, L_LONGITUD) ||
                                  L_COM;
                  WHEN L_TYPDATO = 'NUMBER' THEN
                    L_VALCAMPO := L_VALCAMPO;
                  ELSE
                    NULL;
                END CASE;
              
                L_STRINGINSERT := L_STRINGINSERT || L_PRICAR || L_NOMCAMPO;
                L_STRINGVALUE  := L_STRINGVALUE || L_PRICAR || L_VALCAMPO;
              
                IF L_PRICAR = ' ' THEN
                  L_PRICAR := ',';
                END IF;
              END LOOP;
            
              IF L_PRICAR = ',' THEN
                L_EXISTECAMPOEND := 0;
                L_EXISTECAMPORIE := 0;
              
                BEGIN
                  SELECT COUNT(1)
                    INTO L_EXISTECAMPOEND
                    FROM ALL_TAB_COLUMNS TS
                   WHERE TS.TABLE_NAME = IP_TABLA
                     AND TS.COLUMN_NAME = 'NUM_END';
                END;
              
                BEGIN
                  SELECT COUNT(1)
                    INTO L_EXISTECAMPORIE
                    FROM ALL_TAB_COLUMNS TS
                   WHERE TS.TABLE_NAME = IP_TABLA
                     AND TS.COLUMN_NAME = 'COD_RIES';
                END;
              
                L_STRINGQUERY := 'Insert into ' || IP_TABLA || '(' ||
                                 CHR(10);
                L_STRINGQUERY := L_STRINGQUERY || 'NUM_SECU_POL,';
              
                IF L_EXISTECAMPOEND > 0 THEN
                  L_STRINGQUERY := L_STRINGQUERY || 'NUM_END,';
                END IF;
              
                IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                  L_STRINGQUERY := L_STRINGQUERY || 'COD_RIES,';
                END IF;
              
                L_STRINGQUERY := L_STRINGQUERY || L_STRINGINSERT || ')' ||
                                 CHR(10);
                L_STRINGQUERY := L_STRINGQUERY || ' Values (' || CHR(10);
                L_STRINGQUERY := L_STRINGQUERY || IP_NUMSECUPOL || ',';
              
                IF L_EXISTECAMPOEND > 0 THEN
                  L_STRINGQUERY := L_STRINGQUERY || IP_NUMEND || ',';
                END IF;
              
                IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                  L_STRINGQUERY := L_STRINGQUERY || L_COD_RIES || ',';
                END IF;
              
                L_STRINGQUERY := L_STRINGQUERY || L_STRINGVALUE || ')' ||
                                 CHR(10);
              
                --Sim_Proc_Log(' Nominas ', l_Stringquery);
              
                BEGIN
                  EXECUTE IMMEDIATE L_STRINGQUERY;
                EXCEPTION
                  WHEN OTHERS THEN
                    OP_RESULTADO := -1;
                    RAISE;
                END;
              END IF;
            END IF;
          END IF;
        END LOOP;
      
        /*FIN Ciclo de Riesgos*/
      
        /*------------------------------------------------------------------------
        La siguiente seccion de codigo maneja un sql dinamico que permite ingresar
        informacion a simon, el sql se basa en el nombre de la tabla que viene
        del WebService en el campo tipo estructura y que se ingresa en el
        TYPE DE DATOS ADICIONALES, el sql analiza permite al pl ingresar información
        a cualquier tabla que inicialmente no se contemplo en Simon.
        ------------------------------------------------------------------------*/
      
        L_STRINGINSERT := NULL;
        L_STRINGVALUE  := NULL;
        L_STRINGQUERY  := NULL;
        L_PRICAR       := ' ';
        L_ITEM         := 0;
        L_COD_RIES     := 0;
      
        DELETE X2040400 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
      
        -- NOMINAS
        IF IP_POLIZA.DATOSADICIONAL.EXISTS(1) THEN
          IF IP_POLIZA.DATOSADICIONAL.COUNT > 0 THEN
            FOR NM IN IP_POLIZA.DATOSADICIONAL.FIRST .. IP_POLIZA.DATOSADICIONAL.LAST LOOP
              --intasi31 20220817 PortafolioVida
              IF IP_TABLA = 'X9990100' AND
                 SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCNOMINAVIDAAP(IP_PROCESO) = 'S' THEN
                L_NROREGISTROAP := IP_POLIZA.DATOSADICIONAL(NM).NRO_REGISTRO;
                L_CODRIESAP     := IP_POLIZA.DATOSADICIONAL(NM).COD_RIES;
                -- 30-08-2022 RWinter PortafolioVida
                -- Obtiene la Cobertura basica:
                L_CODCOBAP := SIM_PCK_FUNCION_GEN.TRAERCOBERTURABASE(IP_PROCESO.P_COD_CIA,
                                                                     IP_PROCESO.P_COD_PRODUCTO);
              
                --rescata nomina cobertura basica
                L_NOMINAAP := NULL;
                BEGIN
                  SELECT A.NOMINA
                    INTO L_NOMINAAP
                    FROM A1002100 A
                   WHERE A.COD_CIA = IP_PROCESO.P_COD_CIA
                     AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                     AND A.COD_COB = IP_POLIZA.DATOSADICIONAL(NM).COD_COB;
                  -- RW : PortafolioVida - HU:ODVVI-1903
                  -- INICIA ODVVI-2278 Rwinter Se agregan los productos 956 y 958
                EXCEPTION
                  WHEN OTHERS THEN
                    IF IP_PROCESO.P_COD_PRODUCTO IN (954, 956, 958) THEN
                      L_NOMINAAP := 'ACCI';
                    ELSE
                      L_NOMINAAP := 'VNUE';
                    END IF;
                    -- FIN ODVVI-2278
                END;
              END IF;
              --fin intasi31 20220817 PortafolioVida
            
              NRO_ITEM := IP_POLIZA.DATOSADICIONAL(NM).NRO_REGISTRO;
              L_CODCOB := IP_POLIZA.DATOSADICIONAL(NM).COD_COB;
              IF L_CODCOBANT = 0 THEN
                L_CODCOBANT := L_CODCOB;
              END IF;
              SIM_PROC_LOG('Nominas DAT ADIC codcampo ' || L_CODCAMPO, '');
              SIM_PROC_LOG('Nominas DAT ADIC codcob ' || L_CODCOB, '');
              IF L_COD_RIES = 0 THEN
                L_COD_RIES := IP_POLIZA.DATOSADICIONAL(NM).COD_RIES;
              END IF;
            
              /*   sim_proc_log('MPG NominasServ  EN FOR ULTIMO nro_item '||nro_item,'');
                 sim_proc_log('MPG NominasServ  EN FOR ULTIMO l_codcob '||l_codcob,'');
                 sim_proc_log('MPG NominasServ  EN FOR ULTIMO l_cod_ries '||l_cod_ries,'');
              */
              IF L_ITEM = 0 THEN
                L_ITEM         := NRO_ITEM;
                L_STRINGQUERY  := NULL;
                L_STRINGINSERT := NULL;
                L_STRINGVALUE  := NULL;
              
                IF IP_POLIZA.DATOSADICIONAL(NM).TIPO_ESTRUCTURA IS NOT NULL THEN
                  IP_TABLA := IP_POLIZA.DATOSADICIONAL(NM).TIPO_ESTRUCTURA;
                ELSE
                  IP_TABLA := 'X9990100';
                END IF;
              ELSE
                IF L_ITEM != NRO_ITEM OR
                   IP_TABLA != IP_POLIZA.DATOSADICIONAL(NM).TIPO_ESTRUCTURA THEN
                  L_EXISTECAMPOEND := 0;
                  L_EXISTECAMPORIE := 0;
                  BEGIN
                    SELECT COUNT(1)
                      INTO L_EXISTECAMPOEND
                      FROM ALL_TAB_COLUMNS TS
                     WHERE TS.TABLE_NAME = IP_TABLA
                       AND TS.COLUMN_NAME = 'NUM_END';
                  END;
                
                  BEGIN
                    SELECT COUNT(1)
                      INTO L_EXISTECAMPORIE
                      FROM ALL_TAB_COLUMNS TS
                     WHERE TS.TABLE_NAME = IP_TABLA
                       AND TS.COLUMN_NAME = 'COD_RIES';
                  END;
                
                  L_STRINGQUERY := 'Insert into ' || IP_TABLA || '(' ||
                                   CHR(10);
                  L_STRINGQUERY := L_STRINGQUERY || 'NUM_SECU_POL,';
                
                  IF L_EXISTECAMPOEND > 0 THEN
                    L_STRINGQUERY := L_STRINGQUERY || 'NUM_END,';
                  END IF;
                
                  IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                    L_STRINGQUERY := L_STRINGQUERY || 'COD_RIES,';
                  END IF;
                
                  IF IP_TABLA = 'X2040400' THEN
                    -- sgpinto: Ajuste para colectiva de autos
                    IF FNC299_VALIDA_ES_CLTVA_AUTOS(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                    IP_NUM_END      => IP_NUMEND,
                                                    IP_PROCESO      => IP_PROCESO) = 'N' THEN
                      L_STRINGQUERY := L_STRINGQUERY || 'NUM_COND,';
                    END IF;
                  END IF;
                  --                  Mantis -- Error Columna duplicada
                  IF IP_TABLA = 'X9990100' THEN
                    --PGT nomina CYBER BENEFICIARIOS
                    IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
                      -- incluido por Miguel Manrique, modificado Juan Gonzalez 23.11.2021
                      L_STRINGQUERY := L_STRINGQUERY ||
                                       'NOMINA,COD_RIES,COD_COB,NRO_ITEM,';
                    ELSIF IP_PROCESO.P_COD_PRODUCTO IN (109) THEN
                      IF L_CODCOBANT NOT IN (801, 802) THEN
                        L_STRINGQUERY := L_STRINGQUERY ||
                                         'NOMINA,COD_RIES,COD_COB,NRO_ITEM,';
                      ELSE
                        L_STRINGQUERY := L_STRINGQUERY ||
                                         'COD_RIES,COD_COB,NRO_ITEM,';
                      END IF;
                    END IF;
                  
                  END IF;
                
                  L_STRINGQUERY := L_STRINGQUERY || L_STRINGINSERT || ')' ||
                                   CHR(10);
                  L_STRINGQUERY := L_STRINGQUERY || ' Values (' || CHR(10);
                  L_STRINGQUERY := L_STRINGQUERY || IP_NUMSECUPOL || ',';
                
                  /*   sim_proc_log('MPG NominasServ  EN FOR ULTIMO l_StringQuery 1 '||l_StringQuery,'');*/
                  IF L_EXISTECAMPOEND > 0 THEN
                    L_STRINGQUERY := L_STRINGQUERY || IP_NUMEND || ',';
                  END IF;
                
                  IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                    L_STRINGQUERY := L_STRINGQUERY || L_COD_RIES || ',';
                  END IF;
                
                  --PGT agosto 25 2021
                  --  sim_prog_log('PGT Nomina  antes de control column duplicate  ',ip_tabla);
                
                  --- Mantis -- Error Columna duplicada
                  IF IP_TABLA = 'X9990100' AND
                     IP_PROCESO.P_COD_PRODUCTO IN (940, 942, 946, 944, 948) THEN
                    L_STRINGQUERY := L_STRINGQUERY || L_COM || L_NOMINA ||
                                     L_COM || ',' || L_COD_RIES || ',901,' || NM || ',';
                    --intasi31 20220817 PortafolioVida
                  ELSIF IP_TABLA = 'X9990100' AND
                        SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCNOMINAVIDAAP(IP_PROCESO) = 'S' THEN
                    L_NROREGISTROAP := L_NROREGISTROAP - 1;
                    L_STRINGQUERY   := L_STRINGQUERY || L_COM || L_NOMINAAP ||
                                       L_COM || ',' || IP_POLIZA.DATOSADICIONAL(NM)
                                      .COD_RIES || ',' || L_CODCOBAP || ',' ||
                                       L_NROREGISTROAP || ',';
                    --fin intasi31 20220817 PortafolioVida
                    -- Nomina Hogar
                  ELSIF IP_TABLA = 'X9990100' AND
                        IP_PROCESO.P_COD_PRODUCTO = 109 THEN
                    --PGT nomina CYBER BENEFICIARIOS
                    IF L_CODCOBANT NOT IN (801, 802) THEN
                      L_STRINGQUERY := L_STRINGQUERY || L_COM ||
                                       L_NOMINAHOGAR || L_COM || ',' ||
                                       L_COD_RIES || ',' || L_CODCOBANT || ',' ||
                                       L_ITEM || ',';
                    ELSE
                      L_STRINGQUERY := L_STRINGQUERY || L_COD_RIES || ',' ||
                                       L_CODCOBANT || ',' || L_ITEM || ',';
                    END IF;
                    /*   sim_proc_log('MPG NominasServ  EN FOR ULTIMO ELSIF PRODCTO 109 l_StringQuery 2 '||l_StringQuery,'');
                    */
                  END IF;
                
                  IF IP_TABLA = 'X2040400' THEN
                    -- 15122016 sgpinto: Adición de manejo de Conductor Habitual Colectiva de Autos.
                    /*  l_Stringquery := l_Stringquery || Nm || ',';*/
                    -- sgpinto: Ajuste para colectiva de autos
                    IF FNC299_VALIDA_ES_CLTVA_AUTOS(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                    IP_NUM_END      => IP_NUMEND,
                                                    IP_PROCESO      => IP_PROCESO) = 'N' THEN
                      L_STRINGQUERY := L_STRINGQUERY ||
                                       NVL(L_NUMCONDHAB, NM) || ',';
                    END IF;
                  END IF;
                
                  L_STRINGQUERY := L_STRINGQUERY || L_STRINGVALUE || ')' ||
                                   CHR(10);
                
                  /*   sim_proc_log('MPG NominasServ  EN FOR ULTIMO  l_StringQuery 3 '||l_StringQuery,'');*/
                  BEGIN
                    -- dbms_output.put_line(l_Stringquery);
                    EXECUTE IMMEDIATE L_STRINGQUERY;
                    /*   sim_proc_log('MPG NominasServ  despues executeinmediate 1 '||l_StringQuery,'');  */
                    IF L_CODCOBANT != L_CODCOB THEN
                      L_CODCOBANT := L_CODCOB;
                    END IF;
                  
                  EXCEPTION
                    WHEN OTHERS THEN
                      OP_RESULTADO := -1;
                      RAISE;
                  END;
                
                  L_ITEM         := NRO_ITEM;
                  IP_TABLA       := IP_POLIZA.DATOSADICIONAL(NM)
                                    .TIPO_ESTRUCTURA;
                  L_PRICAR       := ' ';
                  L_STRINGQUERY  := NULL;
                  L_STRINGINSERT := NULL;
                  L_STRINGVALUE  := NULL;
                  L_COD_RIES     := IP_POLIZA.DATOSADICIONAL(NM).COD_RIES;
                  -- 15122016 sgpinto: Adición número de Conductor Habitual
                  L_NUMCONDHAB := NULL;
                END IF;
              END IF;
            
              IP_POLIZA.DATOSADICIONAL(NM).NUM_SECU_POL := IP_NUMSECUPOL;
              IP_POLIZA.DATOSADICIONAL(NM).NUM_END := IP_NUMEND;
              L_NOMCAMPO := IP_POLIZA.DATOSADICIONAL(NM).COD_CAMPO;
              L_VALCAMPO := IP_POLIZA.DATOSADICIONAL(NM).VALOR_CAMPO;
            
              L_TYPDATO  := NULL;
              L_LONGITUD := NULL;
            
              BEGIN
                SELECT TS.DATA_TYPE,
                       DECODE(TS.DATA_TYPE,
                              'NUMBER',
                              TS.DATA_PRECISION,
                              TS.DATA_LENGTH)
                  INTO L_TYPDATO, L_LONGITUD
                  FROM ALL_TAB_COLUMNS TS
                 WHERE TS.TABLE_NAME = IP_TABLA
                   AND TS.COLUMN_NAME = L_NOMCAMPO;
              EXCEPTION
                WHEN OTHERS THEN
                  OP_RESULTADO := -1;
                  RAISE_APPLICATION_ERROR(-20000,
                                          'Fallo al recuperar campo: ' ||
                                          L_NOMCAMPO || ' De la tabla:' ||
                                          IP_TABLA);
              END;
            
              L_LONGITUD := NVL(L_LONGITUD, 0);
            
              CASE
                WHEN L_TYPDATO = 'DATE' THEN
                  L_VALCAMPO := 'to_date(' || L_COM || L_VALCAMPO || L_COM || ',' ||
                                L_COM || 'ddmmyyyy' || L_COM || ') ';
                WHEN L_TYPDATO = 'VARCHAR2' THEN
                  L_VALCAMPO := L_COM || SUBSTR(L_VALCAMPO, 1, L_LONGITUD) ||
                                L_COM;
                WHEN L_TYPDATO = 'NUMBER' THEN
                  L_VALCAMPO := L_VALCAMPO;
                ELSE
                  NULL;
              END CASE;
            
              L_STRINGINSERT := L_STRINGINSERT || L_PRICAR || L_NOMCAMPO;
              L_STRINGVALUE  := L_STRINGVALUE || L_PRICAR || L_VALCAMPO;
            
              -- inicio 15122016 sgpinto: Adición de captura de número de Conductor Habitual (Colectiva de Autos)
              IF L_NOMCAMPO = 'NUM_COND' THEN
                L_NUMCONDHAB := L_VALCAMPO;
              END IF;
              -- fin 15122016 sgpinto.
            
              IF L_PRICAR = ' ' THEN
                L_PRICAR := ',';
              END IF;
            END LOOP;
          
            /*   sim_proc_log('MPG NominasServ  EN FOR ULTIMO  l_StringInsert  '||l_StringQuery,'');   */
          
            IF L_PRICAR = ',' THEN
              L_EXISTECAMPOEND := 0;
              L_EXISTECAMPORIE := 0;
            
              BEGIN
                SELECT COUNT(1)
                  INTO L_EXISTECAMPOEND
                  FROM ALL_TAB_COLUMNS TS
                 WHERE TS.TABLE_NAME = IP_TABLA
                   AND TS.COLUMN_NAME = 'NUM_END';
              END;
            
              BEGIN
                SELECT COUNT(1)
                  INTO L_EXISTECAMPORIE
                  FROM ALL_TAB_COLUMNS TS
                 WHERE TS.TABLE_NAME = IP_TABLA
                   AND TS.COLUMN_NAME = 'COD_RIES';
              END;
            
              L_STRINGQUERY := 'Insert into ' || IP_TABLA || '(' || CHR(10);
              L_STRINGQUERY := L_STRINGQUERY || 'NUM_SECU_POL,';
            
              IF L_EXISTECAMPOEND > 0 THEN
                L_STRINGQUERY := L_STRINGQUERY || 'NUM_END,';
              END IF;
            
              IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                L_STRINGQUERY := L_STRINGQUERY || 'COD_RIES,';
              END IF;
            
              IF IP_TABLA = 'X2040400' THEN
                -- sgpinto: Ajuste para colectiva de autos
                IF FNC299_VALIDA_ES_CLTVA_AUTOS(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                IP_NUM_END      => IP_NUMEND,
                                                IP_PROCESO      => IP_PROCESO) = 'N' THEN
                  L_STRINGQUERY := L_STRINGQUERY || 'NUM_COND,';
                END IF;
              END IF;
            
              --Mantis -- Error Columna duplicada
              --sim_proc_log('Nominas DAT ADIC l_strgquery 1 ',l_stringquery);
              IF IP_TABLA = 'X9990100' THEN
                IF IP_PROCESO.P_COD_PRODUCTO IN
                   (940, 942, 946, 944, 109, 948) THEN
                  L_STRINGQUERY := L_STRINGQUERY ||
                                   'NOMINA,COD_RIES,COD_COB,NRO_ITEM,';
                  --intasi31 20220817 PortafolioVida
                ELSIF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCNOMINAVIDAAP(IP_PROCESO) = 'S' THEN
                  L_STRINGQUERY := L_STRINGQUERY ||
                                   'NOMINA,COD_RIES,COD_COB,NRO_ITEM,';
                  --fin intasi31 20220817 PortafolioVida
                  /*   sim_proc_log('MPG NominasServ  EN FOR ULTIMO IF109  l_StringInsert  '||l_StringQuery,'');  */
                  --PGT nomina CYBER BENEFICIARIOS
                ELSIF IP_PROCESO.P_COD_PRODUCTO IN (109) THEN
                  IF L_CODCOBANT NOT IN (801, 802) THEN
                    L_STRINGQUERY := L_STRINGQUERY ||
                                     'NOMINA,COD_RIES,COD_COB,NRO_ITEM,';
                  ELSE
                    L_STRINGQUERY := L_STRINGQUERY ||
                                     'COD_RIES,COD_COB,NRO_ITEM,';
                  END IF;
                END IF;
              END IF;
            
              L_STRINGQUERY := L_STRINGQUERY || L_STRINGINSERT || ')' ||
                               CHR(10);
              L_STRINGQUERY := L_STRINGQUERY || ' Values (' || CHR(10);
              L_STRINGQUERY := L_STRINGQUERY || IP_NUMSECUPOL || ',';
            
              IF L_EXISTECAMPOEND > 0 THEN
                L_STRINGQUERY := L_STRINGQUERY || IP_NUMEND || ',';
              END IF;
            
              IF L_EXISTECAMPORIE > 0 AND IP_TABLA != 'X9990100' THEN
                L_STRINGQUERY := L_STRINGQUERY || L_COD_RIES || ',';
              END IF;
            
              IF IP_TABLA = 'X2040400' THEN
                -- 15122016 sgpinto: Adición de manejo de Conductor Habitual Colectiva de Autos.
                /*  l_Stringquery := l_Stringquery || '1' || ',';*/
                -- sgpinto: Ajuste para colectiva de autos
                IF FNC299_VALIDA_ES_CLTVA_AUTOS(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                IP_NUM_END      => IP_NUMEND,
                                                IP_PROCESO      => IP_PROCESO) = 'N' THEN
                  L_STRINGQUERY := L_STRINGQUERY ||
                                   TO_CHAR(NVL(L_NUMCONDHAB, 1)) || ',';
                END IF;
              END IF;
            
              --sim_proc_log('Nominas DAT ADIC l_strgquery 2 ',l_stringquery);
              --Mantis -- Error Columna duplicada
              IF IP_TABLA = 'X9990100' AND
                 IP_PROCESO.P_COD_PRODUCTO IN (940, 942, 946, 944, 948) THEN
                L_STRINGQUERY := L_STRINGQUERY || L_COM || L_NOMINA ||
                                 L_COM || ',' || L_COD_RIES || ',901,10,';
                --intasi31 20220817 PortafolioVida
              ELSIF IP_TABLA = 'X9990100' AND
                    SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCNOMINAVIDAAP(IP_PROCESO) = 'S' THEN
                L_STRINGQUERY := L_STRINGQUERY || L_COM || L_NOMINAAP ||
                                 L_COM || ',' || L_CODRIESAP || ',' ||
                                 L_CODCOBAP || ',' || L_NROREGISTROAP || ',';
                --fin intasi31 20220817 PortafolioVida
              ELSIF IP_TABLA = 'X9990100' AND
                    IP_PROCESO.P_COD_PRODUCTO = 109 THEN
                -- PGT nomina cyber Beneficiarios
              
                IF L_CODCOBANT NOT IN (801, 802) THEN
                  L_STRINGQUERY := L_STRINGQUERY || L_COM || L_NOMINAHOGAR ||
                                   L_COM || ',' || L_COD_RIES || ',' ||
                                   L_CODCOBANT || ',' || L_ITEM || ',';
                
                ELSE
                  L_STRINGQUERY := L_STRINGQUERY || L_COD_RIES || ',' ||
                                   L_CODCOBANT || ',' || L_ITEM || ',';
                
                END IF;
              
              END IF;
            
              --sim_proc_log('Nominas DAT ADIC l_strgquery 3 -l_stringvalue ',l_stringvalue);
            
              L_STRINGQUERY := L_STRINGQUERY || L_STRINGVALUE || ')' ||
                               CHR(10);
            
              /*   sim_proc_log('MPG NominasServ  EN FOR ULTIMO PRODTO 109  l_StringQuery  '||l_StringQuery,'');*/
              --sim_proc_log('Nominas DAT ADIC ',l_stringquery);
              BEGIN
                --dbms_output.put_line('DOS '||l_Stringquery);
                EXECUTE IMMEDIATE L_STRINGQUERY;
              EXCEPTION
                WHEN OTHERS THEN
                  OP_RESULTADO := -1;
                  --                  Dbms_Output.Put_Line(l_Stringquery);
                  RAISE;
              END;
            END IF;
          END IF;
        END IF;
      
        IF IP_PROCESO.P_COD_PRODUCTO = 109 THEN
          PCK_ATGC_HOGAR.PROC_CTRLITEMNOMINA(IP_PROCESO.P_COD_CIA,
                                             IP_NUMSECUPOL,
                                             IP_NUMEND,
                                             1,
                                             350);
        END IF;
        --AEEM ACTUALIZACION DE DATOS VARIABLES SEP 28 2023
        SIM_PROC_LOG('AEEM_LATLONG',
                     'IP_PROCESO.P_COD_PRODUCTO :' ||
                     IP_PROCESO.P_COD_PRODUCTO || 'IP_NUMSECUPOL : ' ||
                     IP_NUMSECUPOL || 'IP_NUMEND : ' || IP_NUMEND);
        IF IP_PROCESO.P_COD_PRODUCTO = 923 THEN
          SIM_PCK_HOGAR_TD_TOOLS.PROC_ACTUALIZA_DV(IP_NUMSECUPOL,
                                                   IP_NUMEND);
        END IF;
      
        --    If Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
        IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
          UPDATE X9990100
             SET AMBITO_COB = '1'
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND AMBITO_COB = 'L';
        END IF;
      
        /*------------------------------------------------------------------------*/
        -- Fin: mcolorado: mantis 36453: 28/05/2015: Se actualiza los campos de RC suplementaria para cuando no se ingresa datos
      
        /*Inicia Actualiza Vehiculos*/
        IF IP_POLIZA.DATOSVEHICULOS.EXISTS(1) THEN
          IF IP_POLIZA.DATOSVEHICULOS.COUNT > 0 THEN
            FOR I IN IP_POLIZA.DATOSVEHICULOS.FIRST .. IP_POLIZA.DATOSVEHICULOS.LAST LOOP
              IP_POLIZA.DATOSVEHICULOS(I).NUM_SECU_POL := IP_NUMSECUPOL;
              IP_POLIZA.DATOSVEHICULOS(I).NUM_END := IP_NUMEND;
              IP_POLIZA.DATOSVEHICULOS(I).COD_RIES := I;
            
              L_IDBENEF  := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('BENEFICIARIO',
                                                                     IP_NUMSECUPOL,
                                                                     I);
              L_TDOCBENE := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_BENEF',
                                                                     IP_NUMSECUPOL,
                                                                     I);
            
              --        l_idbenef := Null;
            
              IF L_IDBENEF IS NULL THEN
                L_TDOCASEG := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       I);
                L_IDASEG   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       I);
              
                BEGIN
                  UPDATE X2000020
                     SET VALOR_CAMPO = L_IDASEG, VALOR_CAMPO_EN = L_IDASEG
                   WHERE COD_CAMPO = 'BENEFICIARIO'
                     AND NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_RIES = I;
                END;
              
                BEGIN
                  UPDATE X2000020
                     SET VALOR_CAMPO    = L_TDOCASEG,
                         VALOR_CAMPO_EN = L_TDOCASEG
                   WHERE COD_CAMPO = 'TIPO_DOC_BENEF'
                     AND NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_RIES = I;
                END;
              END IF;
            
              L_EXISTE := 0;
            
              BEGIN
                SELECT COUNT(1)
                  INTO L_EXISTE
                  FROM X2040100
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_RIES = IP_POLIZA.DATOSVEHICULOS(I).COD_RIES;
              END;
            
              L_CODTIPO := 0;
            
              BEGIN
                SELECT COD_TIPO
                  INTO L_CODTIPO
                  FROM A1040400
                 WHERE COD_MARCA = IP_POLIZA.DATOSVEHICULOS(I)
                      .COD_MARCA.CODIGO;
              EXCEPTION
                WHEN OTHERS THEN
                  OP_RESULTADO := -1;
                  RAISE_APPLICATION_ERROR(-20000,
                                          'Fallo No existe tipo de vehiculo para marca: ' || IP_POLIZA.DATOSVEHICULOS(I)
                                          .COD_MARCA.CODIGO);
              END;
            
              IP_POLIZA.DATOSVEHICULOS(I).COD_TIPO := SIM_TYP_LOOKUP(L_CODTIPO,
                                                                     NULL);
            
              L_SUMAACCES    := 0;
              L_SUMAACCESTOT := 0;
            
              IF IP_POLIZA.DATOSVEHICULOS(I).SUMA_ACCES > 0 THEN
                L_MCA_ACCESORIO := 'S';
                L_SUMAACCES     := IP_POLIZA.DATOSVEHICULOS(I).SUMA_ACCES;
                L_SUMAACCESTOT  := L_SUMAACCESTOT + L_SUMAACCES;
              END IF;
            
              IF L_OPCIONRCSUP > 0 THEN
                BEGIN
                  SELECT COUNT(1)
                    INTO L_EXISTERC
                    FROM C9999909
                   WHERE COD_TAB = 'OPCIONRCSUPXPROCESO'
                        --              And    codigo2 =  ip_proceso.p_proceso
                     AND COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                     AND DAT_NUM = IP_PROCESO.P_SUBPRODUCTO
                     AND CODIGO = L_CODTIPO;
                END;
              
                IF L_EXISTERC > 0 THEN
                  L_EXISTERC := 0;
                
                  BEGIN
                    SELECT COUNT(1)
                      INTO L_EXISTERC
                      FROM C9999909
                     WHERE COD_TAB = 'OPCIONRCSUPXPROCESO'
                          --                  And    codigo2 =  ip_proceso.p_proceso
                       AND COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
                       AND DAT_NUM = IP_PROCESO.P_SUBPRODUCTO
                       AND CODIGO = L_CODTIPO
                       AND CODIGO1 = L_OPCIONRCSUP;
                  END;
                  /*               If l_existerc > 0 Then
                    Null;
                  Else
                   If ip_poliza.DatosVehiculos(i).cod_mod
                      Between (to_number(to_char(sysdate,'YYYY'))-15)  And (to_number(to_char(sysdate,'YYYY'))-10)
                      And l_CodTipo In (1,2,6,8,20,21) Then
                        op_resultado := -1;
                         raise_application_error(-20000,'Opcion de Rc No valida para este tipo de vehiculo');
                   Else
                      If l_CodTipo In (4,12) Then
                      op_resultado := -1;
                      raise_application_error(-20000,'Opcion de Rc No valida para este tipo de vehiculo');
                      End If;
                   End If;
                  End If;*/
                END IF;
              END IF;
            
              /*                   Se elimina segun solicitud de mantis 42265
              IF ip_poliza.DatosVehiculos (i).cod_mod BETWEEN (  TO_NUMBER (
                                                                    TO_CHAR (
                                                                       SYSDATE,
                                                                       'YYYY'))
                                                               - 15)
                                                          AND (  TO_NUMBER (
                                                                    TO_CHAR (
                                                                       SYSDATE,
                                                                       'YYYY'))
                                                               - 10)
              THEN
                 IF l_CodTipo IN (1, 2, 6, 8, 20, 21)
                 THEN
                    IF ip_poliza.DatosVehiculos (i).cod_ramo_veh != 17
                    THEN
                       op_resultado := -1;
                       raise_application_error (
                          -20000,
                          'Alternativa de Cobertura solo se permite 17');
                    END IF;
                 END IF;
              END IF;*/
              -- 17112016 sgpinto: Integración. Adición de validación Colectiva de Autos
              -- Veh Electrico  15/01/2020
              SELECT COUNT(*)
                INTO L_OFERTAAUTOS
                FROM X_LISTA_OFERTA_TRAD
               WHERE NUM_SECU_POL = IP_POLIZA.DATOSVEHICULOS(I)
                    .COD_MARCA.CODIGO
                 AND COD_SUBPRODUCTO = IP_PROCESO.P_SUBPRODUCTO;
              -- Fin Electrico
              IF FNC299_VALIDA_ES_CLTVA_AUTOS(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                              IP_NUM_END      => IP_NUMEND,
                                              IP_PROCESO      => IP_PROCESO) = 'N' AND
                 L_OFERTAAUTOS = 0 THEN
                IF IP_POLIZA.DATOSVEHICULOS(I)
                 .COD_TIPO.CODIGO IN (4, 12) AND
                    IP_PROCESO.P_SUBPRODUCTO <> 293 THEN
                  IF IP_POLIZA.DATOSVEHICULOS(I).COD_RAMO_VEH != 25 THEN
                    OP_RESULTADO := -1;
                    -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
                    /*Raise_Application_Error(-20000,
                    'Alternativa de Cobertura solo se permite 25'); */
                    RAISE_APPLICATION_ERROR(-20000,
                                            'Riesgo ' || I ||
                                            '. Alternativa de Cobertura solo se permite 25');
                  END IF;
                ELSE
                  IF IP_POLIZA.DATOSVEHICULOS(I)
                   .COD_RAMO_VEH = 25 AND IP_PROCESO.P_SUBPRODUCTO = 251 THEN
                    OP_RESULTADO := -1;
                    -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
                    /*Raise_Application_Error(-20000,
                    'Alternativa de Cobertura solo para pesados'); */
                    RAISE_APPLICATION_ERROR(-20000,
                                            'Riesgo ' || I ||
                                            '. Alternativa de Cobertura solo para pesados');
                  END IF;
                END IF;
                -- 17112016 sgpinto: Integración. Adición de validación Colectiva de Autos
              END IF;
              --
              /* ****** INICIO-TRANSMASIVO ****** */
              --17032016 lberbesi: Se incluye uso 34 (Mantis 43705)
              /*If Ip_Poliza.Datosvehiculos(i)
              .Cod_Uso.Codigo Not In (31, 32, 15, 34) -- Uso 15 (RAMO 9)
              And l_OfertaAutos = 0*/
              /* ****** FIN-TRANSMASIVO ****** */
              /*Then
              -- 05/08/2016: SGPM. Se adiciona control para canal 3 y sistema de orígen 101,
              --                   de acuerdo con lo conversado con Manuel Orjuela el pasado
              --                   martes 02 de agosto. Este ajuste es temporal, mientras se realiza
              --                   la parametrización correspondiente.
              If Ip_Proceso.p_Canal = 3 And
                 Ip_Proceso.p_Sistema_Origen = 101 Then
                If Ip_Poliza.Datosvehiculos(i)
                 .Cod_Mod Between
                    (To_Number(To_Char(Sysdate, 'YYYY')) - 15) And
                    (To_Number(To_Char(Sysdate, 'YYYY')) - 10) Then
                  If l_Opcion371 != 43 Then
                    Op_Resultado := -1;*/
              -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
              /*Raise_Application_Error(-20000,
              'Opcion de Deducible PTD no valida ' ||
              l_Opcion371 || '*');*/
              /*Raise_Application_Error(-20000,
                                        'Riesgo ' || i ||
                                        '. Opcion de Deducible PTD no valida ' ||
                                        l_Opcion371 || '*');
              End If;
              
              If l_Opcion372 != 24 Then
                Op_Resultado := -1;*/
              -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
              /*Raise_Application_Error(-20000,
              'Opcion de Deducible PPD no valida');*/
              /*Raise_Application_Error(-20000,
                                        'Riesgo ' || i ||
                                        '. Opcion de Deducible PPD no valida');
              End If;
              
              If l_Opcion374 != 43 Then
                Op_Resultado := -1;*/
              -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
              /*Raise_Application_Error(-20000,
              'Opcion de Deducible PTH no valida');*/
              /*Raise_Application_Error(-20000,
                                          'Riesgo ' || i ||
                                          '. Opcion de Deducible PTH no valida');
                End If;
              Else
                --mcolorado : Mantis 25949 : 03/07/2015 -- Se incluye funcion para validar deducibles : validaDeducibleAutos
                If l_Opcion371 != 24 And
                   Sim_Pck_Funcion_Gen.Validadeducibleautos('VALIDAPTDAUTOS',
                                                            Ip_Proceso.p_Subproducto) = 'S' Then
                  Op_Resultado := -1;*/
              -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
              /*Raise_Application_Error(-20000,
              'Opcion de Deducible PTD no valida*' ||
              l_Opcion371 || '*');*/
              /*Raise_Application_Error(-20000,
                                        'Riesgo ' || i ||
                                        '. Opcion de Deducible PTD no valida*' ||
                                        l_Opcion371 || '*');
              End If;
              
              --mcolorado : Mantis 25949 : 03/07/2015 -- Se incluye funcion para validar deducibles : validaDeducibleAutos
              If l_Opcion372 != 24 And
                 Sim_Pck_Funcion_Gen.Validadeducibleautos('VALIDAPPDAUTOS',
                                                          Ip_Proceso.p_Subproducto) = 'S' Then
                Op_Resultado := -1;*/
              -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
              /*Raise_Application_Error(-20000,
              'Opcion de Deducible PPD no valida');*/
              /*Raise_Application_Error(-20000,
                                        'Riesgo ' || i ||
                                        '. Opcion de Deducible PPD no valida');
              End If;
              
              --mcolorado : Mantis 25949 : 03/07/2015 -- Se incluye funcion para validar deducibles : validaDeducibleAutos
              If l_Opcion374 != 24 And
                 Sim_Pck_Funcion_Gen.Validadeducibleautos('VALIDAPTHAUTOS',
                                                          Ip_Proceso.p_Subproducto) = 'S' Then
                Op_Resultado := -1;*/
              -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
              /*Raise_Application_Error(-20000,
              'Opcion de Deducible PTH no valida');*/
              /*Raise_Application_Error(-20000,
                                              'Riesgo ' || i ||
                                              '. Opcion de Deducible PTH no valida');
                    End If;
                  End If;
                End If;
              End If;*/
            
              IF IP_PROCESO.P_PROCESO IN (226, 270) THEN
                BEGIN
                  SIM_PCK_ACCESO_DATOS_EMISION.PROC_VAL_PLACAVEHICULO(IP_POLIZA.DATOSVEHICULOS(I)
                                                                      .PAT_VEH,
                                                                      IP_POLIZA.DATOSVEHICULOS(I)
                                                                      .COD_TIPO.CODIGO,
                                                                      IP_PROCESO,
                                                                      OP_RESULTADO,
                                                                      OP_ARRERRORES);
                END;
              
                IF OP_RESULTADO = -1 THEN
                  -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
                  /*Raise_Application_Error(-20000, 'Placa invalida');*/
                  RAISE_APPLICATION_ERROR(-20000,
                                          'Riesgo ' || I ||
                                          '. Placa invalida');
                END IF;
              END IF;
            
              IF NVL(L_CEROOK, 'N') = 'S' THEN
                IF IP_POLIZA.DATOSVEHICULOS(I)
                 .COD_MOD <
                    TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
                   -- Ini 1.2   11/06/2015 cjrodriguez
                    - SIM_PCK_FUNCION_GEN.OBTENERVALORDATNUM('AUTOS_NUEVOS',
                                                             'CERO_KM')
                -- Fin 1.2   11/06/2015 cjrodriguez
                
                 THEN
                  OP_RESULTADO := -1;
                  -- 17112016 sgpinto: Integración mensajes de error con código de riesgo
                  /*Raise_Application_Error(-20000,
                  'Modelo no permitido para Cero Kilometros');*/
                  RAISE_APPLICATION_ERROR(-20000,
                                          'Riesgo ' || I ||
                                          '. Modelo no permitido para Cero Kilometros');
                END IF;
              END IF;
            
              L_SUMAASEG0K := 0;
            
              BEGIN
                SELECT A.VALOR_NUEVO
                  INTO L_SUMAASEG0K
                  FROM A1040600 A
                 WHERE A.COD_MARCA = IP_POLIZA.DATOSVEHICULOS(I)
                      .COD_MARCA.CODIGO
                   AND A.COD_MOD = IP_POLIZA.DATOSVEHICULOS(I).COD_MOD
                   AND A.FECHA_BAJA IS NULL;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            
              IF L_EXISTE = 0 THEN
                L_SUMAASEG := IP_POLIZA.DATOSVEHICULOS(I).SUMA_ASEG;
              
                L_TDOCASEG := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       I);
                L_IDASEG   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       I);
              
                BEGIN
                  INSERT INTO X2040100 Z
                    (NUM_SECU_POL,
                     NUM_END,
                     COD_RIES,
                     COD_MARCA,
                     COD_MOD,
                     COD_TIPO,
                     COD_USO,
                     COD_RAMO_VEH,
                     PAT_VEH,
                     MOTOR_VEH,
                     CHASIS_VEH,
                     COD_CLASE,
                     NRO_PER,
                     COLOR,
                     SUMA_ASEG,
                     SUMA_ACCES,
                     SUMA_ASEG_V,
                     SUMA_ACCES_V,
                     SUMA_ASEG_0KM,
                     ACREED_PREND,
                     MCA_ACCESORIO,
                     TDOC_TERCERO,
                     COD_ASEG)
                  VALUES
                    (IP_NUMSECUPOL,
                     NVL(IP_POLIZA.DATOSVEHICULOS(I).NUM_END, 0),
                     NVL(IP_POLIZA.DATOSVEHICULOS(I).COD_RIES, 1),
                     IP_POLIZA.DATOSVEHICULOS(I).COD_MARCA.CODIGO,
                     IP_POLIZA.DATOSVEHICULOS(I).COD_MOD,
                     IP_POLIZA.DATOSVEHICULOS(I).COD_TIPO.CODIGO,
                     IP_POLIZA.DATOSVEHICULOS(I).COD_USO.CODIGO,
                     IP_POLIZA.DATOSVEHICULOS(I).COD_RAMO_VEH,
                     IP_POLIZA.DATOSVEHICULOS(I).PAT_VEH,
                     IP_POLIZA.DATOSVEHICULOS(I).MOTOR_VEH,
                     IP_POLIZA.DATOSVEHICULOS(I).CHASIS_VEH,
                     IP_POLIZA.DATOSVEHICULOS(I).COD_CLASE.CODIGO,
                     IP_POLIZA.DATOSVEHICULOS(I).NRO_PER,
                     IP_POLIZA.DATOSVEHICULOS(I).COLOR,
                     L_SUMAASEG,
                     IP_POLIZA.DATOSVEHICULOS(I).SUMA_ACCES,
                     L_SUMAASEG,
                     IP_POLIZA.DATOSVEHICULOS(I).SUMA_ACCES,
                     L_SUMAASEG0K,
                     L_IDBENEF,
                     L_MCA_ACCESORIO,
                     L_TDOCASEG,
                     L_IDASEG);
                EXCEPTION
                  WHEN OTHERS THEN
                    OP_RESULTADO := -1;
                    --sim_proc_log('Seguimiento Error insertando X2040100',Sqlerrm ||'-'||Sqlcode);
                    RAISE;
                END;
              ELSE
                L_SUMAASEG := IP_POLIZA.DATOSVEHICULOS(I).SUMA_ASEG;
              
                L_TDOCASEG := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       I);
                L_IDASEG   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       I);
              
                BEGIN
                  UPDATE X2040100
                  -- se cambia TRM-01-Mar-2019
                  --  Set Num_Secu_Pol  = Ip_Poliza.Datosvehiculos(i)
                  --                      .Num_Secu_Pol,
                     SET NUM_SECU_POL = NVL(IP_POLIZA.DATOSVEHICULOS(I)
                                            .NUM_SECU_POL,
                                            IP_NUMSECUPOL),
                         
                         NUM_END       = IP_POLIZA.DATOSVEHICULOS(I).NUM_END,
                         COD_RIES      = IP_POLIZA.DATOSVEHICULOS(I).COD_RIES,
                         COD_MARCA     = IP_POLIZA.DATOSVEHICULOS(I)
                                         .COD_MARCA.CODIGO,
                         COD_MOD       = IP_POLIZA.DATOSVEHICULOS(I).COD_MOD,
                         COD_TIPO      = IP_POLIZA.DATOSVEHICULOS(I)
                                         .COD_TIPO.CODIGO,
                         COD_USO       = IP_POLIZA.DATOSVEHICULOS(I)
                                         .COD_USO.CODIGO,
                         COD_RAMO_VEH  = IP_POLIZA.DATOSVEHICULOS(I)
                                         .COD_RAMO_VEH,
                         PAT_VEH       = IP_POLIZA.DATOSVEHICULOS(I).PAT_VEH,
                         MOTOR_VEH     = IP_POLIZA.DATOSVEHICULOS(I)
                                         .MOTOR_VEH,
                         CHASIS_VEH    = IP_POLIZA.DATOSVEHICULOS(I)
                                         .CHASIS_VEH,
                         COD_CLASE     = IP_POLIZA.DATOSVEHICULOS(I)
                                         .COD_CLASE.CODIGO,
                         NRO_PER       = IP_POLIZA.DATOSVEHICULOS(I).NRO_PER,
                         COLOR         = IP_POLIZA.DATOSVEHICULOS(I).COLOR,
                         SUMA_ASEG     = L_SUMAASEG,
                         SUMA_ACCES    = IP_POLIZA.DATOSVEHICULOS(I)
                                         .SUMA_ACCES,
                         SUMA_ASEG_V   = L_SUMAASEG,
                         SUMA_ACCES_V  = IP_POLIZA.DATOSVEHICULOS(I)
                                         .SUMA_ACCES,
                         SUMA_ASEG_0KM = L_SUMAASEG0K,
                         ACREED_PREND  = L_IDBENEF,
                         MCA_ACCESORIO = L_MCA_ACCESORIO,
                         TDOC_TERCERO  = L_TDOCASEG,
                         COD_ASEG      = L_IDASEG
                   WHERE NUM_SECU_POL =
                         NVL(IP_POLIZA.DATOSVEHICULOS(I).NUM_SECU_POL,
                             IP_NUMSECUPOL)
                        --Where Num_Secu_Pol = Ip_Poliza.Datosvehiculos(i) se cambia TRM
                        --                  .Num_Secu_Pol  -01-Mar-2019
                        
                     AND COD_RIES = IP_POLIZA.DATOSVEHICULOS(I).COD_RIES;
                EXCEPTION
                  WHEN OTHERS THEN
                    OP_RESULTADO := -1;
                    RAISE_APPLICATION_ERROR(-20000,
                                            'Fallo al Actualizar X2040100: ' ||
                                            SQLERRM);
                END;
              END IF;
              IF SIM_PCK_FUNCION_GEN.AUT_INDIVIDUAL(IP_PROCESO.P_SUBPRODUCTO) = 'S' AND
                 IP_PROCESO.P_SUBPRODUCTO <> 378 --AEEM adicion para mxd - no validar antiguedad > 10 anios
               THEN
              
                L_VALORCAMPO := 'N'; --l_Valorcampo variable que guarda M del procediento si el riesgo es Multivariado
                BEGIN
                  SIM_PCK_FUNCION_GEN.ESMULTIVARIADO(IP_NUMSECUPOL,
                                                     NVL(IP_POLIZA.DATOSVEHICULOS(I)
                                                         
                                                         .COD_RIES,
                                                         1),
                                                     IP_PROCESO.P_COD_CIA,
                                                     IP_PROCESO.P_COD_SECC,
                                                     IP_PROCESO.P_COD_PRODUCTO,
                                                     L_VALORCAMPO);
                EXCEPTION
                  WHEN OTHERS THEN
                    L_VALORCAMPO := 'N';
                END;
              
                IF L_VALORCAMPO = 'N' THEN
                  DECLARE
                    L_ANOSVEH           NUMBER;
                    L_TDOC              VARCHAR2(3);
                    L_NRODOCUMTO        NUMBER;
                    L_TIENEVINCULACION  VARCHAR2(1) := 'N';
                    L_ANOSATRASATGC     NUMBER;
                    L_ANOSATRAS         NUMBER;
                    L_APLICAVINCULACION VARCHAR2(1) := 'S';
                  BEGIN
                    L_ANOSVEH := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - IP_POLIZA.DATOSVEHICULOS(I)
                                .COD_MOD;
                  
                    BEGIN
                      SELECT A.DAT_NUM
                        INTO L_ANOSATRASATGC
                        FROM C9999909 A
                       WHERE A.COD_TAB = 'AUTMODHASTAATGC'
                         AND A.CODIGO1 = IP_PROCESO.P_SUBPRODUCTO;
                    EXCEPTION
                      WHEN OTHERS THEN
                        NULL;
                    END;
                    BEGIN
                      SELECT A.DAT_NUM
                        INTO L_ANOSATRAS
                        FROM C9999909 A
                       WHERE A.COD_TAB = 'AUTMODHASTA';
                    EXCEPTION
                      WHEN OTHERS THEN
                        NULL;
                    END;
                    --- HLC 10072024 se valida si el producto debe o no validar vinculaciones del cliente
                    BEGIN
                      SIM_PCK_FUNCION_GEN.PROC_CLIENTECONVINCULACIONPF(IP_PROCESO.P_COD_CIA,
                                                                       IP_PROCESO.P_COD_SECC,
                                                                       IP_PROCESO.P_COD_PRODUCTO,
                                                                       IP_PROCESO.P_SUBPRODUCTO,
                                                                       L_APLICAVINCULACION);
                    EXCEPTION
                      WHEN OTHERS THEN
                        L_APLICAVINCULACION := 'S';
                    END;
                    --BANCAN3-702
                    IF L_APLICAVINCULACION = 'S' THEN
                      --- HLC 10072024 se valida si el producto debe o no validar vinculaciones del cliente
                      IF L_ANOSVEH BETWEEN NVL(L_ANOSATRAS, 1900) AND
                         NVL(L_ANOSATRASATGC, 1900) THEN
                        BEGIN
                          SELECT TDOC_TERCERO, NRO_DOCUMTO
                            INTO L_TDOC, L_NRODOCUMTO
                            FROM X2000030 DF
                           WHERE DF.NUM_SECU_POL = IP_POLIZA.DATOSVEHICULOS(I)
                                .NUM_SECU_POL;
                        EXCEPTION
                          WHEN OTHERS THEN
                            NULL;
                        END;
                      
                        BEGIN
                          SIM_PCK_FUNCION_GEN.PROC_CLIENTECONVINCULACIONPF(L_TDOC,
                                                                           L_NRODOCUMTO,
                                                                           TO_CHAR(SYSDATE,
                                                                                   'ddmmyyyy'),
                                                                           L_TIENEVINCULACION);
                        END;
                      
                        IF L_TIENEVINCULACION = 'N' THEN
                          OP_RESULTADO := -1;
                          RAISE_APPLICATION_ERROR(-20000,
                                                  'Cliente sin vinculaciones con autos');
                          RETURN;
                        END IF;
                      END IF;
                    END IF; --- HLC 10072024 se valida si el producto debe o no validar vinculaciones del cliente
                  END;
                  --02/04/2019 lberbesi: Se incluye verificación de vinculación para autos por opción
                ELSE
                  NULL;
                  -----------------------------------------------------------------------------------
                  --Mcga 03/11/2020 Se deshabilita este control por solicitud del usuario de movilidad
                  --Se traslada la validación de vinculaciones al momento de generar cotizacion
                  ------------------------------------------------------------------------------------
                  /*          Declare
                   l_Anosveh          Number;
                   l_Tdoc             Varchar2(3);
                   l_Nrodocumto       Number;
                   l_AplicaOpcBas     Varchar2(1) := 'N';
                   l_Anosatrasatgc    Number;
                   l_Anosatras        Number;
                  Begin
                   l_Anosveh := To_Number(To_Char(Sysdate, 'YYYY')) - Ip_Poliza.Datosvehiculos(i)
                               .Cod_Mod;
                   Begin
                    Select a.Dat_Num
                      Into l_Anosatrasatgc
                      From sim_autos_param_det a
                     Where a.Cod_Tab = 'AUTMODHASTAATGC_O'
                       And a.Codigo1 = Ip_Proceso.p_Subproducto;
                   Exception
                    When Others Then
                     Null;
                   End;
                   Begin
                    Select a.Dat_Num
                      Into l_Anosatras
                      From sim_autos_param_det a
                     Where a.Cod_Tab = 'AUTMODHASTA_O';
                   Exception
                    When Others Then
                     Null;
                   End;
                   If l_Anosveh Between Nvl(l_Anosatras, 1900) And
                      Nvl(l_Anosatrasatgc, 1900) Then
                    Begin
                     Select Tdoc_Tercero, Nro_Documto
                       Into l_Tdoc, l_Nrodocumto
                       From X2000030 Df
                      Where Df.Num_Secu_Pol = Ip_Poliza.Datosvehiculos(i)
                           .Num_Secu_Pol;
                    Exception
                     When Others Then
                      Null;
                    End;
                    prc999_autos_cltvas_grabalog('ANTES DE Proc_AplicaOpcBas','l_Nrodocumto: ' || l_Nrodocumto);
                    Begin
                     Sim_Pck_Funcion_Gen.Proc_AplicaOpcBas(l_Tdoc,
                                                           l_Nrodocumto,
                                                           To_Char(Sysdate,
                                                                  'ddmmyyyy'),
                                                           l_AplicaOpcBas);
                    End;
                    prc999_autos_cltvas_grabalog('DESPUES DE Proc_AplicaOpcBas','l_AplicaOpcBas: ' || l_AplicaOpcBas);
                    If l_AplicaOpcBas = 'N' Then
                     Op_Resultado := -1;
                     Raise_Application_Error(-20000,
                                             'Cliente no aplica opción básica. Verifique vinculación y primas');
                     Return;
                        END IF;
                      End If;
                  END;*/
                END IF;
              END IF;
            END LOOP;
          END IF;
        END IF;
      
        DELETE X2040200 WHERE NUM_SECU_POL = IP_NUMSECUPOL;
      
        IF IP_POLIZA.ACCESORIOS.EXISTS(1) THEN
          IF IP_POLIZA.ACCESORIOS.COUNT > 0 THEN
            FOR I IN IP_POLIZA.ACCESORIOS.FIRST .. IP_POLIZA.ACCESORIOS.LAST LOOP
              L_MCATAR := NVL(IP_POLIZA.ACCESORIOS(I).MCA_TAR, 'N');
            
              /*IF sim_pck_funcion_gen.Agente_EsAtgc (l_agenteori) = 'N'
              THEN
                 IF ip_proceso.p_proceso = 270
                 THEN
                    --en formalizacion esta marca corresponde a si es original
                    --si es original no tarifa
                    --si no es original tarifa
                    IF ip_poliza.Accesorios (i).mca_tar = 'S'
                    THEN
                       l_mcatar := 'N';
                    ELSE
                       l_mcatar := 'S';
                    END IF;
                 END IF;
              END IF;*/
            
              --se ajusta según Davivienda autos Siebel-360 TRM-6-Nov-2018
              --Ernesto Castillo - ernesto.castillosegurosbolivar.com - 09/03/2022
              --Consultar sistema origen Davivienda (121,124), como parametro en la tabla C9999909
              -- if Ip_Proceso.p_Sistema_Origen = 121 then
              IF FN_VALIDA_SIS_ORIGEN(IP_PROCESO.P_SISTEMA_ORIGEN) = 1 THEN
                L_MCATAR := 'S';
                IF NVL(IP_POLIZA.ACCESORIOS(I).VALOR_ACCES, 0) > 0 THEN
                  BEGIN
                    INSERT INTO X2040200 Z
                      (NUM_SECU_POL,
                       NUM_END,
                       NRO_PER,
                       COD_RIES,
                       COD_ACCES,
                       VALOR_ACCES,
                       MCA_TAR,
                       MCA_BAJA,
                       DESC_ACCES)
                    VALUES
                      (IP_NUMSECUPOL,
                       NVL(IP_POLIZA.ACCESORIOS(I).NUM_END, 0),
                       1,
                       NVL(IP_POLIZA.ACCESORIOS(I).COD_RIES, 1),
                       IP_POLIZA.ACCESORIOS(I).COD_ACCES.CODIGO,
                       NVL(IP_POLIZA.ACCESORIOS(I).VALOR_ACCES, 0),
                       L_MCATAR,
                       IP_POLIZA.ACCESORIOS(I).MCA_BAJA,
                       IP_POLIZA.ACCESORIOS(I).DESC_ACCES);
                  END;
                END IF;
              ELSE
                BEGIN
                  INSERT INTO X2040200 Z
                    (NUM_SECU_POL,
                     NUM_END,
                     NRO_PER,
                     COD_RIES,
                     COD_ACCES,
                     VALOR_ACCES,
                     MCA_TAR,
                     MCA_BAJA,
                     DESC_ACCES)
                  VALUES
                    (IP_NUMSECUPOL,
                     NVL(IP_POLIZA.ACCESORIOS(I).NUM_END, 0),
                     1,
                     NVL(IP_POLIZA.ACCESORIOS(I).COD_RIES, 1),
                     IP_POLIZA.ACCESORIOS(I).COD_ACCES.CODIGO,
                     NVL(IP_POLIZA.ACCESORIOS(I).VALOR_ACCES, 0),
                     L_MCATAR,
                     IP_POLIZA.ACCESORIOS(I).MCA_BAJA,
                     IP_POLIZA.ACCESORIOS(I).DESC_ACCES);
                END;
              END IF;
            END LOOP;
          END IF;
        END IF;
      
        BEGIN
          BEGIN
            SELECT COUNT(1)
              INTO L_EXISTE
              FROM X2040200
             WHERE NUM_SECU_POL = IP_NUMSECUPOL;
          END;
        
          IF L_EXISTE = 0 AND IP_PROCESO.P_PROCESO IN (241, 201) AND
             L_SUMAACCESTOT > 0 THEN
            BEGIN
              INSERT INTO X2040200 Z
                (NUM_SECU_POL,
                 NUM_END,
                 NRO_PER,
                 COD_RIES,
                 COD_ACCES,
                 VALOR_ACCES,
                 MCA_TAR,
                 MCA_BAJA,
                 DESC_ACCES)
              VALUES
                (IP_NUMSECUPOL, 0, 1, 1, 999, L_SUMAACCESTOT, 'S', '', '');
            END;
          END IF;
        END;
      
        /*Fin Actualiza Vehiculos*/
      
        BEGIN
          -- Call the procedure
          SIM_PCK_PROCESO_DATOS_EMISION2.PROC_UPDATEDELTYPECOB(IP_POLIZA,
                                                               L_VALIDACION,
                                                               IP_PROCESO,
                                                               OP_RESULTADO,
                                                               OP_ARRERRORES);
        END;
      
        --intasi31 07042015
        --ATGC SALUD proceso para copiar declaracion de
        -- asegurabilidad todos los riesgos
        IF SIM_PCK_ATGC_SALUD.FUN_ESRAMOATGCSALUD(IP_PROCESO.P_COD_CIA,
                                                  IP_PROCESO.P_COD_SECC,
                                                  IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
          IF IP_PROCESO.P_PROCESO NOT IN (241, 201) THEN
            --sim_pck_atgc_salud.Prc_ValidaDeclaracionAseg(Ip_NumSecuPol);
            --intasi31 06052016
            SIM_PCK_ATGC_SALUD.PRC_COPIADECLARACIONASEG(IP_NUMSECUPOL);
          END IF;
          --se inician los datos variables de descuentos y recargos, porque estos
          --se cargan con las reglas de calculo de la cobertura. 08042016
          --if ip_proceso.p_proceso = 201 then
          UPDATE X2000020
             SET VALOR_CAMPO_EN = NULL
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND COD_CAMPO IN
                 ('DSCTO_COMER', 'EXTRA_PRIMA', 'VR_EXTRA_PRIMA');
          COMMIT;
          --end if;
          --inserta asegurados en tabla terceros sim_x_tercero
          DECLARE
            L_ARRAYTERCERO SIM_TYP_ARRAY_TERCEROGEN;
          BEGIN
            L_ARRAYTERCERO := NEW SIM_TYP_ARRAY_TERCEROGEN();
            SIM_PCK_PROCESO_DATOS_EMISION2.PROC_CREAARRAYASEGSALUD(IP_NUMSECUPOL,
                                                                   L_ARRAYTERCERO,
                                                                   IP_PROCESO,
                                                                   OP_RESULTADO,
                                                                   OP_ARRERRORES);
          
            IF L_ARRAYTERCERO.COUNT != 0 THEN
              SIM_PCK_PROCESO_DML_EMISION2.PROC_CREAR_SIM_X_TERCERO(IP_NUMSECUPOL,
                                                                    IP_NUMEND,
                                                                    L_ARRAYTERCERO,
                                                                    IP_PROCESO,
                                                                    OP_RESULTADO,
                                                                    OP_ARRERRORES);
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      
        --  If Ip_Proceso.p_Cod_Cia = 2 And  Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
        IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
          DECLARE
            L_OPCION   NUMBER;
            L_FECNAC   VARCHAR2(8);
            L_TDOCASEG VARCHAR2(3);
            L_IDASEG   NUMBER;
            TNOM       PKG_API.T_NOMBRES;
            TMBASNAT   PKG_API.T_MODIF_DAT_BAS_NATURALES;
          BEGIN
            FOR R IN (SELECT DISTINCT (NVL(COD_RIES, 0)) COD_RIES
                        FROM X2000020 X
                       WHERE X.NUM_SECU_POL = IP_NUMSECUPOL
                         AND X.COD_RIES IS NOT NULL) LOOP
              L_OPCION := 0;
            
              BEGIN
                -- Call the procedure
                SIM_PCK_CONSULTA_EMISION2.PROC_CALCULAOPCVIDA(IP_NUMSECUPOL,
                                                              R.COD_RIES,
                                                              L_OPCION,
                                                              IP_PROCESO,
                                                              OP_RESULTADO,
                                                              OP_ARRERRORES);
              END;
            
              IF L_OPCION != 1 THEN
                BEGIN
                  UPDATE X2000020
                     SET VALOR_CAMPO = L_OPCION, VALOR_CAMPO_EN = L_OPCION
                   WHERE NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_RIES = R.COD_RIES
                     AND COD_CAMPO = 'OPCION_ASEG';
                END;
              END IF;
            
              DECLARE
                V_CONTINUE VARCHAR2(1) := 'N';
              BEGIN
                L_TDOCASEG := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       R.COD_RIES);
                L_IDASEG   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       R.COD_RIES);
                IF IP_PROCESO.P_CANAL = 6 THEN
                  BEGIN
                    L_FECNAC := TO_CHAR(PCK999_TERCEROS.FUN_RETORNA_FECHANAC(L_TDOCASEG,
                                                                             L_IDASEG,
                                                                             NULL),
                                        'DDMMYYYY');
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_FECNAC := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('FEC_NACIMIENTO',
                                                                           IP_NUMSECUPOL,
                                                                           R.COD_RIES);
                  END;
                ELSE
                  L_FECNAC := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('FEC_NACIMIENTO',
                                                                       IP_NUMSECUPOL,
                                                                       R.COD_RIES);
                END IF;
                /*morj y wsac, ajuste provisional para que el sistema respete la
                fecha de nacimiento de la cotizacion, se debe arreglar en la
                interfaz grafica*/
              
                IF L_FECNAC IS NULL AND L_NUMSECUPOLORG > 0 THEN
                  BEGIN
                    SELECT VALOR_CAMPO
                      INTO L_FECNAC
                      FROM A2000020 C
                     WHERE C.NUM_SECU_POL = L_NUMSECUPOLORG
                       AND C.COD_CAMPO = 'FEC_NACIMIENTO'
                       AND C.COD_RIES = R.COD_RIES
                       AND C.NUM_END = IP_POLIZA.DATOSFIJOS.NUM_END;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                  UPDATE X2000020
                     SET VALOR_CAMPO = L_FECNAC, VALOR_CAMPO_EN = L_FECNAC
                   WHERE COD_CAMPO = 'FEC_NACIMIENTO'
                     AND NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_RIES = R.COD_RIES;
                
                ELSIF IP_PROCESO.P_CANAL = 6 THEN
                  UPDATE X2000020
                     SET VALOR_CAMPO = L_FECNAC, VALOR_CAMPO_EN = L_FECNAC
                   WHERE COD_CAMPO = 'FEC_NACIMIENTO'
                     AND NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_RIES = R.COD_RIES;
                END IF;
              
                /*fin morj wsac*/
              
                BEGIN
                  UPDATE SIM_X_TERCEROS A
                     SET A.FECHA_NACIMIENTO = TO_DATE(L_FECNAC, 'DDMMYYYY')
                   WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                     AND A.TIPO_DOCUMENTO = L_TDOCASEG
                     AND A.NUMERO_DOCUMENTO = L_IDASEG;
                END;
              END;
            
              IF IP_PROCESO.P_PROCESO = 270 AND L_TDOCASEG = 'CC' THEN
              
                TNOM                    := NULL;
                TNOM.P_NUMERO_DOCUMENTO := L_IDASEG;
                TNOM.P_TIPO_DOCUMENTO   := L_TDOCASEG;
                PKG_API.PRC_RETORNA_NOMBRES(TNOM);
              
                IF TNOM.P_FECHA_NACIMIENTO IS NULL THEN
                  IF TNOM.P_SQLERR = 0 THEN
                    TMBASNAT                     := NULL;
                    TMBASNAT.P_USUARIO_MODIF     := 'TRON2000D';
                    TMBASNAT.P_SECUENCIA_TERCERO := TNOM.P_SECUENCIA_TERCERO;
                    TMBASNAT.P_FECHA_NACIMIENTO  := TO_DATE(L_FECNAC,
                                                            'DDMMYYYY');
                    PKG_API.PRC_MODIF_DAT_BAS_NATURALES(TMBASNAT);
                  END IF;
                END IF;
              END IF;
            
              BEGIN
                SELECT COUNT(1)
                  INTO L_CANTIDAD
                  FROM X9990100 X
                 WHERE X.AMBITO_COB = 2
                   AND X.NUM_SECU_POL = IP_NUMSECUPOL
                   AND X.COD_RIES = R.COD_RIES;
              END;
            
              IF L_CANTIDAD > 0 THEN
                BEGIN
                  UPDATE X2000020
                     SET VALOR_CAMPO = 'S', VALOR_CAMPO_EN = 'S'
                   WHERE NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_RIES = R.COD_RIES
                     AND COD_CAMPO = 'ES_ONEROSO';
                END;
              END IF;
            END LOOP;
          END;
        
          DECLARE
            L_FIDUCIANIT NUMBER;
          BEGIN
            BEGIN
              SELECT NVL(VALOR_CAMPO, VALOR_CAMPO_EN)
                INTO L_FIDUCIANIT
                FROM X2000020
               WHERE NUM_SECU_POL = IP_NUMSECUPOL
                 AND COD_CAMPO = 'FIDUCIA_NIT';
            EXCEPTION
              WHEN OTHERS THEN
                L_FIDUCIANIT := 0;
            END;
          
            IF L_FIDUCIANIT > 0 THEN
              BEGIN
                UPDATE X2000020
                   SET VALOR_CAMPO = 'S', VALOR_CAMPO_EN = 'S'
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'FIDUCIA';
              END;
            END IF;
          END;
        
          IF IP_PROCESO.P_PROCESO != 241 THEN
            -- En cotizaciones siempre debe pedir declaracion
            DECLARE
              L_TIENEDEC VARCHAR2(1) := 'N';
              L_TDOCASEG VARCHAR2(3);
              L_IDASEG   NUMBER;
            BEGIN
              --Manejo de declaracion de asegurabilidad
              --El sistema valida si existe una declaración de asegurabilidad vigente para el asegurado
              BEGIN
                L_TDOCASEG := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       1);
                L_IDASEG   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_ASEG',
                                                                       IP_NUMSECUPOL,
                                                                       1);
              
                -- INICIO ODVVI-2939 Rwinter 27012023 :
                -- Se modifica para que los productos de portafolio vida NO llamen a la declaración anterior
                IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' AND
                   (IP_PROCESO.P_PROCESO || '-' || IP_PROCESO.P_SUBPROCESO <>
                    '242-240') THEN
                  -- 20230217 OFEVALN3-3 sandro.preciado
                  L_TIENEDEC := 'N';
                ELSE
                  L_TIENEDEC := SIM_PCK_FUNCION_GEN.ASEGURADO_TIENE_DEC(L_TDOCASEG,
                                                                        L_IDASEG,
                                                                        IP_NUMSECUPOL);
                END IF;
                -- FIN ODVVI-2939 Rwinter 27012023
              
                BEGIN
                  UPDATE X2000020
                     SET VALOR_CAMPO    = L_TIENEDEC,
                         VALOR_CAMPO_EN = L_TIENEDEC
                   WHERE NUM_SECU_POL = IP_NUMSECUPOL
                     AND COD_CAMPO = 'TIENE_DEC';
                END;
              END;
            END;
          END IF;
        
          DECLARE
            L_ARRAYTERCERO SIM_TYP_ARRAY_TERCEROGEN;
          BEGIN
            L_ARRAYTERCERO := NEW SIM_TYP_ARRAY_TERCEROGEN();
            SIM_PCK_PROCESO_DATOS_EMISION2.PROC_CREAARRAYASEG(IP_NUMSECUPOL,
                                                              L_ARRAYTERCERO,
                                                              IP_PROCESO,
                                                              OP_RESULTADO,
                                                              OP_ARRERRORES);
          
            IF L_ARRAYTERCERO.COUNT != 0 THEN
              SIM_PCK_PROCESO_DML_EMISION2.PROC_CREAR_SIM_X_TERCERO(IP_NUMSECUPOL,
                                                                    IP_NUMEND,
                                                                    L_ARRAYTERCERO,
                                                                    IP_PROCESO,
                                                                    OP_RESULTADO,
                                                                    OP_ARRERRORES);
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END IF;
      
        BEGIN
          DELETE X2000020
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        
          DELETE X2000040
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        
          DELETE X9990100
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        
          DELETE X2040100
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        
          DELETE X2040200
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        
          DELETE X2040300
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        
          DELETE X2040400
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        
          DELETE SIM_X_DATOSSOAT
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND COD_RAMO_VEH = 0; --elimina en soat, el primer registro que se ingresa por inserta transitorias
        
          DELETE SIM_DECL_ASEG_POL
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NVL(COD_RIES, -1) > L_MAXRIES;
        END;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_UPDATEDELTYPE;
  /*---------------------------------------------------*/
  /*---------------------------------------------------*/

  PROCEDURE PROC_UPDATEDINAMYC(IP_NUMSECUPOL IN NUMBER,
                               IP_NUMEND     IN NUMBER,
                               IP_PROCESO    IN SIM_TYP_PROCESO,
                               OP_RESULTADO  OUT NUMBER,
                               OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_STRINGQUERY  SIM_PCK_TIPOS_GENERALES.T_VAR_EXTRALARGO;
    L_STRINGUPDATE SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
  
    L_TYPDATO  SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_COM      SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO := '''';
    L_VALCAMPO SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_PRICAR   SIM_PCK_TIPOS_GENERALES.T_CARACTER := ' ';
    L_TABLAORG SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_PRIVEZ   SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'S';
  
    CURSOR C_UPD IS
      SELECT TD.COD_CAMPO CAMPO, TD.DAT_OBS VALORUPD, TD.DAT_CAR TABLA
        FROM C9999909 TD
       WHERE TD.COD_TAB = 'SIM_DEF_WEB'
         AND TD.COD_CIA = IP_PROCESO.P_COD_CIA
         AND TD.COD_SECC = IP_PROCESO.P_COD_SECC
         AND TD.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND NVL(TD.CODIGO2, 101) = IP_PROCESO.P_SISTEMA_ORIGEN --Modif Juan González 21122018 (servicio externo)
         AND TD.DAT_CAR != 'X2000020'
       ORDER BY TD.DAT_CAR, TD.CODIGO;
  
    CURSOR C_UPD20 IS
      SELECT TD2.COD_CAMPO CAMPO, TD2.DAT_OBS VALORUPD, TD2.DAT_CAR TABLA
        FROM C9999909 TD2
       WHERE TD2.COD_TAB = 'SIM_DEF_WEB'
         AND TD2.COD_CIA = IP_PROCESO.P_COD_CIA
         AND TD2.COD_SECC = IP_PROCESO.P_COD_SECC
         AND TD2.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND NVL(TD2.CODIGO2, 101) = IP_PROCESO.P_SISTEMA_ORIGEN --Modif Juan González 21122018 (servicio externo)
         AND TD2.DAT_CAR = 'X2000020'
       ORDER BY TD2.DAT_CAR, TD2.CODIGO;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_UpdateDinamic';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    L_STRINGUPDATE := NULL;
    L_PRICAR       := ' ';
  
    FOR REG_UPD2 IN C_UPD20 LOOP
      --sim_proc_log('Seguimiento expideService Proc_Updatedinamyc','upd2');
      BEGIN
        UPDATE X2000020 B
           SET B.VALOR_CAMPO_EN = NVL(B.VALOR_CAMPO_EN, REG_UPD2.VALORUPD),
               B.VALOR_CAMPO    = NVL(B.VALOR_CAMPO, REG_UPD2.VALORUPD)
         WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
           AND B.COD_CAMPO = REG_UPD2.CAMPO;
      
        IF SQL%NOTFOUND THEN
          INSERT INTO X2000020
            (NUM_SECU_POL,
             COD_CAMPO,
             VALOR_CAMPO,
             VALOR_CAMPO_EN,
             NUM_SECU,
             COD_NIVEL)
          VALUES
            (IP_NUMSECUPOL,
             REG_UPD2.CAMPO,
             REG_UPD2.VALORUPD,
             REG_UPD2.VALORUPD,
             -1,
             -1);
        END IF;
      END;
    END LOOP;
  
    L_STRINGUPDATE := NULL;
    L_TABLAORG     := NULL;
    L_PRICAR       := ' ';
    L_PRIVEZ       := 'S';
  
    FOR REG_UPD IN C_UPD LOOP
      --sim_proc_log('Seguimiento expideService Proc_Updatedinamyc','updN2');
      IF L_PRIVEZ = 'S' THEN
        L_PRIVEZ   := 'N';
        L_TABLAORG := REG_UPD.TABLA;
      END IF;
    
      IF L_TABLAORG != REG_UPD.TABLA THEN
        L_STRINGQUERY := ' Update   ' || L_TABLAORG || CHR(10);
        L_STRINGQUERY := L_STRINGQUERY || ' Set   ';
        L_STRINGQUERY := L_STRINGQUERY || L_STRINGUPDATE;
        L_STRINGQUERY := L_STRINGQUERY || ' Where Num_secu_pol = ' ||
                         IP_NUMSECUPOL;
      
        BEGIN
          EXECUTE IMMEDIATE L_STRINGQUERY;
        EXCEPTION
          WHEN OTHERS THEN
            OP_RESULTADO := -1;
            RAISE_APPLICATION_ERROR(-20000,
                                    'Err SqlDinamyc :' || SQLERRM ||
                                    '*Tabla:' || L_TABLAORG);
        END;
      
        L_PRICAR       := ' ';
        L_TABLAORG     := REG_UPD.TABLA;
        L_STRINGQUERY  := NULL;
        L_STRINGUPDATE := NULL;
      END IF;
    
      L_TYPDATO := NULL;
    
      BEGIN
        SELECT TS.DATA_TYPE
          INTO L_TYPDATO
          FROM ALL_TAB_COLUMNS TS
         WHERE TS.TABLE_NAME = REG_UPD.TABLA
           AND TS.COLUMN_NAME = REG_UPD.CAMPO;
      END;
    
      CASE
        WHEN L_TYPDATO = 'DATE' THEN
          L_VALCAMPO := 'to_date(' || L_COM || REG_UPD.VALORUPD || L_COM || ',' ||
                        L_COM || 'ddmmyyyy' || L_COM || ') ';
        WHEN L_TYPDATO = 'VARCHAR2' THEN
          L_VALCAMPO := L_COM || REG_UPD.VALORUPD || L_COM;
        WHEN L_TYPDATO = 'NUMBER' THEN
          L_VALCAMPO := REG_UPD.VALORUPD;
        ELSE
          NULL;
      END CASE;
    
      L_STRINGUPDATE := L_STRINGUPDATE || L_PRICAR || REG_UPD.CAMPO ||
                        ' = nvl(' || REG_UPD.CAMPO || ',' || L_VALCAMPO || ')' ||
                        CHR(10);
    
      IF L_PRICAR = ' ' THEN
        L_PRICAR := ',';
      END IF;
    END LOOP;
  
    IF L_TABLAORG IS NOT NULL AND L_STRINGUPDATE IS NOT NULL THEN
      L_STRINGQUERY := ' Update   ' || L_TABLAORG || CHR(10);
      L_STRINGQUERY := L_STRINGQUERY || ' Set   ';
      L_STRINGQUERY := L_STRINGQUERY || L_STRINGUPDATE;
      L_STRINGQUERY := L_STRINGQUERY || ' Where Num_secu_pol = ' ||
                       IP_NUMSECUPOL;
    
      BEGIN
        EXECUTE IMMEDIATE L_STRINGQUERY;
      EXCEPTION
        WHEN OTHERS THEN
          OP_RESULTADO := -1;
          --sim_proc_log('Seguimiento expideService Proc_Updatedinamyc',l_stringquery);
          RAISE_APPLICATION_ERROR(-20000,
                                  'Err SqlDinamyc 2:' || SQLERRM ||
                                  '*Tabla:' || L_TABLAORG);
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_UPDATEDINAMYC;

  /*---------------------------------------------------*/

  /*---------------------------------------------------*/

  PROCEDURE PROC_UPDATETYPEDEX(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                               OP_POLIZA     OUT SIM_TYP_POLIZAGEN,
                               IP_NUMSECUPOL IN NUMBER,
                               IP_NUMEND     IN NUMBER,
                               IP_PROCESO    IN SIM_TYP_PROCESO,
                               OP_RESULTADO  OUT NUMBER,
                               OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    CURSOR DV IS
      SELECT A.COD_RIES,
             A.COD_CAMPO,
             A.VALOR_CAMPO,
             A.VALOR_CAMPO_EN,
             A.COD_NIVEL
        FROM X2000020 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND (A.VALOR_CAMPO IS NOT NULL OR A.VALOR_CAMPO_EN IS NOT NULL)
       ORDER BY A.COD_NIVEL;
  
    CURSOR COB IS
      SELECT A.COD_RIES,
             A.COD_COB,
             A.TXT_COB,
             A.END_SUMA_ASEG,
             A.END_PRIMA_COB,
             A.END_TASA_COB,
             A.END_TASA_TOTAL,
             A.PORC_PPAGO,
             A.IND_AJUSTE,
             A.PORC_REBAJA,
             A.TASA_AGR,
             A.MCA_GRATUITA,
             A.NUM_SECU
        FROM X2000040 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
       ORDER BY A.NUM_SECU ASC; --Modificado Juan González (20022019)
    --And   a.end_prima_cob != 0;
  
    CURSOR COBAUT IS
      SELECT A.COD_RIES,
             DECODE(A.COD_COB, 216, 3, 1) COD_COB,
             DECODE(A.COD_COB, 216, 'Valor Asistencia', 'Valor Prima') TXT_COB,
             SUM(A.END_PRIMA_COB) VALOR
        FROM X2000040 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.END_PRIMA_COB != 0
         AND A.COD_COB NOT IN (363, 364, 367) --Cristina Autos liviano 03 ago 2020
       GROUP BY A.COD_RIES,
                DECODE(A.COD_COB, 216, 3, 1),
                DECODE(A.COD_COB, 216, 'Valor Asistencia', 'Valor Prima')
      UNION
      SELECT A.COD_RIES,
             DECODE(A.COD_COB, 216, 4, 2) COD_COB,
             DECODE(A.COD_COB,
                    216,
                    'Valor Iva Asistencia',
                    'Valor Iva Prima') TXT_COB,
             SUM(A.END_PRIMA_COB) * SUM(B.TASA_IMPUEST_E) / COUNT(1) / 100 VALOR
        FROM X2000040 A, X2000190 B
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.END_PRIMA_COB != 0
       GROUP BY A.COD_RIES,
                DECODE(A.COD_COB, 216, 4, 2),
                DECODE(A.COD_COB,
                       216,
                       'Valor Iva Asistencia',
                       'Valor Iva Prima')
      UNION
      SELECT A.COD_RIES,
             DECODE(A.COD_COB, 450, 5, 6) COD_COB,
             DECODE(A.COD_COB,
                    450,
                    'Valor Pequeños Accesorios',
                    'Valor Iva Prima PA') TXT_COB,
             SUM(A.END_PRIMA_COB) VALOR
        FROM X2000040 A, X2000190 B
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.COD_COB = 450
         AND A.END_PRIMA_COB != 0
         AND NOT EXISTS (SELECT ''
                FROM X2000020 -- Oferta Autos
               WHERE NUM_SECU_POL = A.NUM_SECU_POL
                 AND COD_RIES = A.COD_RIES
                 AND COD_CAMPO = 'API_OFERTA_TRD'
                 AND VALOR_CAMPO_EN IS NOT NULL)
       GROUP BY A.COD_RIES,
                DECODE(A.COD_COB, 450, 5, 6),
                DECODE(A.COD_COB,
                       450,
                       'Valor Pequeños Accesorios',
                       'Valor Iva Prima PA')
      UNION
      SELECT A.COD_RIES,
             DECODE(A.COD_COB, 450, 6, 5) COD_COB,
             DECODE(A.COD_COB,
                    450,
                    'Valor Iva Prima PA',
                    'Valor Pequeños Accesorios') TXT_COB,
             SUM(A.END_PRIMA_COB) * SUM(B.TASA_IMPUEST_E) / COUNT(1) / 100 VALOR
        FROM X2000040 A, X2000190 B
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.COD_COB = 450
         AND A.END_PRIMA_COB != 0
         AND NOT EXISTS (SELECT ''
                FROM X2000020 -- Oferta Autos
               WHERE NUM_SECU_POL = A.NUM_SECU_POL
                 AND COD_RIES = A.COD_RIES
                 AND COD_CAMPO = 'API_OFERTA_TRD'
                 AND VALOR_CAMPO_EN IS NOT NULL)
       GROUP BY A.COD_RIES,
                DECODE(A.COD_COB, 450, 6, 5),
                DECODE(A.COD_COB,
                       450,
                       'Valor Iva Prima PA',
                       'Valor Pequeños Accesorios')
      UNION
      SELECT A.COD_RIES,
             DECODE(A.COD_COB, 370, 7, 8) COD_COB,
             DECODE(A.COD_COB, 370, 'Valor Riesgos Patrimoniales', '') TXT_COB,
             SUM(A.END_SUMA_ASEG / 1000000) VALOR
        FROM X2000040 A, X2000190 B
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.COD_COB = 370
         AND A.END_PRIMA_COB != 0
         AND NOT EXISTS (SELECT ''
                FROM X2000020 -- Oferta Autos
               WHERE NUM_SECU_POL = A.NUM_SECU_POL
                 AND COD_RIES = A.COD_RIES
                 AND COD_CAMPO = 'API_OFERTA_TRD'
                 AND VALOR_CAMPO_EN IS NOT NULL)
       GROUP BY A.COD_RIES,
                DECODE(A.COD_COB, 370, 7, 8),
                DECODE(A.COD_COB, 370, 'Valor Riesgos Patrimoniales', '')
      UNION --Cristina 03 de Agosto 2020
      SELECT A.COD_RIES,
             DECODE(A.COD_COB, 363, 9, 10) COD_COB,
             DECODE(A.COD_COB, 363, 'Accidentes Personales', '') TXT_COB,
             SUM(A.END_PRIMA_COB) VALOR
        FROM X2000040 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.END_PRIMA_COB != 0
         AND A.COD_COB IN (363) --Cristina Autos liviano 03 ago 2020
       GROUP BY A.COD_RIES,
                DECODE(A.COD_COB, 363, 9, 10),
                DECODE(A.COD_COB, 363, 'Accidentes Personales', '')
      UNION --Cristina 10 de Agosto 2020
      SELECT A.COD_RIES,
             DECODE(A.COD_COB, 364, 11, 12) COD_COB,
             DECODE(A.COD_COB, 364, 'Movilidad Total', '') TXT_COB,
             SUM(A.END_PRIMA_COB) VALOR
        FROM X2000040 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.END_PRIMA_COB != 0
         AND A.COD_COB IN (364) --Cristina Premium Mov. Total 10 ago 2020
       GROUP BY A.COD_RIES,
                DECODE(A.COD_COB, 364, 11, 12),
                DECODE(A.COD_COB, 364, 'Movilidad Total', '');
  
    CURSOR PRIMAXRIE IS
      SELECT C.COD_RIES, SUM(C.END_PRIMA_COB) PRIMARIES
        FROM X2000040 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
      --      And c.End_Prima_Cob != 0
       GROUP BY C.COD_RIES;
  
    CURSOR PRIMA IS
      SELECT B.IMP_PRIMA_END,
             B.IMP_DER_EMI_EN,
             B.IMP_IMPUESTO_E,
             B.PORC_BONIF_EN,
             B.IMP_BONIF_EN,
             B.PREMIO_END,
             B.SUMA_ASEG,
             B.PRIMA_ANU
        FROM X2000160 B
       WHERE B.NUM_SECU_POL = IP_NUMSECUPOL;
  
    CURSOR RIES IS
      SELECT DISTINCT C.COD_RIES
        FROM X2000020 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND NVL(C.COD_RIES, 0) > 0;
  
    L_ENCONTRO       SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_ARRCOB         SIM_TYP_ARRAY_COBPOLIZASGEN;
    L_COBERTURA      SIM_TYP_COBERTURAPOLIZAGEN;
    L_DATOSVARIABLES SIM_TYP_DATOS_VARIABLESGEN;
    L_PRIMA          SIM_TYP_PRIMA;
    L_DATOSRIESGOS   SIM_TYP_RIESGOGEN;
    L_DATOSRIESGO    SIM_TYP_DATOSRIESGO;
    L_POLIZA         SIM_TYP_POLIZAGEN;
    L_CODCOB         NUMBER;
    L_TITULO         VARCHAR2(60);
    L_DESC           VARCHAR2(60);
    L_NOMBRECOB      VARCHAR2(120);
    L_PREMIOA        NUMBER;
    L_PREMIOX        NUMBER;
    L_EXISTE         VARCHAR2(1) := 'S';
    L_CANTIDAD       NUMBER;
    L_APLICAPREF     VARCHAR2(1) := 'N';
    L_ENTRACOB       VARCHAR2(1) := 'S';
    -- 17112016 sgpinto: Integración. Adición de variable para almacenar código de riesgo.
    L_CODRIES    NUMBER;
    L_CONTAH     NUMBER := 0;
    L_NSPAH      C2999300.NUM_SECU_POL_ANEXO%TYPE;
    L_NUMCONSEC  C2990020.CONSECUTIVO%TYPE;
    L_VALIDACION VARCHAR2(1) := 'S';
    L_VALORCAMPO X2000020.VALOR_CAMPO_EN%TYPE;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_UpdateTypedeX';
    L_COBERTURA   := NEW SIM_TYP_COBERTURAPOLIZAGEN;
    L_DATOSRIESGO := NEW SIM_TYP_DATOSRIESGO;
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_POLIZA      := NEW SIM_TYP_POLIZAGEN;
  
    L_POLIZA := IP_POLIZA;
    --Valida emision de Anexo Hogar para que no se haga liquidación-->22/08/2017(Juan Gonzalez)
    IF IP_PROCESO.P_COD_PRODUCTO = 121 AND
       IP_PROCESO.P_PROCESO IN (241, 261, 270) THEN
      OP_POLIZA := IP_POLIZA;
      RETURN;
    END IF;
  
    BEGIN
      SELECT COD_PROD, NUM_POL_COTIZ
        INTO L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO,
             L_POLIZA.DATOSFIJOS.NUM_POL_COTIZ
        FROM A2000030
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND NUM_END = IP_NUMEND;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT COD_PROD
            INTO L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO
            FROM X2000030
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NUM_END = IP_NUMEND;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      BEGIN
        SELECT A.PREMIO_END
          INTO L_PREMIOA
          FROM A2000160 A
         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
           AND A.NUM_END = IP_NUMEND
           AND A.TIPO_REG = 'T';
      EXCEPTION
        WHEN OTHERS THEN
          L_EXISTE := 'N';
      END;
    
      IF L_EXISTE = 'S' THEN
        BEGIN
          SELECT B.PREMIO_END
            INTO L_PREMIOX
            FROM X2000160 B
           WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
             AND B.TIPO_REG = 'T';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        IF L_PREMIOA != L_PREMIOX THEN
          BEGIN
            L_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'N';
          END;
        ELSE
          BEGIN
            L_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'S';
          END;
        END IF;
      END IF;
    END;
  
    BEGIN
      SELECT C.COD_PROD, C.COD_MON
        INTO L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO,
             L_POLIZA.DATOSFIJOS.COD_MON.CODIGO
        FROM X2000030 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.NUM_END = IP_NUMEND;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --------------------Inicio Datos Variables
    FOR RDV IN DV LOOP
      -- 17112016 sgpinto: Adición de niveles 3 y 5 al recorrido.
      /* If Rdv.Cod_Nivel = 2 Then*/
    
      L_VALORCAMPO := RDV.VALOR_CAMPO_EN;
    
      --Ernesto Castillo - ernesto.castillosegurosbolivar.com - 09/03/2022
      --Consultar sistema origen Davivienda (121,124), como parametro en la tabla C9999909
      -- If Nvl(Ip_Proceso.p_Sistema_Origen, 0) = 121 Then
    
      IF RDV.COD_CAMPO = 'CPOS_RIES' THEN
        IF FN_VALIDA_SIS_ORIGEN(NVL(IP_PROCESO.P_SISTEMA_ORIGEN, 0)) = 1 THEN
          L_VALORCAMPO := SIM_PCK_PYMES_MAPEODAT.CODIGOCODAZZIDAVIVIENDA(L_VALORCAMPO);
        END IF;
      END IF;
      IF RDV.COD_CAMPO = 'COD_PROV' THEN
        IF FN_VALIDA_SIS_ORIGEN(NVL(IP_PROCESO.P_SISTEMA_ORIGEN, 0)) = 1 THEN
          L_VALORCAMPO := SIM_PCK_PYMES_MAPEODAT.CODIGOCODAZZIDAVIVIENDA(L_VALORCAMPO);
        END IF;
      END IF;
    
      --      If Rdv.Cod_Nivel In (2, 3, 5) Then
      L_DATOSVARIABLES := NEW
                          SIM_TYP_DATOS_VARIABLESGEN(NUM_SECU_POL => IP_NUMSECUPOL,
                                                     COD_RIES     => RDV.COD_RIES,
                                                     NUM_END      => IP_NUMEND,
                                                     COD_CAMPO    => RDV.COD_CAMPO,
                                                     COD_NIVEL    => RDV.COD_NIVEL,
                                                     COD_COB      => L_CODCOB,
                                                     TITULO       => L_TITULO,
                                                     VALOR_CAMPO  => L_VALORCAMPO, --Rdv.Valor_Campo_En,
                                                     DESCRIPCION  => L_DESC);
    
      L_ENCONTRO := 'N';
    
      IF L_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
        -- 17112016 sgpinto: Integración. Adición de llamado a función que recupera código de riesgo
        -- 19/08/2016 sgpm: Cambio de valor de índice por valor retornado de función
        --Modificado Juan González (25092018): corregir error de Copia Cotizacion 948
        IF LENGTH(TRIM(RDV.COD_RIES)) = 0 THEN
          L_CODRIES := FNC299_RECUPERA_INDRIESGO(IP_INDICE       => RDV.COD_RIES,
                                                 IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                 IP_NUM_END      => IP_NUMEND);
        ELSE
          L_CODRIES := 1;
        END IF;
        --
        -- 17112016 sgpinto: se cambia índice de Rdv.Cod_Ries a l_CodRies
        /*If l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables.Exists(1) Then
          If l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables.Count > 0 Then
            For j In l_Poliza.Datosriesgos(Rdv.Cod_Ries)
                     .Datosvariables.First .. l_Poliza.Datosriesgos(Rdv.Cod_Ries)
                                              .Datosvariables.Last Loop
              If l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables(j)
               .Cod_Ries = Rdv.Cod_Ries And l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables(j)
                 .Cod_Campo = Rdv.Cod_Campo Then
                l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables(j) := l_Datosvariables;
                l_Encontro := 'S';
              End If;
            End Loop;
          End If;
        End If;*/
        IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES.EXISTS(1) THEN
          IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES.COUNT > 0 THEN
            FOR J IN L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES.FIRST .. L_POLIZA.DATOSRIESGOS(L_CODRIES)
                                                                              .DATOSVARIABLES.LAST LOOP
              IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES(J)
               .COD_RIES = RDV.COD_RIES AND L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES(J)
                 .COD_CAMPO = RDV.COD_CAMPO THEN
                L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES(J) := L_DATOSVARIABLES;
                L_ENCONTRO := 'S';
              END IF;
            END LOOP;
          END IF;
        END IF;
      END IF;
    
      IF L_ENCONTRO = 'N' THEN
        -- Revisar
        -- 17112016 sgpinto: se cambia índice de Rdv.Cod_Ries a l_CodRies
        /*
          -- Revisar
          If l_Poliza.Datosriesgos.Exists(1) Then
            If l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables.Exists(1) Then
              Null;
            Else
              l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables := New
                                                                    Sim_Typ_Array_Dv_Gen();
            End If;
          Else
            l_Poliza.Datosriesgos := New Sim_Typ_Array_Riesgosgen();
            l_Poliza.Datosriesgos.Extend;
            l_Poliza.Datosriesgos(Rdv.Cod_Ries) := New Sim_Typ_Riesgogen();
            l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables := New
                                                                  Sim_Typ_Array_Dv_Gen();
          End If;
        
          l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables.Extend;
          l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables(l_Poliza.Datosriesgos(Rdv.Cod_Ries).Datosvariables.Count) := l_Datosvariables;
        End If;*/
        IF L_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
          IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES.EXISTS(1) THEN
            NULL;
          ELSE
            L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES := NEW
                                                               SIM_TYP_ARRAY_DV_GEN();
          END IF;
        ELSE
          L_POLIZA.DATOSRIESGOS := NEW SIM_TYP_ARRAY_RIESGOSGEN();
          L_POLIZA.DATOSRIESGOS.EXTEND;
          L_POLIZA.DATOSRIESGOS(L_CODRIES) := NEW SIM_TYP_RIESGOGEN();
          L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES := NEW
                                                             SIM_TYP_ARRAY_DV_GEN();
        END IF;
      
        L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES.EXTEND;
        L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES(L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSVARIABLES.COUNT) := L_DATOSVARIABLES;
      END IF;
      --      End If;
    END LOOP;
  
    --------------------Fin Datos Variables
    IF IP_PROCESO.P_COD_PRODUCTO = 942 THEN
      BEGIN
        SELECT VALOR_CAMPO
          INTO L_APLICAPREF
          FROM X2000020
         WHERE NUM_SECU_POL = IP_NUMSECUPOL
           AND NVL(COD_RIES, 1) = 1
           AND COD_CAMPO = 'APLICA_944';
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            SELECT VALOR_CAMPO
              INTO L_APLICAPREF
              FROM A2000020
             WHERE NUM_SECU_POL = IP_NUMSECUPOL
               AND NVL(COD_RIES, 1) = 1
               AND NUM_END = IP_NUMEND
               AND COD_CAMPO = 'APLICA_944';
          EXCEPTION
            WHEN OTHERS THEN
              L_APLICAPREF := 'N';
          END;
      END;
      IF L_APLICAPREF = 'S' THEN
        L_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'N';
      END IF;
    
    END IF;
  
    --================ACTUALIZAZION TYPE
    --Actualiza Coberturas
  
    CASE
      WHEN SIM_PCK_FUNCION_GEN.ES_AUTOS(IP_PROCESO.P_COD_SECC,
                                        IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
        FOR RCOB IN COBAUT LOOP
          L_COBERTURA := NEW
                         SIM_TYP_COBERTURAPOLIZAGEN(NUM_SECU_POL         => IP_NUMSECUPOL,
                                                    NUM_END              => IP_NUMEND,
                                                    COD_RIES             => RCOB.COD_RIES,
                                                    COD_COB              => SIM_TYP_LOOKUP(RCOB.COD_COB,
                                                                                           RCOB.TXT_COB),
                                                    SUMA_ASEG            => '',
                                                    TASA_COB             => '',
                                                    TASA_TOTAL           => '',
                                                    PORC_PPAGO           => '',
                                                    IND_AJUSTE           => '',
                                                    PRIMA_COB            => RCOB.VALOR,
                                                    PORC_REBAJA          => '',
                                                    TASA_AGR             => '',
                                                    MCA_GRATUITA         => 'N',
                                                    NUM_SECU             => RCOB.COD_COB,
                                                    TIPO_REG             => '',
                                                    COD_CIACOA           => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    VAL_ASEGURABLE       => '',
                                                    PRIMA_ANU            => '',
                                                    COD_AGRUP_CONT       => '',
                                                    MCA_BAJA_COB         => '',
                                                    FECHA_INCLUSION      => '',
                                                    FECHA_EXCLUSION      => '',
                                                    COD_PROV             => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    MCA_VIGENTE          => '',
                                                    COD_COB_INF          => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    DESCUENT_PRIMA       => '',
                                                    MCA_PRIMA_INF        => '',
                                                    MCA_TASA_INF         => '',
                                                    MCA_TIPO_COB         => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    NOMINA               => '',
                                                    TIPO_FRANQ           => '',
                                                    PORC_FRANQ           => '',
                                                    IMP_FRANQ            => '',
                                                    MIN_FRANQ            => '',
                                                    MAX_FRANQ            => '',
                                                    MCA_AHORRO           => '',
                                                    MCA_VALOR_ABLE       => '',
                                                    MCA_VAL_SINI         => '',
                                                    FECHA_VIG_FRANQ      => '',
                                                    MCA_REASEGURO        => '',
                                                    COD_SECC_REAS        => '',
                                                    NUM_BLOQUE_REAS      => '',
                                                    REGLA_CAP_REAS       => '',
                                                    CAPITAL_REAS         => '',
                                                    PRIMA_REAS           => '',
                                                    CAPITAL_CALCULO_REAS => '',
                                                    MCA_CAPITAL          => '',
                                                    CAPITAL_UNIDAD       => '',
                                                    COD_GRUPO            => '',
                                                    FECHA_ORI_VIDA       => '',
                                                    PRIMA_REAS_ORI       => '',
                                                    END_PRIMA_REAS_ORI   => '',
                                                    SIM_FECHA_INCLUSION  => '',
                                                    SIM_FECHA_EXCLUSION  => '',
                                                    SIM_MCA_SUMA_INF     => '',
                                                    SIM_FECHA_VIG_END    => '',
                                                    SIM_FECHA_VENC_END   => '',
                                                    SIM_COEFCOB          => '');
        
          L_ENCONTRO := 'N';
        
          IF L_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
            -- 17112016 sgpinto: Integración. Adición de llamado a función que recupera código de riesgo
            -- 19/08/2016 sgpm: Cambio de valor de índice por valor retornado de función
            L_CODRIES := FNC299_RECUPERA_INDRIESGO(IP_INDICE       => RCOB.COD_RIES,
                                                   IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                   IP_NUM_END      => IP_NUMEND);
            --
            -- 17112016 sgpinto: se cambia índice de Rdv.Cod_Ries a l_CodRies
            /*
              If l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas.Exists(1) Then
                If l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                 .Datoscoberturas.Count > 0 Then
                  For j In l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                           .Datoscoberturas.First .. l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                                                     .Datoscoberturas.Last Loop
                    If l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(j)
                     .Cod_Ries = Rcob.Cod_Ries And l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(j)
                       .Cod_Cob.Codigo = Rcob.Cod_Cob Then
                      l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(j) := l_Cobertura;
                      l_Encontro := 'S';
                    End If;
                  End Loop;
                End If;
              End If;
            End If;*/
          
            IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.EXISTS(1) THEN
              IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.COUNT > 0 THEN
                FOR J IN L_POLIZA.DATOSRIESGOS(L_CODRIES)
                         .DATOSCOBERTURAS.FIRST .. L_POLIZA.DATOSRIESGOS(L_CODRIES)
                                                   .DATOSCOBERTURAS.LAST LOOP
                  IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(J)
                   .COD_RIES = RCOB.COD_RIES AND L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(J)
                     .COD_COB.CODIGO = RCOB.COD_COB THEN
                    L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(J) := L_COBERTURA;
                    L_ENCONTRO := 'S';
                  END IF;
                END LOOP;
              END IF;
            END IF;
          END IF;
        
          IF L_ENCONTRO = 'N' THEN
            -- 17112016 sgpinto: se cambia índice de Rdv.Cod_Ries a l_CodRies
            /*
              -- Revisar
              If l_Poliza.Datosriesgos.Exists(1) Then
                If l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                 .Datoscoberturas.Exists(1) Then
                  Null;
                Else
                  l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas := New
                                                                          Sim_Typ_Array_Cobpolizasgen();
                End If;
              Else
                l_Poliza.Datosriesgos := New Sim_Typ_Array_Riesgosgen();
                l_Poliza.Datosriesgos.Extend;
                l_Poliza.Datosriesgos(Rcob.Cod_Ries) := New Sim_Typ_Riesgogen();
                l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas := New
                                                                        Sim_Typ_Array_Cobpolizasgen();
              End If;
            
              l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas.Extend;
              l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas.Count) := l_Cobertura;
            End If;
            */
            IF L_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
              IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.EXISTS(1) THEN
                NULL;
              ELSE
                L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS := NEW
                                                                    SIM_TYP_ARRAY_COBPOLIZASGEN();
              END IF;
            ELSE
              L_POLIZA.DATOSRIESGOS := NEW SIM_TYP_ARRAY_RIESGOSGEN();
              L_POLIZA.DATOSRIESGOS.EXTEND;
              L_POLIZA.DATOSRIESGOS(L_CODRIES) := NEW SIM_TYP_RIESGOGEN();
              L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS := NEW
                                                                  SIM_TYP_ARRAY_COBPOLIZASGEN();
            END IF;
          
            L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.EXTEND;
            L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.COUNT) := L_COBERTURA;
          END IF;
        END LOOP;
      WHEN IP_PROCESO.P_COD_PRODUCTO = 777 THEN
        L_ARRCOB := NEW SIM_TYP_ARRAY_COBPOLIZASGEN();
        FOR RRIES IN RIES LOOP
          BEGIN
            SIM_PCK_PYMES.PROC_COBERTURA(IP_NUMSECUPOL,
                                         IP_NUMEND,
                                         RRIES.COD_RIES,
                                         L_ARRCOB,
                                         L_VALIDACION,
                                         IP_PROCESO,
                                         OP_RESULTADO,
                                         OP_ARRERRORES);
          
          END;
          L_POLIZA.DATOSRIESGOS(RRIES.COD_RIES).DATOSCOBERTURAS := NEW
                                                                   SIM_TYP_ARRAY_COBPOLIZASGEN();
          L_POLIZA.DATOSRIESGOS(RRIES.COD_RIES).DATOSCOBERTURAS := L_ARRCOB;
        END LOOP;
      ELSE
        FOR RCOB IN COB LOOP
        
          -- Wesv 20180515 -- No Se muestran las coberturas que no tengan prima en BUPA
          L_ENTRACOB := 'N';
          IF IP_PROCESO.P_COD_CIA = 2 AND IP_PROCESO.P_COD_SECC = 34 AND
             IP_PROCESO.P_COD_PRODUCTO IN (66, 67) THEN
            IF RCOB.END_PRIMA_COB > 0 OR NVL(RCOB.MCA_GRATUITA, 'N') = 'S' THEN
              L_ENTRACOB := 'S';
              IF RCOB.END_PRIMA_COB = 0 AND RCOB.COD_COB <> 240 THEN
                L_ENTRACOB := 'N';
              END IF;
            ELSE
              L_ENTRACOB := 'N'; --pRUEBA
            END IF;
          ELSE
            L_ENTRACOB := 'S';
          END IF;
        
          IF L_ENTRACOB = 'S' THEN
            L_NOMBRECOB := NVL(SIM_PCK_FUNCION_GEN.COBERTURAS(L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO,
                                                              L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO,
                                                              RCOB.COD_COB),
                               'Sin Informacion');
            --Sim_Proc_Log('Cobertura:' || Rcob.Cod_Cob, 'Nombre:' || l_Nombrecob);
            L_COBERTURA := NEW
                           SIM_TYP_COBERTURAPOLIZAGEN(NUM_SECU_POL         => IP_NUMSECUPOL,
                                                      NUM_END              => IP_NUMEND,
                                                      COD_RIES             => RCOB.COD_RIES,
                                                      COD_COB              => SIM_TYP_LOOKUP(RCOB.COD_COB,
                                                                                             L_NOMBRECOB),
                                                      SUMA_ASEG            => RCOB.END_SUMA_ASEG,
                                                      TASA_COB             => RCOB.END_TASA_COB,
                                                      TASA_TOTAL           => RCOB.END_TASA_TOTAL,
                                                      PORC_PPAGO           => RCOB.PORC_PPAGO,
                                                      IND_AJUSTE           => RCOB.IND_AJUSTE,
                                                      PRIMA_COB            => RCOB.END_PRIMA_COB,
                                                      PORC_REBAJA          => RCOB.PORC_REBAJA,
                                                      TASA_AGR             => RCOB.TASA_AGR,
                                                      MCA_GRATUITA         => RCOB.MCA_GRATUITA,
                                                      NUM_SECU             => RCOB.NUM_SECU,
                                                      TIPO_REG             => '',
                                                      COD_CIACOA           => SIM_TYP_LOOKUP('',
                                                                                             ''),
                                                      VAL_ASEGURABLE       => '',
                                                      PRIMA_ANU            => '',
                                                      COD_AGRUP_CONT       => '',
                                                      MCA_BAJA_COB         => '',
                                                      FECHA_INCLUSION      => '',
                                                      FECHA_EXCLUSION      => '',
                                                      COD_PROV             => SIM_TYP_LOOKUP('',
                                                                                             ''),
                                                      MCA_VIGENTE          => '',
                                                      COD_COB_INF          => SIM_TYP_LOOKUP('',
                                                                                             ''),
                                                      DESCUENT_PRIMA       => '',
                                                      MCA_PRIMA_INF        => '',
                                                      MCA_TASA_INF         => '',
                                                      MCA_TIPO_COB         => SIM_TYP_LOOKUP('',
                                                                                             ''),
                                                      NOMINA               => '',
                                                      TIPO_FRANQ           => '',
                                                      PORC_FRANQ           => '',
                                                      IMP_FRANQ            => '',
                                                      MIN_FRANQ            => '',
                                                      MAX_FRANQ            => '',
                                                      MCA_AHORRO           => '',
                                                      MCA_VALOR_ABLE       => '',
                                                      MCA_VAL_SINI         => '',
                                                      FECHA_VIG_FRANQ      => '',
                                                      MCA_REASEGURO        => '',
                                                      COD_SECC_REAS        => '',
                                                      NUM_BLOQUE_REAS      => '',
                                                      REGLA_CAP_REAS       => '',
                                                      CAPITAL_REAS         => '',
                                                      PRIMA_REAS           => '',
                                                      CAPITAL_CALCULO_REAS => '',
                                                      MCA_CAPITAL          => '',
                                                      CAPITAL_UNIDAD       => '',
                                                      COD_GRUPO            => '',
                                                      FECHA_ORI_VIDA       => '',
                                                      PRIMA_REAS_ORI       => '',
                                                      END_PRIMA_REAS_ORI   => '',
                                                      SIM_FECHA_INCLUSION  => '',
                                                      SIM_FECHA_EXCLUSION  => '',
                                                      SIM_MCA_SUMA_INF     => '',
                                                      SIM_FECHA_VIG_END    => '',
                                                      SIM_FECHA_VENC_END   => '',
                                                      SIM_COEFCOB          => '');
          
            L_ENCONTRO := 'N';
          
            IF L_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
              -- 17112016 sgpinto: Integración. Adición de llamado a función que recupera código de riesgo
              -- 19/08/2016 sgpm: Cambio de valor de índice por valor retornado de función
              L_CODRIES := FNC299_RECUPERA_INDRIESGO(IP_INDICE       => RCOB.COD_RIES,
                                                     IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                                     IP_NUM_END      => IP_NUMEND);
              --
              -- 17112016 sgpinto: se cambia índice de Rdv.Cod_Ries a l_CodRies
              /*
              If l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas.Exists(1) Then
                If l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                 .Datoscoberturas.Count > 0 Then
                  For j In l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                           .Datoscoberturas.First .. l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                                                     .Datoscoberturas.Last Loop
                    If l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(j)
                     .Cod_Ries = Rcob.Cod_Ries And l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(j)
                       .Cod_Cob.Codigo = Rcob.Cod_Cob Then
                      l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(j) := l_Cobertura;
                      l_Encontro := 'S';
                    End If;
                  End Loop;
                End If;*/
              IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.EXISTS(1) THEN
                IF L_POLIZA.DATOSRIESGOS(L_CODRIES)
                 .DATOSCOBERTURAS.COUNT > 0 THEN
                  FOR J IN L_POLIZA.DATOSRIESGOS(L_CODRIES)
                           .DATOSCOBERTURAS.FIRST .. L_POLIZA.DATOSRIESGOS(L_CODRIES)
                                                     .DATOSCOBERTURAS.LAST LOOP
                    IF L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(J)
                     .COD_RIES = RCOB.COD_RIES AND L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(J)
                       .COD_COB.CODIGO = RCOB.COD_COB THEN
                      L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(J) := L_COBERTURA;
                      L_ENCONTRO := 'S';
                    END IF;
                  END LOOP;
                END IF;
              END IF;
            END IF;
          
            IF L_ENCONTRO = 'N' AND
               (RCOB.END_PRIMA_COB != 0 OR RCOB.MCA_GRATUITA = 'S') --Modif Juan González, ver comentario
             THEN
              -- 17112016 sgpinto: se cambia índice de Rdv.Cod_Ries a l_CodRies
              /*
                -- Revisar
                If l_Poliza.Datosriesgos.Exists(1) Then
                  If l_Poliza.Datosriesgos(Rcob.Cod_Ries)
                   .Datoscoberturas.Exists(1) Then
                    Null;
                  Else
                    l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas := New
                                                                            Sim_Typ_Array_Cobpolizasgen();
                  End If;
                Else
                  l_Poliza.Datosriesgos := New Sim_Typ_Array_Riesgosgen();
                  l_Poliza.Datosriesgos.Extend;
                  l_Poliza.Datosriesgos(Rcob.Cod_Ries) := New Sim_Typ_Riesgogen();
                  l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas := New
                                                                          Sim_Typ_Array_Cobpolizasgen();
                End If;
              
                l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas.Extend;
                l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas(l_Poliza.Datosriesgos(Rcob.Cod_Ries).Datoscoberturas.Count) := l_Cobertura;
              End If;*/
              IF L_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
                IF L_POLIZA.DATOSRIESGOS(L_CODRIES)
                 .DATOSCOBERTURAS.EXISTS(1) THEN
                  NULL;
                ELSE
                  L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS := NEW
                                                                      SIM_TYP_ARRAY_COBPOLIZASGEN();
                END IF;
              ELSE
                L_POLIZA.DATOSRIESGOS := NEW SIM_TYP_ARRAY_RIESGOSGEN();
                L_POLIZA.DATOSRIESGOS.EXTEND;
                L_POLIZA.DATOSRIESGOS(L_CODRIES) := NEW SIM_TYP_RIESGOGEN();
                L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS := NEW
                                                                    SIM_TYP_ARRAY_COBPOLIZASGEN();
              END IF;
            
              L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.EXTEND;
              L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS(L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSCOBERTURAS.COUNT) := L_COBERTURA;
            END IF;
          END IF;
        END LOOP;
    END CASE;
  
    FOR RPRIMAXRIE IN PRIMAXRIE LOOP
      L_DATOSRIESGO.NUM_SECU_POL := IP_NUMSECUPOL;
      L_DATOSRIESGO.NUM_END      := IP_NUMEND;
      L_DATOSRIESGO.COD_RIES     := RPRIMAXRIE.COD_RIES;
      L_DATOSRIESGO.IMP_PRIMA    := RPRIMAXRIE.PRIMARIES;
      -- 17112016 sgpinto: Integración. Adición de llamado a función que recupera código de riesgo
      -- 19/08/2016 sgpm: Cambio de valor de índice por valor retornado de función
      L_CODRIES := FNC299_RECUPERA_INDRIESGO(IP_INDICE       => RPRIMAXRIE.COD_RIES,
                                             IP_NUM_SECU_POL => IP_NUMSECUPOL,
                                             IP_NUM_END      => IP_NUMEND);
      --
      -- 17112016 sgpinto: se cambia índice de Rdv.Cod_Ries a l_CodRies
      /* l_Poliza.Datosriesgos(Rprimaxrie.Cod_Ries).Datosriesgo := l_Datosriesgo;*/
      L_POLIZA.DATOSRIESGOS(L_CODRIES).DATOSRIESGO := L_DATOSRIESGO;
    END LOOP;
  
    FOR RPRIMA IN PRIMA LOOP
      L_PRIMA := NEW SIM_TYP_PRIMA(NUM_SECU_POL => IP_NUMSECUPOL,
                                   NUM_END      => IP_NUMEND,
                                   IMP_PRIMA    => RPRIMA.IMP_PRIMA_END,
                                   IMP_DER_EMI  => RPRIMA.IMP_DER_EMI_EN,
                                   IMP_IMPUESTO => RPRIMA.IMP_IMPUESTO_E,
                                   PORC_BONIF   => RPRIMA.PORC_BONIF_EN,
                                   IMP_BONIF    => RPRIMA.IMP_BONIF_EN,
                                   PREMIO       => RPRIMA.PREMIO_END,
                                   SUMA_ASEG    => RPRIMA.SUMA_ASEG,
                                   PRIMA_ANU    => RPRIMA.PRIMA_ANU);
    
      L_POLIZA.PRIMA := L_PRIMA;
    END LOOP;
  
    -- Inlcusion de caberturas de anexo hogar -->22/08/2017(Juan Gonzalez)
    IF SIM_PCK_ATGC_VIDA_GRUPO.FUN_ESRAMOATGCVIDAGRUPO(IP_PROCESO.P_COD_CIA,
                                                       IP_PROCESO.P_COD_SECC,
                                                       IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
    
      IF IP_PROCESO.P_COD_PRODUCTO IN (719, 792) AND
         IP_PROCESO.P_PROCESO IN (241, 270) THEN
        -- aplica solo para cotiza(241) /emite(270)
        SIM_PCK_ATGC_VIDA_GRUPO.PROC_ADJUNTACOBERANEXO(L_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                       L_POLIZA,
                                                       IP_PROCESO);
      
        L_POLIZA.PRIMA.IMP_IMPUESTO := SIM_PCK_ATGC_VIDA_GRUPO.FUN_VLRIMPUESTO(L_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                                               IP_PROCESO);
      END IF;
    
    END IF;
  
    /* 31 mar 2015
    Se coloca esta condicionpara que en las cotizaciones de vida, si el
    agente no es atgc, no puede formalizar, devolviendo la
    mca_term_ok en N, no prende el boton de formalizar*/
    --If Ip_Proceso.p_Cod_Producto In (940, 942, 946, 944) Then
    IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
      IF SIM_PCK_FUNCION_GEN.AGENTE_ESATGC(L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO,
                                           IP_PROCESO.P_COD_CIA,
                                           IP_PROCESO.P_COD_SECC,
                                           IP_PROCESO.P_COD_PRODUCTO,
                                           IP_PROCESO.P_SUBPRODUCTO) = 0 THEN
        L_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'N';
      END IF;
    END IF;
  
    L_CANTIDAD := 0;
  
    BEGIN
      SELECT COUNT(1)
        INTO L_CANTIDAD
        FROM X2000220 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.COD_ERROR != 924 --no se tiene en cuenta por se un control de reaseguros que se dispara por error
         AND C.NUM_ORDEN = IP_NUMEND
         AND C.COD_RECHAZO > 1;
    END;
  
    IF L_CANTIDAD = 0 THEN
      BEGIN
        SELECT COUNT(1)
          INTO L_CANTIDAD
          FROM A2000220 C
         WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
           AND C.NUM_ORDEN = IP_NUMEND
           AND C.COD_RECHAZO > 1;
      END;
    END IF;
  
    IF L_CANTIDAD > 0 THEN
      L_POLIZA.DATOSFIJOS.MCA_PROVISORIO := 'S';
    ELSE
      L_POLIZA.DATOSFIJOS.MCA_PROVISORIO := 'N';
    END IF;
  
    OP_POLIZA := L_POLIZA;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_UPDATETYPEDEX;

  /*----------------------------------------------------*/

  /*----------------------------------------------------*/

  PROCEDURE PROC_CONTEXTO_INS_TRANS(IP_NUMSECUPOL  IN NUMBER,
                                    IP_NUMEND      IN NUMBER,
                                    IP_VALIDACION  IN VARCHAR2,
                                    IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    OP_ARRCONTEXTO OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                    IP_PROCESO     IN SIM_TYP_PROCESO,
                                    OP_RESULTADO   OUT NUMBER,
                                    OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    L_ERROR       SIM_TYP_ERROR;
    L_NUMPOL1     A2000030.NUM_POL1%TYPE;
    L_NUMPOLCOTIZ A2000030.NUM_POL_COTIZ%TYPE;
    --
    L_NUMPOLFLOT     A2000030.NUM_POL_FLOT%TYPE;
    L_NUMENDFLOT     A2000030.NUM_END_FLOT%TYPE;
    L_NUMSECUPOLFLOT A2010030.NUM_SECU_POL%TYPE;
    L_MCAPROVISORIO  A2000030.MCA_PROVISORIO%TYPE;
    L_PROGRAMA       VARCHAR2(30);
    L_TIPONEGOCIO    NUMBER(15);
    L_TIPOPROCESO    NUMBER(15);
    L_NUMSECUPOL     NUMBER(15) := IP_NUMSECUPOL;
    L_NUMEND         NUMBER(15) := IP_NUMEND;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Inserta_Transitoria ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
    OP_ARRERRORES  := NEW SIM_TYP_ARRAY_ERROR();
    OP_ARRCONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    OP_RESULTADO   := 0;
  
    L_NUMPOL1       := 0;
    L_NUMPOLCOTIZ   := 0;
    L_MCAPROVISORIO := 'N';
  
    BEGIN
      SELECT NVL(NUM_POL1, 0),
             NVL(NUM_POL_COTIZ, 0),
             NVL(MCA_PROVISORIO, 'N')
        INTO L_NUMPOL1, L_NUMPOLCOTIZ, L_MCAPROVISORIO
        FROM A2000030
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND NUM_END = 0;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF L_NUMPOL1 != 0 THEN
      IF L_MCAPROVISORIO = 'N' THEN
        --        raise_application_error(-20000,'<<<<<Poliza ya generada Nro. '||l_numpol1||'>>>>>');
        NULL;
      ELSE
        L_ERROR := SIM_TYP_ERROR(-20000,
                                 'Poliza En estado Provisorio, Se genera una nueva',
                                 'W');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := 1;
      END IF;
    END IF;
  
    L_TIPONEGOCIO := SIM_PCK_CONSULTA_EMISION.FUN_TIPONEGOCIO(IP_PROCESO.P_PROCESO,
                                                              IP_PROCESO.P_SUBPROCESO,
                                                              IP_PROCESO.P_MODULO);
  
    L_NUMPOLFLOT := NULL;
    L_NUMENDFLOT := NULL;
  
    BEGIN
      SELECT A.NUM_POL_FLOT, A.NUM_END_FLOT
        INTO L_NUMPOLFLOT, L_NUMENDFLOT
        FROM X2000030 A
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND NUM_END = IP_NUMEND;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL; -- No importa si no tiene numero de poliza flotante . Wesv 20130805
    END;
  
    IF L_NUMPOLFLOT IS NOT NULL THEN
      BEGIN
        SELECT B.NUM_SECU_POL
          INTO L_NUMSECUPOLFLOT
          FROM A2010030 B
         WHERE B.NUM_POL1 = L_NUMPOLFLOT
           AND B.NUM_END = L_NUMENDFLOT;
      END;
    END IF;
  
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B1_NUM_POL_FLOT', L_NUMPOLFLOT);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_NUM_POL_FLOT',
                                        L_NUMPOLFLOT);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_NUMPOLFLOT', L_NUMPOLFLOT);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_TRUCHA', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_MCARENOV', 'N');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NUMPOLANT', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B1_NUM_POL_ANT', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_DISPOSITIVO', 'X');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_MCAVIGEND', 'N');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTPOLPRES', L_TIPONEGOCIO);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NUMSECUPOLFLOT',
                                        L_NUMSECUPOLFLOT);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NUMSECUPOLANT', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NUMSECUPOL', IP_NUMSECUPOL);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NUMEND', IP_NUMEND);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODEND', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODSECC',
                                        IP_PROCESO.P_COD_SECC);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODCIA', IP_PROCESO.P_COD_CIA);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODRAMO',
                                        IP_PROCESO.P_COD_PRODUCTO);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B85_NUMPOLRESERV', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NUMPOL1COBRO', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_SUBCODEND', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B1_PERIODO_FACT', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B1_COD_MON', '');
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B1_FECHAVIGEND',
                                        TO_CHAR(SYSDATE, 'DDMMYYYY'));
  
    BEGIN
      BEGIN
        L_PROGRAMA := SIM_PCK_REGLAS.G_PARAMETROS('B99_CODPROG');
      EXCEPTION
        WHEN OTHERS THEN
          L_PROGRAMA := NULL;
      END;
    
      IF L_PROGRAMA IS NULL OR IP_NUMEND = 0 THEN
        L_PROGRAMA := SIM_PCK_CONSULTA_EMISION.FUN_PROGRAMATRONADOR(IP_PROCESO.P_PROCESO,
                                                                    IP_PROCESO.P_SUBPROCESO,
                                                                    IP_PROCESO.P_MODULO);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20000,
                                'Error al recuperar tipos de proceso/programa');
    END;
  
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODPROG', L_PROGRAMA);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_CODPROG', L_PROGRAMA);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_COD_PROG', L_PROGRAMA);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_S_CODSIST',
                                        SUBSTR(L_PROGRAMA, 3, 1));
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_COD_SIST',
                                        SUBSTR(L_PROGRAMA, 3, 1));
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_COD_PROCESO',
                                        SUBSTR(L_PROGRAMA, 3, 1));
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_S_CODSUBS',
                                        SUBSTR(L_PROGRAMA, 4, 2));
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_COD_SIST',
                                        SUBSTR(L_PROGRAMA, 3, 1));
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_NTPOLPRES', L_TIPONEGOCIO);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_NTPOLPRES', L_TIPONEGOCIO);
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE,
                               G_SUBPROGRAMA || ' ' || SQLERRM,
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_CONTEXTO_INS_TRANS;

  /*----------------------------------------------------*/

  /*----------------------------------------------------*/
  PROCEDURE PROC_DEDUCIBLES(IP_NUMPOL1       IN NUMBER,
                            IP_CODRIES       IN NUMBER,
                            IP_CODCOB        IN NUMBER,
                            IP_NUMEND        IN NUMBER,
                            OP_ARRDEDUCIBLES OUT SIM_TYP_ARRAY_DEDUCIBLES,
                            IP_VALIDACION    IN VARCHAR2,
                            IP_ARRCONTEXTO   IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                            OP_ARRCONTEXTO   OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                            IP_PROCESO       IN SIM_TYP_PROCESO,
                            OP_RESULTADO     OUT NUMBER,
                            OP_ARRERRORES    OUT SIM_TYP_ARRAY_ERROR) IS
    L_CODCIA        C1001210.COD_CIA%TYPE;
    L_CODCOB        C1001210.COD_COB%TYPE;
    L_CODRAMO       C1001210.COD_RAMO%TYPE;
    L_CODZONA       C1010160.COD_ZONA%TYPE;
    L_CODTIPO       C1010160.COD_TIPO%TYPE;
    L_FECHAVIGMOV   DATE;
    L_CODMON        A2000030.COD_MON%TYPE;
    L_GLOBAL_TRUCHA SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_IRATITULOS    SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'S';
    L_TITULOS       SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 0;
    L_CODCOBANT     C1001210.COD_COB%TYPE := 0;
    L_TYP_DEDUCIBLE SIM_TYP_DEDUCIBLES;
    L_TC            A2000030.TC%TYPE;
    L_NUMSECUPOL    A2000030.NUM_SECU_POL%TYPE;
  
    /*  Num_secu_pol  Number(15)
       ,num_end       Number(3)
       ,cod_ries      Number(3)
       ,cod_cob       Number(3)
       ,opcion        Number(3)
       ,campo1        Varchar2(25)
       ,campo2        Varchar2(25)
       ,campo3        Varchar2(25)
       ,campo4        Varchar2(25)
    */
  
    CURSOR B20 IS
      SELECT A.COD_COB,
             A.COD_MON,
             A.FECHA_VIG,
             A.IMP_FRANQ,
             A.PORC_FRANQ,
             A.MIN_FRANQ,
             A.PORC_MIN,
             A.MAX_FRANQ,
             A.PORC_MAX,
             A.FOR_APLI_FRANQ,
             A.FOR_APLI_MIN,
             A.FOR_APLI_MAX,
             A.TIPO_FRANQ,
             A.DESCUENT_PRIMA
        FROM C1001210 A
       WHERE A.COD_CIA = L_CODCIA
         AND A.COD_COB = NVL(L_CODCOB, A.COD_COB)
         AND A.COD_RAMO = L_CODRAMO
         AND A.FECHA_BAJA IS NULL
         AND (A.COD_COB, A.COD_RAMO, A.TIPO_FRANQ, A.FECHA_VIG) IN
             (SELECT B.COD_COB, B.COD_RAMO, B.TIPO_FRANQ, MAX(B.FECHA_VIG)
                FROM C1001210 B
               WHERE B.COD_CIA = L_CODCIA
                 AND B.COD_RAMO = L_CODRAMO
                 AND B.COD_COB = A.COD_COB
               GROUP BY B.COD_RAMO, B.COD_COB, B.TIPO_FRANQ)
         AND (A.COD_RAMO, A.COD_COB, A.TIPO_FRANQ) IN
             (SELECT C.COD_RAMO, C.COD_COB, C.TIPO_FRANQ
                FROM C1010160 C
               WHERE C.COD_CIA = L_CODCIA
                 AND C.COD_ZONA IN (L_CODZONA, 999)
                 AND C.COD_TIPO = L_CODTIPO
                 AND C.COD_RAMO = L_CODRAMO
                 AND C.COD_COB = A.COD_COB
                 AND C.FECHA_BAJA IS NULL
                 AND C.FECHA_VIG IN (SELECT MAX(D.FECHA_VIG)
                                       FROM C1010160 D
                                      WHERE D.COD_CIA = L_CODCIA
                                        AND D.COD_ZONA = C.COD_ZONA
                                        AND D.COD_TIPO = L_CODTIPO
                                        AND D.COD_RAMO = L_CODRAMO
                                        AND D.COD_COB = A.COD_COB
                                        AND FECHA_BAJA IS NULL
                                      GROUP BY D.COD_ZONA,
                                               D.COD_RAMO,
                                               D.COD_COB,
                                               D.TIPO_FRANQ))
       ORDER BY A.COD_COB, A.TIPO_FRANQ;
  
    CURSOR B21 IS
      SELECT A.COD_COB,
             A.COD_MON,
             A.FECHA_VIG,
             A.IMP_FRANQ,
             A.PORC_FRANQ,
             A.MIN_FRANQ,
             A.PORC_MIN,
             A.MAX_FRANQ,
             A.PORC_MAX,
             A.FOR_APLI_FRANQ,
             A.FOR_APLI_MIN,
             A.FOR_APLI_MAX,
             A.TIPO_FRANQ,
             A.DESCUENT_PRIMA
        FROM C1001210 A
       WHERE A.FECHA_BAJA IS NULL
         AND (A.COD_CIA, A.COD_RAMO, A.COD_COB, A.TIPO_FRANQ, A.FECHA_VIG) IN
             (SELECT X.COD_CIA,
                     X.COD_RAMO,
                     X.COD_COB,
                     X.TIPO_FRANQ,
                     X.FECHA_VIG
                FROM C1001210 X
               WHERE X.COD_CIA = L_CODCIA
                 AND X.COD_RAMO = L_CODRAMO
                 AND X.COD_COB = NVL(L_CODCOB, X.COD_COB)
                 AND X.FECHA_VIG =
                     (SELECT MAX(Y.FECHA_VIG)
                        FROM C1001210 Y
                       WHERE Y.COD_CIA = L_CODCIA
                         AND Y.COD_RAMO = L_CODRAMO
                         AND Y.TIPO_FRANQ = X.TIPO_FRANQ
                         AND Y.COD_COB = X.COD_COB
                         AND Y.FECHA_BAJA IS NULL
                         AND Y.FECHA_VIG <= L_FECHAVIGMOV))
       ORDER BY A.COD_COB, A.TIPO_FRANQ;
  BEGIN
    /*  sim_proc_log(' Proc_deducibles - Entro','*Proceso:'||Ip_proceso.p_proceso ||'*');
    */
    L_ERROR := NEW SIM_TYP_ERROR;
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
    OP_ARRERRORES    := NEW SIM_TYP_ARRAY_ERROR();
    OP_ARRCONTEXTO   := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    OP_ARRDEDUCIBLES := NEW SIM_TYP_ARRAY_DEDUCIBLES();
    L_TYP_DEDUCIBLE  := NEW SIM_TYP_DEDUCIBLES();
    OP_RESULTADO     := 0;
    --TITULOS
    /* SI LA COBERTURA TRATADA FIGURA EN LA TABLA C1010170, DEBE VERIFICAR-
       SE QUE LOS DEDUCIBLES RESCATADOS SE ENCUENTREN DENTRO DE ESTA PARA
       EL VALOR DEL 0 KM.
    */
    L_CODCIA  := IP_PROCESO.P_COD_CIA; --sim_pck_reglas.g_Parametros('B99_CODCIA');
    L_CODCOB  := IP_CODCOB; --sim_pck_reglas.g_Parametros('B5_COD_COB');
    L_CODRAMO := IP_PROCESO.P_COD_PRODUCTO; --sim_pck_reglas.g_Parametros('B99_CODRAMO');
  
    IF IP_PROCESO.P_PROCESO NOT IN (500, 501) THEN
      --Cuando no son consulta trae la inf de variables de contexto
      L_CODZONA     := SIM_PCK_REGLAS.G_PARAMETROS('B99_CODZONA');
      L_CODTIPO     := SIM_PCK_REGLAS.G_PARAMETROS('B35_COD_TIPO');
      L_FECHAVIGMOV := SIM_PCK_REGLAS.G_PARAMETROS('B99_FECHAVIGMOV');
      L_CODMON      := SIM_PCK_REGLAS.G_PARAMETROS('B1_COD_MON');
      L_TC          := SIM_PCK_REGLAS.G_PARAMETROS('B1_TC');
    ELSE
      IF IP_PROCESO.P_PROCESO IN (240, 241, 242) THEN
        BEGIN
          SELECT A.FECHA_EMI_END, A.COD_MON, A.TC, A.NUM_SECU_POL
            INTO L_FECHAVIGMOV, L_CODMON, L_TC, L_NUMSECUPOL
            FROM A2000030 A
           WHERE A.NUM_POL_COTIZ = IP_NUMPOL1
             AND A.COD_CIA = IP_PROCESO.P_COD_CIA
             AND A.COD_SECC = IP_PROCESO.P_COD_SECC
             AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
             AND A.NUM_END =
                 (SELECT MAX(B.NUM_END)
                    FROM A2000030 B
                   WHERE B.NUM_SECU_POL = A.NUM_SECU_POL
                     AND B.NUM_END <= NVL(IP_NUMEND, 0));
        EXCEPTION
          WHEN OTHERS THEN
            SIM_PROC_LOG('Proc_deducibles - Error A2000030',
                         '*Cotizacion:' || IP_NUMPOL1 || '*');
        END;
      ELSE
        BEGIN
          SELECT A.FECHA_EMI_END, A.COD_MON, A.TC, A.NUM_SECU_POL
            INTO L_FECHAVIGMOV, L_CODMON, L_TC, L_NUMSECUPOL
            FROM A2000030 A
           WHERE A.NUM_POL1 = IP_NUMPOL1
             AND A.COD_CIA = IP_PROCESO.P_COD_CIA
             AND A.COD_SECC = IP_PROCESO.P_COD_SECC
             AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
             AND A.NUM_END =
                 (SELECT MAX(B.NUM_END)
                    FROM A2000030 B
                   WHERE B.NUM_SECU_POL = A.NUM_SECU_POL
                     AND B.NUM_END <= NVL(IP_NUMEND, 0));
        EXCEPTION
          WHEN OTHERS THEN
            SIM_PROC_LOG('Proc_deducibles - Error A2000030',
                         '*Poliza:' || IP_NUMPOL1 || '*');
        END;
      END IF;
    
      BEGIN
        SELECT B.COD_TIPO
          INTO L_CODTIPO
          FROM A2040100 B
         WHERE B.NUM_SECU_POL = L_NUMSECUPOL
           AND B.NUM_END =
               (SELECT MAX(C.NUM_END)
                  FROM A2040100 C
                 WHERE C.NUM_SECU_POL = B.NUM_SECU_POL
                   AND C.NUM_END <= NVL(IP_NUMEND, 0));
      EXCEPTION
        WHEN OTHERS THEN
          SIM_PROC_LOG('Proc_deducibles - Error A2040100',
                       '*numsecupol:' || L_NUMSECUPOL || '*');
      END;
    
      L_CODZONA := '999';
    
      BEGIN
        SELECT ZONA_TAR
          INTO L_CODZONA
          FROM A1000101
         WHERE COD_CIA = IP_PROCESO.P_COD_CIA
           AND COD_SECC = IP_PROCESO.P_COD_SECC
           AND (COD_POSTAL =
               (SELECT VALOR_CAMPO_EN
                   FROM X2000020
                  WHERE NUM_SECU_POL = L_NUMSECUPOL
                    AND COD_RIES = IP_CODRIES
                    AND COD_CAMPO = 'ZON_RADIC_RIES') OR
               COD_POSTAL = 99999)
           AND ROWNUM <= 1;
      EXCEPTION
        WHEN OTHERS THEN
          SIM_PROC_LOG('Proc_deducibles - Error A1000101',
                       '*numsecupol:' || L_NUMSECUPOL || '*');
      END;
    END IF;
  
    /*   sim_proc_log(' Proc_Deducibles proceso*'||Ip_proceso.p_proceso ||'*'||
                 '*Cia:'       || l_codcia         ||
                 '*Codcob:'    || l_codcob         ||
                 '*Ramo:'      || l_codramo        ||
                 '*Zona:'      || l_codzona        ||
                 '*Tipo:'      || l_codtipo        ||
                 '*FechaMov:'  || l_fechavigmov    ||
                 '*CodMon:'    || l_codmon         ||
                 '*Tc:'        || l_tc,
                 '*Ipcodries:' || Ip_codries       ||
                 '*Numsecupol:'|| l_numsecupol     ||
                 '*Numend:'    || Ip_numend        ||
                 '*Seccion:'   || Ip_proceso.p_cod_secc ||
                 '*');
    */
    IF IP_PROCESO.P_COD_PRODUCTO IN (12, 13, 14, 16, 17, 19) THEN
      IF IP_CODCOB IN (202, 203) AND
         IP_PROCESO.P_COD_PRODUCTO IN (12, 13, 14, 16, 19) THEN
        BEGIN
          SELECT ''
            INTO L_GLOBAL_TRUCHA --:GLOBAL.DEDUC
            FROM C1001210 A
           WHERE A.COD_CIA = L_CODCIA
             AND A.COD_COB = L_CODCOB
             AND A.COD_RAMO = L_CODRAMO
             AND A.FECHA_BAJA IS NULL
             AND (A.COD_COB, A.COD_RAMO, A.TIPO_FRANQ, A.FECHA_VIG) IN
                 (SELECT B.COD_COB,
                         B.COD_RAMO,
                         B.TIPO_FRANQ,
                         MAX(B.FECHA_VIG)
                    FROM C1001210 B
                   WHERE B.COD_CIA = L_CODCIA
                     AND B.COD_RAMO = L_CODRAMO
                     AND B.COD_COB = L_CODCOB
                   GROUP BY B.COD_RAMO, B.COD_COB, B.TIPO_FRANQ)
             AND (A.COD_RAMO, A.COD_COB, A.TIPO_FRANQ) IN
                 (SELECT C.COD_RAMO, C.COD_COB, C.TIPO_FRANQ
                    FROM C1010160 C
                   WHERE C.COD_CIA = L_CODCIA
                     AND C.COD_ZONA IN (L_CODZONA, 999)
                     AND C.COD_TIPO = L_CODTIPO
                     AND C.COD_RAMO = L_CODRAMO
                     AND C.COD_COB = L_CODCOB
                     AND C.FECHA_BAJA IS NULL
                     AND C.FECHA_VIG IN
                         (SELECT MAX(D.FECHA_VIG)
                            FROM C1010160 D
                           WHERE D.COD_CIA = L_CODCIA
                             AND D.COD_ZONA = C.COD_ZONA
                             AND D.COD_TIPO = L_CODTIPO
                             AND D.COD_RAMO = L_CODRAMO
                             AND D.COD_COB = L_CODCOB
                             AND D.FECHA_BAJA IS NULL
                           GROUP BY D.COD_ZONA,
                                    D.COD_RAMO,
                                    D.COD_COB,
                                    D.TIPO_FRANQ));
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            OP_RESULTADO := -1;
            RAISE_APPLICATION_ERROR(-20000,
                                    'No hay Deducibles ...' || SQLERRM);
          WHEN TOO_MANY_ROWS THEN
            NULL;
          WHEN OTHERS THEN
            OP_RESULTADO := -1;
            RAISE_APPLICATION_ERROR(-20000,
                                    'Error en Deducibles...' || SQLERRM);
        END;
      
        FOR REG_B20 IN B20 LOOP
          /*=====================    B20   =======================*/
          L_IRATITULOS := 'N';
        
          BEGIN
            SELECT ''
              INTO L_GLOBAL_TRUCHA
              FROM C1010170
             WHERE COD_CIA = L_CODCIA
               AND COD_RAMO = L_CODRAMO
               AND COD_COB = L_CODCOB;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              L_IRATITULOS := 'S';
            WHEN OTHERS THEN
              NULL;
          END;
        
          IF L_IRATITULOS = 'N' THEN
            BEGIN
              SELECT ''
                INTO L_GLOBAL_TRUCHA
                FROM C1010170
               WHERE COD_CIA = L_CODCIA
                 AND COD_RAMO = L_CODRAMO
                 AND COD_COB = L_CODCOB
                 AND TIPO_FRANQ = REG_B20.TIPO_FRANQ
                 AND COD_MON = L_CODMON
                 AND COD_ZONA IN (L_CODZONA, 999)
                 AND COD_TIPO = L_CODTIPO
                 AND FECHA_BAJA IS NULL
                 AND SIM_PCK_REGLAS.G_PARAMETROS('B35_SUMA_ASEG_0KM') BETWEEN
                     LIM_INF AND LIM_SUP;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000,
                                        'Sin datos C1010170...' || SQLERRM);
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
        
          --                 <<TITULOS>>
          IF L_TITULOS = 0 OR L_CODCOBANT != REG_B20.COD_COB THEN
            L_TYP_DEDUCIBLE         := NEW SIM_TYP_DEDUCIBLES();
            L_TYP_DEDUCIBLE.OPCION  := 0;
            L_TYP_DEDUCIBLE.COD_COB := REG_B20.COD_COB;
          
            IF REG_B20.FOR_APLI_FRANQ = 'ASEG' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBDEDUC',
                                                  'DED(Val.Asegurado)');
              L_TYP_DEDUCIBLE.CAMPO1 := 'DED(Val.Asegurado)';
            END IF;
          
            IF REG_B20.FOR_APLI_FRANQ = 'ABLE' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBDEDUC',
                                                  'DED(Val.Asegurable)');
              L_TYP_DEDUCIBLE.CAMPO1 := 'DED(Val.Asegurable)';
            END IF;
          
            IF REG_B20.FOR_APLI_FRANQ = 'PERD' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBDEDUC',
                                                  'DED(Costo/Perdida)');
              L_TYP_DEDUCIBLE.CAMPO1 := 'DED(Costo/Perdida)';
            END IF;
          
            IF REG_B20.FOR_APLI_MIN = 'ASEG' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBMINIM',
                                                  'MIN(Val.Asegurado)');
              L_TYP_DEDUCIBLE.CAMPO2 := 'MIN(Val.Asegurado)';
            END IF;
          
            IF REG_B20.FOR_APLI_MIN = 'ABLE' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBMINIM',
                                                  'MIN(Val.Asegurable)');
              L_TYP_DEDUCIBLE.CAMPO2 := 'MIN(Val.Asegurable)';
            END IF;
          
            IF REG_B20.FOR_APLI_MIN = 'PERD' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBMINIM',
                                                  'MIN(Costo/Perdida)');
              L_TYP_DEDUCIBLE.CAMPO2 := 'MIN(Costo/Perdida)';
            END IF;
          
            IF REG_B20.FOR_APLI_MAX = 'ASEG' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBMAXIM',
                                                  'MAX(Val.Asegurado)');
              L_TYP_DEDUCIBLE.CAMPO3 := 'MAX(Val.Asegurado)';
            END IF;
          
            IF REG_B20.FOR_APLI_MAX = 'ABLE' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBMAXIM',
                                                  'MAX(Val.Asegurable)');
              L_TYP_DEDUCIBLE.CAMPO3 := 'MAX(Val.Asegurable)';
            END IF;
          
            IF REG_B20.FOR_APLI_MAX = 'PERD' THEN
              SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_TXTCOBMAXIM',
                                                  'MAX(Costo/Perdida)');
              L_TYP_DEDUCIBLE.CAMPO3 := 'MAX(Costo/Perdida)';
            END IF;
          
            OP_ARRDEDUCIBLES.EXTEND;
            OP_ARRDEDUCIBLES(OP_ARRDEDUCIBLES.COUNT) := L_TYP_DEDUCIBLE;
            L_TITULOS := 1;
            L_CODCOBANT := REG_B20.COD_COB;
          END IF;
        
          L_TYP_DEDUCIBLE         := NEW SIM_TYP_DEDUCIBLES();
          L_TYP_DEDUCIBLE.COD_COB := REG_B20.COD_COB;
          L_TYP_DEDUCIBLE.OPCION  := REG_B20.TIPO_FRANQ;
          L_TYP_DEDUCIBLE.CAMPO4  := REG_B20.DESCUENT_PRIMA;
        
          IF REG_B20.COD_MON = L_CODMON THEN
            --:B20.MCA_FRANQ := NULL;
            --:B20.MCA_MIN   := NULL;
            --:B20.MCA_MAX   := NULL;
            IF REG_B20.IMP_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO1 := REG_B20.IMP_FRANQ;
            ELSE
              IF REG_B20.PORC_FRANQ IS NOT NULL THEN
                L_TYP_DEDUCIBLE.CAMPO1 := REG_B20.PORC_FRANQ || ' %';
              END IF;
            END IF;
          
            IF REG_B20.MIN_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO2 := REG_B20.MIN_FRANQ;
            ELSE
              IF REG_B20.PORC_MIN IS NOT NULL THEN
                L_TYP_DEDUCIBLE.CAMPO2 := REG_B20.PORC_MIN || ' %';
              END IF;
            END IF;
          
            IF REG_B20.MAX_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO3 := REG_B20.MAX_FRANQ;
            ELSE
              IF REG_B20.PORC_MAX IS NOT NULL THEN
                L_TYP_DEDUCIBLE.CAMPO3 := REG_B20.PORC_MAX || ' %';
              END IF;
            END IF;
          ELSE
            DECLARE
              CURSOR DATOS IS
                SELECT ROUND(NVL(REG_B20.IMP_FRANQ, 0) * TC1 /
                             DECODE(L_CODMON, 1, 1, L_TC),
                             2),
                       ROUND(NVL(REG_B20.MAX_FRANQ, 0) * TC1 /
                             DECODE(L_CODMON, 1, 1, L_TC),
                             2),
                       ROUND(NVL(REG_B20.MIN_FRANQ, 0) * TC1 /
                             DECODE(L_CODMON, 1, 1, L_TC),
                             2)
                  FROM A1000500
                 WHERE COD_MON = REG_B20.COD_MON
                   AND FECHA_TIPO_CAMBIO <= L_FECHAVIGMOV
                 ORDER BY FECHA_TIPO_CAMBIO DESC;
            BEGIN
              OPEN DATOS;
            
              LOOP
                FETCH DATOS
                  INTO L_TYP_DEDUCIBLE.CAMPO1,
                       L_TYP_DEDUCIBLE.CAMPO2,
                       L_TYP_DEDUCIBLE.CAMPO3;
              
                IF DATOS%NOTFOUND AND DATOS%ROWCOUNT = 0 THEN
                  CLOSE DATOS;
                
                  RAISE NO_DATA_FOUND;
                END IF;
              
                CLOSE DATOS;
              
                EXIT;
              END LOOP;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
              WHEN OTHERS THEN
                NULL;
            END;
          
            IF REG_B20.PORC_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO1 := REG_B20.PORC_FRANQ || ' %';
            END IF;
          
            IF REG_B20.PORC_MIN IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO2 := REG_B20.PORC_MIN || ' %';
            END IF;
          
            IF REG_B20.PORC_MAX IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO3 := REG_B20.PORC_MAX || ' %';
            END IF;
          END IF;
        
          OP_ARRDEDUCIBLES.EXTEND;
          OP_ARRDEDUCIBLES(OP_ARRDEDUCIBLES.COUNT) := L_TYP_DEDUCIBLE;
          /*=====================  FB20  =======================*/
        END LOOP;
      ELSE
        FOR REG_B21 IN B21 LOOP
          NULL;
          /*=====================    B21   =======================*/
          /* SI LA COBERTURA TRATADA FIGURA EN LA TABLA C1010170, DEBE VERIFICAR-
          SE QUE LOS DEDUCIBLES RESCATADOS SE ENCUENTREN DENTRO DE ESTA PARA
          EL VALOR DEL 0 KM. */
          /* */
        
          L_IRATITULOS := 'N';
        
          BEGIN
            SELECT ''
              INTO L_GLOBAL_TRUCHA
              FROM C1010170
             WHERE COD_CIA = L_CODCIA
               AND COD_RAMO = L_CODRAMO
               AND COD_COB = L_CODCOB;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              L_IRATITULOS := 'S';
            WHEN OTHERS THEN
              NULL;
          END;
        
          IF L_IRATITULOS = 'N' THEN
            BEGIN
              SELECT ''
                INTO L_GLOBAL_TRUCHA
                FROM C1010170
               WHERE COD_CIA = L_CODCIA
                 AND COD_RAMO = L_CODRAMO
                 AND COD_COB = L_CODCOB
                 AND TIPO_FRANQ = REG_B21.TIPO_FRANQ
                 AND COD_MON = L_CODMON
                 AND COD_ZONA IN (L_CODZONA, 999)
                 AND COD_TIPO = L_CODTIPO
                 AND FECHA_BAJA IS NULL
                 AND SIM_PCK_REGLAS.G_PARAMETROS('B35_SUMA_ASEG_0KM') BETWEEN
                     LIM_INF AND LIM_SUP;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                OP_RESULTADO := -1;
                RAISE_APPLICATION_ERROR(-20000,
                                        'Sin datos C1010170...' || SQLERRM);
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
        
          IF L_TITULOS = 0 OR L_CODCOBANT != REG_B21.COD_COB THEN
            L_TYP_DEDUCIBLE         := NEW SIM_TYP_DEDUCIBLES();
            L_TYP_DEDUCIBLE.OPCION  := 0;
            L_TYP_DEDUCIBLE.COD_COB := REG_B21.COD_COB;
          
            --      <<TITULOS>>
            IF REG_B21.FOR_APLI_FRANQ = 'ASEG' THEN
              L_TYP_DEDUCIBLE.CAMPO1 := 'DED(Val.Asegurado)';
            END IF;
          
            IF REG_B21.FOR_APLI_FRANQ = 'ABLE' THEN
              L_TYP_DEDUCIBLE.CAMPO1 := 'DED(Val.Asegurable)';
            END IF;
          
            IF REG_B21.FOR_APLI_FRANQ = 'PERD' THEN
              L_TYP_DEDUCIBLE.CAMPO1 := 'DED(Costo/Perdida)';
            END IF;
          
            IF REG_B21.FOR_APLI_MIN = 'ASEG' THEN
              L_TYP_DEDUCIBLE.CAMPO2 := 'MIN(Val.Asegurado)';
            END IF;
          
            IF REG_B21.FOR_APLI_MIN = 'ABLE' THEN
              L_TYP_DEDUCIBLE.CAMPO2 := 'MIN(Val.Asegurable)';
            END IF;
          
            IF REG_B21.FOR_APLI_MIN = 'PERD' THEN
              L_TYP_DEDUCIBLE.CAMPO2 := 'MIN(Costo/Perdida)';
            END IF;
          
            IF REG_B21.FOR_APLI_MAX = 'ASEG' THEN
              L_TYP_DEDUCIBLE.CAMPO3 := 'MAX(Val.Asegurado)';
            END IF;
          
            IF REG_B21.FOR_APLI_MAX = 'ABLE' THEN
              L_TYP_DEDUCIBLE.CAMPO3 := 'MAX(Val.Asegurable)';
            END IF;
          
            IF REG_B21.FOR_APLI_MAX = 'PERD' THEN
              L_TYP_DEDUCIBLE.CAMPO3 := 'MAX(Costo/Perdida)';
            END IF;
          
            OP_ARRDEDUCIBLES.EXTEND;
            OP_ARRDEDUCIBLES(OP_ARRDEDUCIBLES.COUNT) := L_TYP_DEDUCIBLE;
            L_TITULOS := 1;
            L_CODCOBANT := REG_B21.COD_COB;
          END IF;
        
          L_TYP_DEDUCIBLE         := NEW SIM_TYP_DEDUCIBLES();
          L_TYP_DEDUCIBLE.COD_COB := REG_B21.COD_COB;
          L_TYP_DEDUCIBLE.OPCION  := REG_B21.TIPO_FRANQ;
          L_TYP_DEDUCIBLE.CAMPO4  := REG_B21.DESCUENT_PRIMA;
        
          IF REG_B21.COD_MON = L_CODMON THEN
            --               :B21.MCA_FRANQ := NULL;
            --               :B21.MCA_MIN   := NULL;
            --               :B21.MCA_MAX   := NULL;
            IF REG_B21.IMP_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO1 := REG_B21.IMP_FRANQ;
            ELSE
              IF REG_B21.PORC_FRANQ IS NOT NULL THEN
                L_TYP_DEDUCIBLE.CAMPO1 := REG_B21.PORC_FRANQ || ' %';
              END IF;
            END IF;
          
            IF REG_B21.MIN_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO2 := REG_B21.MIN_FRANQ;
            ELSE
              IF REG_B21.PORC_MIN IS NOT NULL THEN
                L_TYP_DEDUCIBLE.CAMPO2 := REG_B21.PORC_MIN || ' %';
              END IF;
            END IF;
          
            IF REG_B21.MAX_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO3 := REG_B21.MAX_FRANQ;
            ELSE
              IF REG_B21.PORC_MAX IS NOT NULL THEN
                L_TYP_DEDUCIBLE.CAMPO3 := REG_B21.PORC_MAX || ' %';
              END IF;
            END IF;
          ELSE
            DECLARE
              CURSOR DATOS IS
                SELECT ROUND(NVL(REG_B21.IMP_FRANQ, 0) * TC1 /
                             DECODE(L_CODMON, 1, 1, L_TC),
                             2),
                       ROUND(NVL(REG_B21.MAX_FRANQ, 0) * TC1 /
                             DECODE(L_CODMON, 1, 1, L_TC),
                             2),
                       ROUND(NVL(REG_B21.MIN_FRANQ, 0) * TC1 /
                             DECODE(L_CODMON, 1, 1, L_TC),
                             2)
                  FROM A1000500
                 WHERE COD_MON = L_CODMON
                   AND FECHA_TIPO_CAMBIO <= L_FECHAVIGMOV
                 ORDER BY FECHA_TIPO_CAMBIO DESC;
            BEGIN
              OPEN DATOS;
            
              LOOP
                FETCH DATOS
                  INTO L_TYP_DEDUCIBLE.CAMPO1,
                       L_TYP_DEDUCIBLE.CAMPO2,
                       L_TYP_DEDUCIBLE.CAMPO3;
              
                IF DATOS%NOTFOUND AND DATOS%ROWCOUNT = 0 THEN
                  CLOSE DATOS;
                
                  RAISE NO_DATA_FOUND;
                END IF;
              
                CLOSE DATOS;
              
                EXIT;
              END LOOP;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
              WHEN OTHERS THEN
                NULL;
            END;
          
            IF REG_B21.PORC_FRANQ IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO1 := REG_B21.PORC_FRANQ || ' %';
            END IF;
          
            IF REG_B21.PORC_MIN IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO2 := REG_B21.PORC_MIN || ' %';
            END IF;
          
            IF REG_B21.PORC_MAX IS NOT NULL THEN
              L_TYP_DEDUCIBLE.CAMPO3 := REG_B21.PORC_MAX || ' %';
            END IF;
          END IF;
        
          OP_ARRDEDUCIBLES.EXTEND;
          OP_ARRDEDUCIBLES(OP_ARRDEDUCIBLES.COUNT) := L_TYP_DEDUCIBLE;
          /*           IF :B5.TIPO_FRANQ = :B21.TIPO_FRANQ THEN
                           F3_DISPLAY_FIELD ('B21.TIPO_FRANQ'    ,'BOLD-INVERSE');
                           F3_DISPLAY_FIELD ('B21.DEDUCIBLE'     ,'BOLD-INVERSE');
                           F3_DISPLAY_FIELD ('B21.MINIMO'        ,'BOLD-INVERSE');
                           F3_DISPLAY_FIELD ('B21.MAXIMO'        ,'BOLD-INVERSE');
                           F3_DISPLAY_FIELD ('B21.DESCUENT_PRIMA','BOLD-INVERSE');
                           :B5.DESCUENT_PRIMA := NVL(:B21.DESCUENT_PRIMA,0)/100;
                     END IF;
          */
        /*=====================    FB21   =======================*/
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, G_SUBPROGRAMA, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_DEDUCIBLES;

  PROCEDURE PROC_INTEGRAPREINS(IP_INSPECCION  IN NUMBER,
                               IP_PRESUPUESTO IN NUMBER,
                               OP_PRESINSPECC OUT SIM_TYP_PRESUPINSP,
                               IP_VALIDACION  IN VARCHAR2,
                               IP_PROCESO     IN SIM_TYP_PROCESO,
                               OP_RESULTADO   OUT NUMBER,
                               OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    L_PRODUCTO         SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 0;
    L_ID_PRODUCTO      SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 0;
    L_NUMEND           SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 0;
    L_CODRIES          SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO := 1;
    L_NUMSECUPOL       SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA := 0;
    L_DESC_ACCES       A1041100.DESC_ACCES%TYPE;
    L_VALIDACION       SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_ACCESORIOS       SIM_TYP_AUTOSACCESORIOS;
    OP_TYP_TERCERO     SIM_TYP_TERCERO;
    IP_ARRCONTEXTO     SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    OP_ARRCONTEXTO     SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    L_PRIMER_NOMBRE    VARCHAR2(100);
    L_SEGUNDO_NOMBRE   VARCHAR2(100);
    L_PRIMER_APELLIDO  VARCHAR2(100);
    L_SEGUNDO_APELLIDO VARCHAR2(100);
    L_MARCA            A2040100.COD_MARCA%TYPE;
    L_MODELO           A2040100.COD_MOD%TYPE;
    L_NUMCOTIZACION    A2000030.NUM_POL_COTIZ%TYPE;
    L_NUMPOL1          A2000030.NUM_POL1%TYPE;
    L_TIPOPROCESO      SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO;
    L_PROCESO          SIM_TYP_PROCESO;
    L_MCAPROVISORIO    A2000030.MCA_PROVISORIO%TYPE;
    L_TIPOENVIO        A2000030.SIM_TIPO_ENVIO%TYPE;
    L_SUBPRODUCTO      A2000030.SIM_SUBPRODUCTO%TYPE;
    L_AGENTE           A2000030.COD_PROD%TYPE;
    L_TDOCTOMAD        A2000030.TDOC_TERCERO%TYPE;
    L_DOCTOMAD         A2000030.NRO_DOCUMTO%TYPE;
    L_TDOCASEG         A2000030.TDOC_TERCERO%TYPE;
    L_DOCASEG          A2000030.NRO_DOCUMTO%TYPE;
    L_TDOCBENEF        A2000030.TDOC_TERCERO%TYPE;
    L_DOCBENEF         A2000030.NRO_DOCUMTO%TYPE;
    L_FECHAINSPEC      DATE;
    L_DIASINSPEC       NUMBER;
    L_DATOSAGENTE      IP_PROCESO.P_INFO3%TYPE;
    L_DATOSADIC        IP_PROCESO.P_INFO3%TYPE;
    L_TIPO             VARCHAR2(2);
    L_ASEGURABLE       SIM_INSPECCION_AUTOS.ASEGURABLE%TYPE;
  
    CURSOR C_ACCES IS
      SELECT SIAA.COD_ACCES, SIAA.ORIGINAL, SIAA.MARCA_SERIE, SIAA.VALOR
        FROM SIM_INSPECCION_AUTOS_ACCES SIAA
       WHERE SIAA.NRO_INSPECCION = IP_INSPECCION;
  BEGIN
    --sim_proc_log('Seguimiento entrando a integrapreins inspeccion',Ip_inspeccion);
    --sim_proc_log('Seguimiento entrando a integrapreins presupuesto',Ip_presupuesto);
    L_ERROR        := NEW SIM_TYP_ERROR;
    OP_ARRERRORES  := NEW SIM_TYP_ARRAY_ERROR();
    OP_PRESINSPECC := NEW SIM_TYP_PRESUPINSP();
    L_ACCESORIOS   := NEW SIM_TYP_AUTOSACCESORIOS();
    L_PROCESO      := NEW SIM_TYP_PROCESO();
    L_DATOSAGENTE  := IP_PROCESO.P_INFO2;
    L_DATOSADIC    := IP_PROCESO.P_INFO3;
  
    OP_RESULTADO := 0;
  
    IF NVL(IP_INSPECCION, 0) = 0 AND NVL(IP_PROCESO.P_CANAL, 0) <> 3 THEN
      -- Se adiciona la condicion de p_canal = 3 ya que la inspeccion no es obligatoria
      -- cuando viene de SimonQuotation -- Wesv 20140702
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000,
                              'Falta Número de Cotización o es Negativo Nro:' ||
                              IP_INSPECCION);
    END IF;
  
    IF NVL(IP_PRESUPUESTO, 0) <= 0 THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000,
                              'Falta Número de Cotización o es Negativo Nro:' ||
                              IP_PRESUPUESTO);
    END IF;
  
    BEGIN
      SELECT S.INTERMEDIARIO,
             S.OTROSV,
             S.COD_MARCA,
             S.COD_MOD,
             S.PLACA,
             S.COLOR,
             S.NRO_MOTOR,
             S.NRO_CHASIS,
             S.COD_USO,
             S.COD_TIPO,
             S.CPOS_RIES,
             S.VALOR_ASEG,
             S.CIA_ASEG,
             S.FECHA,
             NVL(S.ASEGURABLE, 'S')
      
        INTO L_AGENTE,
             OP_PRESINSPECC.OTRAS_VINC,
             OP_PRESINSPECC.MARCA,
             OP_PRESINSPECC.MODELO,
             OP_PRESINSPECC.PLACA,
             OP_PRESINSPECC.COLOR,
             OP_PRESINSPECC.MOTOR,
             OP_PRESINSPECC.CHASIS,
             OP_PRESINSPECC.USO,
             OP_PRESINSPECC.TIPO,
             OP_PRESINSPECC.LOCALIDAD_VEHICULO,
             OP_PRESINSPECC.SUMA_ASEG,
             OP_PRESINSPECC.CIA_ASEG,
             L_FECHAINSPEC,
             L_ASEGURABLE
      
        FROM SIM_INSPECCION_AUTOS S
       WHERE S.NRO_INSPECCION = IP_INSPECCION;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000, 'Número de Inspección No Existe');
      WHEN OTHERS THEN
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000,
                                'Error Recuperando Inspección :' || SQLERRM);
    END;
  
    IF L_ASEGURABLE = 'N' THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000,
                              'Vehiculo no es Asegurable Segun inspección ');
    END IF;
  
    BEGIN
    
      FOR REG_ACCES IN C_ACCES LOOP
        L_DESC_ACCES := NULL;
      
        BEGIN
          SELECT T.DESC_ACCES
            INTO L_DESC_ACCES
            FROM A1041100 T
           WHERE T.COD_CIA = 3
             AND T.COD_ACCES = REG_ACCES.COD_ACCES;
        EXCEPTION
          WHEN OTHERS THEN
            L_DESC_ACCES := NULL;
        END;
      
        OP_PRESINSPECC.ACCESORIOS.EXTEND;
        L_ACCESORIOS.COD_ACCES   := SIM_TYP_LOOKUP(REG_ACCES.COD_ACCES,
                                                   L_DESC_ACCES);
        L_ACCESORIOS.VALOR_ACCES := REG_ACCES.VALOR;
        IF REG_ACCES.ORIGINAL = 'S' THEN
          L_ACCESORIOS.MCA_TAR := 'N';
        ELSE
          L_ACCESORIOS.MCA_TAR := 'S';
        END IF;
        L_ACCESORIOS.DESC_ACCES := REG_ACCES.MARCA_SERIE;
        OP_PRESINSPECC.ACCESORIOS(OP_PRESINSPECC.ACCESORIOS.COUNT) := L_ACCESORIOS;
      END LOOP;
    END;
  
    BEGIN
      SELECT A.NUM_POL1
        INTO L_NUMPOL1
        FROM A2000030 A
       WHERE A.NUM_POL_COTIZ = IP_PRESUPUESTO
         AND A.NUM_END = L_NUMEND
         AND A.NUM_POL1 IS NOT NULL
         AND A.COD_SECC = 1
         AND A.COD_CIA = 3;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL; --Asume que no se ha formalizado
    END;
  
    IF L_NUMPOL1 IS NOT NULL THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000,
                              'Cotización previamente formalizada con Póliza' ||
                              L_NUMPOL1);
    END IF;
  
    L_NUMSECUPOL := 0;
  
    BEGIN
      SELECT A.COD_CIA,
             A.COD_SECC,
             A.COD_RAMO,
             NVL(A.SIM_SUBPRODUCTO, 251),
             FECHA_EMI_END,
             FECHA_VIG_POL,
             TDOC_TERCERO,
             NRO_DOCUMTO,
             NUM_SECU_POL,
             NUM_POL1 -- wesv
            ,
             MCA_PROVISORIO,
             A.SIM_TIPO_ENVIO,
             FECHA_VENC_POL,
             A.SIM_SUBPRODUCTO,
             MONTHS_BETWEEN(A.FECHA_VENC_POL, A.FECHA_VIG_POL)
        INTO OP_PRESINSPECC.COD_CIA,
             OP_PRESINSPECC.SECCION,
             L_PRODUCTO,
             OP_PRESINSPECC.SIM_SUBPRODUCTO,
             OP_PRESINSPECC.FECHA_EMI_END,
             OP_PRESINSPECC.FECHA_VIG_POL,
             OP_PRESINSPECC.TDOC_TOMADOR,
             OP_PRESINSPECC.ID_TOMADOR,
             L_NUMSECUPOL,
             L_NUMPOL1 -- wesv
            ,
             L_MCAPROVISORIO,
             L_TIPOENVIO,
             OP_PRESINSPECC.FECHA_VENC_POL,
             L_SUBPRODUCTO,
             OP_PRESINSPECC.PERIODICIDAD
        FROM A2000030 A -- wesv
       WHERE A.NUM_POL_COTIZ = IP_PRESUPUESTO -- wesv
            --       AND a.num_pol1 IS NULL
         AND A.NUM_END = L_NUMEND
         AND A.COD_SECC = 1
         AND A.COD_CIA = 3;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000, 'Número de Cotización No Existe');
      WHEN OTHERS THEN
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000,
                                'Error Recuperando Cotización :' || SQLERRM);
    END;
  
    BEGIN
      SELECT DIAS_INSPECCION
        INTO L_DIASINSPEC
        FROM C1010791
       WHERE COD_RAMO = L_SUBPRODUCTO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF SYSDATE > L_FECHAINSPEC + L_DIASINSPEC THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000,
                              'Error Inspección Con mas de :' ||
                              L_DIASINSPEC || ' Dias');
    END IF;
  
    BEGIN
      SELECT CODIGO
        INTO L_AGENTE
        FROM C9999909
       WHERE COD_TAB = 'SUBPRODCLAVEDIR'
         AND DAT_NUM = L_SUBPRODUCTO
         AND COD_RAMO = L_PRODUCTO
         AND FECHA_BAJA IS NULL;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    OP_PRESINSPECC.COD_PROD   := L_AGENTE;
    OP_PRESINSPECC.NUMSECUPOL := L_NUMSECUPOL;
  
    L_NUMPOL1 := 0;
  
    --  comentario por wesv
    BEGIN
      SELECT NVL(NUM_POL1, 0)
        INTO L_NUMPOL1
        FROM A2000030
       WHERE NUM_SECU_POL = L_NUMSECUPOL
         AND NUM_END = 0;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF L_NUMPOL1 > 0 THEN
      IF NVL(L_MCAPROVISORIO, 'N') = 'S' THEN
        L_ERROR := SIM_TYP_ERROR(-20000,
                                 'Cotización ya Convertida a Poliza Provisoria Nro.' ||
                                 L_NUMPOL1,
                                 'W');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := 1;
      ELSE
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000,
                                'Cotización ya Convertida a Poliza Nro.' ||
                                L_NUMPOL1);
      END IF;
    END IF;
  
    BEGIN
      SELECT E.COD_RAMO_VEH,
             D.SUMA_ACCES,
             E.COD_MARCA,
             E.COD_MOD,
             D.SUMA_ASEG
        INTO OP_PRESINSPECC.OPCION_COBER,
             OP_PRESINSPECC.SUMA_ACCES,
             L_MARCA,
             L_MODELO,
             OP_PRESINSPECC.SUMA_ASEG
        FROM A2040300 D, A2040100 E
       WHERE D.NUM_SECU_POL = L_NUMSECUPOL
         AND D.NUM_END = L_NUMEND
         AND E.NUM_SECU_POL = D.NUM_SECU_POL
         AND E.NUM_END = D.NUM_END;
    EXCEPTION
      WHEN OTHERS THEN
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000, 'Tabla A2040100 ' || SQLERRM);
    END;
  
    IF OP_PRESINSPECC.MARCA != L_MARCA THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000,
                              'Cotización e Inspección, No son la misma Marca');
    END IF;
  
    IF OP_PRESINSPECC.MODELO != L_MODELO THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000,
                              'Cotización e Inspección, No son el mismo modelo');
    END IF;
  
    IF OP_PRESINSPECC.MODELO < TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY') - 9) THEN
      OP_RESULTADO := -1;
      RAISE_APPLICATION_ERROR(-20000, 'Modelo inferior al permitido ');
    END IF;
  
    BEGIN
      SELECT D.NOM_COND,
             D.FECHA_NAC_COND,
             D.COD_PROF,
             D.COD_SEXO,
             D.COD_EST_CIV
        INTO OP_PRESINSPECC.NOMBRES,
             OP_PRESINSPECC.FECHA_NAC,
             OP_PRESINSPECC.OCUPACION,
             OP_PRESINSPECC.SEXO,
             OP_PRESINSPECC.EST_CIVIL
      --      From    P2040400 d --  wesv
        FROM A2040400 D
       WHERE D.NUM_SECU_POL = L_NUMSECUPOL
         AND D.NOM_COND IS NOT NULL
         AND ROWNUM <= 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      WHEN OTHERS THEN
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000, 'Tabla a2040400 ' || SQLERRM);
    END;
  
    /*   -- wesv
      Op_PresInspecc.conduct_menor_25   := sim_pck_funcion_gen.FUN_RESCATA_P2000020('AUTO_OTROSCOND',l_numsecupol,l_codries);
       Op_PresInspecc.RC_suplementaria   := sim_pck_funcion_gen.FUN_RESCATA_P2000020('OPCION_RC_BAS',l_numsecupol,l_codries);
       Op_PresInspecc.vehiculo_reemplazo := sim_pck_funcion_gen.FUN_RESCATA_P2000020('OPC_REEMP',l_numsecupol,l_codries);
       Op_PresInspecc.deduc_cobertura_rc := sim_pck_funcion_gen.FUN_RESCATA_P2000020('OPCION_370',l_numsecupol,l_codries);
       Op_PresInspecc.deduc_ptd          := sim_pck_funcion_gen.FUN_RESCATA_P2000020('OPCION_371',l_numsecupol,l_codries);
       Op_PresInspecc.deduc_ppd          := sim_pck_funcion_gen.FUN_RESCATA_P2000020('OPCION_372',l_numsecupol,l_codries);
       Op_PresInspecc.deduc_hurto        := sim_pck_funcion_gen.FUN_RESCATA_P2000020('OPCION_374',l_numsecupol,l_codries);
       Op_PresInspecc.bonificacion       := sim_pck_funcion_gen.FUN_RESCATA_P2000020('BONUS_O_MALUS',l_numsecupol,l_codries);
       Op_PresInspecc.nro_certif         := sim_pck_funcion_gen.FUN_RESCATA_P2000020('CERT_BONIF_ANT',l_numsecupol,l_codries);
       Op_PresInspecc.oneroso            := sim_pck_funcion_gen.FUN_RESCATA_P2000020('BENEF_ONEROSO',l_numsecupol,l_codries);
       Op_PresInspecc.Tdoc_benef         := sim_pck_funcion_gen.FUN_RESCATA_P2000020('TIPO_DOC_BENEF',l_numsecupol,l_codries);
       Op_PresInspecc.id_benef           := sim_pck_funcion_gen.FUN_RESCATA_P2000020('BENEFICIARIO',l_numsecupol,l_codries);
       Op_PresInspecc.nombre_benef       := sim_pck_funcion_gen.FUN_RESCATA_P2000020('RAZ_SOC_BENEF',l_numsecupol,l_codries);
    */
    OP_PRESINSPECC.COD_OFI_BAN        := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('COD_OFI_DAVI',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.COD_EMP_BAN        := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('PROMOTOR_DA',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.CONDUCT_MENOR_25   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('AUTO_OTROSCOND',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.OTRAS_VINC         := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('AUTO_OTRAVINC',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.RC_SUPLEMENTARIA   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('OPCION_RC_SUP',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.VEHICULO_REEMPLAZO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('OPC_REEMP',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.DEDUC_COBERTURA_RC := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('OPCION_370',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.DEDUC_PTD          := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('OPCION_371',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.DEDUC_PPD          := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('OPCION_372',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.DEDUC_HURTO        := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('OPCION_374',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.BONIFICACION       := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('BONUS_O_MALUS',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.NRO_CERTIF         := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('CERT_BONIF_ANT',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.ONEROSO            := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('BENEF_ONEROSO',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.TDOC_BENEF         := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('TIPO_DOC_BENEF',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.ID_BENEF           := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('BENEFICIARIO',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.NOMBRE_BENEF       := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('RAZ_SOC_BENEF',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    OP_PRESINSPECC.LOCALIDAD_VEHICULO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('ZON_RADIC_RIES',
                                                                                  L_NUMSECUPOL,
                                                                                  L_CODRIES);
    --Ini: mantis: 25949 14/10/2015 - mcolorado
    IF (SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('LIMITE_RENTA',
                                                 L_NUMSECUPOL,
                                                 '') IS NOT NULL) AND
       (SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('PERIODO_INDEM',
                                                 L_NUMSECUPOL,
                                                 '') IS NOT NULL) AND
       (SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('DED_RENTA',
                                                 L_NUMSECUPOL,
                                                 '') IS NOT NULL) THEN
      OP_PRESINSPECC.RENTA_DIA := SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                         'TXT_RTDIA_VLR_COB') ||
                                  SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('LIMITE_RENTA',
                                                                           L_NUMSECUPOL,
                                                                           '') ||
                                  SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                         'TXT_RTDIA_COB_MAX') ||
                                  SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('PERIODO_INDEM',
                                                                           L_NUMSECUPOL,
                                                                           '') ||
                                  SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                         'TXT_RTDIA_DEDUC') ||
                                  SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('DED_RENTA',
                                                                           L_NUMSECUPOL,
                                                                           '') ||
                                  SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                         'TXT_RTDIA_DIAS');
    END IF;
    IF (SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('RENTA',
                                                 L_NUMSECUPOL,
                                                 L_CODRIES) IS NOT NULL) AND
       (SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('PERIODO_INMOB',
                                                 L_NUMSECUPOL,
                                                 L_CODRIES) IS NOT NULL) AND
       (SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('DED_RENTA_I',
                                                 L_NUMSECUPOL,
                                                 L_CODRIES) IS NOT NULL) THEN
      OP_PRESINSPECC.RENTA_DIA_INM := SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                             'TXT_RTDIA_VLR_COB') ||
                                      SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('RENTA',
                                                                               L_NUMSECUPOL,
                                                                               L_CODRIES) ||
                                      SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                             'TXT_RTDIA_COB_MAX') ||
                                      SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('PERIODO_INMOB',
                                                                               L_NUMSECUPOL,
                                                                               L_CODRIES) ||
                                      SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                             'TXT_RTDIA_DEDUC') ||
                                      SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('DED_RENTA_I',
                                                                               L_NUMSECUPOL,
                                                                               L_CODRIES) ||
                                      SIM_PCK_FUNCION_GEN.OBTENERVALORTABCAR('TEXT_RENTA_DIARIA',
                                                                             'TXT_RTDIA_DIAS');
    END IF;
    --Fin: mantis: 25949 14/10/2015 - mcolorado
  
    IF SIM_PCK_FUNCION_GEN.FUN_POLIZA_ELECTRONICA(OP_PRESINSPECC.COD_CIA,
                                                  OP_PRESINSPECC.SECCION,
                                                  L_PRODUCTO,
                                                  OP_PRESINSPECC.SIM_SUBPRODUCTO) = 'S' THEN
      OP_PRESINSPECC.TIPO_ENVIO_POLIZA := L_TIPOENVIO;
    ELSE
      OP_PRESINSPECC.TIPO_ENVIO_POLIZA := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2000020('MODO_IMPRIME',
                                                                                   L_NUMSECUPOL,
                                                                                   L_CODRIES);
    END IF;
  
    BEGIN
      SELECT ID_PRODUCTO
        INTO L_ID_PRODUCTO
        FROM SIM_PRODUCTOS
       WHERE COD_PRODUCTO = L_PRODUCTO;
    EXCEPTION
      WHEN OTHERS THEN
        OP_RESULTADO := -1;
        RAISE_APPLICATION_ERROR(-20000,
                                'Producto Con error en sim_productos :' ||
                                SQLERRM);
    END;
  
    OP_PRESINSPECC.PRODUCTO := SIM_TYP_LOOKUP(L_PRODUCTO, L_ID_PRODUCTO);
  
    L_TDOCTOMAD := OP_PRESINSPECC.TDOC_TOMADOR;
    L_DOCTOMAD  := OP_PRESINSPECC.ID_TOMADOR;
    L_TDOCASEG  := OP_PRESINSPECC.TDOC_TOMADOR;
    L_DOCASEG   := OP_PRESINSPECC.ID_TOMADOR;
    L_TDOCBENEF := OP_PRESINSPECC.TDOC_BENEF;
    L_DOCBENEF  := OP_PRESINSPECC.ID_BENEF;
  
    IF L_SUBPRODUCTO IN (288, 310, 311, 277, 279) THEN
      OP_PRESINSPECC.NOMBRE_BENEF := NULL;
      OP_PRESINSPECC.ONEROSO      := 'S';
    
      BEGIN
        SELECT A.CODIGO1, A.DAT_CAR
          INTO L_DOCTOMAD, L_TDOCTOMAD
          FROM C9999909 A
         WHERE A.COD_TAB = 'SIM_SUBPRODTERCDEF'
           AND A.DAT_NUM = L_SUBPRODUCTO
           AND A.COD_RAMO = L_PRODUCTO
           AND A.COD_CAMPO = 'TOMADOR'
              --          And    1 = 2
           AND A.FECHA_BAJA IS NULL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT A.CODIGO1, A.DAT_CAR
          INTO L_DOCBENEF, L_TDOCBENEF
          FROM C9999909 A
         WHERE A.COD_TAB = 'SIM_SUBPRODTERCDEF'
           AND A.DAT_NUM = L_SUBPRODUCTO
           AND A.COD_RAMO = L_PRODUCTO
           AND A.COD_CAMPO = 'BENEFICIARIO'
           AND A.FECHA_BAJA IS NULL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('COD_CIA', OP_PRESINSPECC.COD_CIA);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('COD_SECC', OP_PRESINSPECC.SECCION);
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('COD_RAMO',
                                        OP_PRESINSPECC.PRODUCTO.CODIGO);
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(IP_ARRCONTEXTO);
  
    --Tomador
    BEGIN
      SIM_PCK_PROCESO_DATOS_EMISION.PROC_RECUPERA_TERCERO(L_TDOCTOMAD,
                                                          L_DOCTOMAD,
                                                          OP_TYP_TERCERO,
                                                          IP_VALIDACION,
                                                          IP_ARRCONTEXTO,
                                                          OP_ARRCONTEXTO,
                                                          IP_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END;
  
    OP_PRESINSPECC.PRIMER_NOMBRE    := NULL;
    OP_PRESINSPECC.SEGUNDO_NOMBRE   := NULL;
    OP_PRESINSPECC.PRIMER_APELLIDO  := NULL;
    OP_PRESINSPECC.SEGUNDO_APELLIDO := NULL;
  
    IF OP_RESULTADO = 0 THEN
      BEGIN
        L_PRIMER_NOMBRE    := SUBSTR(OP_TYP_TERCERO.NOMBRES,
                                     1,
                                     INSTR(OP_TYP_TERCERO.NOMBRES, ' '));
        L_SEGUNDO_NOMBRE   := SUBSTR(OP_TYP_TERCERO.NOMBRES,
                                     INSTR(OP_TYP_TERCERO.NOMBRES, ' ') + 1,
                                     LENGTH(OP_TYP_TERCERO.NOMBRES));
        L_PRIMER_APELLIDO  := SUBSTR(OP_TYP_TERCERO.APELLIDOS,
                                     1,
                                     INSTR(OP_TYP_TERCERO.APELLIDOS, ' '));
        L_SEGUNDO_APELLIDO := SUBSTR(OP_TYP_TERCERO.APELLIDOS,
                                     INSTR(OP_TYP_TERCERO.APELLIDOS, ' ') + 1,
                                     LENGTH(OP_TYP_TERCERO.APELLIDOS));
      END;
    
      OP_PRESINSPECC.PRIMER_NOMBRE    := NVL(TRIM(L_PRIMER_NOMBRE),
                                             OP_TYP_TERCERO.RAZON_SOCIAL);
      OP_PRESINSPECC.SEGUNDO_NOMBRE   := L_SEGUNDO_NOMBRE;
      OP_PRESINSPECC.PRIMER_APELLIDO  := L_PRIMER_APELLIDO;
      OP_PRESINSPECC.SEGUNDO_APELLIDO := L_SEGUNDO_APELLIDO;
    ELSE
      BEGIN
        SELECT SUBSTR(C.NOMBRES, 1, INSTR(C.NOMBRES, ' ')),
               SUBSTR(C.NOMBRES,
                      INSTR(C.NOMBRES, ' ') + 1,
                      LENGTH(C.NOMBRES)),
               SUBSTR(C.APELLIDOS, 1, INSTR(C.APELLIDOS, ' ')),
               SUBSTR(C.APELLIDOS,
                      INSTR(C.APELLIDOS, ' ') + 1,
                      LENGTH(C.APELLIDOS))
          INTO OP_PRESINSPECC.PRIMER_NOMBRE,
               OP_PRESINSPECC.SEGUNDO_NOMBRE,
               OP_PRESINSPECC.PRIMER_APELLIDO,
               OP_PRESINSPECC.SEGUNDO_APELLIDO
          FROM SIM_TERCEROS C
         WHERE C.NUM_SECU_POL = L_NUMSECUPOL
           AND C.NUM_END = 0
           AND C.TIPO_DOCUMENTO = L_TDOCTOMAD
           AND C.NUMERO_DOCUMENTO = L_DOCTOMAD
           AND C.ROL = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    --Asegurado
    BEGIN
      SIM_PCK_PROCESO_DATOS_EMISION.PROC_RECUPERA_TERCERO(L_TDOCASEG,
                                                          L_DOCASEG,
                                                          OP_TYP_TERCERO,
                                                          IP_VALIDACION,
                                                          IP_ARRCONTEXTO,
                                                          OP_ARRCONTEXTO,
                                                          IP_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END;
  
    OP_PRESINSPECC.PRIMER_NOMBRE_A    := NULL;
    OP_PRESINSPECC.SEGUNDO_NOMBRE_A   := NULL;
    OP_PRESINSPECC.PRIMER_APELLIDO_A  := NULL;
    OP_PRESINSPECC.SEGUNDO_APELLIDO_A := NULL;
  
    IF OP_RESULTADO = 0 THEN
      BEGIN
        L_PRIMER_NOMBRE := SUBSTR(OP_TYP_TERCERO.NOMBRES,
                                  1,
                                  INSTR(OP_TYP_TERCERO.NOMBRES, ' '));
      
        L_SEGUNDO_NOMBRE   := SUBSTR(OP_TYP_TERCERO.NOMBRES,
                                     INSTR(OP_TYP_TERCERO.NOMBRES, ' ') + 1,
                                     LENGTH(OP_TYP_TERCERO.NOMBRES));
        L_PRIMER_APELLIDO  := SUBSTR(OP_TYP_TERCERO.APELLIDOS,
                                     1,
                                     INSTR(OP_TYP_TERCERO.APELLIDOS, ' '));
        L_SEGUNDO_APELLIDO := SUBSTR(OP_TYP_TERCERO.APELLIDOS,
                                     INSTR(OP_TYP_TERCERO.APELLIDOS, ' ') + 1,
                                     LENGTH(OP_TYP_TERCERO.APELLIDOS));
      END;
    
      OP_PRESINSPECC.PRIMER_NOMBRE_A    := SUBSTR(NVL(TRIM(L_PRIMER_NOMBRE),
                                                      OP_TYP_TERCERO.RAZON_SOCIAL),
                                                  1,
                                                  60);
      OP_PRESINSPECC.SEGUNDO_NOMBRE_A   := SUBSTR(L_SEGUNDO_NOMBRE, 1, 60);
      OP_PRESINSPECC.PRIMER_APELLIDO_A  := SUBSTR(L_PRIMER_APELLIDO, 1, 60);
      OP_PRESINSPECC.SEGUNDO_APELLIDO_A := SUBSTR(L_SEGUNDO_APELLIDO, 1, 60);
    ELSE
      BEGIN
        SELECT SUBSTR(C.NOMBRES, 1, INSTR(C.NOMBRES, ' ')),
               SUBSTR(C.NOMBRES,
                      INSTR(C.NOMBRES, ' ') + 1,
                      LENGTH(C.NOMBRES)),
               SUBSTR(C.APELLIDOS, 1, INSTR(C.APELLIDOS, ' ')),
               SUBSTR(C.APELLIDOS,
                      INSTR(C.APELLIDOS, ' ') + 1,
                      LENGTH(C.APELLIDOS))
          INTO OP_PRESINSPECC.PRIMER_NOMBRE_A,
               OP_PRESINSPECC.SEGUNDO_NOMBRE_A,
               OP_PRESINSPECC.PRIMER_APELLIDO_A,
               OP_PRESINSPECC.SEGUNDO_APELLIDO_A
          FROM SIM_TERCEROS C
         WHERE C.NUM_SECU_POL = L_NUMSECUPOL
           AND C.NUM_END = 0
           AND C.TIPO_DOCUMENTO = L_TDOCASEG
           AND C.NUMERO_DOCUMENTO = L_DOCASEG
           AND C.ROL = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    --Beneficiario
    BEGIN
      SIM_PCK_PROCESO_DATOS_EMISION.PROC_RECUPERA_TERCERO(L_TDOCBENEF,
                                                          L_DOCBENEF,
                                                          OP_TYP_TERCERO,
                                                          IP_VALIDACION,
                                                          IP_ARRCONTEXTO,
                                                          OP_ARRCONTEXTO,
                                                          IP_PROCESO,
                                                          OP_RESULTADO,
                                                          OP_ARRERRORES);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE;
    END;
  
    OP_PRESINSPECC.NOMBRE_BENEF := NULL;
  
    IF OP_RESULTADO = 0 THEN
      BEGIN
        OP_PRESINSPECC.NOMBRE_BENEF := NVL(TRIM(OP_TYP_TERCERO.NOMBRES),
                                           OP_TYP_TERCERO.RAZON_SOCIAL);
      END;
    END IF;
  
    /*===============*/
  
    OP_PRESINSPECC.TDOC_BENEF   := L_TDOCBENEF;
    OP_PRESINSPECC.ID_BENEF     := L_DOCBENEF;
    OP_PRESINSPECC.TDOC_TOMADOR := L_TDOCTOMAD;
    OP_PRESINSPECC.ID_TOMADOR   := L_DOCTOMAD;
    OP_PRESINSPECC.TDOC_ASEG    := L_TDOCASEG;
    OP_PRESINSPECC.ID_ASEG      := L_DOCASEG;
  
    BEGIN
      UPDATE A2000020
         SET VALOR_CAMPO = IP_INSPECCION
       WHERE NUM_SECU_POL = L_NUMSECUPOL
         AND COD_CAMPO = 'NRO_INSPECCION';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, G_SUBPROGRAMA || SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_INTEGRAPREINS;

  --Ini RCB: Modificaciones Ventas
  FUNCTION FUN_DESCACCESORIO(IP_CODACC IN A1041100.COD_ACCES%TYPE,
                             IP_CODCIA IN A1041100.COD_CIA%TYPE)
    RETURN VARCHAR IS
    L_CDESCACC A1041100.DESC_ACCES%TYPE;
  BEGIN
    L_CDESCACC := NULL;
    BEGIN
      SELECT T.DESC_ACCES
        INTO L_CDESCACC
        FROM A1041100 T
       WHERE T.COD_CIA = IP_CODCIA
         AND T.COD_ACCES = IP_CODACC;
    EXCEPTION
      WHEN OTHERS THEN
        L_CDESCACC := NULL;
    END;
    RETURN L_CDESCACC;
  END FUN_DESCACCESORIO;

  FUNCTION FUN_DESCMARCA(IP_CODMARCA IN A1040400.COD_MARCA%TYPE,
                         IP_CODCIA   IN A1041100.COD_CIA%TYPE) RETURN VARCHAR IS
    L_CDESCMARCA A1040400.DESC_MARCA%TYPE;
  BEGIN
    L_CDESCMARCA := NULL;
    BEGIN
      SELECT T.DESC_MARCA
        INTO L_CDESCMARCA
        FROM A1040400 T
       WHERE T.COD_CIA = IP_CODCIA
         AND T.COD_MARCA = IP_CODMARCA;
    EXCEPTION
      WHEN OTHERS THEN
        L_CDESCMARCA := NULL;
    END;
    RETURN L_CDESCMARCA;
  END FUN_DESCMARCA;

  FUNCTION FUN_VALASEG(IP_NUMSECUPOL IN A2040300.NUM_SECU_POL%TYPE,
                       IP_NUMEND     IN A2040300.NUM_END%TYPE,
                       OP_SUMACC     OUT A2040300.SUMA_ACCES%TYPE)
    RETURN NUMBER IS
    L_NSUMASEG A2040300.SUMA_ASEG%TYPE;
    L_NSUMACC  A2040300.SUMA_ACCES%TYPE;
  BEGIN
    L_NSUMASEG := 0;
    L_NSUMACC  := 0;
    BEGIN
      SELECT B.SUMA_ASEG, B.SUMA_ACCES
        INTO L_NSUMASEG, L_NSUMACC
        FROM A2040300 B
       WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
         AND B.NUM_END = (SELECT MAX(NUM_END)
                            FROM A2040300 D
                           WHERE D.NUM_SECU_POL = B.NUM_SECU_POL
                             AND NVL(D.COD_RIES, 0) = NVL(B.COD_RIES, 0)
                             AND D.NUM_END <= IP_NUMEND);
    EXCEPTION
      WHEN OTHERS THEN
        L_NSUMASEG := 0;
        L_NSUMACC  := 0;
    END;
  
    OP_SUMACC := L_NSUMACC;
    RETURN L_NSUMASEG;
  END FUN_VALASEG;
  --Fin RCB: Modificaciones Ventas

  --Miguel Angel Manrique Iniciativa 444
  FUNCTION FUN_VALPLACAGENSIMON(IP_PLACA IN VARCHAR2, OP_RETURN OUT NUMBER)
    RETURN NUMBER IS
    OP_COUNT NUMBER;
  BEGIN
    OP_COUNT := 0;
    BEGIN
      --AEEM 06/10/2021 RELACIONADO CON PLACAS TRANSITORIAS GENERADAS
      --Se adicionan las placas de 6 digitos para que genere el campo placa
      SELECT COUNT(1)
        INTO OP_COUNT
        FROM DUAL
       WHERE (IP_PLACA LIKE 'EA%' AND REGEXP_LIKE(IP_PLACA, 'EA[0-9]{4}'))
          OR (REGEXP_LIKE(IP_PLACA, '[0-9]{6}'));
    EXCEPTION
      WHEN OTHERS THEN
        OP_COUNT := 0;
    END;
    OP_RETURN := OP_COUNT;
    RETURN OP_RETURN;
  END FUN_VALPLACAGENSIMON;

  /*------------------------------------------------------*/
  PROCEDURE PROC_CONSOBJPOL(IP_NUMPOL1    IN NUMBER,
                            IP_NUMEND     IN NUMBER,
                            IP_NUMSECUPOL IN NUMBER,
                            IP_TIPO       IN VARCHAR2 -- 'C' Cotizacion 'P' Poliza
                           ,
                            OP_OBJPOLIZA  OUT SIM_TYP_POLIZAGEN,
                            IP_VALIDACION IN VARCHAR2,
                            IP_PROCESO    IN SIM_TYP_PROCESO,
                            OP_RESULTADO  OUT NUMBER,
                            OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_TYP_POLIZA       SIM_TYP_POLIZAGEN;
    L_TYP_DATOSFIJOS   SIM_TYP_DATOSFIJOS;
    L_TYP_PRIMA        SIM_TYP_PRIMA;
    L_ARRAY_TYP_DV     SIM_TYP_ARRAY_DV_GEN;
    L_ARRAY_TYP_COB    SIM_TYP_ARRAY_COBPOLIZASGEN;
    L_ARRAY_TYP_AGE    SIM_TYP_ARRAY_AGENTESPOL;
    L_ARRAY_DF_AUTOS   SIM_TYP_ARRAY_AUTOSDATOSFIJOS;
    L_ARRAY_TERCEROS   SIM_TYP_ARRAY_TERCEROGEN;
    L_TYPTERCGEN       SIM_TYP_TERCEROGEN;
    L_ENCONTROX        NUMBER;
    L_ARRAY_ACCESORIOS SIM_TYP_ARRAY_AUTOSACCESORIOS;
  
    L_ERROR SIM_TYP_ERROR;
  
    L_NUMERO      SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_CODSECC     SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_CODRAMO     SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_SUBPRODUCTO SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_CODCIA      SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_NUMSECUPOL  SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_NUMEND      SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_ENCONTRO    SIM_PCK_TIPOS_GENERALES.T_CARACTER;
  
    L_DATOSRIESGOS       SIM_TYP_RIESGOGEN;
    L_DATOSRIESGO        SIM_TYP_DATOSRIESGO;
    L_ARRRIESGOS         SIM_TYP_ARRAY_DATOSRIESGO;
    L_ARRDATADIC         SIM_TYP_ARRAY_DATOS_ADIC;
    L_DATOADICIONAL      SIM_TYP_DATOS_ADIC;
    L_VIGENTE            SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_VALIDACION         SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_FECHAEMISION       DATE;
    L_SECUENCIA          SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_DESC_TDOC_TERCERO  SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_NOMB_TERCERO       SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    L_NUMDIASVIGENCIACOT SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_PROCESO            SIM_TYP_PROCESO;
    L_TIPOUSER           SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_CANTIDAD           SIM_PCK_TIPOS_GENERALES.T_NUM_VALOR;
    L_NSUMASEG           A2040300.SUMA_ASEG%TYPE;
    L_NSUMACC            A2040300.SUMA_ACCES%TYPE;
    L_EXISTETER          NUMBER(1);
    L_NUMDOC             NUMBER(16);
    L_TIPDOC             VARCHAR2(3);
    L_PRIMERA            VARCHAR2(30);
    L_SEGUNDOA           VARCHAR2(30);
    L_PRIMERN            VARCHAR2(30);
    L_SEGUNDON           VARCHAR2(30);
    L_RAZON_SOCIAL       VARCHAR2(120);
    L_TIPO               VARCHAR2(2);
    L_DESCTIPO           VARCHAR2(50);
    L_EXISTECOBX         NUMBER(1);
    L_CANTMSGS           NUMBER(16) := 0;
    L_PLACAGENERADA      NUMBER(2) := 0;
  
    /*BRGH añade para carga información debito automatico*/
    L_TYP_DEBITOAUT       SIM_TYP_DATOSDEBITOGEN;
    L_ARRAY_TYP_DEBITOAUT SIM_TYP_ARRAY_DATOSDEBITOGEN;
    /*Fin BRGH*/
    /*BRGH a?ade para requerimiento davivienda calculo de IVA en cobertura*/
    L_TASAIMPUESTO A1001000.TASA%TYPE;
    /* fin BRGH*/
  
    CURSOR C_AGE(V_NUMSECUPOL NUMBER, V_NUMEND NUMBER) IS
      SELECT SIM_TYP_AGENTEPOLIZA(NUM_SECU_POL,
                                  NUM_END,
                                  SIM_TYP_LOOKUP(COD_AGENTE, ''),
                                  SIM_TYP_LOOKUP('', '') --,Agencia
                                 ,
                                  FOR_ACTUACION,
                                  COD_CONV,
                                  PORC_PART,
                                  MCA_BASE --,Lider
                                 ,
                                  PORC_PART --,Porc_pactado
                                 ,
                                  COD_BENEF --,Nro_Documento
                                 ,
                                  '' --,Rol
                                 ,
                                  COD_COB,
                                  '' --,cod_ries
                                 ,
                                  CASE FOR_ACTUACION
                                    WHEN 'PR' THEN
                                     NULL
                                    ELSE
                                     DECODE(PORC_COMI_END,
                                            0,
                                            NULL,
                                            PORC_COMI_END)
                                  END) TIPAGE
      --,porc_comision BRGH se a?ade pa solucionar error en PYMES
        FROM A2000250 A
       WHERE NUM_SECU_POL = V_NUMSECUPOL
            --And Num_End = v_Numend
         AND NUM_END = (SELECT MAX(NUM_END)
                          FROM A2000250 D
                         WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                           AND D.NUM_END <= V_NUMEND)
         AND TIPO_REG = 'T';
  
    CURSOR C_DV(V_NUMSECUPOL NUMBER,
                V_NUMEND     NUMBER,
                V_CODRAMO    NUMBER,
                V_CODRIES    NUMBER) IS
      SELECT SIM_TYP_DATOS_VARIABLESGEN(A.NUM_SECU_POL,
                                        A.COD_RIES,
                                        A.NUM_END,
                                        A.COD_CAMPO,
                                        A.COD_NIVEL,
                                        A.COD_COB,
                                        C.TITULO,
                                        -- ini Mantis  56164  --  Modificaciones Autos Fase II Riesgos fuera de politicas
                                        --                                      a.valor_campo
                                        NVL(A.VALOR_CAMPO,
                                            DECODE(B.PGM_HELP,
                                                   NULL,
                                                   A.VALOR_CAMPO,
                                                   '0')),
                                        ' ') TIPDV,
             -- fin Mantis  56164  -  Modificaciones Autos Fase II Riesgos fuera de politicas
             B.COD_NIVEL,
             A.COD_RIES,
             NVL(A.COD_COB, 0) COD_COB,
             -- ini Mantis  56164  -  Modificaciones Autos Fase II Riesgos fuera de politicas
             A.COD_CAMPO,
             NVL(A.VALOR_CAMPO,
                 DECODE(B.PGM_HELP, NULL, A.VALOR_CAMPO, '0')) VALOR_CAMPO,
             A.NUM_SECU_POL,
             A.NUM_END,
             B.COD_RAMO
      -- fin Mantis  56164  -  Modificaciones Autos Fase II Riesgos fuera de politicas
        FROM A2000020 A, G2000020 B, SIM_G2000020 C
       WHERE A.NUM_SECU_POL = V_NUMSECUPOL
            --And a.Num_End = v_Numend
         AND A.NUM_END = (SELECT MAX(NUM_END)
                            FROM A2000020 D
                           WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                             AND NVL(D.COD_RIES, 0) = NVL(A.COD_RIES, 0)
                             AND D.COD_CAMPO = A.COD_CAMPO
                             AND D.NUM_END <= V_NUMEND)
         AND A.COD_CAMPO = B.COD_CAMPO
         AND B.COD_CAMPO = C.COD_CAMPO
         AND B.COD_CIA = L_CODCIA
         AND B.COD_RAMO = V_CODRAMO
         AND B.COD_CIA = C.COD_CIA
         AND B.COD_RAMO = C.COD_RAMO
         AND NVL(A.COD_RIES, 0) = NVL(V_CODRIES, 0);
  
    CURSOR C_COB(V_NUMSECUPOL NUMBER, V_NUMEND NUMBER, V_CODRIES NUMBER) IS
      SELECT COD_RIES,
             COD_COB,
             SIM_TYP_COBERTURAPOLIZAGEN(A.NUM_SECU_POL,
                                        A.NUM_END,
                                        A.COD_RIES,
                                        SIM_TYP_LOOKUP(A.COD_COB,
                                                       SIM_PCK_FUNCION_GEN.COBERTURAS(B.COD_CIA,
                                                                                      B.COD_RAMO,
                                                                                      A.COD_COB)),
                                        NVL(A.SUMA_ASEG, 0),
                                        A.TASA_COB,
                                        A.TASA_TOTAL,
                                        A.PORC_PPAGO,
                                        A.IND_AJUSTE,
                                        A.PRIMA_COB,
                                        A.PORC_REBAJA,
                                        A.TASA_AGR,
                                        A.MCA_GRATUITA,
                                        A.NUM_SECU,
                                        '',
                                        SIM_TYP_LOOKUP('', ''),
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        SIM_TYP_LOOKUP('', ''),
                                        '',
                                        SIM_TYP_LOOKUP('', ''),
                                        '',
                                        '',
                                        '',
                                        SIM_TYP_LOOKUP('Ded', '*'),
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '') TIPCOB
        FROM A2000040 A, A2000030 B
       WHERE A.NUM_SECU_POL = V_NUMSECUPOL
            --And a.Num_End = v_Numend
         AND A.NUM_END = (SELECT MAX(NUM_END)
                            FROM A2000040 D
                           WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                             AND D.COD_RIES = A.COD_RIES
                             AND D.COD_COB = A.COD_COB
                             AND D.NUM_END <= V_NUMEND)
         AND (NVL(A.END_SUMA_ASEG, 0) + NVL(A.END_PRIMA_COB, 0) != 0 OR
             NVL(A.PRIMA_COB, 0) != 0)
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.NUM_END = B.NUM_END
         AND A.COD_RIES = V_CODRIES;
  
    CURSOR C_COBX(V_NUMSECUPOL NUMBER, V_NUMEND NUMBER, V_CODRIES NUMBER) IS
      SELECT COD_RIES,
             COD_COB,
             SIM_TYP_COBERTURAPOLIZAGEN(A.NUM_SECU_POL,
                                        0,
                                        A.COD_RIES,
                                        SIM_TYP_LOOKUP(A.COD_COB,
                                                       SIM_PCK_FUNCION_GEN.COBERTURAS(B.COD_CIA,
                                                                                      B.COD_RAMO,
                                                                                      A.COD_COB)),
                                        A.SUMA_ASEG,
                                        A.TASA_COB,
                                        A.TASA_TOTAL,
                                        A.PORC_PPAGO,
                                        A.IND_AJUSTE,
                                        A.PRIMA_COB,
                                        A.PORC_REBAJA,
                                        A.TASA_AGR,
                                        A.MCA_GRATUITA,
                                        A.NUM_SECU,
                                        '',
                                        SIM_TYP_LOOKUP('', ''),
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        SIM_TYP_LOOKUP('', ''),
                                        '',
                                        SIM_TYP_LOOKUP('', ''),
                                        '',
                                        '',
                                        '',
                                        SIM_TYP_LOOKUP('Ded', '*'),
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '') TIPCOB
        FROM X2000040 A, X2000030 B
       WHERE A.NUM_SECU_POL = V_NUMSECUPOL
         AND NVL(A.END_SUMA_ASEG, 0) + NVL(A.END_PRIMA_COB, 0) != 0
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.COD_RIES = V_CODRIES;
  
    /*    Cursor c_Dfaut(v_Numsecupol Number, v_Numend Number) Is
          Select Sim_Typ_Autosdatosfijos(a.Num_Secu_Pol,
                                         a.Num_End,
                                         a.Cod_Ries,
                                         a.Cod_Ramo_Veh,
                                         Sim_Typ_Lookup(a.Cod_Marca, ''),
                                         Cod_Mod,
                                         Sim_Typ_Lookup(a.Cod_Tipo, ''),
                                         Sim_Typ_Lookup(a.Cod_Uso, ''),
                                         a.Pat_Veh,
                                         a.Motor_Veh,
                                         a.Chasis_Veh,
                                         Sim_Typ_Lookup(a.Cod_Clase, ''),
                                         a.Nro_Per,
                                         a.Color,
                                         b.Suma_Aseg,
                                         b.Suma_Acces) Tipdfaut
            From A2040100 a, A2040300 b
           Where a.Num_Secu_Pol = v_Numsecupol
           --And a.Num_End = v_Numend
             And b.Num_End      = (SELECT MAX(num_end)
                                     FROM A2040300 d
                                    WHERE d.num_secu_pol     = b.num_secu_pol
                                      AND NVL(d.Cod_Ries, 0) = Nvl(b.cod_ries, 0)
                                      AND d.num_end         <= v_Numend)
             And a.Num_Secu_Pol = b.Num_Secu_Pol(+)
             And a.Num_End = b.Num_End(+)
             And a.Cod_Ries = b.Cod_Ries(+);
    */
  
    CURSOR C_DFAUT(V_NUMSECUPOL NUMBER, V_NUMEND NUMBER) IS
      SELECT SIM_TYP_AUTOSDATOSFIJOS(A.NUM_SECU_POL,
                                     A.NUM_END,
                                     A.COD_RIES,
                                     A.COD_RAMO_VEH,
                                     SIM_TYP_LOOKUP(A.COD_MARCA, ''),
                                     COD_MOD,
                                     SIM_TYP_LOOKUP(A.COD_TIPO, ''),
                                     SIM_TYP_LOOKUP(A.COD_USO, ''),
                                     A.PAT_VEH,
                                     A.MOTOR_VEH,
                                     A.CHASIS_VEH,
                                     SIM_TYP_LOOKUP(A.COD_CLASE, ''),
                                     A.NRO_PER,
                                     A.COLOR,
                                     FUN_VLRASEG(A.NUM_SECU_POL,
                                                 A.COD_RIES,
                                                 1), --  b.Suma_Aseg,
                                     FUN_VLRASEG(A.NUM_SECU_POL,
                                                 A.COD_RIES,
                                                 2)) TIPDFAUT --b.Suma_Acces) Tipdfaut
        FROM A2040100 A
       WHERE A.NUM_SECU_POL = V_NUMSECUPOL
            --And a.Num_End = v_Numend
         AND A.NUM_END = (SELECT MAX(NUM_END)
                            FROM A2040100 D
                           WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                             AND NVL(D.COD_RIES, 0) = NVL(A.COD_RIES, 0)
                             AND D.NUM_END <= V_NUMEND);
  
    CURSOR C_CONDHABAUT(V_NUMSECUPOL NUMBER, V_CODRIES NUMBER) IS
      SELECT A.NOM_COND,
             TO_CHAR(A.FECHA_NAC_COND, 'DD-MON-RRRR') FECHA_NAC_COND,
             A.COD_PROF,
             A.COD_SEXO,
             A.COD_EST_CIV
        FROM A2040400 A
       WHERE A.NUM_SECU_POL = V_NUMSECUPOL
         AND A.COD_RIES = V_CODRIES
         AND A.NUM_COND = SIM_PCK_TIPOS_GENERALES.C_UNO;
  
    CURSOR C_TER(V_NUMSECUPOL NUMBER, V_NUMEND NUMBER) IS
      SELECT SIM_TYP_TERCEROGEN(TIPO_DOCUMENTO,
                                NUMERO_DOCUMENTO,
                                SECUENCIA_TERCERO,
                                COD_RIES,
                                ROL,
                                NOMBRES,
                                APELLIDOS,
                                '' --razon_social
                               ,
                                '' --tipo_beneficiario
                               ,
                                '' --desc_tipo
                               ,
                                FECHA_NACIMIENTO,
                                EDAD,
                                SEXO,
                                NVL(DIRECCION, 'N/A'),
                                SIM_TYP_LOOKUP(NVL(CIUDAD, 0), ''),
                                SIM_TYP_LOOKUP(NVL(OCUPACION, 0), ''),
                                NVL(TELEFONO, 0),
                                FAX,
                                CELULAR,
                                EMAIL,
                                SIM_TYP_LOOKUP(NVL(PROFESION, 0), '')) TIPTER
        FROM SIM_TERCEROS A
       WHERE NUM_SECU_POL = V_NUMSECUPOL
            --And Num_End = v_Numend
         AND NUM_END = (SELECT MAX(NUM_END)
                          FROM SIM_TERCEROS D
                         WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                           AND D.NUM_END <= V_NUMEND);
  
    CURSOR C_ACC(V_NUMSECUPOL NUMBER, V_NUMEND NUMBER) IS
      SELECT SIM_TYP_AUTOSACCESORIOS(NUM_SECU_POL,
                                     NUM_END,
                                     COD_RIES,
                                     SIM_TYP_LOOKUP(COD_ACCES, ''),
                                     VALOR_ACCES,
                                     VALOR_ACCES_EN,
                                     MCA_TAR,
                                     MCA_BAJA,
                                     
                                     NVL(DESC_ACCES, 'GENERICO')) TIPACC
        FROM A2040200 A
       WHERE NUM_SECU_POL = V_NUMSECUPOL
            --And Num_End = v_Numend
         AND A.NUM_END = (SELECT MAX(NUM_END)
                            FROM A2040200 D
                           WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                             AND D.COD_RIES = A.COD_RIES
                             AND D.COD_ACCES = A.COD_ACCES
                             AND D.NUM_END <= V_NUMEND)
         AND NVL(A.MCA_BAJA, 'N') = 'N';
    --Juan Gonzalez (04102017)
    --Mantis 58211
    CURSOR C_CT(V_NUMSECUPOL NUMBER, V_NUMEND NUMBER) IS
      SELECT A.COD_ERROR, C.DESC_ERROR, A.COD_RECHAZO
        FROM X2000220 A, X2000030 B, G2000210 C, C9999909 N
       WHERE A.NUM_SECU_POL = V_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.NUM_ORDEN = B.NUM_END
         AND C.COD_CIA = B.COD_CIA
         AND C.COD_ERROR = A.COD_ERROR
         AND C.COD_ERROR = N.DAT_NUM
         AND A.COD_ERROR = N.DAT_NUM
         AND N.COD_TAB = 'PARAM_EXAM_MEDICO';
  
    L_CUENTAUSR NUMBER;
  BEGIN
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    L_ERROR       := NEW SIM_TYP_ERROR;
    L_TYP_POLIZA  := NEW SIM_TYP_POLIZAGEN();
    SIM_PROC_LOG('proc_consobj ' || IP_NUMSECUPOL || '-' || IP_NUMPOL1,
                 IP_PROCESO.P_COD_SECC || '-' || IP_NUMEND || '-' ||
                 IP_TIPO);
    IF SIM_PCK_AUTOGESTIONMOD.FUN_HAB_INCLUSION_MOD(IP_NUMSECUPOL,
                                                    IP_NUMPOL1,
                                                    IP_PROCESO.P_COD_SECC) = 'S' AND
       IP_PROCESO.P_PROCESO = 293 THEN
      SIM_PROC_LOG('proc_consobj ingreso autos ', '');
      SIM_PROC_LOG('UsrHabilitado ' || IP_PROCESO.P_COD_USR, '');
      SELECT COUNT(1)
        INTO L_CUENTAUSR
        FROM C9999909
       WHERE COD_TAB = 'USR_HAB_INCL_367'
         AND IP_PROCESO.P_COD_USR = DAT_CAR
         AND FECHA_BAJA IS NULL;
      IF L_CUENTAUSR = 0 THEN
        L_ERROR := SIM_TYP_ERROR(-20000,
                                 'Usuario No habilitado para Inclusion',
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
      ELSE
        SIM_PCK_AUTOGESTIONMOD.PROC_CONSOBJPOLAUTOS(IP_NUMPOL1,
                                                    IP_NUMEND,
                                                    IP_NUMSECUPOL,
                                                    IP_TIPO,
                                                    OP_OBJPOLIZA,
                                                    IP_VALIDACION,
                                                    IP_PROCESO,
                                                    OP_RESULTADO,
                                                    OP_ARRERRORES);
      END IF;
    ELSE
      L_NUMERO := IP_NUMPOL1;
      IF IP_PROCESO.P_CANAL = 6 THEN
        BEGIN
          SELECT NUM_POL1
            INTO L_NUMERO
            FROM A2000030
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NUM_END = 0;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      L_CODSECC     := IP_PROCESO.P_COD_SECC;
      L_CODCIA      := IP_PROCESO.P_COD_CIA;
      L_NUMEND      := IP_NUMEND;
      OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
      L_TYP_POLIZA  := NEW SIM_TYP_POLIZAGEN();
      SIM_PROC_LOG('proc_consobjpol', 1);
    
      L_TYP_DATOSFIJOS := NEW SIM_TYP_DATOSFIJOS();
    
      /*BRGH variable para cargar datos de debito automatico*/
      L_TYP_DEBITOAUT := NEW SIM_TYP_DATOSDEBITOGEN();
      /*Fin BRGH*/
    
      --dbms_output.put_line('l_Numero:'||l_Numero||' l_Codsecc:'||l_Codsecc||' l_Numend:'||
      --' l_Codcia:'||l_Codcia);
    
      BEGIN
        IF UPPER(IP_TIPO) = 'C' THEN
          SELECT SIM_TYP_DATOSFIJOS(SIM_TYP_LOOKUP(A.COD_CIA, ''),
                                    SIM_TYP_LOOKUP(A.COD_SECC, ''),
                                    A.NUM_POL_COTIZ,
                                    A.NUM_POL_FLOT,
                                    A.FECHA_EMI,
                                    A.FECHA_VIG_POL,
                                    A.FECHA_VENC_POL,
                                    SIM_TYP_LOOKUP(A.COD_PROD, ''),
                                    A.NUM_POL_ANT,
                                    A.NUM_SECU_POL,
                                    SIM_TYP_LOOKUP(A.NRO_DOCUMTO, ''),
                                    SIM_TYP_LOOKUP(A.COD_RAMO, ''),
                                    A.MCA_ANU_POL,
                                    A.DESC_POL,
                                    A.NUM_END,
                                    A.COD_END,
                                    A.SUB_COD_END,
                                    SIM_TYP_LOOKUP(A.TIPO_END, ''),
                                    A.FEC_ANU_POL,
                                    A.MCA_EXCLUSIVO,
                                    NVL(A.MCA_TERM_OK, 'S'),
                                    A.COD_USR,
                                    A.COD_USER_EXCLU,
                                    A.COD_DURACION,
                                    SIM_TYP_LOOKUP(A.COD_MON, ''),
                                    SIM_TYP_LOOKUP(A.PERIODO_FACT, ''),
                                    SIM_TYP_LOOKUP(A.FOR_COBRO, ''),
                                    A.COD_PLAN_PAGO,
                                    A.MCA_PROVISORIO,
                                    SIM_TYP_LOOKUP(A.TDOC_TERCERO, ''),
                                    A.SEC_TERCERO,
                                    A.SUC_TERCERO,
                                    SIM_TYP_LOOKUP(A.SIM_SUBPRODUCTO, ''),
                                    A.SIM_NUMERO_STELLENT,
                                    A.SIM_REFERIDO,
                                    A.SIM_PAQUETE_SEGURO,
                                    A.NUM_POL_COTIZ,
                                    MCA_PRORRATA,
                                    FECHA_EMI_END,
                                    FECHA_VIG_END,
                                    FECHA_VENC_END,
                                    TC,
                                    TC_PROMED,
                                    MCA_IMPTOS,
                                    CANT_CUOTAS,
                                    CANT_CUOTAS_IMP,
                                    RENOVADA_POR,
                                    CANT_ANUAL,
                                    COD_CONV,
                                    CANT_UBIC,
                                    CANT_SINI1,
                                    CANT_SINI2,
                                    CANT_SINI3,
                                    CANT_SINI4,
                                    CANT_SINI5,
                                    COD_COA,
                                    SIM_TYP_LOOKUP(COD_CIACOA, ''),
                                    NUM_POL_COA,
                                    NUM_ENDOSO_COA,
                                    PORC_PARTCOA,
                                    DESC_CLAUSULA,
                                    MCA_CL90,
                                    CANT_CL90,
                                    CANT_COP_FRE,
                                    NUM_POL_CLI,
                                    NUM_END_MODI,
                                    MCA_END_ANU,
                                    FEC_ANU_END,
                                    MCA_ADM_PROD,
                                    MCA_POL_CALC,
                                    MCA_IMP_POL,
                                    MCA_IMP_CL90,
                                    MCA_IMP_REC,
                                    MCA_IMP_ANXCOA,
                                    MCA_MOD_DCOBRO,
                                    MCA_COND_FEA,
                                    MCA_BONA_FEA,
                                    MCA_REST_BON,
                                    COD_USER_RESP,
                                    NUM_AUTORIZA,
                                    FEC_AUTORIZA,
                                    MCA_AUTORIZA,
                                    NRO_PERIODO,
                                    FECHA_VIG_PER,
                                    FECHA_VENC_PER,
                                    MCA_END_TEMP,
                                    MCA_PER_ANUL,
                                    COD_CONV_ORG,
                                    FECHA_EQUIPO,
                                    VAL_CM_FV,
                                    FECHA_ULT_DENU,
                                    MCA_SUSP_VIG,
                                    MCA_DATOS_MIN,
                                    MCA_RENOV,
                                    MCA_POL_VUE,
                                    MCA_RV_AUT,
                                    COEF_POL,
                                    FECHA_MOVI,
                                    MCA_COND_FR,
                                    NUM_END_FLOT,
                                    COD_COBRADOR,
                                    NODO_ID,
                                    MCA_TRANSMIT,
                                    FECHA_ANTIC,
                                    TC_UF,
                                    SOLICITUD,
                                    MCA_CADUCA,
                                    MCA_AVISO,
                                    NUM_TARJETA,
                                    COD_PROG,
                                    MCA_FACTURA,
                                    PORC_COMCOA,
                                    PERIODIC_PAGO,
                                    TIPO_REGULARIZACION,
                                    PORC_REGULARIZACION,
                                    COD_INDICE_REGUL,
                                    TEXTO_ESPECIAL,
                                    PRIMAS_ESPECIALES,
                                    ANOS_MAX_DUR,
                                    MESES_MAX_DUR,
                                    DIAS_MAX_DUR,
                                    DURACION_PAGO_PRIMA,
                                    MCA_PDTE_CUMULO,
                                    CES_DERECHOS,
                                    COD_CESION,
                                    COMISIONES_MANUALES,
                                    MCA_END_ANUL,
                                    MCA_COTIZACION,
                                    FECHA_COTIZ,
                                    IMPORTE_COTIZ,
                                    MCA_CESION_GTIA,
                                    MCA_MULTIRAMO,
                                    MCA_END_DTOT,
                                    NUM_LIQ,
                                    COEFCOB,
                                    NRO_EJECUCION,
                                    USUARIO_IMPRE,
                                    PROMOTOR,
                                    FECHA_CREACION,
                                    SIM_TYP_LOOKUP(SISTEMA_ORIGEN, ''),
                                    FEC_IMP_POL,
                                    CARNET_GENERADO,
                                    SIM_VINCULACION,
                                    SIM_TIPO_NEGOCIO,
                                    SIM_TYP_LOOKUP(SIM_USUARIO_CREACION, ''),
                                    SIM_COLECTIVA,
                                    SIM_TIPO_COLECTIVA,
                                    SIM_TYP_LOOKUP(SIM_CANAL, ''),
                                    SIM_MARCA_TARIFA,
                                    SIM_COD_SECC_ANT,
                                    SIM_NUM_COTIZ_ANT,
                                    SIM_TYP_LOOKUP(SIM_USUARIO_EXCLUSIVO, ''),
                                    SIM_TYP_LOOKUP(SIM_USUARIO_AUTORIZA, ''),
                                    SIM_TYP_LOOKUP(SIM_MODO_IMPRESION, ''),
                                    SIM_TYP_LOOKUP(SIM_SISTEMA_ORIGEN, ''),
                                    SIM_TYP_LOOKUP(SIM_TIPO_PROCESO, ''),
                                    SIM_TYP_LOOKUP(NVL(SIM_PCK_FUNCION_GEN.FUN_MARCA_PE(A.COD_CIA,
                                                                                        A.COD_SECC,
                                                                                        A.COD_RAMO,
                                                                                        A.SIM_SUBPRODUCTO,
                                                                                        A.SIM_CANAL,
                                                                                        A.COD_PROD),
                                                       A.SIM_TIPO_ENVIO),
                                                   '')),
                 A.NUM_SECU_POL,
                 A.COD_RAMO,
                 A.SIM_SUBPRODUCTO
          
            INTO L_TYP_POLIZA.DATOSFIJOS,
                 L_NUMSECUPOL,
                 L_CODRAMO,
                 L_SUBPRODUCTO
            FROM A2000030 A
           WHERE A.NUM_POL_COTIZ = L_NUMERO
             AND A.COD_SECC = L_CODSECC
             AND NVL(A.NUM_END, 0) = NVL(L_NUMEND, 0)
             AND NVL(A.MCA_TERM_OK, 'S') = 'S'
             AND NVL(A.MCA_COTIZACION, 'N') = 'S'
             AND A.COD_CIA = L_CODCIA;
        
          L_DESC_TDOC_TERCERO := NULL;
        
          BEGIN
            L_DESC_TDOC_TERCERO := PCK999_TERCEROS.FUN_TIPO_DOC(L_TYP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO);
          EXCEPTION
            WHEN OTHERS THEN
              BEGIN
                SELECT A.NOMBRES || ' ' || A.APELLIDOS
                  INTO L_NOMB_TERCERO
                  FROM SIM_TERCEROS A
                 WHERE A.NUM_SECU_POL = L_NUMSECUPOL
                   AND A.ROL = 2
                   AND A.NUM_END = 0;
              EXCEPTION
                WHEN OTHERS THEN
                  L_NOMB_TERCERO := NULL;
              END;
          END;
        
          BEGIN
            L_NOMB_TERCERO := PCK999_TERCEROS.FUN_RETORNA_NOMBRESD(L_TYP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO,
                                                                   L_TYP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO,
                                                                   L_SECUENCIA);
          EXCEPTION
            WHEN OTHERS THEN
              -- Para cotizaciones puede ser que el el tercero no exista en terceros
              -- wesv 20140915
              BEGIN
                SELECT ST.NOMBRES || ' - ' || ST.APELLIDOS
                  INTO L_NOMB_TERCERO
                  FROM SIM_TERCEROS ST
                 WHERE ST.NUM_SECU_POL = L_NUMSECUPOL
                   AND ST.NUM_END = 0
                   AND NVL(ST.COD_RIES, 0) = 0
                   AND ST.ROL = SIM_PCK_TIPOS_GENERALES.C_UNO;
              EXCEPTION
                WHEN OTHERS THEN
                  L_NOMB_TERCERO := NULL;
              END;
          END;
        
          L_TYP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.VALOR  := L_NOMB_TERCERO;
          L_TYP_POLIZA.DATOSFIJOS.TDOC_TERCERO.VALOR := L_DESC_TDOC_TERCERO;
        
          BEGIN
            L_PROCESO               := IP_PROCESO;
            L_PROCESO.P_SUBPRODUCTO := L_TYP_POLIZA.DATOSFIJOS.SUBPRODUCTO.VALOR;
            SIM_PCK_FUNCION_GEN.PROC_DIASVIGENCIACOTIZA(SUBSTR(L_TYP_POLIZA.DATOSFIJOS.NUM_POL1,
                                                               12,
                                                               2),
                                                        L_NUMDIASVIGENCIACOT,
                                                        IP_VALIDACION,
                                                        L_PROCESO,
                                                        OP_RESULTADO,
                                                        OP_ARRERRORES);
          
            IF OP_RESULTADO = -1 THEN
              RAISE_APPLICATION_ERROR(-20099,
                                      'Error Proc_ConsObjPol al recuperar dias Vigencia');
            END IF;
          
            IF TRUNC(L_TYP_POLIZA.DATOSFIJOS.FECHA_VIG_POL +
                     L_NUMDIASVIGENCIACOT) < TRUNC(SYSDATE) THEN
              L_TYP_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'N';
              L_TYP_POLIZA.DATOSFIJOS.DESC_POL    := 'Cotizacion vencida. Fecha Cotizacion:' ||
                                                     TO_CHAR(L_TYP_POLIZA.DATOSFIJOS.FECHA_VIG_POL,
                                                             'yyyy-mm-dd');
            ELSE
              L_TYP_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'S';
            END IF;
            /* se envía mca term ok en N si el agente no es de atgc para que
            no pueda formalizar la cotizacion Wesv 20140926*/
          
            IF NVL(L_TYP_POLIZA.DATOSFIJOS.MCA_TERM_OK, 'N') = 'S' THEN
              -- Si el tipo de usuario es empleado no importa, solo aplica
              -- si es agente
            
              SIM_PCK_SEGURIDAD.PROC_VALIDATIPOUSUARIO(L_TIPOUSER,
                                                       L_VALIDACION,
                                                       IP_PROCESO,
                                                       OP_RESULTADO,
                                                       OP_ARRERRORES);
            
              IF OP_RESULTADO = -1 THEN
                RAISE_APPLICATION_ERROR(-20099,
                                        'Error Proc_ConsObjPol al validar tipousuario');
              END IF;
            
              IF SIM_PCK_FUNCION_GEN.AGENTE_ESATGC(L_TYP_POLIZA.DATOSFIJOS.COD_PROD.CODIGO,
                                                   L_TYP_POLIZA.DATOSFIJOS.COD_CIA.CODIGO,
                                                   L_TYP_POLIZA.DATOSFIJOS.COD_SECC.CODIGO,
                                                   L_TYP_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO,
                                                   NVL(L_TYP_POLIZA.DATOSFIJOS.SUBPRODUCTO.CODIGO,
                                                       0)) = 'N' THEN
                L_TYP_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'N';
              END IF;
            END IF;
          END;
        ELSE
          SELECT SIM_TYP_DATOSFIJOS(SIM_TYP_LOOKUP(A.COD_CIA, ''),
                                    SIM_TYP_LOOKUP(A.COD_SECC, ''),
                                    A.NUM_POL1,
                                    A.NUM_POL_FLOT,
                                    A.FECHA_EMI,
                                    A.FECHA_VIG_POL,
                                    A.FECHA_VENC_POL,
                                    SIM_TYP_LOOKUP(A.COD_PROD, ''),
                                    A.NUM_POL_ANT,
                                    A.NUM_SECU_POL,
                                    SIM_TYP_LOOKUP(A.NRO_DOCUMTO,
                                                   PCK999_TERCEROS.FUN_RETORNA_NOMBRESD(A.NRO_DOCUMTO,
                                                                                        A.TDOC_TERCERO,
                                                                                        L_SECUENCIA)),
                                    SIM_TYP_LOOKUP(A.COD_RAMO, ''),
                                    A.MCA_ANU_POL,
                                    A.DESC_POL,
                                    A.NUM_END,
                                    A.COD_END,
                                    A.SUB_COD_END,
                                    SIM_TYP_LOOKUP(A.TIPO_END, ''),
                                    A.FEC_ANU_POL,
                                    A.MCA_EXCLUSIVO,
                                    A.MCA_TERM_OK,
                                    A.COD_USR,
                                    A.COD_USER_EXCLU,
                                    A.COD_DURACION,
                                    SIM_TYP_LOOKUP(A.COD_MON, ''),
                                    SIM_TYP_LOOKUP(A.PERIODO_FACT, ''),
                                    SIM_TYP_LOOKUP(A.FOR_COBRO, ''),
                                    A.COD_PLAN_PAGO,
                                    A.MCA_PROVISORIO,
                                    SIM_TYP_LOOKUP(A.TDOC_TERCERO,
                                                   PCK999_TERCEROS.FUN_TIPO_DOC(A.TDOC_TERCERO)),
                                    A.SEC_TERCERO,
                                    A.SUC_TERCERO,
                                    SIM_TYP_LOOKUP(A.SIM_SUBPRODUCTO, ''),
                                    A.SIM_NUMERO_STELLENT,
                                    A.SIM_REFERIDO,
                                    A.SIM_PAQUETE_SEGURO,
                                    A.NUM_POL_COTIZ,
                                    MCA_PRORRATA,
                                    FECHA_EMI_END,
                                    FECHA_VIG_END,
                                    FECHA_VENC_END,
                                    TC,
                                    TC_PROMED,
                                    MCA_IMPTOS,
                                    CANT_CUOTAS,
                                    CANT_CUOTAS_IMP,
                                    RENOVADA_POR,
                                    CANT_ANUAL,
                                    COD_CONV,
                                    CANT_UBIC,
                                    CANT_SINI1,
                                    CANT_SINI2,
                                    CANT_SINI3,
                                    CANT_SINI4,
                                    CANT_SINI5,
                                    COD_COA,
                                    SIM_TYP_LOOKUP(COD_CIACOA, ''),
                                    NUM_POL_COA,
                                    NUM_ENDOSO_COA,
                                    PORC_PARTCOA,
                                    DESC_CLAUSULA,
                                    MCA_CL90,
                                    CANT_CL90,
                                    CANT_COP_FRE,
                                    NUM_POL_CLI,
                                    NUM_END_MODI,
                                    MCA_END_ANU,
                                    FEC_ANU_END,
                                    MCA_ADM_PROD,
                                    MCA_POL_CALC,
                                    MCA_IMP_POL,
                                    MCA_IMP_CL90,
                                    MCA_IMP_REC,
                                    MCA_IMP_ANXCOA,
                                    MCA_MOD_DCOBRO,
                                    MCA_COND_FEA,
                                    MCA_BONA_FEA,
                                    MCA_REST_BON,
                                    COD_USER_RESP,
                                    NUM_AUTORIZA,
                                    FEC_AUTORIZA,
                                    MCA_AUTORIZA,
                                    NRO_PERIODO,
                                    FECHA_VIG_PER,
                                    FECHA_VENC_PER,
                                    MCA_END_TEMP,
                                    MCA_PER_ANUL,
                                    COD_CONV_ORG,
                                    FECHA_EQUIPO,
                                    VAL_CM_FV,
                                    FECHA_ULT_DENU,
                                    MCA_SUSP_VIG,
                                    MCA_DATOS_MIN,
                                    MCA_RENOV,
                                    MCA_POL_VUE,
                                    MCA_RV_AUT,
                                    COEF_POL,
                                    FECHA_MOVI,
                                    MCA_COND_FR,
                                    NUM_END_FLOT,
                                    COD_COBRADOR,
                                    NODO_ID,
                                    MCA_TRANSMIT,
                                    FECHA_ANTIC,
                                    TC_UF,
                                    SOLICITUD,
                                    MCA_CADUCA,
                                    MCA_AVISO,
                                    NUM_TARJETA,
                                    COD_PROG,
                                    MCA_FACTURA,
                                    PORC_COMCOA,
                                    PERIODIC_PAGO,
                                    TIPO_REGULARIZACION,
                                    PORC_REGULARIZACION,
                                    COD_INDICE_REGUL,
                                    TEXTO_ESPECIAL,
                                    PRIMAS_ESPECIALES,
                                    ANOS_MAX_DUR,
                                    MESES_MAX_DUR,
                                    DIAS_MAX_DUR,
                                    DURACION_PAGO_PRIMA,
                                    MCA_PDTE_CUMULO,
                                    CES_DERECHOS,
                                    COD_CESION,
                                    COMISIONES_MANUALES,
                                    MCA_END_ANUL,
                                    MCA_COTIZACION,
                                    FECHA_COTIZ,
                                    IMPORTE_COTIZ,
                                    MCA_CESION_GTIA,
                                    MCA_MULTIRAMO,
                                    MCA_END_DTOT,
                                    NUM_LIQ,
                                    COEFCOB,
                                    NRO_EJECUCION,
                                    USUARIO_IMPRE,
                                    PROMOTOR,
                                    FECHA_CREACION,
                                    SIM_TYP_LOOKUP(SISTEMA_ORIGEN, ''),
                                    FEC_IMP_POL,
                                    CARNET_GENERADO,
                                    SIM_VINCULACION,
                                    SIM_TIPO_NEGOCIO,
                                    SIM_TYP_LOOKUP(SIM_USUARIO_CREACION, ''),
                                    SIM_COLECTIVA,
                                    SIM_TIPO_COLECTIVA,
                                    SIM_TYP_LOOKUP(SIM_CANAL, ''),
                                    SIM_MARCA_TARIFA,
                                    SIM_COD_SECC_ANT,
                                    SIM_NUM_COTIZ_ANT,
                                    SIM_TYP_LOOKUP(SIM_USUARIO_EXCLUSIVO, ''),
                                    SIM_TYP_LOOKUP(SIM_USUARIO_AUTORIZA, ''),
                                    SIM_TYP_LOOKUP(SIM_MODO_IMPRESION, ''),
                                    SIM_TYP_LOOKUP(SIM_SISTEMA_ORIGEN, ''),
                                    SIM_TYP_LOOKUP(SIM_TIPO_PROCESO, ''),
                                    SIM_TYP_LOOKUP(SIM_TIPO_ENVIO, '')),
                 A.NUM_SECU_POL,
                 A.COD_RAMO
            INTO L_TYP_POLIZA.DATOSFIJOS, L_NUMSECUPOL, L_CODRAMO
            FROM A2000030 A
           WHERE A.NUM_POL1 = L_NUMERO
             AND A.COD_SECC = L_CODSECC
                --And Nvl(a.Num_End, 0) = Nvl(l_Numend, 0) --rcb
             AND NVL(A.NUM_END, 0) =
                 (SELECT MAX(NUM_END)
                    FROM A2000030 D
                   WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                     AND D.NUM_END <= NVL(L_NUMEND, 0))
             AND A.COD_CIA = L_CODCIA;
        END IF;
      
        IF NVL(L_TYP_POLIZA.DATOSFIJOS.SUBPRODUCTO.CODIGO, 0) > 0 THEN
          BEGIN
            SELECT SUBP.DESC_SUBPRODUCTO
              INTO L_TYP_POLIZA.DATOSFIJOS.SUBPRODUCTO.VALOR
              FROM SIM_SUBPRODUCTOS SUBP, SIM_PRODUCTOS SP
             WHERE SUBP.COD_SUBPRODUCTO =
                   L_TYP_POLIZA.DATOSFIJOS.SUBPRODUCTO.CODIGO
               AND SUBP.ID_PRODUCTO = SP.ID_PRODUCTO
               AND SP.COD_PRODUCTO =
                   L_TYP_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO
               AND SP.COD_CIA = L_TYP_POLIZA.DATOSFIJOS.COD_CIA.CODIGO
               AND SP.COD_SECC = L_TYP_POLIZA.DATOSFIJOS.COD_SECC.CODIGO;
          EXCEPTION
            WHEN OTHERS THEN
              L_TYP_POLIZA.DATOSFIJOS.SUBPRODUCTO.VALOR := 'No tiene';
          END;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
          OP_RESULTADO := -1;
      END;
    
      --    sim_proc_log('wesv.valor tipodoc:',l_typ_poliza.DatosFijos.NRO_DOCUMTO.valor||' ',l_typ_poliza.DatosFijos.NRO_DOCUMTO.codigo);
      SIM_PCK_RECUPERA_DATOS_EMISION.PROC_RECUPERARIESGOPOLIZA(IP_NUMPOL1,
                                                               L_NUMSECUPOL,
                                                               IP_NUMEND,
                                                               NULL,
                                                               L_VIGENTE,
                                                               L_FECHAEMISION,
                                                               'N',
                                                               L_ARRRIESGOS,
                                                               L_VALIDACION,
                                                               IP_PROCESO,
                                                               OP_RESULTADO,
                                                               OP_ARRERRORES);
    
      IF OP_RESULTADO = -1 THEN
        RAISE_APPLICATION_ERROR(-20099,
                                'Error Proc_ConsObjPol al recuperar riesgo póliza');
      END IF;
    
      IF L_ARRRIESGOS.COUNT > 0 THEN
        FOR I IN L_ARRRIESGOS.FIRST .. L_ARRRIESGOS.LAST LOOP
          L_TYP_POLIZA.DATOSRIESGOS.EXTEND;
          L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT) := NEW
                                                                        SIM_TYP_RIESGOGEN();
          /*BRGH se incluye para validar los riesgos excluidos y no tenerlos en cuenta para la renovación*/
          /* JIR-GD717-336: Adiciono 445 y 446 para nuevo proceso renovacion polizas hijas - 06-10-2023 */
          IF IP_PROCESO.P_PROCESO IN (440, 441, 442, 445, 446) THEN
            IF (L_ARRRIESGOS(I).MARCA_BAJA = 'N') THEN
              L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSRIESGO := L_ARRRIESGOS(I);
            ELSE
              L_TYP_POLIZA.DATOSRIESGOS.DELETE(L_TYP_POLIZA.DATOSRIESGOS.COUNT);
            END IF;
          ELSE
            L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSRIESGO := L_ARRRIESGOS(I);
          END IF;
          /*Fin BRGH*/
        
          --        If ip_proceso.p_cod_producto IN (940, 942, 946) then
          /*
           Vida Grupo extra premium calculation, added Vida Grupo Condition
           Seguros de Vida , TraQIQ_20200129
           starts
          */
          IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' OR
             SIM_PCK_ATGC_VIDA_GRUPO.FUN_ESRAMOATGCVIDAGRUPO(IP_PROCESO.P_COD_CIA,
                                                             IP_PROCESO.P_COD_SECC,
                                                             IP_PROCESO.P_COD_PRODUCTO) = 'S' AND
             IP_PROCESO.P_COD_PRODUCTO NOT IN (721, 710, 793, 799) THEN
            --Seguros de Vida , TraQIQ_20200129
            BEGIN
              SELECT COUNT(1)
                INTO L_ENCONTROX
                FROM X2000030
               WHERE NUM_SECU_POL = L_NUMSECUPOL;
            END;
          
            IF L_ENCONTROX > 0 THEN
              FOR REG_COB IN C_COBX(L_NUMSECUPOL,
                                    L_NUMEND,
                                    L_ARRRIESGOS(I).COD_RIES) LOOP
                /*BRGH anade para requerimiento davivienda calculo de IVA en cobertura*/
                --Ernesto Castillo - ernesto.castillosegurosbolivar.com - 09/03/2022
                --Consultar sistema origen Davivienda (121,124), como parametro en la tabla C9999909
                -- if(Ip_Proceso.p_sistema_origen = 121 and Ip_Proceso.p_cod_cia = 3
                IF (FN_VALIDA_SIS_ORIGEN(IP_PROCESO.P_SISTEMA_ORIGEN) = 1 AND
                   IP_PROCESO.P_COD_SECC = 66 AND
                   IP_PROCESO.P_COD_PRODUCTO = 777 AND
                   REG_COB.TIPCOB IS NOT NULL AND
                   REG_COB.TIPCOB.PRIMA_COB > 0) THEN
                  BEGIN
                    SELECT C.TASA_IMPUEST_E
                      INTO L_TASAIMPUESTO
                      FROM A2000190 C
                     WHERE C.NUM_SECU_POL = L_NUMSECUPOL
                       AND C.NUM_END = L_NUMEND
                       AND C.TIPO_REG = 'T';
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_TASAIMPUESTO := 100;
                  END;
                  REG_COB.TIPCOB.PRIMA_COB := REG_COB.TIPCOB.PRIMA_COB +
                                              (REG_COB.TIPCOB.PRIMA_COB *
                                              L_TASAIMPUESTO) / 100;
                END IF;
                /*fin BRGH*/
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.EXTEND;
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := NEW
                                                                                                                                                                                SIM_TYP_COBERTURAPOLIZAGEN();
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := REG_COB.TIPCOB;
              END LOOP;
            ELSE
            
              FOR REG_COB IN C_COB(L_NUMSECUPOL,
                                   L_NUMEND,
                                   L_ARRRIESGOS(I).COD_RIES) LOOP
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.EXTEND;
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := NEW
                                                                                                                                                                                SIM_TYP_COBERTURAPOLIZAGEN();
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := REG_COB.TIPCOB;
              END LOOP;
            END IF;
          ELSE
          
            FOR REG_COB IN C_COB(L_NUMSECUPOL,
                                 L_NUMEND,
                                 L_ARRRIESGOS(I).COD_RIES) LOOP
              /*BRGH anade para requerimiento davivienda calculo de IVA en cobertura*/
              --Ernesto Castillo - ernesto.castillosegurosbolivar.com - 09/03/2022
              --Consultar sistema origen Davivienda (121,124), como parametro en la tabla C9999909
              -- if(Ip_Proceso.p_sistema_origen = 121 and Ip_Proceso.p_cod_cia = 3
            
              IF (FN_VALIDA_SIS_ORIGEN(IP_PROCESO.P_SISTEMA_ORIGEN) = 1 AND
                 IP_PROCESO.P_COD_CIA = 3 AND IP_PROCESO.P_COD_SECC = 66 AND
                 IP_PROCESO.P_COD_PRODUCTO = 777 AND
                 REG_COB.TIPCOB IS NOT NULL AND
                 REG_COB.TIPCOB.PRIMA_COB > 0) THEN
                BEGIN
                  SELECT C.TASA_IMPUEST_E
                    INTO L_TASAIMPUESTO
                    FROM A2000190 C
                   WHERE C.NUM_SECU_POL = L_NUMSECUPOL
                     AND C.NUM_END = L_NUMEND
                     AND C.TIPO_REG = 'T';
                EXCEPTION
                  WHEN OTHERS THEN
                    L_TASAIMPUESTO := 100;
                END;
                REG_COB.TIPCOB.PRIMA_COB := REG_COB.TIPCOB.PRIMA_COB +
                                            (REG_COB.TIPCOB.PRIMA_COB *
                                            L_TASAIMPUESTO) / 100;
              END IF;
              /*fin BRGH*/
              /*BRGH se incluye para validar los riesgos excluidos y no tenerlos en cuenta para la renovación*/
              /* JIR-GD717-336: Adiciono 445 y 446 para nuevo proceso renovacion polizas hijas - 06-10-2023 */
              IF IP_PROCESO.P_PROCESO IN (440, 441, 442, 445, 446) THEN
                IF (L_ARRRIESGOS(I).MARCA_BAJA = 'N') THEN
                  L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.EXTEND;
                  L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := NEW
                                                                                                                                                                                  SIM_TYP_COBERTURAPOLIZAGEN();
                  L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := REG_COB.TIPCOB;
                END IF;
              ELSE
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.EXTEND;
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := NEW
                                                                                                                                                                                SIM_TYP_COBERTURAPOLIZAGEN();
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSCOBERTURAS.COUNT) := REG_COB.TIPCOB;
              END IF;
              /*Fin BRGH*/
            END LOOP;
          END IF;
        
          -- Inlcusion de caberturas de anexo hogar -->22/08/2017(Juan Gonzalez)
          IF SIM_PCK_ATGC_VIDA_GRUPO.FUN_ESRAMOATGCVIDAGRUPO(IP_PROCESO.P_COD_CIA,
                                                             IP_PROCESO.P_COD_SECC,
                                                             IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
          
            IF IP_PROCESO.P_COD_PRODUCTO IN (719, 792) AND
               IP_PROCESO.P_PROCESO IN (202, 241, 270) AND L_ARRRIESGOS(I)
              .COD_RIES = 1 THEN
              -- aplica solo para cotiza(241) /emite(270)
              SIM_PCK_ATGC_VIDA_GRUPO.PROC_ADJUNTACOBERANEXO(L_TYP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                             L_TYP_POLIZA,
                                                             IP_PROCESO);
            
              L_TYP_POLIZA.PRIMA.IMP_IMPUESTO := SIM_PCK_ATGC_VIDA_GRUPO.FUN_VLRIMPUESTO(L_TYP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                                                         IP_PROCESO);
            END IF;
          END IF;
        
          FOR REG_DV IN C_DV(L_NUMSECUPOL,
                             L_NUMEND,
                             L_CODRAMO,
                             L_ARRRIESGOS(I).COD_RIES) LOOP
          
            /*BRGH se incluye para validar los riesgos excluidos y no tenerlos en cuenta para la renovación*/
            /* JIR-GD717-336: Adiciono 445 y 446 para nuevo proceso renovacion polizas hijas - 06-10-2023 */
            IF IP_PROCESO.P_PROCESO IN (440, 441, 442, 445, 446) THEN
              IF (L_ARRRIESGOS(I).MARCA_BAJA = 'N') THEN
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.EXTEND;
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT) := NEW
                                                                                                                                                                              SIM_TYP_DATOS_VARIABLESGEN();
                --Ernesto Castillo - ernesto.castillosegurosbolivar.com - 09/03/2022
                --Consultar sistema origen Davivienda (121,124), como parametro en la tabla C9999909
                -- .Cod_Campo = 'CPOS_RIES' And Ip_Proceso.p_Sistema_Origen = 121 Then
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT) := REG_DV.TIPDV;
                IF L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT)
                 .COD_CAMPO = 'CPOS_RIES' AND
                    FN_VALIDA_SIS_ORIGEN(IP_PROCESO.P_SISTEMA_ORIGEN) = 1 THEN
                  --Davivienda MANTIS 60695
                  L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT).VALOR_CAMPO := SIM_PCK_PYMES_MAPEODAT.CODIGOCODAZZIDAVIVIENDA(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT)
                                                                                                                                                                                                                                           .VALOR_CAMPO);
                END IF;
                IF L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT)
                 .COD_CAMPO = 'VLR_RESPCIV' THEN
                  --Mantis 63751
                  IF SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2020_X2020('LV_RC',
                                                                 L_NUMSECUPOL,
                                                                 L_ARRRIESGOS(I)
                                                                 .COD_RIES,
                                                                 L_NUMEND) = 'L' THEN
                    L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT).VALOR_CAMPO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2020_X2020('VLR_RESPCIV_L',
                                                                                                                                                                                                                                          L_NUMSECUPOL,
                                                                                                                                                                                                                                          L_ARRRIESGOS(I)
                                                                                                                                                                                                                                          .COD_RIES,
                                                                                                                                                                                                                                          L_NUMEND);
                  END IF;
                END IF;
              END IF;
            ELSE
              L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.EXTEND;
              L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT) := NEW
                                                                                                                                                                            SIM_TYP_DATOS_VARIABLESGEN();
              --Ernesto Castillo - ernesto.castillosegurosbolivar.com - 09/03/2022
              --Consultar sistema origen Davivienda (121,124), como parametro en la tabla C9999909
              -- .Cod_Campo = 'CPOS_RIES' And Ip_Proceso.p_Sistema_Origen = 121 Then
              L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT) := REG_DV.TIPDV;
              IF L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT)
               .COD_CAMPO = 'CPOS_RIES' AND
                  FN_VALIDA_SIS_ORIGEN(IP_PROCESO.P_SISTEMA_ORIGEN) = 1 THEN
                --Davivienda MANTIS 60695
                L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT).VALOR_CAMPO := SIM_PCK_PYMES_MAPEODAT.CODIGOCODAZZIDAVIVIENDA(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT)
                                                                                                                                                                                                                                         .VALOR_CAMPO);
              END IF;
              IF L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT)
               .COD_CAMPO = 'VLR_RESPCIV' THEN
                --Mantis 63751
                IF SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2020_X2020('LV_RC',
                                                               L_NUMSECUPOL,
                                                               L_ARRRIESGOS(I)
                                                               .COD_RIES,
                                                               L_NUMEND) = 'L' THEN
                  L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES(L_TYP_POLIZA.DATOSRIESGOS(L_TYP_POLIZA.DATOSRIESGOS.COUNT).DATOSVARIABLES.COUNT).VALOR_CAMPO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_A2020_X2020('VLR_RESPCIV_L',
                                                                                                                                                                                                                                        L_NUMSECUPOL,
                                                                                                                                                                                                                                        L_ARRRIESGOS(I)
                                                                                                                                                                                                                                        .COD_RIES,
                                                                                                                                                                                                                                        L_NUMEND);
                END IF;
              END IF;
            END IF;
            /*Fin BRGH*/
          END LOOP;
        
          L_TYP_POLIZA.DATOSADICIONAL := NEW SIM_TYP_ARRAY_DATOS_ADIC();
        
          FOR REG_CHAB IN C_CONDHABAUT(L_NUMSECUPOL,
                                       L_ARRRIESGOS(I).COD_RIES) LOOP
            L_DATOADICIONAL := NEW
                               SIM_TYP_DATOS_ADIC(L_NUMSECUPOL,
                                                  L_NUMEND,
                                                  L_ARRRIESGOS(I).COD_RIES,
                                                  NULL,
                                                  1,
                                                  'NOM_COND',
                                                  0,
                                                  'X2040400',
                                                  REG_CHAB.NOM_COND);
            L_TYP_POLIZA.DATOSADICIONAL.EXTEND;
            L_TYP_POLIZA.DATOSADICIONAL(L_TYP_POLIZA.DATOSADICIONAL.COUNT) := L_DATOADICIONAL;
            L_DATOADICIONAL := NEW
                               SIM_TYP_DATOS_ADIC(L_NUMSECUPOL,
                                                  L_NUMEND,
                                                  L_ARRRIESGOS(I).COD_RIES,
                                                  NULL,
                                                  1,
                                                  'COD_SEXO',
                                                  0,
                                                  'X2040400',
                                                  REG_CHAB.COD_SEXO);
            L_TYP_POLIZA.DATOSADICIONAL.EXTEND;
            L_TYP_POLIZA.DATOSADICIONAL(L_TYP_POLIZA.DATOSADICIONAL.COUNT) := L_DATOADICIONAL;
          
            L_DATOADICIONAL := NEW
                               SIM_TYP_DATOS_ADIC(L_NUMSECUPOL,
                                                  L_NUMEND,
                                                  L_ARRRIESGOS(I).COD_RIES,
                                                  NULL,
                                                  1,
                                                  'FECHA_NAC_COND',
                                                  0,
                                                  'X2040400',
                                                  REG_CHAB.FECHA_NAC_COND);
            L_TYP_POLIZA.DATOSADICIONAL.EXTEND;
            L_TYP_POLIZA.DATOSADICIONAL(L_TYP_POLIZA.DATOSADICIONAL.COUNT) := L_DATOADICIONAL;
            L_DATOADICIONAL := NEW
                               SIM_TYP_DATOS_ADIC(L_NUMSECUPOL,
                                                  L_NUMEND,
                                                  L_ARRRIESGOS(I).COD_RIES,
                                                  NULL,
                                                  1,
                                                  'COD_PROF',
                                                  0,
                                                  'X2040400',
                                                  REG_CHAB.COD_PROF);
            L_TYP_POLIZA.DATOSADICIONAL.EXTEND;
            L_TYP_POLIZA.DATOSADICIONAL(L_TYP_POLIZA.DATOSADICIONAL.COUNT) := L_DATOADICIONAL;
          
            L_DATOADICIONAL := NEW
                               SIM_TYP_DATOS_ADIC(L_NUMSECUPOL,
                                                  L_NUMEND,
                                                  L_ARRRIESGOS(I).COD_RIES,
                                                  NULL,
                                                  1,
                                                  'COD_EST_CIV',
                                                  0,
                                                  'X2040400',
                                                  REG_CHAB.COD_EST_CIV);
            L_TYP_POLIZA.DATOSADICIONAL.EXTEND;
            L_TYP_POLIZA.DATOSADICIONAL(L_TYP_POLIZA.DATOSADICIONAL.COUNT) := L_DATOADICIONAL;
          END LOOP;
        END LOOP;
      END IF;
    
      /*BRGH se incluye para validar los riesgos excluidos y no tenerlos en cuenta para la renovación*/
      /* JIR-GD717-336: Adiciono 445 y 446 para nuevo proceso renovacion polizas hijas - 06-10-2023 */
      FOR REG_DV IN C_DV(L_NUMSECUPOL, L_NUMEND, L_CODRAMO, 0) LOOP
        IF IP_PROCESO.P_PROCESO IN (440, 441, 442, 445, 446) THEN
          IF L_ARRRIESGOS.COUNT > 0 THEN
            FOR I IN L_ARRRIESGOS.FIRST .. L_ARRRIESGOS.LAST LOOP
            
              IF (L_ARRRIESGOS(I)
                 .MARCA_BAJA = 'N' AND
                  (L_ARRRIESGOS(I).COD_RIES = REG_DV.COD_RIES)) THEN
              
                L_TYP_POLIZA.DV_POLIZA.EXTEND;
                L_TYP_POLIZA.DV_POLIZA(L_TYP_POLIZA.DV_POLIZA.COUNT) := NEW
                                                                        SIM_TYP_DATOS_VARIABLESGEN();
                L_TYP_POLIZA.DV_POLIZA(L_TYP_POLIZA.DV_POLIZA.COUNT) := REG_DV.TIPDV;
              END IF;
            
            END LOOP;
          END IF;
        ELSE
          L_TYP_POLIZA.DV_POLIZA.EXTEND;
          L_TYP_POLIZA.DV_POLIZA(L_TYP_POLIZA.DV_POLIZA.COUNT) := NEW
                                                                  SIM_TYP_DATOS_VARIABLESGEN();
          L_TYP_POLIZA.DV_POLIZA(L_TYP_POLIZA.DV_POLIZA.COUNT) := REG_DV.TIPDV;
        END IF;
      END LOOP;
      /*FIN BRGH se incluye para validar los riesgos excluidos y no tenerlos en cuenta para la renovación*/
    
      L_ARRAY_TYP_AGE := NEW SIM_TYP_ARRAY_AGENTESPOL();
    
      FOR REG_A IN C_AGE(L_NUMSECUPOL, L_NUMEND) LOOP
        L_ARRAY_TYP_AGE.EXTEND;
        L_ARRAY_TYP_AGE(L_ARRAY_TYP_AGE.COUNT) := REG_A.TIPAGE;
      END LOOP;
    
      /*If l_Array_Typ_Age.Exists(1) Then
        If l_Array_Typ_Age.Count > 0 Then
          For i In l_Array_Typ_Age.First .. l_Array_Typ_Age.Last Loop
            Dbms_Output.Put_Line('Agente:        ' || l_Array_Typ_Age(i)
                                 .Cod_Agente.Codigo || '*     *:' || l_Array_Typ_Age(i)
                                 .Porc_Part || '*');
          End Loop;
        End If;
      End If;*/
    
      L_ARRAY_DF_AUTOS := NEW SIM_TYP_ARRAY_AUTOSDATOSFIJOS();
    
      FOR REG_DFA IN C_DFAUT(L_NUMSECUPOL, L_NUMEND) LOOP
        L_ARRAY_DF_AUTOS.EXTEND;
        --Ini RCB: Modificaciones Ventas - Descripción del Accesorio.
        --                               - Valores de suma asegurada y accesorios
        REG_DFA.TIPDFAUT.COD_MARCA.VALOR := FUN_DESCMARCA(REG_DFA.TIPDFAUT.COD_MARCA.CODIGO,
                                                          L_TYP_POLIZA.DATOSFIJOS.COD_CIA.CODIGO);
        L_NSUMASEG                       := FUN_VALASEG(REG_DFA.TIPDFAUT.NUM_SECU_POL,
                                                        IP_NUMEND,
                                                        L_NSUMACC);
        REG_DFA.TIPDFAUT.SUMA_ASEG       := L_NSUMASEG;
        REG_DFA.TIPDFAUT.SUMA_ACCES      := L_NSUMACC;
      
        ---Miguel Angel Manrique ----> Si la cotización actual tiene una placa generada por simón, entonces se le
        --asigna otra placa
        --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
        IF IP_PROCESO.P_PROCESO = 240 AND IP_PROCESO.P_COD_PRODUCTO = 250 AND
           IP_PROCESO.P_SUBPRODUCTO IN (251, 360) THEN
          L_PLACAGENERADA := FUN_VALPLACAGENSIMON(REG_DFA.TIPDFAUT.PAT_VEH,
                                                  L_PLACAGENERADA);
          IF (L_PLACAGENERADA <> 0) THEN
            SIM_PCK_SERVICIOS_WEB.PROC_RETORNAPLACAVEHNUEVO(REG_DFA.TIPDFAUT.PAT_VEH,
                                                            L_PROCESO,
                                                            OP_RESULTADO,
                                                            OP_ARRERRORES);
          END IF;
        END IF;
      
        --dbms_output.put_line('RCB - Reg_Dfa.Tipdfaut.suma_aseg: '||Reg_Dfa.Tipdfaut.suma_aseg);
        --dbms_output.put_line('RCB - eg_Dfa.Tipdfaut.suma_acces: '||Reg_Dfa.Tipdfaut.suma_acces);
        --Fin RCB
        L_ARRAY_DF_AUTOS(L_ARRAY_DF_AUTOS.COUNT) := REG_DFA.TIPDFAUT;
      END LOOP;
    
      /*If l_Array_Df_Autos.Exists(1) Then
        If l_Array_Df_Autos.Count > 0 Then
          For i In l_Array_Df_Autos.First .. l_Array_Df_Autos.Last Loop
            Dbms_Output.Put_Line('Datos Fijos Autos:        ' || l_Array_Df_Autos(i)
                                 .Cod_Ramo_Veh || '*     *:' || l_Array_Df_Autos(i)
                                 .Cod_Marca.Codigo || '*');
          End Loop;
        End If;
      End If;*/
    
      L_ARRAY_TERCEROS := NEW SIM_TYP_ARRAY_TERCEROGEN();
      L_EXISTETER      := 0;
      FOR REG_TER IN C_TER(L_NUMSECUPOL, L_NUMEND) LOOP
        L_ARRAY_TERCEROS.EXTEND;
        L_ARRAY_TERCEROS(L_ARRAY_TERCEROS.COUNT) := REG_TER.TIPTER;
        L_EXISTETER := 1;
      END LOOP;
    
      IF L_EXISTETER = 0 THEN
        L_TYPTERCGEN := NEW SIM_TYP_TERCEROGEN();
        PCK999_TERCEROS.PRC_DATOSD_TERCERO(L_TYP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO --l_Numdoc
                                          ,
                                           L_TYP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO --l_Tipdoc
                                          ,
                                           L_SECUENCIA,
                                           L_PRIMERA,
                                           L_SEGUNDOA,
                                           L_PRIMERN,
                                           L_SEGUNDON,
                                           L_RAZON_SOCIAL,
                                           L_TIPO,
                                           L_DESCTIPO);
        L_TYPTERCGEN.NUMERO_DOCUMENTO := L_TYP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO;
        L_TYPTERCGEN.TIPO_DOCUMENTO   := L_TYP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO;
        L_TYPTERCGEN.SECUENCIA        := L_SECUENCIA;
      
        --       dbms_output.put_line('nombre A'||l_primern||'A');
        L_TYPTERCGEN.NOMBRES   := SUBSTR(TRIM(L_PRIMERN) || ' ' ||
                                         TRIM(L_SEGUNDON),
                                         1,
                                         60);
        L_TYPTERCGEN.APELLIDOS := SUBSTR(TRIM(L_PRIMERA) || ' ' ||
                                         TRIM(L_SEGUNDOA),
                                         1,
                                         60);
        L_TYPTERCGEN.COD_RIES  := 1;
        L_TYPTERCGEN.ROL       := 1;
        L_TYPTERCGEN.TIPO      := L_TIPO;
        L_TYPTERCGEN.DESC_TIPO := L_DESCTIPO;
        --23 ABR 2019 SE INCLUYEN LOS SIGUIENTES TRES CAMPOS Y SE INICIALIZAN EN NULO
        --PORQUE ESTAN HACIENDO FALLAR EL WS
        L_TYPTERCGEN.CIUDAD    := SIM_TYP_LOOKUP('0', 'N/A');
        L_TYPTERCGEN.PROFESION := SIM_TYP_LOOKUP('0', 'N/A');
        L_TYPTERCGEN.OCUPACION := SIM_TYP_LOOKUP('0', 'N/A');
        L_ARRAY_TERCEROS.EXTEND;
        L_ARRAY_TERCEROS(L_ARRAY_TERCEROS.COUNT) := L_TYPTERCGEN;
      
        --    l_Typ_Poliza.Datosfijos.nro_documto.codigo
        --    l_Typ_Poliza.Datosfijos.nro_documto.valor
      
        --    l_Typ_Poliza.Datosfijos.tdoc_tercero.codigo
      
      END IF;
    
      /*If l_Array_Terceros.Exists(1) Then
        If l_Array_Terceros.Count > 0 Then
          For i In l_Array_Terceros.First .. l_Array_Terceros.Last Loop
            Dbms_Output.Put_Line('Terceros:        ' || l_Array_Terceros(i)
                                 .Numero_Documento || '*     *:' || l_Array_Terceros(i)
                                 .Nombres || '*');
          End Loop;
        End If;
      End If;*/
    
      L_ARRAY_ACCESORIOS := NEW SIM_TYP_ARRAY_AUTOSACCESORIOS();
    
      FOR REG_ACC IN C_ACC(L_NUMSECUPOL, L_NUMEND) LOOP
        L_ARRAY_ACCESORIOS.EXTEND;
        --Ini RCB: Modificaciones Ventas - Descripción del Accesorio.
        REG_ACC.TIPACC.COD_ACCES.VALOR := FUN_DESCACCESORIO(REG_ACC.TIPACC.COD_ACCES.CODIGO,
                                                            L_TYP_POLIZA.DATOSFIJOS.COD_CIA.CODIGO);
        --Para modificaciones ventas se visualiza la columna original que
        --toma valor inverso a mca_tarifa
        IF IP_PROCESO.P_SISTEMA_ORIGEN = 101 AND IP_PROCESO.P_CANAL = 3 THEN
          CASE NVL(REG_ACC.TIPACC.MCA_TAR, 'N')
            WHEN 'N' THEN
              REG_ACC.TIPACC.MCA_TAR := 'S';
            WHEN 'S' THEN
              REG_ACC.TIPACC.MCA_TAR := 'N';
          END CASE;
        END IF;
        --Fin RCB
        L_ARRAY_ACCESORIOS(L_ARRAY_ACCESORIOS.COUNT) := REG_ACC.TIPACC;
      END LOOP;
    
      /*If l_Array_Accesorios.Exists(1) Then
        If l_Array_Accesorios.Count > 0 Then
          For i In l_Array_Accesorios.First .. l_Array_Accesorios.Last Loop
            Dbms_Output.Put_Line('Terceros:        ' || l_Array_Accesorios(i)
                                 .Cod_Acces.Codigo || '*     *:' || l_Array_Accesorios(i)
                                 .Valor_Acces || '*');
          End Loop;
        End If;
      End If;*/
    
      L_TYP_PRIMA := NEW SIM_TYP_PRIMA();
    
      --    If ip_proceso.p_cod_producto IN (940, 942, 946) then
      IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
        BEGIN
          SELECT COUNT(1)
            INTO L_ENCONTROX
            FROM X2000160
           WHERE NUM_SECU_POL = L_NUMSECUPOL;
        END;
      
        IF L_ENCONTROX > 0 THEN
          BEGIN
            SELECT SIM_TYP_PRIMA(NUM_SECU_POL,
                                 0,
                                 IMP_PRIMA_END,
                                 IMP_DER_EMI,
                                 IMP_IMPUESTO,
                                 PORC_BONIF,
                                 IMP_BONIF,
                                 PREMIO_END,
                                 SUMA_ASEG,
                                 PRIMA_ANU)
              INTO L_TYP_PRIMA
              FROM X2000160
             WHERE NUM_SECU_POL = L_NUMSECUPOL;
          END;
        ELSE
          BEGIN
            SELECT SIM_TYP_PRIMA(NUM_SECU_POL,
                                 NUM_END,
                                 IMP_PRIMA_END,
                                 IMP_DER_EMI,
                                 IMP_IMPUESTO,
                                 PORC_BONIF,
                                 IMP_BONIF,
                                 PREMIO_END,
                                 SUMA_ASEG,
                                 PRIMA_ANU)
              INTO L_TYP_PRIMA
              FROM A2000160 A
             WHERE NUM_SECU_POL = L_NUMSECUPOL
                  --And Num_End = l_Numend; --rcb
               AND NUM_END = (SELECT MAX(NUM_END)
                                FROM A2000160 D
                               WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                                 AND D.NUM_END <= L_NUMEND);
          END;
        END IF;
      ELSE
        BEGIN
          SELECT SIM_TYP_PRIMA(NUM_SECU_POL,
                               NUM_END,
                               IMP_PRIMA,
                               IMP_DER_EMI,
                               IMP_IMPUESTO,
                               PORC_BONIF,
                               IMP_BONIF,
                               PREMIO,
                               SUMA_ASEG,
                               PRIMA_ANU)
            INTO L_TYP_PRIMA
            FROM A2000160 A
           WHERE NUM_SECU_POL = L_NUMSECUPOL
                --And Num_End = l_Numend; --rcb
             AND NUM_END = (SELECT MAX(NUM_END)
                              FROM A2000160 D
                             WHERE D.NUM_SECU_POL = A.NUM_SECU_POL
                               AND D.NUM_END <= L_NUMEND);
        END;
      END IF;
    
      --Juan Gonzalez (04102017)
      --Mantis 58211
      IF SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
        IF IP_PROCESO.P_PROCESO = 241 THEN
          FOR REG_C_CT IN C_CT(L_NUMSECUPOL, L_NUMEND) LOOP
            IF REG_C_CT.COD_ERROR IN
               (72, 73, 875, 877, 878, 879, 881, 882, 949) THEN
              --Estos controles requieren Agendamiento Medico
              L_CANTMSGS := L_CANTMSGS + 1;
              L_ERROR    := SIM_TYP_ERROR(-20000,
                                          L_CANTMSGS || '-' ||
                                          REG_C_CT.DESC_ERROR,
                                          'E');
              OP_ARRERRORES.EXTEND;
              OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
              OP_RESULTADO := 1;
            END IF;
          END LOOP;
        END IF;
      END IF;
    
      --Insertado por Juan González (27052019) -- Manejo de EG Arbol de Declaración de A
      IF IP_PROCESO.P_COD_PRODUCTO = 766 AND IP_PROCESO.P_PROCESO = 241 THEN
        BEGIN
          FOR COB_R IN (SELECT COD_RIES
                          FROM X2000040 X
                         WHERE X.NUM_SECU_POL = L_NUMSECUPOL
                           AND X.COD_COB = 680
                           AND X.COD_SELECC = 'S') LOOP
            L_CANTIDAD := 0;
          
            --Valida la cobertura enf Graves
            SELECT COUNT(1)
              INTO L_CANTIDAD
              FROM X2000040 A
             WHERE A.NUM_SECU_POL = L_NUMSECUPOL
               AND A.COD_RIES = COB_R.COD_RIES
               AND A.COD_COB = 680
               AND A.COD_SELECC = 'S';
          
            --Valida las preguntas de declaracion
            IF L_CANTIDAD > 0 THEN
              SELECT COUNT(1)
                INTO L_CANTIDAD
                FROM SIM_DECL_ASEG_POL P
               WHERE NUM_SECU_POL = L_NUMSECUPOL
                 AND ID_PREDECASE IN (30001158)
                 AND NVL(VALOR, 'NO') = 'SI'
                 AND P.COD_RIES = COB_R.COD_RIES;
              IF L_CANTIDAD > 0 THEN
                L_CANTIDAD := 0;
                SELECT COUNT(1)
                  INTO L_CANTIDAD
                  FROM SIM_DECL_ASEG_POL S
                 WHERE NUM_SECU_POL = L_NUMSECUPOL
                   AND ID_PREDECASE IN (30001159)
                   AND S.COD_RIES = COB_R.COD_RIES
                   AND NVL(VALOR, 'NO') = 'SI';
              END IF;
            END IF;
            IF L_CANTIDAD > 0 THEN
              L_ERROR := SIM_TYP_ERROR(-20000,
                                       'ERROR NO DEBE INCLUIR ALGUNAS COBERTURAS',
                                       'W');
              OP_ARRERRORES.EXTEND;
              OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
              OP_RESULTADO := 1;
            END IF;
          END LOOP;
        END;
      END IF;
    
      /*BRGH bloque que determina si existe debito automatico y carga la respectiva informaciión*/
      /* JIR-GD717-336: completo con ceros a la izquierda al número de cuenta de Tronador según longitud 
      configurada para banco y canal de descuento (nuevo proceso renov. pol. hijas) - 06-10-2023 */
      IF (L_TYP_POLIZA.DATOSFIJOS.FOR_COBRO IS NOT NULL AND
         L_TYP_POLIZA.DATOSFIJOS.FOR_COBRO.CODIGO = 'DB') THEN
        BEGIN
          SELECT SIM_TYP_DATOSDEBITOGEN(A.NUM_SECU_POL,
                                        A.NUM_END,
                                        SIM_TYP_LOOKUP(A.COD_ENTIDAD, ''),
                                        SIM_TYP_LOOKUP(A.CANAL_DESCTO, ''),
                                        NVL(A.SIM_NRO_CUENTA,
                                            LPAD(A.NRO_CUENTA,
                                                 NVL(FNC_LONG_CUENTA(A.COD_ENTIDAD,
                                                                     A.CANAL_DESCTO),
                                                     LENGTH(A.NRO_CUENTA)),
                                                 '0')),
                                        SIM_TYP_LOOKUP(A.COD_IDENTIF, ''),
                                        A.FECHA_VTO,
                                        A.NOMBRE_IDEN,
                                        A.DIRECCION_IDEN,
                                        SIM_TYP_LOOKUP(A.CIUDAD_IDEN, ''),
                                        A.TELEFONO_IDEN,
                                        SIM_TYP_LOOKUP(A.TIPDOC_CTAHABIENTE,
                                                       ''),
                                        A.SECTER_CTAHABIENTE,
                                        A.TC_NRO_CUOTAS,
                                        A.EMAIL)
            INTO L_TYP_DEBITOAUT
            FROM A2000060 A
           WHERE A.NUM_SECU_POL = L_TYP_POLIZA.DATOSFIJOS.NUM_SECU_POL
             AND A.NUM_END =
                 (SELECT MAX(W.NUM_END)
                    FROM A2000060 W
                   WHERE W.NUM_SECU_POL = A.NUM_SECU_POL);
        
          L_ARRAY_TYP_DEBITOAUT := NEW SIM_TYP_ARRAY_DATOSDEBITOGEN();
          L_ARRAY_TYP_DEBITOAUT.EXTEND();
          L_ARRAY_TYP_DEBITOAUT(L_ARRAY_TYP_DEBITOAUT.COUNT()) := L_TYP_DEBITOAUT;
        
          L_TYP_POLIZA.DEBITOAUT := L_ARRAY_TYP_DEBITOAUT;
        
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
      END IF;
      /*Fin BERGH*/
    
      L_TYP_POLIZA.DATOSVEHICULOS := L_ARRAY_DF_AUTOS;
      L_TYP_POLIZA.DATOSTERCEROS  := L_ARRAY_TERCEROS;
      L_TYP_POLIZA.AGENTES        := L_ARRAY_TYP_AGE;
      L_TYP_POLIZA.PRIMA          := L_TYP_PRIMA;
      L_TYP_POLIZA.ACCESORIOS     := L_ARRAY_ACCESORIOS;
    
      OP_OBJPOLIZA := NEW SIM_TYP_POLIZAGEN();
      OP_OBJPOLIZA := L_TYP_POLIZA;
      --Sim_Proc_Log('pinfo2 MCATERMOK3', l_Typ_Poliza.Datosfijos.Mca_Term_Ok);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_CONSOBJPOL;
  /*********************************************************************/
  FUNCTION FUN_TRAE_PRIMAXRIES(IP_NUMSECUPOL NUMBER,
                               IP_NUMEND     NUMBER,
                               IP_CODRIES    NUMBER) RETURN NUMBER IS
    L_PRIMAXRIES NUMBER;
  BEGIN
    L_PRIMAXRIES := 0;
  
    BEGIN
      SELECT SUM(C.END_PRIMA_COB) PRIMARIES
        INTO L_PRIMAXRIES
        FROM A2000040 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.NUM_END = IP_NUMEND
         AND C.COD_RIES = IP_CODRIES
         AND C.END_PRIMA_COB != 0
       GROUP BY C.COD_RIES;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    RETURN L_PRIMAXRIES;
  END FUN_TRAE_PRIMAXRIES;

  PROCEDURE PROC_IMPRIME_DOC1(OP_IMPRIME    OUT VARCHAR2,
                              IP_VALIDACION IN VARCHAR2,
                              IP_PROCESO    IN SIM_TYP_PROCESO,
                              OP_RESULTADO  OUT NUMBER,
                              OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_MARCAIMP SIM_PCK_TIPOS_GENERALES.T_CARACTER;
  BEGIN
    L_MARCAIMP := 'N';
  
    BEGIN
      SELECT A.DAT_CAR
        INTO L_MARCAIMP
        FROM C9999909 A
       WHERE A.COD_CIA = IP_PROCESO.P_COD_CIA
         AND A.COD_SECC = IP_PROCESO.P_COD_SECC
         AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND A.CODIGO1 = IP_PROCESO.P_PROCESO
         AND A.COD_TAB = 'SIM_IMPRIME_WEB_DOC1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*Sim_Proc_Log('sim_imprime_doc1',
    'Imprime' || l_Marcaimp || 'Ip_proceso.p_cod_cia' ||
    Ip_Proceso.p_Cod_Cia || 'Ip_proceso.p_cod_secc' ||
    Ip_Proceso.p_Cod_Secc || 'Ip_proceso.p_cod_producto' ||
    Ip_Proceso.p_Cod_Producto || 'Ip_proceso.p_proceso' ||
    Ip_Proceso.p_Proceso);*/
    OP_IMPRIME   := L_MARCAIMP;
    OP_RESULTADO := 0;
  END PROC_IMPRIME_DOC1;

  PROCEDURE PROC_UPDATEDELTYPECOB(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                  IP_VALIDACION IN VARCHAR2,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NUMBER,
                                  OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_COD_COB A2000040.COD_COB%TYPE;
  BEGIN
    BEGIN
      -- GD748-1 Rwinter 18/04/2023: Se agrega un nuevo bloque para marcar las coberturas de la sección 118
      IF IP_PROCESO.P_CANAL = 3 AND IP_PROCESO.P_COD_CIA = 2 AND
         IP_PROCESO.P_COD_SECC = 118 THEN
        IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
          FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
            IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.EXISTS(1) THEN
              FOR C IN IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                          .DATOSCOBERTURAS.LAST LOOP
              
                IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                 .SUMA_ASEG = 0 AND
                    SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
                
                  UPDATE X2000040 A
                     SET A.SUMA_ASEG          = NULL, --Nvl(Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).Suma_Aseg, 0),
                         A.SIM_SUMA_ASEG_ORIG = NULL, -- Nvl(Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).Suma_Aseg,0),
                         A.SIM_MCA_SUMA_INF   = 'S',
                         A.MCA_PRIMA_INF      = 'N',
                         A.SUMA_ASEG_CONS     = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                    .SUMA_ASEG,
                                                    0)
                   WHERE A.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                     AND A.COD_RIES = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_RIES
                     AND A.COD_COB = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_COB.CODIGO;
                  -- GD748-155 Rwinter 09/06/2023: Se agrega el ELSE para la actualizacion de las coberturas cuando el valor no sea 0
                ELSE
                  UPDATE X2000040 A
                     SET A.SUMA_ASEG = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                           .SUMA_ASEG,
                                           0)
                   WHERE A.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                     AND A.COD_RIES = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_RIES
                     AND A.COD_COB = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_COB.CODIGO;
                END IF;
              END LOOP;
            END IF;
          END LOOP;
        END IF;
      
        --aeem AJUSTE M6E 23/02/2024
      ELSIF IP_PROCESO.P_CANAL = 3 AND IP_PROCESO.P_COD_CIA = 3 AND
            IP_PROCESO.P_COD_SECC = 14 AND IP_PROCESO.P_COD_PRODUCTO = 153 THEN
        IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
          FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
            IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.EXISTS(1) THEN
              FOR C IN IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                          .DATOSCOBERTURAS.LAST LOOP
              
                IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                 .SUMA_ASEG = 0 AND
                    SIM_PCK_FUNCION_GEN.ESPRODUCTOATGCVIDA(IP_PROCESO.P_COD_PRODUCTO) = 'S' THEN
                
                  UPDATE X2000040 A
                     SET A.SUMA_ASEG          = NULL, --Nvl(Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).Suma_Aseg, 0),
                         A.SIM_SUMA_ASEG_ORIG = NULL, -- Nvl(Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).Suma_Aseg,0),
                         A.SIM_MCA_SUMA_INF   = 'S',
                         A.MCA_PRIMA_INF      = 'N',
                         A.SUMA_ASEG_CONS     = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                    .SUMA_ASEG,
                                                    0)
                   WHERE A.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                     AND A.COD_RIES = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_RIES
                     AND A.COD_COB = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_COB.CODIGO;
                  -- GD748-155 Rwinter 09/06/2023: Se agrega el ELSE para la actualizacion de las coberturas cuando el valor no sea 0
                ELSE
                  UPDATE X2000040 A
                     SET A.SUMA_ASEG     = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                               .SUMA_ASEG,
                                               0),
                         A.PRIMA_COB     = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                               .PRIMA_COB,
                                               0),
                         A.END_PRIMA_COB = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                               .PRIMA_COB,
                                               0)
                  
                   WHERE A.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                     AND A.COD_RIES = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_RIES
                     AND A.COD_COB = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_COB.CODIGO;
                END IF;
              END LOOP;
            END IF;
          END LOOP;
        END IF;
      
        --fin aeem
      ELSIF (IP_PROCESO.P_CANAL = 3 AND IP_PROCESO.P_COD_CIA = 2 AND
            IP_PROCESO.P_COD_SECC IN (47, 48)) OR
            (IP_PROCESO.P_CANAL = 6 AND IP_PROCESO.P_COD_PRODUCTO = 948) THEN
        IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
          FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
            IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.EXISTS(1) THEN
              FOR C IN IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                          .DATOSCOBERTURAS.LAST LOOP
                SIM_PROC_LOG('Valores originales:' || IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                             .COD_COB.CODIGO || ' - ' ||
                             NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                 .SUMA_ASEG,
                                 0),
                             'zCoberturas');
              
                IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                 .SUMA_ASEG != 0 THEN
                  L_COD_COB := IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                               .COD_COB.CODIGO;
                
                  UPDATE X2000040 A
                     SET A.SUMA_ASEG          = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                    .SUMA_ASEG,
                                                    0),
                         A.SIM_SUMA_ASEG_ORIG = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                    .SUMA_ASEG,
                                                    0),
                         A.SIM_MCA_SUMA_INF   = 'N',
                         -- Wesv: se incluye este campo para guardar el valor inicial enviado
                         --por el cotizador de vida. 20131227
                         A.SUMA_ASEG_CONS  = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                 .SUMA_ASEG,
                                                 0),
                         A.PRIMA_ANIO_CONS = DECODE(IP_PROCESO.P_CANAL,
                                                    6,
                                                    NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                        .PRIMA_COB,
                                                        0),
                                                    NULL)
                   WHERE A.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                     AND A.COD_RIES = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_RIES
                     AND A.COD_COB = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_COB.CODIGO;
                END IF;
              END LOOP;
            END IF;
          END LOOP;
        END IF;
      
        /* Se incluyen coberturas para que el proceso de reenganche conserve
        las sumas informadas desde cotizadores */
        BEGIN
          UPDATE X2000040 A
             SET A.SIM_MCA_SUMA_INF = 'S',
                 A.SUMA_ASEG        = 0,
                 A.END_SUMA_ASEG    = 0
           WHERE A.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
             AND COD_COB != 901
             AND (NVL(A.SUMA_ASEG, 0) = 0 OR
                 COD_COB IN (908, 911, 912, 916, 918));
        END;
        -- **************************************
        -- CUMPLIMIENTO: Agregamos Canal 5, Sistema origen 100
        -- **************************************
      ELSIF IP_PROCESO.P_CANAL = 5 AND IP_PROCESO.P_COD_CIA = 3 AND
            IP_PROCESO.P_COD_SECC = 4 THEN
        PROC_MAPEO_COB_CUMP(IP_POLIZA     => IP_POLIZA,
                            IP_NUMSECUPOL => IP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                            IP_NUMEND     => IP_POLIZA.DATOSFIJOS.NUM_END,
                            IP_PROCESO    => IP_PROCESO,
                            OP_RESULTADO  => OP_RESULTADO,
                            OP_ARRERRORES => OP_ARRERRORES);
      ELSIF IP_PROCESO.P_CANAL = 7 THEN
        -- SIMON API
        IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
          FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
            IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.EXISTS(1) THEN
              FOR C IN IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                          .DATOSCOBERTURAS.LAST LOOP
                IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                 .SUMA_ASEG != 0 THEN
                  L_COD_COB := IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                               .COD_COB.CODIGO;
                  /*  sim_proc_log('API ries'|| Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).cod_ries||'-'||
                                  Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).cod_cob.codigo,
                                 Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).Suma_Aseg||'-'||
                                  Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).Prima_cob||'-'||
                                   Ip_Poliza.Datosriesgos(r).Datoscoberturas(c).tasa_cob);
                  */
                  UPDATE X2000040 A
                     SET A.SUMA_ASEG_CONS      = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                 .SUMA_ASEG,
                         A.PRIMA_ANIO_CONS     = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                 .PRIMA_COB,
                         A.TARIFA              = ROUND(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                       .TASA_COB,
                                                       3),
                         A.END_TASA_TOTAL      = ROUND(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                       .TASA_TOTAL,
                                                       3),
                         A.SIM_TASA_TOTAL_ORIG = ROUND(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                       .TASA_TOTAL,
                                                       3),
                         A.END_TASA_AGR        = ROUND(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                       .TASA_AGR,
                                                       3),
                         A.DESCUENT_PRIMA      = ROUND(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                       .DESCUENT_PRIMA,
                                                       3)
                   WHERE A.NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL
                     AND A.COD_RIES = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_RIES
                     AND A.COD_COB = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                        .COD_COB.CODIGO;
                END IF;
              END LOOP;
            END IF;
          END LOOP;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    OP_RESULTADO := 0;
  END PROC_UPDATEDELTYPECOB;

  PROCEDURE PROC_DETALLE_POLIZASNORENOV(IP_LISTAPOLIZAS IN SIM_TYP_ARRAY_LISTA,
                                        IP_TOMADOR      IN NUMBER,
                                        OP_ARRAYPOLIZAS OUT SIM_TYP_ARRAY_POLIZAGEN,
                                        IP_VALIDACION   IN VARCHAR2,
                                        IP_PROCESO      IN SIM_TYP_PROCESO,
                                        OP_RESULTADO    OUT NUMBER,
                                        OP_ARRERRORES   OUT SIM_TYP_ARRAY_ERROR) IS
    L_DETALLEPOLIZA SIM_TYP_POLIZAGEN;
    L_POLIZA        SIM_TYP_LISTA;
    L_NROPOLIZA     NUMBER;
    L_PRODUCTO      NUMBER;
    L_SI            VARCHAR2(1) := 'S';
    L_NULL          VARCHAR2(1);
  
    CURSOR POLIZASTOMADOR IS
      SELECT NUM_SECU_POL, COD_CIA, COD_SECC, COD_RAMO, NUM_POL1
        FROM A2000030 A
       WHERE NRO_DOCUMTO = IP_TOMADOR
         AND NVL(COD_SECC, 0) = IP_PROCESO.P_COD_SECC
         AND NVL(COD_RAMO, 0) = IP_PROCESO.P_COD_PRODUCTO
         AND NUM_END = (SELECT MAX(NUM_END)
                          FROM A2000030
                         WHERE NUM_SECU_POL = A.NUM_SECU_POL)
         AND NVL(RENOVADA_POR, 0) = 0
         AND NVL(MCA_ANU_POL, 'N') = 'N';
  
    L_NUMSECUPOL NUMBER;
    L_PROCESO    SIM_TYP_PROCESO;
  BEGIN
    L_ERROR         := NEW SIM_TYP_ERROR;
    OP_ARRERRORES   := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO    := SIM_PCK_TIPOS_GENERALES.C_CERO;
    OP_ARRAYPOLIZAS := NEW SIM_TYP_ARRAY_POLIZAGEN();
    L_DETALLEPOLIZA := NEW SIM_TYP_POLIZAGEN;
    L_POLIZA        := NEW SIM_TYP_LISTA;
  
    IF IP_TOMADOR IS NOT NULL OR IP_LISTAPOLIZAS.COUNT > 0 THEN
      IF IP_TOMADOR IS NOT NULL THEN
        FOR J IN POLIZASTOMADOR LOOP
          L_PROCESO                := NEW SIM_TYP_PROCESO;
          L_PROCESO.P_COD_CIA      := J.COD_CIA;
          L_PROCESO.P_COD_SECC     := J.COD_SECC;
          L_PROCESO.P_COD_PRODUCTO := J.COD_RAMO;
          L_NROPOLIZA              := J.NUM_POL1;
          L_NUMSECUPOL             := J.NUM_SECU_POL;
          PROC_RECUPERA_DETALLEPOL(L_NROPOLIZA,
                                   L_DETALLEPOLIZA,
                                   L_NUMSECUPOL,
                                   L_NULL,
                                   L_SI,
                                   IP_PROCESO,
                                   OP_RESULTADO,
                                   OP_ARRERRORES);
        
          IF OP_RESULTADO = 0 THEN
            OP_ARRAYPOLIZAS.EXTEND;
            OP_ARRAYPOLIZAS(OP_ARRAYPOLIZAS.COUNT) := L_DETALLEPOLIZA;
          END IF;
        END LOOP;
      ELSE
        FOR I IN IP_LISTAPOLIZAS.FIRST .. IP_LISTAPOLIZAS.LAST LOOP
          L_POLIZA    := IP_LISTAPOLIZAS(I);
          L_NROPOLIZA := L_POLIZA.CODIGO;
          L_PRODUCTO  := L_POLIZA.VALOR;
        
          BEGIN
            SELECT NUM_SECU_POL
              INTO L_NUMSECUPOL
              FROM A2000030 A
             WHERE NUM_POL1 = L_NROPOLIZA
               AND NVL(COD_SECC, 0) = IP_PROCESO.P_COD_SECC
               AND NUM_END =
                   (SELECT MAX(NUM_END)
                      FROM A2000030
                     WHERE NUM_SECU_POL = A.NUM_SECU_POL)
               AND NVL(RENOVADA_POR, 0) = 0
               AND NVL(MCA_ANU_POL, 'N') = 'N';
          
            PROC_RECUPERA_DETALLEPOL(L_NROPOLIZA,
                                     L_DETALLEPOLIZA,
                                     L_NUMSECUPOL,
                                     L_NULL,
                                     L_SI,
                                     IP_PROCESO,
                                     OP_RESULTADO,
                                     OP_ARRERRORES);
          
            IF OP_RESULTADO = 0 THEN
              OP_ARRAYPOLIZAS.EXTEND;
              OP_ARRAYPOLIZAS(OP_ARRAYPOLIZAS.COUNT) := L_DETALLEPOLIZA;
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END LOOP;
      END IF;
    
      IF OP_ARRAYPOLIZAS.COUNT = 0 THEN
        L_ERROR := SIM_TYP_ERROR(SQLCODE,
                                 'No existen pólizas pendientes de renovar para los parametros ingresados',
                                 'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
        OP_RESULTADO := -1;
      END IF;
    ELSE
      L_ERROR := SIM_TYP_ERROR(SQLCODE,
                               'Faltan parametros de entrada (Tomador o Pólizas)',
                               'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, G_SUBPROGRAMA || SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_RECUPERA_DETALLEPOL(IP_NUMPOL1    IN A2000030.NUM_POL1%TYPE,
                                     OP_POLIZA     OUT SIM_TYP_POLIZAGEN,
                                     IP_NUMSECUPOL IN NUMBER,
                                     IP_NUMEND     IN NUMBER,
                                     IP_VIGENTE    IN VARCHAR2,
                                     IP_PROCESO    IN SIM_TYP_PROCESO,
                                     OP_RESULTADO  OUT NUMBER,
                                     OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_TIPOCOA NUMBER;
  
    CURSOR DF(C_NUMEND NUMBER) IS
      SELECT COD_CIA,
             COD_SECC,
             NUM_POL1,
             NUM_POL_FLOT,
             FECHA_EMI,
             FECHA_VIG_POL,
             FECHA_VENC_POL,
             COD_PROD,
             NUM_POL_ANT,
             NUM_SECU_POL,
             NRO_DOCUMTO,
             COD_RAMO,
             MCA_ANU_POL,
             DESC_POL,
             NUM_END,
             COD_END,
             SUB_COD_END,
             TIPO_END,
             FEC_ANU_POL,
             MCA_EXCLUSIVO,
             MCA_TERM_OK,
             COD_USR,
             COD_USER_EXCLU,
             COD_DURACION,
             COD_MON,
             PERIODO_FACT,
             FOR_COBRO,
             COD_PLAN_PAGO,
             MCA_PROVISORIO,
             TDOC_TERCERO,
             SEC_TERCERO,
             SUC_TERCERO,
             SIM_SUBPRODUCTO,
             SIM_NUMERO_STELLENT,
             SIM_REFERIDO,
             SIM_PAQUETE_SEGURO,
             COD_COA,
             NUM_POL_COTIZ,
             MCA_PRORRATA,
             FECHA_EMI_END,
             FECHA_VIG_END,
             FECHA_VENC_END,
             TC,
             TC_PROMED,
             MCA_IMPTOS,
             CANT_CUOTAS,
             CANT_CUOTAS_IMP,
             RENOVADA_POR,
             CANT_ANUAL,
             COD_CONV,
             CANT_UBIC,
             CANT_SINI1,
             CANT_SINI2,
             CANT_SINI3,
             CANT_SINI4,
             CANT_SINI5,
             COD_CIACOA,
             NUM_POL_COA,
             NUM_ENDOSO_COA,
             PORC_PARTCOA,
             DESC_CLAUSULA,
             MCA_CL90,
             CANT_CL90,
             CANT_COP_FRE,
             NUM_POL_CLI,
             NUM_END_MODI,
             MCA_END_ANU,
             FEC_ANU_END,
             MCA_ADM_PROD,
             MCA_POL_CALC,
             MCA_IMP_POL,
             MCA_IMP_CL90,
             MCA_IMP_REC,
             MCA_IMP_ANXCOA,
             MCA_MOD_DCOBRO,
             MCA_COND_FEA,
             MCA_BONA_FEA,
             MCA_REST_BON,
             COD_USER_RESP,
             NUM_AUTORIZA,
             FEC_AUTORIZA,
             MCA_AUTORIZA,
             NRO_PERIODO,
             FECHA_VIG_PER,
             FECHA_VENC_PER,
             MCA_END_TEMP,
             MCA_PER_ANUL,
             COD_CONV_ORG,
             FECHA_EQUIPO,
             VAL_CM_FV,
             FECHA_ULT_DENU,
             MCA_SUSP_VIG,
             MCA_DATOS_MIN,
             MCA_RENOV,
             MCA_POL_VUE,
             MCA_RV_AUT,
             COEF_POL,
             FECHA_MOVI,
             MCA_COND_FR,
             NUM_END_FLOT,
             COD_COBRADOR,
             NODO_ID,
             MCA_TRANSMIT,
             FECHA_ANTIC,
             TC_UF,
             SOLICITUD,
             MCA_CADUCA,
             MCA_AVISO,
             NUM_TARJETA,
             COD_PROG,
             MCA_FACTURA,
             PORC_COMCOA,
             PERIODIC_PAGO,
             TIPO_REGULARIZACION,
             PORC_REGULARIZACION,
             COD_INDICE_REGUL,
             TEXTO_ESPECIAL,
             PRIMAS_ESPECIALES,
             ANOS_MAX_DUR,
             MESES_MAX_DUR,
             DIAS_MAX_DUR,
             DURACION_PAGO_PRIMA,
             MCA_PDTE_CUMULO,
             CES_DERECHOS,
             COD_CESION,
             COMISIONES_MANUALES,
             MCA_END_ANUL,
             MCA_COTIZACION,
             FECHA_COTIZ,
             IMPORTE_COTIZ,
             MCA_CESION_GTIA,
             MCA_MULTIRAMO,
             MCA_END_DTOT,
             NUM_LIQ,
             COEFCOB,
             NRO_EJECUCION,
             USUARIO_IMPRE,
             PROMOTOR,
             FECHA_CREACION,
             SISTEMA_ORIGEN,
             FEC_IMP_POL,
             CARNET_GENERADO,
             SIM_VINCULACION,
             SIM_TIPO_NEGOCIO,
             SIM_USUARIO_CREACION,
             SIM_COLECTIVA,
             SIM_TIPO_COLECTIVA,
             SIM_CANAL,
             SIM_MARCA_TARIFA,
             SIM_COD_SECC_ANT,
             SIM_NUM_COTIZ_ANT,
             SIM_USUARIO_EXCLUSIVO,
             SIM_USUARIO_AUTORIZA,
             SIM_MODO_IMPRESION,
             SIM_SISTEMA_ORIGEN,
             SIM_TIPO_PROCESO,
             SIM_TIPO_ENVIO
        FROM A2000030 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.NUM_END = C_NUMEND;
  
    CURSOR COB IS
      SELECT A.COD_RIES,
             A.COD_COB,
             '' TXT_COB, --a.txt_cob,
             A.END_SUMA_ASEG,
             A.END_PRIMA_COB,
             A.END_TASA_COB,
             A.END_TASA_TOTAL,
             A.PORC_PPAGO,
             A.IND_AJUSTE,
             A.PORC_REBAJA,
             A.TASA_AGR,
             A.MCA_GRATUITA,
             A.NUM_SECU
        FROM A2000040 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.END_PRIMA_COB != 0;
  
    CURSOR PRIMAXRIE IS
      SELECT C.COD_RIES, SUM(C.END_PRIMA_COB) PRIMARIES
        FROM A2000040 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.END_PRIMA_COB != 0
       GROUP BY C.COD_RIES;
  
    CURSOR PRIMA IS
      SELECT B.IMP_PRIMA_END,
             B.IMP_DER_EMI_EN,
             B.IMP_IMPUESTO_E,
             B.PORC_BONIF_EN,
             B.IMP_BONIF_EN,
             B.PREMIO_END,
             B.SUMA_ASEG,
             B.PRIMA_ANU
        FROM A2000160 B
       WHERE B.NUM_SECU_POL = IP_NUMSECUPOL;
  
    L_ENCONTRO             SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_DFPOLIZA             SIM_TYP_DATOSFIJOS;
    L_COBERTURA            SIM_TYP_COBERTURAPOLIZAGEN;
    L_OP_TYP_COASEGURADORA SIM_TYP_ARRAY_COASEGUROPOLIZA;
  
    L_DATOSFIJOS   SIM_TYP_DATOSFIJOS;
    L_PRIMA        SIM_TYP_PRIMA;
    L_DATOSRIESGOS SIM_TYP_RIESGOGEN;
    --l_datosriesgo           sim_typ_DatosRiesgo;
    L_POLIZA       SIM_TYP_POLIZAGEN;
    L_NUMEND       A2000030.NUM_END%TYPE;
    L_NUMPOL1      A2000030.NUM_POL1%TYPE;
    L_VALIDACION   VARCHAR2(1);
    L_MARCA_PPAL   VARCHAR2(1) := 'N';
    L_FECHAEMISION DATE;
  
    L_AGENTESPOL       SIM_TYP_ARRAY_AGENTESPOL;
    L_OP_AGENTESPOL    SIM_ARRAY_AGENTE_POLIZA;
    L_OP_TYP_RIESGOGEN SIM_TYP_ARRAY_RIESGOSGEN;
    L_OP_TYP_RIESGO    SIM_TYP_ARRAY_DATOSRIESGO;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_UpdateTypedeA';
    L_COBERTURA   := NEW SIM_TYP_COBERTURAPOLIZAGEN;
    --  l_datosriesgo   := New sim_typ_DatosRiesgo;
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_DFPOLIZA    := NEW SIM_TYP_DATOSFIJOS;
    L_AGENTESPOL  := NEW SIM_TYP_ARRAY_AGENTESPOL();
    L_POLIZA      := NEW SIM_TYP_POLIZAGEN;
  
    L_OP_TYP_COASEGURADORA := NEW SIM_TYP_ARRAY_COASEGUROPOLIZA();
    L_OP_TYP_RIESGOGEN     := NEW SIM_TYP_ARRAY_RIESGOSGEN();
    L_OP_TYP_RIESGO        := NEW SIM_TYP_ARRAY_DATOSRIESGO();
    L_DATOSRIESGOS         := NEW SIM_TYP_RIESGOGEN;
  
    BEGIN
      SELECT NUM_END, NUM_POL1
        INTO L_NUMEND, L_NUMPOL1
        FROM A2000030 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND A.NUM_END =
             (SELECT MAX(B.NUM_END)
                FROM A2000030 B
               WHERE B.NUM_SECU_POL = A.NUM_SECU_POL);
    END;
  
    FOR RDF IN DF(L_NUMEND) LOOP
      L_DATOSFIJOS := NEW
                      SIM_TYP_DATOSFIJOS(SIM_TYP_LOOKUP(RDF.COD_CIA, ''),
                                         SIM_TYP_LOOKUP(RDF.COD_SECC, ''),
                                         RDF.NUM_POL1,
                                         RDF.NUM_POL_FLOT,
                                         RDF.FECHA_EMI,
                                         RDF.FECHA_VIG_POL,
                                         RDF.FECHA_VENC_POL,
                                         SIM_TYP_LOOKUP(RDF.COD_PROD, ''),
                                         RDF.NUM_POL_ANT,
                                         RDF.NUM_SECU_POL,
                                         SIM_TYP_LOOKUP(RDF.NRO_DOCUMTO, ''),
                                         SIM_TYP_LOOKUP(RDF.COD_RAMO, ''),
                                         RDF.MCA_ANU_POL,
                                         RDF.DESC_POL,
                                         RDF.NUM_END,
                                         RDF.COD_END,
                                         RDF.SUB_COD_END,
                                         SIM_TYP_LOOKUP(RDF.TIPO_END, ''),
                                         RDF.FEC_ANU_POL,
                                         RDF.MCA_EXCLUSIVO,
                                         RDF.MCA_TERM_OK,
                                         RDF.COD_USR,
                                         RDF.COD_USER_EXCLU,
                                         RDF.COD_DURACION,
                                         SIM_TYP_LOOKUP(RDF.COD_MON, ''),
                                         SIM_TYP_LOOKUP(RDF.PERIODO_FACT, ''),
                                         SIM_TYP_LOOKUP(RDF.FOR_COBRO, ''),
                                         RDF.COD_PLAN_PAGO,
                                         RDF.MCA_PROVISORIO,
                                         SIM_TYP_LOOKUP(RDF.TDOC_TERCERO, ''),
                                         RDF.SEC_TERCERO,
                                         RDF.SUC_TERCERO,
                                         SIM_TYP_LOOKUP(RDF.SIM_SUBPRODUCTO,
                                                        ''),
                                         RDF.SIM_NUMERO_STELLENT,
                                         RDF.SIM_REFERIDO,
                                         RDF.SIM_PAQUETE_SEGURO,
                                         RDF.NUM_POL_COTIZ,
                                         RDF.MCA_PRORRATA,
                                         RDF.FECHA_EMI_END,
                                         RDF.FECHA_VIG_END,
                                         RDF.FECHA_VENC_END,
                                         RDF.TC,
                                         RDF.TC_PROMED,
                                         RDF.MCA_IMPTOS,
                                         RDF.CANT_CUOTAS,
                                         RDF.CANT_CUOTAS_IMP,
                                         RDF.RENOVADA_POR,
                                         RDF.CANT_ANUAL,
                                         RDF.COD_CONV,
                                         RDF.CANT_UBIC,
                                         RDF.CANT_SINI1,
                                         RDF.CANT_SINI2,
                                         RDF.CANT_SINI3,
                                         RDF.CANT_SINI4,
                                         RDF.CANT_SINI5,
                                         RDF.COD_COA,
                                         SIM_TYP_LOOKUP(RDF.COD_CIACOA, ''),
                                         RDF.NUM_POL_COA,
                                         RDF.NUM_ENDOSO_COA,
                                         RDF.PORC_PARTCOA,
                                         RDF.DESC_CLAUSULA,
                                         RDF.MCA_CL90,
                                         RDF.CANT_CL90,
                                         RDF.CANT_COP_FRE,
                                         RDF.NUM_POL_CLI,
                                         RDF.NUM_END_MODI,
                                         RDF.MCA_END_ANU,
                                         RDF.FEC_ANU_END,
                                         RDF.MCA_ADM_PROD,
                                         RDF.MCA_POL_CALC,
                                         RDF.MCA_IMP_POL,
                                         RDF.MCA_IMP_CL90,
                                         RDF.MCA_IMP_REC,
                                         RDF.MCA_IMP_ANXCOA,
                                         RDF.MCA_MOD_DCOBRO,
                                         RDF.MCA_COND_FEA,
                                         RDF.MCA_BONA_FEA,
                                         RDF.MCA_REST_BON,
                                         RDF.COD_USER_RESP,
                                         RDF.NUM_AUTORIZA,
                                         RDF.FEC_AUTORIZA,
                                         RDF.MCA_AUTORIZA,
                                         RDF.NRO_PERIODO,
                                         RDF.FECHA_VIG_PER,
                                         RDF.FECHA_VENC_PER,
                                         RDF.MCA_END_TEMP,
                                         RDF.MCA_PER_ANUL,
                                         RDF.COD_CONV_ORG,
                                         RDF.FECHA_EQUIPO,
                                         RDF.VAL_CM_FV,
                                         RDF.FECHA_ULT_DENU,
                                         RDF.MCA_SUSP_VIG,
                                         RDF.MCA_DATOS_MIN,
                                         RDF.MCA_RENOV,
                                         RDF.MCA_POL_VUE,
                                         RDF.MCA_RV_AUT,
                                         RDF.COEF_POL,
                                         RDF.FECHA_MOVI,
                                         RDF.MCA_COND_FR,
                                         RDF.NUM_END_FLOT,
                                         RDF.COD_COBRADOR,
                                         RDF.NODO_ID,
                                         RDF.MCA_TRANSMIT,
                                         RDF.FECHA_ANTIC,
                                         RDF.TC_UF,
                                         RDF.SOLICITUD,
                                         RDF.MCA_CADUCA,
                                         RDF.MCA_AVISO,
                                         RDF.NUM_TARJETA,
                                         RDF.COD_PROG,
                                         RDF.MCA_FACTURA,
                                         RDF.PORC_COMCOA,
                                         RDF.PERIODIC_PAGO,
                                         RDF.TIPO_REGULARIZACION,
                                         RDF.PORC_REGULARIZACION,
                                         RDF.COD_INDICE_REGUL,
                                         RDF.TEXTO_ESPECIAL,
                                         RDF.PRIMAS_ESPECIALES,
                                         RDF.ANOS_MAX_DUR,
                                         RDF.MESES_MAX_DUR,
                                         RDF.DIAS_MAX_DUR,
                                         RDF.DURACION_PAGO_PRIMA,
                                         RDF.MCA_PDTE_CUMULO,
                                         RDF.CES_DERECHOS,
                                         RDF.COD_CESION,
                                         RDF.COMISIONES_MANUALES,
                                         RDF.MCA_END_ANUL,
                                         RDF.MCA_COTIZACION,
                                         RDF.FECHA_COTIZ,
                                         RDF.IMPORTE_COTIZ,
                                         RDF.MCA_CESION_GTIA,
                                         RDF.MCA_MULTIRAMO,
                                         RDF.MCA_END_DTOT,
                                         RDF.NUM_LIQ,
                                         RDF.COEFCOB,
                                         RDF.NRO_EJECUCION,
                                         RDF.USUARIO_IMPRE,
                                         RDF.PROMOTOR,
                                         RDF.FECHA_CREACION,
                                         SIM_TYP_LOOKUP(RDF.SISTEMA_ORIGEN,
                                                        ''),
                                         RDF.FEC_IMP_POL,
                                         RDF.CARNET_GENERADO,
                                         RDF.SIM_VINCULACION,
                                         RDF.SIM_TIPO_NEGOCIO,
                                         SIM_TYP_LOOKUP(RDF.SIM_USUARIO_CREACION,
                                                        ''),
                                         RDF.SIM_COLECTIVA,
                                         RDF.SIM_TIPO_COLECTIVA,
                                         SIM_TYP_LOOKUP(RDF.SIM_CANAL, ''),
                                         RDF.SIM_MARCA_TARIFA,
                                         RDF.SIM_COD_SECC_ANT,
                                         RDF.SIM_NUM_COTIZ_ANT,
                                         SIM_TYP_LOOKUP(RDF.SIM_USUARIO_EXCLUSIVO,
                                                        ''),
                                         SIM_TYP_LOOKUP(RDF.SIM_USUARIO_AUTORIZA,
                                                        ''),
                                         SIM_TYP_LOOKUP(RDF.SIM_MODO_IMPRESION,
                                                        ''),
                                         SIM_TYP_LOOKUP(RDF.SIM_SISTEMA_ORIGEN,
                                                        ''),
                                         SIM_TYP_LOOKUP(RDF.SIM_TIPO_PROCESO,
                                                        ''),
                                         SIM_TYP_LOOKUP(RDF.SIM_TIPO_ENVIO,
                                                        ''));
      L_TIPOCOA    := RDF.COD_COA;
    END LOOP;
  
    --Actualiza Agentes
    L_POLIZA.DATOSFIJOS := L_DATOSFIJOS;
  
    SIM_PCK_RECUPERA_DATOS_EMISION.PROC_RECUPERAAGENTEPOLIZA(L_NUMPOL1,
                                                             IP_NUMEND,
                                                             L_MARCA_PPAL,
                                                             IP_VIGENTE,
                                                             L_FECHAEMISION,
                                                             L_OP_AGENTESPOL,
                                                             L_VALIDACION,
                                                             IP_PROCESO,
                                                             OP_RESULTADO,
                                                             OP_ARRERRORES);
  
    IF L_OP_AGENTESPOL.EXISTS(1) THEN
      IF L_OP_AGENTESPOL.COUNT > 0 THEN
        FOR J IN L_OP_AGENTESPOL.FIRST .. L_OP_AGENTESPOL.LAST LOOP
          L_AGENTESPOL.EXTEND;
          L_AGENTESPOL(L_AGENTESPOL.COUNT) := L_OP_AGENTESPOL(J);
        END LOOP;
      END IF;
    END IF;
  
    L_POLIZA.AGENTES := L_AGENTESPOL;
  
    --Actualiza Coaseguradoras
    IF L_TIPOCOA = 1 THEN
      SIM_PCK_RECUPERA_DATOS_EMISION.PROC_RECUPERACOASEGURASPOLIZA(L_NUMPOL1,
                                                                   IP_NUMSECUPOL,
                                                                   L_OP_TYP_COASEGURADORA,
                                                                   L_VALIDACION,
                                                                   IP_PROCESO,
                                                                   OP_RESULTADO,
                                                                   OP_ARRERRORES);
    END IF;
  
    L_POLIZA.COASEGURADORAS := L_OP_TYP_COASEGURADORA;
    -- Riesgos
    SIM_PCK_RECUPERA_DATOS_EMISION.PROC_RECUPERARIESGOPOLIZA(L_NUMPOL1,
                                                             IP_NUMSECUPOL,
                                                             IP_NUMEND,
                                                             NULL,
                                                             IP_VIGENTE,
                                                             L_FECHAEMISION,
                                                             'N',
                                                             L_OP_TYP_RIESGO,
                                                             L_VALIDACION,
                                                             IP_PROCESO,
                                                             OP_RESULTADO,
                                                             OP_ARRERRORES);
  
    IF L_OP_TYP_RIESGO.COUNT > 0 THEN
      FOR I IN L_OP_TYP_RIESGO.FIRST .. L_OP_TYP_RIESGO.LAST LOOP
        IF L_OP_TYP_RIESGO(I).MARCA_BAJA = 'N' THEN
          L_OP_TYP_RIESGOGEN.EXTEND;
          L_DATOSRIESGOS.DATOSRIESGO := L_OP_TYP_RIESGO(I);
          L_OP_TYP_RIESGOGEN(L_OP_TYP_RIESGOGEN.COUNT) := L_DATOSRIESGOS;
        END IF;
      END LOOP;
    
      L_POLIZA.DATOSRIESGOS := L_OP_TYP_RIESGOGEN;
    END IF;
  
    OP_POLIZA := L_POLIZA;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;

  PROCEDURE PROC_EXISTE_INSPECCION_AUTOS(IP_PLACA      VARCHAR2,
                                         OP_CONCEPTO   OUT VARCHAR2,
                                         OP_RESULTADO  OUT NUMBER,
                                         OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    V_CONCEPTO CHAR(1);
  BEGIN
    OP_CONCEPTO   := 'No existe informe de inspección';
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    BEGIN
      SELECT DISTINCT ASEGURABLE
        INTO V_CONCEPTO
        FROM SIM_INSPECCION_AUTOS
       WHERE PLACA = UPPER(IP_PLACA);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_CONCEPTO := NULL;
      WHEN TOO_MANY_ROWS THEN
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                            'Existe mas de un informe de inspección con diferente concepto para la placa ' ||
                                                            IP_PLACA,
                                                            'E');
        OP_RESULTADO := -1;
    END;
  
    IF V_CONCEPTO = 'S' THEN
      OP_CONCEPTO := 'Asegurable';
    ELSIF V_CONCEPTO = 'N' THEN
      OP_CONCEPTO := 'No Asegurable';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          SQLERRM,
                                                          'E');
      OP_RESULTADO := -1;
  END PROC_EXISTE_INSPECCION_AUTOS;

  PROCEDURE PROC_LISTA_CONVENIOSSEGUROS(OP_ARRAYCONVENIOS OUT SIM_TYP_ARRAY_LISTA,
                                        IP_VALIDACION     IN VARCHAR2,
                                        IP_PROCESO        IN SIM_TYP_PROCESO,
                                        OP_RESULTADO      OUT NUMBER,
                                        OP_ARRERRORES     OUT SIM_TYP_ARRAY_ERROR) IS
    L_CONVENIOS     SIM_TYP_LISTA;
    L_TIPOUSR       VARCHAR2(1);
    L_SUBCODBENEF   SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_USRSUBTIPO    SIM_PCK_TIPOS_GENERALES.T_VAR_CORTO;
    L_PAIS          SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO;
    L_CONVENIO      SIM_PCK_TIPOS_GENERALES.T_NUM_CODIGO;
    L_BANDERA_MULTI VARCHAR2(1) := 'N';
  
    CURSOR CONVENIOS IS
    
      SELECT DISTINCT G.CONVENIO, G.DESCRIPCION
        FROM SIM_USUARIOS_CONVENIOS B, SIM_CONVENIO_SEGUROS G
       WHERE USUARIO_HAB = IP_PROCESO.P_COD_USR
         AND G.CONVENIO = B.CONVENIO
         AND G.TIPO_CONVENIO =
             DECODE(L_CONVENIO, NULL, G.TIPO_CONVENIO, L_CONVENIO)
         AND B.FECHA_BAJA IS NULL
         AND CAUSAL IS NULL;
    /*    SELECT DISTINCT convenio
     FROM sim_usuarios_convenios b
    WHERE     usuario_hab = ip_proceso.p_cod_usr
          AND EXISTS
                 (SELECT ''
                    FROM sim_convenio_seguros G
                   WHERE     G.tipo_convenio =
                                DECODE (l_Convenio,
                                        NULL, G.tipo_convenio,
                                        l_Convenio)
                         AND b.convenio = G.convenio)
          AND b.fecha_baja IS NULL
          AND causal IS NULL;*/
  BEGIN
    OP_ARRERRORES     := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO      := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_CONVENIOS       := NEW SIM_TYP_LISTA;
    OP_ARRAYCONVENIOS := NEW SIM_TYP_ARRAY_LISTA();
    L_SUBCODBENEF     := SIM_PCK_SEGURIDAD.SUBCODBENEF(IP_PROCESO);
    L_USRSUBTIPO      := SIM_PCK_SEGURIDAD.USRSUBTIPO(IP_PROCESO);
    L_PAIS            := IP_PROCESO.P_PAIS;
    L_TIPOUSR         := SIM_PCK_SEGURIDAD.TIPOUSUARIO(L_PAIS,
                                                       L_SUBCODBENEF,
                                                       L_USRSUBTIPO); --- hlc 11062020 no aplica para convenios soat
    /*Inicio - Multiclaves 19102018*/
    ---Ip_Proceso);
    /*Fin - Multiclaves 19102018*/
    L_BANDERA_MULTI := SIM_PCK_MULTI_CLAVES_SIMON.FNC_ACTMULTI;
  
    IF L_BANDERA_MULTI != 'S' THEN
      IF L_TIPOUSR = 'A' OR IP_PROCESO.P_INFO4 = 'A' THEN
        L_CONVENIO := 12;
      END IF;
    END IF;
  
    FOR I IN CONVENIOS LOOP
      L_CONVENIOS := SIM_TYP_LISTA(I.CONVENIO, I.DESCRIPCION, NULL);
      OP_ARRAYCONVENIOS.EXTEND;
      OP_ARRAYCONVENIOS(OP_ARRAYCONVENIOS.COUNT) := L_CONVENIOS;
    END LOOP;
  END;

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
  PROCEDURE PROC_MAPEO_TEXTOS(IP_POLIZA      IN SIM_TYP_POLIZAGEN,
                              IP_NUMSECUPOL  IN NUMBER,
                              IP_TIPOPROCESO IN NUMBER,
                              OP_POLIZA      OUT SIM_TYP_POLIZAGEN,
                              IP_VALIDACION  IN VARCHAR2,
                              IP_ARRCONTEXTO IN SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                              OP_ARRCONTEXTO OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                              IP_PROCESO     IN SIM_TYP_PROCESO,
                              OP_RESULTADO   OUT NUMBER,
                              OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    -- Datos mapeados desde IP_POLIZA
    L_NUM_SECU_POL  NUMBER(15);
    L_COD_RIES      NUMBER(15);
    L_NUM_END       NUMBER(5);
    L_COD_COB       SIM_TYP_LOOKUP;
    L_COD_CAMPO     VARCHAR2(30);
    L_COD_TEXTO     NUMBER(5);
    L_SUB_COD_TEXTO NUMBER(5);
    L_ORDEN         NUMBER(5);
    L_TEXTO         CLOB;
    L_MODIFICABLE CONSTANT VARCHAR2(1) := 'S';
    L_PROCESO     CONSTANT VARCHAR2(1) := '2'; -- Modificación en SIMON
  BEGIN
    OP_RESULTADO   := 0;
    OP_ARRERRORES  := NEW SIM_TYP_ARRAY_ERROR();
    OP_ARRCONTEXTO := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    G_SUBPROGRAMA  := G_PROGRAMA || '.PROC_MAPEO_TEXTOS';
    OP_POLIZA      := NEW SIM_TYP_POLIZAGEN();
    -- Inicializando contexto.
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
  
    /* ****** INICIO-001 ****** */
    -- SGPM 20/01/2014: Adición de bloque PL para capturar excepción cuando el componente
    --                  de textos no viene instaciado (Expedición sin TEXTOS).
    BEGIN
      /* ****** FIN-001 ****** */
      IF IP_POLIZA.TEXTOS.EXISTS(1) THEN
        -- SGPM:  22/01/2014 Caso sin Textos
        IF IP_POLIZA.TEXTOS.COUNT() > 0 THEN
          IF IP_TIPOPROCESO IN (1, 2, 3) THEN
            -- 3: HIJA BASADA EN PPAL
            -- 1. Extracción de datos desde la póliza general
            FOR I IN IP_POLIZA.TEXTOS.FIRST .. IP_POLIZA.TEXTOS.LAST LOOP
              -- 2. Extracción de valores desde la tabla (constantes mejor)
              G_SUBPROGRAMA := G_PROGRAMA || '.proc_mapeo_textos';
            
              BEGIN
                -- 2.1. Inicio del mapeo de textos
              
                L_NUM_SECU_POL  := NVL(IP_POLIZA.TEXTOS(I).NUM_SECU_POL,
                                       IP_POLIZA.DATOSFIJOS.NUM_SECU_POL);
                L_COD_RIES      := IP_POLIZA.TEXTOS(I).COD_RIES;
                L_NUM_END       := NVL(IP_POLIZA.TEXTOS(I).NUM_END,
                                       IP_POLIZA.DATOSFIJOS.NUM_END);
                L_COD_COB       := IP_POLIZA.TEXTOS(I).COD_COB;
                L_COD_CAMPO     := IP_POLIZA.TEXTOS(I).COD_CAMPO;
                L_COD_TEXTO     := IP_POLIZA.TEXTOS(I).COD_TEXTO;
                L_SUB_COD_TEXTO := IP_POLIZA.TEXTOS(I).SUB_COD_TEXTO;
                L_TEXTO         := IP_POLIZA.TEXTOS(I).TEXTO;
                L_ORDEN         := IP_POLIZA.TEXTOS(I).ORDEN;
              
                -- 3. Inserción (con modificaciones o filtros)
                -- 3.1. Conversión de longitud para el CÓDIGO DEL RIESGO
                SELECT TO_NUMBER(SUBSTR(LPAD(CAST(L_COD_RIES AS
                                                  VARCHAR2(15)),
                                             15,
                                             0),
                                        -7,
                                        7))
                  INTO L_COD_RIES
                  FROM DUAL;
              
                -- 3.2. Reducción de longitud para el CÓDIGO DEL CAMPO.
                SELECT SUBSTR(L_COD_CAMPO, 15) INTO L_COD_CAMPO FROM DUAL;
              
                -- 4. Inserción en la tabla SIM_X_TEXTOS_POLIZAS
                /* ****** INICIO-002 ****** */
                BEGIN
                
                  -- Modificación de update anterior por problemas en la actualizacion de los
                  -- textos Mcga 2016/09/14
                  UPDATE SIM_X_TEXTOS_POLIZAS
                     SET TEXTO = L_TEXTO
                   WHERE NUM_SECU_POL = L_NUM_SECU_POL
                     AND NUM_END = L_NUM_END
                     AND CODIGO_TEXTO = L_COD_TEXTO
                     AND SUBCODIGO_TEXTO = L_SUB_COD_TEXTO
                     AND ORDEN = L_ORDEN;
                  IF SQL%NOTFOUND THEN
                    /* ****** FIN-002 ****** */
                    INSERT INTO SIM_X_TEXTOS_POLIZAS
                      (NUM_SECU_POL,
                       NUM_END,
                       COD_RIES,
                       COD_COB,
                       COD_CAMPO,
                       ORDEN,
                       CODIGO_TEXTO,
                       SUBCODIGO_TEXTO,
                       PROCESO,
                       MODIFICABLE,
                       TEXTO)
                    VALUES
                      (L_NUM_SECU_POL,
                       L_NUM_END,
                       L_COD_RIES,
                       L_COD_COB.CODIGO,
                       L_COD_CAMPO,
                       L_ORDEN,
                       L_COD_TEXTO,
                       L_SUB_COD_TEXTO,
                       L_PROCESO,
                       L_MODIFICABLE,
                       L_TEXTO);
                    /* ****** INICIO-002 ****** */
                  END IF;
                END;
                /* ****** FIN-002 ****** */
              EXCEPTION
                WHEN OTHERS THEN
                  SIM_PROC_LOG(PROCESO => 'SGPM: Error : ' || SQLERRM || ' ' ||
                                          DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                               VBLE    => 100);
              END;
            END LOOP;
          END IF;
        END IF;
      END IF;
      /* ****** INICIO-001 ****** */
      -- SGPM 20/01/2015: Captura de excepción cuando no viene instanciado el componente de TEXTOS
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /* ****** FIN-001 ****** */
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
    OP_POLIZA := IP_POLIZA;
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Hubo un error desconocido al momento de mapear los textos.' ||
                                                          SQLERRM,
                                                          'E');
  END PROC_MAPEO_TEXTOS;

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
  --                                                        Maróa Cristina González (Seguros Bolívar)
  FUNCTION FUN_MAPEO_COASEGUROS(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                IP_PROCESO    IN SIM_TYP_PROCESO,
                                OP_RESULTADO  OUT NUMBER,
                                OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR)
    RETURN NUMBER IS
    L_COASEGURO      NUMBER(1) := 0;
    L_COASEGURADORAS SIM_TYP_ARRAY_COASEGUROPOLIZA;
  BEGIN
    -- 1. Prerrequisitos
    -- 1.1. Inicializando variables
    OP_RESULTADO  := 0;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    G_SUBPROGRAMA := G_PROGRAMA || '.PROC_MAPEO_COASEGUROS';
    -- 1.2. Extracción de datos desde el TYPE de coasegurradoras
    L_COASEGURADORAS := IP_POLIZA.COASEGURADORAS;
  
    --
    -- 2. Lógica del algoritmo
    IF L_COASEGURADORAS.EXISTS(1) THEN
      -- SGPM: 22/01/2015 Array sin Instanciar
      IF L_COASEGURADORAS.COUNT() = 0 THEN
        --> 0: Coaseguro Rechazado
        NULL;
      ELSIF L_COASEGURADORAS.COUNT() = 1 THEN
        FOR J IN 1 .. L_COASEGURADORAS.COUNT LOOP
          --> 3: Coaseguro Aceptado
          L_COASEGURO := 3;
        
          IF L_COASEGURADORAS(J).COD_CIACOA.CODIGO != 999 THEN
            UPDATE X2010030
               SET COD_CIACOA     = L_COASEGURADORAS(J).COD_CIACOA.CODIGO,
                   NUM_POL_COA    = L_COASEGURADORAS(J).NUM_POL_COA,
                   NUM_ENDOSO_COA = L_COASEGURADORAS(J).NUM_ENDOSO_COA,
                   PORC_PARTCOA   = L_COASEGURADORAS(J).POR_PARTCOA
             WHERE NUM_SECU_POL = IP_POLIZA.DATOSFIJOS.NUM_SECU_POL;
          END IF;
        END LOOP;
      ELSE
        --> 1: Coaseguro Cedido
        L_COASEGURO := 1;
      
        FOR J IN 1 .. L_COASEGURADORAS.COUNT LOOP
          SIM_PCK_PROCESO_DML_EMISION.PROC_ACTUALIZA_COASEGURO(IP_POLIZA.DATOSFIJOS.NUM_SECU_POL,
                                                               L_COASEGURADORAS(J));
        END LOOP;
      END IF;
    END IF;
  
    RETURN L_COASEGURO;
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                          'Hubo un error desconocido al momento de mapear coaseguros.' ||
                                                          SQLERRM,
                                                          'E');
      RETURN L_COASEGURO;
  END FUN_MAPEO_COASEGUROS;

  -- Procedimiento para el mapeo de coberturas de cumplimiento en el service de expedición
  -- %author Ing. Lic. Stephen Guseph Pinto Morato - sgpinto@asesoftware.com
  -- %param ip_poliza     IN sim_typ_polizagen
  -- %param ip_numsecupol IN NUMBER
  -- %param ip_numend     IN NUMBER
  -- %param ip_proceso    IN sim_typ_proceso
  -- %param op_resultado  OUT NUMBER
  -- %param op_arrerrores OUT sim_typ_array_error
  -- %version 1.0
  --
  -- Fecha       - Versión  - Autor                     - Cambios
  -- ---------------------------------------------------------------------------
  -- 10/11/2014  - 1.0     - Stephen Pinto (ASESOFTWARE) - Creación.
  PROCEDURE PROC_MAPEO_COB_CUMP(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                IP_NUMSECUPOL IN NUMBER,
                                IP_NUMEND     IN NUMBER,
                                IP_PROCESO    IN SIM_TYP_PROCESO,
                                OP_RESULTADO  OUT NUMBER,
                                OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    -- Constantes para expedición.
    C_SIM_MCA_SUMA_INF CONSTANT VARCHAR2(1) := 'N';
    C_MCA_TASA_INF     CONSTANT VARCHAR2(1) := 'S';
    C_MCA_PRIMA_INF    CONSTANT VARCHAR2(1) := 'N';
    -- Constantes para invocación de método
    C_LLAMADO      CONSTANT NUMBER(1) := 1;
    C_TIPO_PROCESO CONSTANT NUMBER(1) := 1;
    -- Variables locales
    L_SIM_MCA_SUMA_INF VARCHAR2(1);
    L_MCA_TASA_INF     VARCHAR2(1);
    L_MCA_PRIMA_INF    VARCHAR2(1);
    -- Variables para extracción de coberturas
    IL_COBERTURAS  SIM_TYP_ARRAY_COBPOLIZASGEN;
    OL_COBERTURAS  SIM_TYP_ARRAY_COBPOLIZASGEN;
    L_SIM_COEF_COB NUMBER(17, 15);
    -- datos de cobertura y tasa de cobertura
    L_SIM_TASA_COB     NUMBER(5, 2);
    L_SIM_END_TASA_COB NUMBER(6);
    L_COD_SELECC       VARCHAR2(1) := 'N';
    L_ERROR            SIM_TYP_ERROR;
    L_SQL              CLOB;
    L_CUENTA           PLS_INTEGER;
  BEGIN
    -- Inicialización de Variables e instanciación de objetos.
    --   g_subprograma := g_programa || 'Proc_Mapeo_CobRiesgos_PolHija';
    L_ERROR       := NEW SIM_TYP_ERROR();
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    IL_COBERTURAS := NEW SIM_TYP_ARRAY_COBPOLIZASGEN();
  
    -- Invocando proceso de Extracción de Condiciones Definitivas de Cliente.
  
    -- Procesamiento de datos e inicio de mapeo
    IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
      -- SGPM: 22/01/2015 Array sin instanciar
      IF IP_POLIZA.DATOSRIESGOS.COUNT() > 0 THEN
        -- r: índice r-ósimo del riesgo.
        -- c: indice c-ósimo de la cobertura.
        --> Ciclo 1: Riesgos
        FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
          --> Ciclo 2: Coberturas.
          IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.COUNT() > 0 THEN
            -- Asignando Coberturas Existentes al TYPE
            IL_COBERTURAS := IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS;
          
            -- Recorrido para asignaciones.
            -- A tener en cuenta (de acuerdo con el correo de Manuel Orjuela)
          
            -- l_sim_mca_suma_inf := 'N';
            -- l_mca_tasa_inf     := 'S';
            -- l_mca_prima_inf    := 'N';
          
            -- sim_fecha_inclusion = sim_fecha_vig_end
            -- sim_fecha_exclusion = sim_fecha_venc_end
          
            FOR C IN IL_COBERTURAS.FIRST .. IL_COBERTURAS.LAST LOOP
              IF IL_COBERTURAS(C).SUMA_ASEG != 0 THEN
                --
                L_SIM_MCA_SUMA_INF := C_SIM_MCA_SUMA_INF;
                L_MCA_TASA_INF     := C_MCA_TASA_INF;
                L_MCA_PRIMA_INF    := C_MCA_PRIMA_INF;
              
                L_SIM_COEF_COB := SIM_CU_PCK_CTRLES_Y_VALID.FUN_RESCATA_COEFCOB(IP_FECHAVIGPOL  => IL_COBERTURAS(C)
                                                                                                   .SIM_FECHA_INCLUSION,
                                                                                IP_FECHAVENCPOL => IL_COBERTURAS(C)
                                                                                                   .SIM_FECHA_EXCLUSION,
                                                                                IP_VALIDACION   => NULL,
                                                                                IP_PROCESO      => IP_PROCESO,
                                                                                OP_RESULTADO    => OP_RESULTADO,
                                                                                OP_ARRERRORES   => OP_ARRERRORES);
              
                IF NVL(IL_COBERTURAS(C).MCA_AHORRO, 'N') = 'N' THEN
                  L_COD_SELECC := 'S'; --'X';
                END IF;
              
                -- Mapeo en la X2000040
                SELECT COUNT(1)
                  INTO L_CUENTA
                  FROM X2000040 A
                 WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                   AND A.COD_RIES = IL_COBERTURAS(C).COD_RIES
                   AND A.COD_COB = IL_COBERTURAS(C).COD_COB.CODIGO;
              
                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('CUENTA ANTES ' ||
                                                    L_CUENTA,
                                                    'EXPEDIR');
                L_SQL := 'UPDATE x2000040 a
                               SET a.suma_aseg           = ' || IL_COBERTURAS(C)
                        .SUMA_ASEG || '
                                  ,a.tasa_cob            = ' || IL_COBERTURAS(C)
                        .TASA_COB || '
                                  ,a.prima_cob           = ' || IL_COBERTURAS(C)
                        .PRIMA_COB || '
                                  ,a.sim_coefcob         = ' ||
                         L_SIM_COEF_COB || '
                                  ,a.sim_mca_suma_inf    = ''' ||
                         L_SIM_MCA_SUMA_INF || '''
                                  ,a.mca_tasa_inf        = ''' ||
                         L_MCA_TASA_INF || '''
                                  ,a.mca_prima_inf       = ''' ||
                         L_MCA_PRIMA_INF || '''
                                  ,a.cod_selecc          = ''' ||
                         L_COD_SELECC || '''
                                  ,a.sim_fecha_inclusion = to_date(''' || IL_COBERTURAS(C)
                        .SIM_FECHA_INCLUSION ||
                         ''', ''DD-MON-YY'')
                                  ,a.sim_fecha_exclusion = to_date(''' || IL_COBERTURAS(C)
                        .SIM_FECHA_EXCLUSION ||
                         ''', ''DD-MON-YY'')
                                  ,a.end_suma_aseg       = ' || IL_COBERTURAS(C)
                        .SUMA_ASEG || /* '
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,a.val_asegurable      = ' || il_coberturas(c)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    .suma_aseg || '
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,a.end_val_asegurable  = ' || il_coberturas(c)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    .suma_aseg || */
                        
                         '
                                  ,a.tasa_total          = ' || IL_COBERTURAS(C)
                        .TASA_COB || '
                                  ,a.end_prima_cob       = ' || IL_COBERTURAS(C)
                        .PRIMA_COB || '
                                  ,a.sim_fecha_vig_end   = to_date(''' || IL_COBERTURAS(C)
                        .SIM_FECHA_INCLUSION ||
                         ''', ''DD-MON-YY'')
                                  ,a.sim_fecha_venc_end  = to_date(''' || IL_COBERTURAS(C)
                        .SIM_FECHA_EXCLUSION ||
                         ''', ''DD-MON-YY'')
                             WHERE a.num_secu_pol = ' ||
                         IP_NUMSECUPOL || '
                               AND a.cod_ries = ' || IL_COBERTURAS(C)
                        .COD_RIES || '
                               AND a.cod_cob = ' || IL_COBERTURAS(C)
                        .COD_COB.CODIGO;
                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE(L_SQL, 'EXPEDIR');
              
                SELECT COUNT(1)
                  INTO L_CUENTA
                  FROM X2000040 A
                 WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                   AND A.COD_RIES = IL_COBERTURAS(C).COD_RIES
                   AND A.COD_COB = IL_COBERTURAS(C).COD_COB.CODIGO;
              
                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('CUENTA DESP' ||
                                                    L_CUENTA,
                                                    'EXPEDIR');
              
                EXECUTE IMMEDIATE L_SQL;
              
                COMMIT;
              END IF;
            END LOOP;
          END IF;
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(IP_IDERROR   => SQLCODE,
                               IP_DESCERROR => SQLERRM || ' ' ||
                                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                               IP_TIPOERROR => 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_MAPEO_COB_CUMP;

  PROCEDURE PROC_SERVICE_MODIFICA_POLHIJA(IP_POLIZA      IN SIM_TYP_POLIZAGEN,
                                          IP_TIPOPROCESO IN NUMBER,
                                          IP_ARRCONTEXTO IN OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                          OP_ARRCONTEXTO OUT SIM_TYP_ARRAY_VAR_MOTORREGLAS,
                                          OP_POLIZA      OUT SIM_TYP_POLIZAGEN,
                                          IP_VALIDACION  IN VARCHAR2,
                                          IP_PROCESO     IN SIM_TYP_PROCESO,
                                          OP_RESULTADO   OUT NUMBER,
                                          OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    L_TPROCESO        NUMBER;
    L_TSUBPROCESO     NUMBER;
    L_TNTPOLPRES      VARCHAR2(10);
    L_NUMPOLCOTIZ     NUMBER;
    L_NUMPOL1         NUMBER;
    L_NUMSECUPOL      NUMBER;
    L_NUMEND          NUMBER;
    L_RIESGO          NUMBER;
    L_MARCA           NUMBER;
    L_TIPO_END        SIM_CODIGOS_ENDOSO_SECCION.TIPO_END%TYPE;
    L_VALORCAMPO      A2000020.VALOR_CAMPO%TYPE;
    LO_MCA_PROVISORIA A2000030.MCA_PROVISORIO%TYPE;
    LO_NUMPOL1        A2000030.NUM_POL1%TYPE;
    LO_NUMEND         A2000020.NUM_END%TYPE;
    OP_NUMPOL1        A2000030.NUM_POL1%TYPE;
    L_NIVELCT         SIM_PCK_TIPOS_GENERALES.T_VAR_MINIMO;
    L_EXISTE_CT       SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_GRABAR          SIM_PCK_TIPOS_GENERALES.T_CARACTER;
    L_POLIZA          SIM_TYP_POLIZAGEN;
    L_PROCESO         SIM_TYP_PROCESO;
    L_DFIJOS_POLIZA   SIM_TYP_DATOSFIJOSPOLIZA;
    LI_ARRCONTEXTO    SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    LO_ARRCONTEXTO    SIM_TYP_ARRAY_VAR_MOTORREGLAS;
    /* ***** cambio 2 ***** */
    L_VALIDACION   VARCHAR2(50);
    L_MAXFECHAVENC VARCHAR2(11);
    L_MINFECHAVIG  VARCHAR2(11);
    L_CUENTA       PLS_INTEGER := 0;
    /* ***** cambio 2 ***** */
    /*Cursor para consultar información de riesgos*/
    CURSOR C_RIESGOS IS
      SELECT DISTINCT COD_RIES
        FROM X2000020
       WHERE NUM_SECU_POL = L_NUMSECUPOL
         AND COD_RIES IS NOT NULL
       ORDER BY NVL(COD_RIES, 0);
  
    /*Cursor para consultar información de controles técnicos*/
    CURSOR C_CTECNICO IS
      SELECT A.COD_ERROR, C.DESC_ERROR, A.COD_RECHAZO
        FROM X2000220 A, X2000030 B, G2000210 C
       WHERE A.NUM_SECU_POL = L_NUMSECUPOL
         AND A.NUM_SECU_POL = B.NUM_SECU_POL
         AND A.NUM_ORDEN = B.NUM_END
         AND C.COD_CIA = B.COD_CIA
         AND C.COD_ERROR = A.COD_ERROR;
  
    -- TEMPORAL
    L_REG SIM_TYP_VAR_MOTORREGLAS;
  BEGIN
    /**** 1.INICIO: Inicialización ****/
    L_PROCESO       := IP_PROCESO;
    G_SUBPROGRAMA   := G_PROGRAMA || '.Proc_Service_Modifica_PolHija';
    L_ERROR         := NEW SIM_TYP_ERROR;
    OP_ARRERRORES   := NEW SIM_TYP_ARRAY_ERROR();
    L_POLIZA        := NEW SIM_TYP_POLIZAGEN();
    L_DFIJOS_POLIZA := NEW SIM_TYP_DATOSFIJOSPOLIZA();
    LI_ARRCONTEXTO  := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    LO_ARRCONTEXTO  := NEW SIM_TYP_ARRAY_VAR_MOTORREGLAS();
    L_POLIZA        := IP_POLIZA;
    L_NUMSECUPOL    := L_POLIZA.DATOSFIJOS.NUM_SECU_POL;
    OP_RESULTADO    := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_NUMPOL1       := 0;
    L_NUMPOLCOTIZ   := 0;
    L_MARCA         := NULL;
    L_GRABAR        := 'S';
  
    L_DFIJOS_POLIZA.COD_CIA.CODIGO  := L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO;
    L_DFIJOS_POLIZA.COD_SECC.CODIGO := L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO;
    L_DFIJOS_POLIZA.COD_RAMO.CODIGO := L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO;
    L_DFIJOS_POLIZA.NUM_POL1        := L_POLIZA.DATOSFIJOS.NUM_POL1;
    L_DFIJOS_POLIZA.NUM_END         := L_POLIZA.DATOSFIJOS.NUM_END;
    L_DFIJOS_POLIZA.NUM_SECU_POL    := L_POLIZA.DATOSFIJOS.NUM_SECU_POL;
    L_DFIJOS_POLIZA.COD_PROD.CODIGO := L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO;
    L_DFIJOS_POLIZA.COMPARTIDA      := 'N';
    -- Mapeo del tipo de coaseguro (0)sin coaseguro, (1)Cedido y (3)Aceptado
    -- Mcga 2017/03/16 fallaban las modificaciones en polizas con coaseguro
    L_DFIJOS_POLIZA.COD_COA := NEW SIM_TYP_LOOKUP(L_POLIZA.DATOSFIJOS.COD_COA,
                                                  NULL);
    -- Revisión SGPM: 06/02/2015
    -- Inicalización del contexto desde el array (Traemos el array de entrada y lo asignamos al contexto).
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(IP_ARRCONTEXTO);
    -- Inicialización de contexto GLOBAL_SIMUSUARIO
    SIM_PCK_REGLAS.INICIALIZAPARAMETROS('GLOBAL_SIMUSUARIO',
                                        IP_PROCESO.P_COD_USR);
    SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Entra a service', 'MOD POL HIJA');
  
    --Valida existencia del producto para la compañia y seccion de entrada
    BEGIN
      SELECT 1
        INTO L_MARCA
        FROM SIM_PRODUCTOS A
       WHERE A.COD_CIA = L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO
         AND A.COD_SECC = L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO
         AND A.COD_PRODUCTO = L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20099,
                                'Producto : ' ||
                                L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO ||
                                ' Inexistente para la Seccion : ' ||
                                L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO ||
                                ' Compania :' ||
                                L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO);
    END;
  
    --Valida existencia del proceso para el codigo de proceso, subproceso y modulo de entrada
    BEGIN
      SELECT NVL(F.TIPO_NEGOCIO_TRONADOR, 1)
        INTO L_MARCA
        FROM SIM_PROCESOS F
       WHERE F.ID_PROCESO = L_PROCESO.P_PROCESO
         AND NVL(F.ID_PROCESO_PADRE, -1) = NVL(L_PROCESO.P_SUBPROCESO, -1)
         AND F.MODULO = L_PROCESO.P_MODULO;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20099, 'Tipo de negocio Inexistente');
    END;
  
    --Consultar el tipo de endoso
    BEGIN
      SELECT TIPO_END
        INTO L_TIPO_END
        FROM SIM_CODIGOS_ENDOSO_SECCION
       WHERE COD_CIA = L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO
         AND COD_SECC = L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO
         AND COD_END = L_POLIZA.DATOSFIJOS.COD_END
         AND SUB_COD_END = L_POLIZA.DATOSFIJOS.SUB_COD_END;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        L_TIPO_END := L_POLIZA.DATOSFIJOS.TIPO_END.CODIGO;
    END;
  
    /**** 1.FIN: Inicialización ****/
  
    /* ****** SGPM_cambio ***** */
    PKG299_DATOS_GEN_MC.BORRA_TRANSITORIAS(P_NUMSECUPOL => L_POLIZA.DATOSFIJOS.NUM_SECU_POL);
    /* ****** SGPM_cambio ***** */
    /**** 2.INICIO: Insertar Transitorias ****/
    --Insertar Tablas Transitorias
  
    SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Entra a inserta_x_endodos',
                                        'MOD POL HIJA');
  
    -- ADICIÓN:
    -- Inicialización del Array local de entrada con los datos del contexto.
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
    --Mcga 2023/02/01 se verifica con Rosario funcionalidad
    --de Cumplimiento para modificaciones no requiere reenganche 
  
    /*    Select Count(*) --
     Into l_Cuenta
     From P2000030
    Where Num_Secu_Pol = l_Numsecupol;*/
  
    --Para modificaciones siempre se l_cuenta =0
    L_CUENTA := 0;
  
    IF L_CUENTA = 0 THEN
      BEGIN
        SIM_PCK_PROCESO_DML_EMISION2.PROC_INSERTA_X_ENDOSOS(IP_NUMSECUPOL      => L_NUMSECUPOL,
                                                            IP_FECHAVIGEND     => L_POLIZA.DATOSFIJOS.FECHA_VIG_POL,
                                                            IP_CODENDOSO       => L_POLIZA.DATOSFIJOS.COD_END,
                                                            IP_SUBCODENDOSO    => L_POLIZA.DATOSFIJOS.SUB_COD_END,
                                                            IP_DESCRIPCION     => NULL,
                                                            IP_TIPOEND         => NVL(L_POLIZA.DATOSFIJOS.TIPO_END.CODIGO,
                                                                                      L_TIPO_END),
                                                            IP_USUARIOTRONADOR => L_POLIZA.DATOSFIJOS.COD_USR,
                                                            IP_DATOSFIJOS      => L_DFIJOS_POLIZA,
                                                            OP_NUMEND          => L_NUMEND,
                                                            IP_ARRCONTEXTO     => LI_ARRCONTEXTO,
                                                            OP_ARRCONTEXTO     => LO_ARRCONTEXTO,
                                                            IP_PROCESO         => IP_PROCESO,
                                                            OP_RESULTADO       => OP_RESULTADO,
                                                            OP_ARRERRORES      => OP_ARRERRORES);
      
        IF OP_RESULTADO = -1 THEN
          RETURN;
        END IF;
      END;
    ELSE
      -- Reenganche
      SIM_PCK_PROCESO_DML_EMISION.PROC_INSERTABASADO_REENGANCHE(L_NUMSECUPOL --
                                                               ,
                                                                L_POLIZA.DATOSFIJOS.NUM_POL1,
                                                                L_POLIZA.DATOSFIJOS.NUM_END,
                                                                OP_RESULTADO,
                                                                OP_ARRERRORES);
      L_NUMEND := L_POLIZA.DATOSFIJOS.NUM_END;
      SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
      DECLARE
        L_NUM_SECU_POL_ANT NUMBER(15);
      BEGIN
        BEGIN
          L_NUM_SECU_POL_ANT := SIM_PCK_REGLAS.G_PARAMETROS('B99_NUMSECUPOLANT');
        EXCEPTION
          WHEN OTHERS THEN
            LI_ARRCONTEXTO.EXTEND();
            LI_ARRCONTEXTO(LI_ARRCONTEXTO.COUNT()) := NEW
                                                      SIM_TYP_VAR_MOTORREGLAS(CODIGO => 'B99_NUMSECUPOLANT',
                                                                              VALOR  => L_NUMSECUPOL);
        END;
        LO_ARRCONTEXTO := LI_ARRCONTEXTO;
      END;
      SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
    
    END IF;
    DECLARE
      L_CUENTA PLS_INTEGER;
    BEGIN
      SELECT COUNT(1)
        INTO L_CUENTA
        FROM X2000040
       WHERE NUM_SECU_POL = L_NUMSECUPOL;
    
      SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE(IP_CONSULTA => 'Cuenta COBERTURAS 1 ' ||
                                                         L_CUENTA,
                                          IP_OBJETO   => 'X2000040');
    EXCEPTION
      WHEN OTHERS THEN
        SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE(IP_CONSULTA => 'No cuenta 1 ' ||
                                                           SQLERRM,
                                            IP_OBJETO   => 'X2000040');
    END;
  
    -- Se adiciona la Inserción del Riesgo Prueba de Stephen y Maria Cristina 2015/02/18
    /*    DECLARE
        lo_ries  NUMBER(5);
        l_cuenta PLS_INTEGER := 0;
      BEGIN
        sim_pck_proceso_dml_emision.proc_insertanuevoriesgo(ip_numsecupol => l_numsecupol,
                                                            ip_numend     => l_numend,
                                                            op_codries    => lo_ries,
                                                            ip_validacion => ip_validacion,
                                                            ip_proceso    => ip_proceso,
                                                            op_resultado  => op_resultado,
                                                            op_arrerrores => op_arrerrores);
        IF op_resultado = -1 THEN
          RETURN;
        ELSIF op_resultado = 1 THEN
          sim_cu_pck_util.prc_cu_grabar_trace(ip_consulta => 'Hubo warning y no lo sabía',
                                              ip_objeto   => 'X2000040');
        ELSE
          BEGIN
            SELECT COUNT(1)
              INTO l_cuenta
              FROM x2000040
             WHERE num_secu_pol = l_numsecupol;
            sim_cu_pck_util.prc_cu_grabar_trace(ip_consulta => 'Cuenta COBERTURAS 2' ||
                                                               l_cuenta,
                                                ip_objeto   => 'X2000040');
          EXCEPTION
            WHEN OTHERS THEN
              sim_cu_pck_util.prc_cu_grabar_trace(ip_consulta => 'No cuenta 2 ' ||
                                                                 SQLERRM,
                                                  ip_objeto   => 'X2000040');
          END;
        END IF;
      END;
    */
    SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Sale de inserta_x_endodos',
                                        'MOD POL HIJA');
    -- Salida: Se cargan los datos desde el array al contexto
    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
  
    /**** 2.FIN: Insertar Transitorias ****/
  
    /**** 3.INICIO: Mapeo ****/
    IF OP_RESULTADO = 0 THEN
      --Mapeo Datos Fijos Póliza Hija
      SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Mapeo Datos Fijos',
                                          'MOD POL HIJA');
      --Dbms_Output.Put_Line(l_Poliza.Datosfijos.Fecha_Venc_Pol);
      --Dbms_Output.Put_Line(To_Char(l_Poliza.Datosfijos.Fecha_Venc_Pol,
      --'DD/MM/YYYY'));
    
      BEGIN
        L_MAXFECHAVENC := SIM_PCK_REGLAS.G_PARAMETROS('B99_MAXFECHAVENCPOL');
      EXCEPTION
        WHEN OTHERS THEN
          L_MAXFECHAVENC := L_POLIZA.DATOSFIJOS.FECHA_VENC_POL;
      END;
    
      /*Dbms_Output.Put_Line(l_Poliza.Datosfijos.Fecha_Vig_Pol);
      Dbms_Output.Put_Line(To_Char(l_Poliza.Datosfijos.Fecha_Vig_Pol,
                                 'DD/MM/YYYY'));*/
    
      BEGIN
        L_MINFECHAVIG := SIM_PCK_REGLAS.G_PARAMETROS('B99_MINFECHAVIGPOL');
      EXCEPTION
        WHEN OTHERS THEN
          L_MINFECHAVIG := TO_CHAR(L_POLIZA.DATOSFIJOS.FECHA_VIG_POL,
                                   'DD/MM/YYYY');
      END;
    
      /* ****** INICIO-005 ****** */
      -- Adición de mapeo de tipos de endoso solicitados en Endosos Unificados.
      BEGIN
        SELECT DESC_POL
          INTO G_DESC_POL
          FROM A2010030 A
         WHERE NUM_SECU_POL =
               (SELECT W.NUM_SECU_POL
                  FROM A2010030 W
                 WHERE W.NUM_POL1 =
                       (SELECT Z.NUM_POL_FLOT
                          FROM A2000030 Z
                         WHERE Z.NUM_SECU_POL =
                               L_POLIZA.DATOSFIJOS.NUM_SECU_POL
                           AND Z.NUM_END =
                               (SELECT MAX(Y.NUM_END)
                                  FROM A2000030 Y
                                 WHERE Y.NUM_SECU_POL = Z.NUM_SECU_POL))
                   AND W.NUM_END =
                       (SELECT MAX(NUM_END)
                          FROM A2010030 B
                         WHERE B.NUM_SECU_POL = W.NUM_SECU_POL)
                   AND W.COD_SECC = L_POLIZA.DATOSFIJOS.COD_SECC.CODIGO) -- dherrera ajuste jira 2877 se agrega filtro por seccion
           AND NUM_END = (SELECT MAX(NUM_END)
                            FROM A2010030 B
                           WHERE B.NUM_SECU_POL = A.NUM_SECU_POL);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          G_DESC_POL := 'Error';
      END;
    
      IF INSTR(G_DESC_POL, 'VIG_SIN_COBRO') > 0 THEN
        G_DESC_POL := 'TRASLADO';
      END IF;
    
      SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('DESC_POL' || G_DESC_POL,
                                          'G_DESC_POL');
    
      /* ****** FIN-001 ****** */
      BEGIN
        /*Dbms_Output.Put_Line('Fecha Maxima ' || l_Maxfechavenc ||
        ' si es date ' ||
        To_Date(l_Maxfechavenc, 'DD/MM/YYYY'));*/
        PROC_MAPEO_DFIJOS_POLHIJA(IP_POLIZA      => L_POLIZA,
                                  IP_FECHAMINIMA => L_MINFECHAVIG,
                                  IP_FECHAMAXIMA => L_MAXFECHAVENC,
                                  IP_NUMSECUPOL  => L_NUMSECUPOL,
                                  IP_NUMEND      => L_NUMEND,
                                  IP_PROCESO     => L_PROCESO,
                                  OP_RESULTADO   => OP_RESULTADO,
                                  OP_ARRERRORES  => OP_ARRERRORES);
      END;
    
      SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin Mapeo Datos Fijos',
                                          'MOD POL HIJA');
    
      IF OP_RESULTADO = 0 THEN
        --Mapeo Datos Variables Póliza Hija
        SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Mapeo Datos Variables',
                                            'MOD POL HIJA');
      
        BEGIN
          PROC_MAPEO_DVARIABLES_POLHIJA(IP_POLIZA     => L_POLIZA,
                                        IP_NUMSECUPOL => L_NUMSECUPOL,
                                        IP_NUMEND     => L_NUMEND,
                                        IP_PROCESO    => L_PROCESO,
                                        OP_RESULTADO  => OP_RESULTADO,
                                        OP_ARRERRORES => OP_ARRERRORES);
        END;
      
        /**** 3.FIN: Mapeo ****/
        SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin Mapeo Datos Variables',
                                            'MOD POL HIJA');
      
        /**** 4.INICIO: Insertar Transitorias Riesgos ****/
        IF OP_RESULTADO = 0 THEN
          --Insertar Tablas Transitorias Riesgos
          SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Inserta X endosos riesgo',
                                              'MOD POL HIJA');
        
          BEGIN
            SIM_PCK_PROCESO_DML_EMISION2.PROC_INSERTA_X_ENDOSOS_RIESGO(IP_NUMSECUPOL => L_NUMSECUPOL,
                                                                       IP_NUMEND     => L_POLIZA.DATOSFIJOS.NUM_END,
                                                                       IP_CODRIES    => NULL,
                                                                       IP_PROCESO    => IP_PROCESO,
                                                                       OP_RESULTADO  => OP_RESULTADO,
                                                                       OP_ARRERRORES => OP_ARRERRORES);
          END;
        
          /**** 4.FIN: Insertar Transitorias Riesgos ****/
          SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin X endosos riesgo',
                                              'MOD POL HIJA');
        
          /**** 5.INICIO: Mapeo Riesgos ****/
          IF OP_RESULTADO = 0 THEN
            --Mapeo Datos Variables Riesgos Póliza Hija
            BEGIN
              SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('DV riesgo',
                                                  'MOD POL HIJA');
              PROC_MAPEO_DVRIESGOS_POLHIJA(IP_POLIZA     => L_POLIZA,
                                           IP_NUMSECUPOL => L_NUMSECUPOL,
                                           IP_NUMEND     => L_NUMEND,
                                           IP_PROCESO    => L_PROCESO,
                                           OP_RESULTADO  => OP_RESULTADO,
                                           OP_ARRERRORES => OP_ARRERRORES);
            END;
          
            SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin endosos riesgo',
                                                'MOD POL HIJA');
          
            IF OP_RESULTADO = 0 THEN
              --Mapeo Coberturas Riesgos Póliza Hija
              BEGIN
                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Mapeo cobriesgo',
                                                    'MOD POL HIJA');
                PROC_MAPEO_COBRIESGOS_POLHIJA(IP_POLIZA     => L_POLIZA,
                                              IP_NUMSECUPOL => L_NUMSECUPOL,
                                              IP_NUMEND     => L_NUMEND,
                                              IP_PROCESO    => L_PROCESO,
                                              OP_RESULTADO  => OP_RESULTADO,
                                              OP_ARRERRORES => OP_ARRERRORES);
              END;
            
              /**** 5.FIN: Mapeo Riesgos ****/
              SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin cobriesgo',
                                                  'MOD POL HIJA');
            
              /**** 6.INICIO: Reglas de Negocio - Controles Técnicos ****/
              IF OP_RESULTADO = 0 THEN
                --Ejecucion Reglas Del Negocio (Datos Fijos)
                SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_VALIDACION', 'N');
              
                --Dbms_Output.Put_Line('Contexto Datos Fijos');
                -- Cargue de Variable de Contexto B99_VAKLIDACION en el Contexto
                SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Inicio proceso contexto datos fijos',
                                                    'MOD POL HIJA');
              
                BEGIN
                  SIM_PCK_CONTEXTO_EMISION.PROC_CONTEXTODATOSFIJOS(IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                                   IP_ARRCONTEXTO => LI_ARRCONTEXTO,
                                                                   OP_ARRCONTEXTO => LO_ARRCONTEXTO,
                                                                   IP_PROCESO     => L_PROCESO,
                                                                   OP_RESULTADO   => OP_RESULTADO,
                                                                   OP_ARRERRORES  => OP_ARRERRORES);
                END;
              
                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin proceso contexto datos fijos',
                                                    'MOD POL HIJA');
                -- Inicialización del contexto desde el array
                SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
              
                IF OP_RESULTADO = 0 THEN
                  --Controles Técnicos Datos Fijos (1-5)
                  --Dbms_Output.Put_Line('Controles Técnicos Datos Fijos (1-5)');
                  SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
                
                  BEGIN
                    L_NIVELCT := '15';
                    SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Inicio ejecuta control técnico',
                                                        'MOD POL HIJA');
                    SIM_PCK_CONTROL_TECNICO.PROC_EJECUTA_CONTROL_TECNICO(IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                                         IP_NIVEL       => L_NIVELCT,
                                                                         OP_EXISTE_CT   => L_EXISTE_CT,
                                                                         IP_VALIDACION  => IP_VALIDACION,
                                                                         IP_ARRCONTEXTO => LI_ARRCONTEXTO,
                                                                         OP_ARRCONTEXTO => LO_ARRCONTEXTO,
                                                                         IP_PROCESO     => L_PROCESO,
                                                                         OP_RESULTADO   => OP_RESULTADO,
                                                                         OP_ARRERRORES  => OP_ARRERRORES);
                  END;
                
                  SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
                  SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin ejecuta control técnico',
                                                      'MOD POL HIJA');
                
                  IF OP_RESULTADO = 0 THEN
                    --Procesar Datos Variables
                    --Dbms_Output.Put_Line('Procesar Datos Variables');
                    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
                  
                    BEGIN
                      SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Inicio procesa Datos Variabels',
                                                          'MOD POL HIJA');
                      SIM_PCK_PROCESO_DATOS_EMISION2.PROC_PROCESAR_DV(IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                                      IP_CODRIES     => NULL,
                                                                      IP_NIVEL       => 1,
                                                                      IP_COBERTURA   => NULL,
                                                                      IP_ARRCONTEXTO => LI_ARRCONTEXTO,
                                                                      OP_ARRCONTEXTO => LO_ARRCONTEXTO,
                                                                      IP_PROCESO     => L_PROCESO,
                                                                      OP_RESULTADO   => OP_RESULTADO,
                                                                      OP_ARRERRORES  => OP_ARRERRORES);
                    END;
                  
                    SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin procesar datos variabels',
                                                        'MOD POL HIJA');
                    SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
                  
                    IF OP_RESULTADO = 0 THEN
                      FOR REG_RIESGOS IN C_RIESGOS LOOP
                        SIM_PCK_REGLAS.INICIALIZAPARAMETROS('B99_CODRIES',
                                                            REG_RIESGOS.COD_RIES);
                      
                        --Procesar Riesgos
                        --Dbms_Output.Put_Line('Procesar Riesgos');
                      
                        /*sim_pck_reglas.inicializaparametros('B99_CODCIA',
                                                            ip_proceso.p_cod_cia);
                        
                        sim_pck_reglas.inicializaparametros('B99_NUMSECUPOL',
                                                            l_poliza.datosfijos.num_secu_pol);
                        sim_pck_reglas.inicializaparametros('B99_NUMEND',
                                                            l_poliza.datosfijos.num_end);
                                                             sim_pck_reglas.iniarrayfromcontexto(li_arrcontexto);*/
                        -- TEMPORAL Adición de contextos
                        /* BEGIN
                            l_reg        := NEW sim_typ_var_motorreglas();
                            l_reg.codigo := 'B99_CODCIA';
                            l_reg.valor  := ip_proceso.p_cod_cia;
                        END;
                        
                        li_arrcontexto.extend;
                        li_arrcontexto(li_arrcontexto.count) := l_reg;
                        
                        BEGIN
                            l_reg        := NEW sim_typ_var_motorreglas();
                            l_reg.codigo := 'B99_NUMEND';
                            l_reg.valor  := 1;
                        END;
                        
                        li_arrcontexto.extend;
                        li_arrcontexto(li_arrcontexto.count) := l_reg;*/
                        BEGIN
                          FOR I IN LI_ARRCONTEXTO.FIRST .. LI_ARRCONTEXTO.LAST LOOP
                            SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE(IP_CONSULTA => LI_ARRCONTEXTO(I)
                                                                               .CODIGO || ', ' || LI_ARRCONTEXTO(I)
                                                                               .VALOR,
                                                                IP_OBJETO   => 'CONTEXTO');
                          END LOOP;
                        EXCEPTION
                          WHEN OTHERS THEN
                            NULL;
                        END;
                        BEGIN
                          SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Inicio proceso riesgos',
                                                              'MOD POL HIJA');
                          SIM_PCK_PROCESO_DATOS_EMISION2.PROC_PROCESAR_RIESGO(IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                                              IP_CODRIES     => REG_RIESGOS.COD_RIES,
                                                                              IP_ARRCONTEXTO => LI_ARRCONTEXTO,
                                                                              OP_ARRCONTEXTO => LO_ARRCONTEXTO,
                                                                              IP_PROCESO     => L_PROCESO,
                                                                              OP_RESULTADO   => OP_RESULTADO,
                                                                              OP_ARRERRORES  => OP_ARRERRORES);
                        
                          IF OP_RESULTADO <> 0 THEN
                            IF OP_ARRERRORES.COUNT() > 0 THEN
                              FOR I IN OP_ARRERRORES.FIRST .. OP_ARRERRORES.LAST LOOP
                                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE(' id_error : ' || OP_ARRERRORES(I)
                                                                    .ID_ERROR || '
            . Descipción: ' || OP_ARRERRORES(I)
                                                                    .DESC_ERROR ||
                                                                    'LINEA ' ||
                                                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(),
                                                                    'MOD POL HIJA');
                              END LOOP;
                            END IF;
                          
                            RETURN;
                          END IF;
                        
                          DECLARE
                            PRIMA_RET VARCHAR2(30);
                          BEGIN
                            BEGIN
                              PRIMA_RET := SIM_PCK_REGLAS.G_PARAMETROS('B99_PRIMACOB');
                            EXCEPTION
                              WHEN OTHERS THEN
                                PRIMA_RET := '-1';
                            END;
                          
                            --Dbms_Output.Put_Line('B99_PRIMACOB ' || Prima_Ret);
                          END;
                        END;
                      
                        SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin proceso riesgos',
                                                            'MOD POL HIJA');
                        SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
                      
                        /* cristina gonzalez 02Jul2015
                           Se deja en comentario por que control tecnico ya se dispara una vezen procesar riesgo
                        
                                                                        IF op_resultado = 0 THEN
                                                                            --Controles Técnicos Riesgos (DC)
                                                                            dbms_output.put_line('Control técnico DC');
                                                                            l_nivelct := 'DC';
                                                                            sim_pck_reglas.iniarrayfromcontexto(li_arrcontexto);
                                                                            BEGIN
                                                                                sim_cu_pck_util.prc_cu_grabar_trace('Inicio ejecuta control técnico',
                                                                                                                    'MOD POL HIJA');
                                                                                sim_pck_control_tecnico.proc_ejecuta_control_tecnico(ip_numsecupol  => l_numsecupol,
                                                                                                                                     ip_nivel       => l_nivelct,
                                                                                                                                     op_existe_ct   => l_existe_ct,
                                                                                                                                     ip_validacion  => ip_validacion,
                                                                                                                                     ip_arrcontexto => li_arrcontexto,
                                                                                                                                     op_arrcontexto => lo_arrcontexto,
                                                                                                                                     ip_proceso     => l_proceso,
                                                                                                                                     op_resultado   => op_resultado,
                                                                                                                                     op_arrerrores  => op_arrerrores);
                                                                            END;
                                                                            sim_cu_pck_util.prc_cu_grabar_trace('Fin ejecuta control técnico',
                                                                                                                'MOD POL HIJA');
                                                                            sim_pck_reglas.inicontextofromarrray(lo_arrcontexto);
                                                                        END IF;
                        */
                      
                        EXIT WHEN OP_RESULTADO = -1;
                      END LOOP;
                    
                      IF OP_RESULTADO = 0 THEN
                        --Calcular Prima Total
                        SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
                      
                        BEGIN
                          SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Calcula prima total',
                                                              'MOD POL HIJA');
                          SIM_PCK_ACCESO_DATOS_EMISION.PROC_CALCULAPRIMATOTAL(IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                                              IP_NUMEND      => L_NUMEND,
                                                                              IP_ARRCONTEXTO => LI_ARRCONTEXTO,
                                                                              OP_ARRCONTEXTO => LO_ARRCONTEXTO,
                                                                              IP_PROCESO     => L_PROCESO,
                                                                              OP_RESULTADO   => OP_RESULTADO,
                                                                              OP_ARRERRORES  => OP_ARRERRORES);
                        END;
                      
                        SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin calcula prima',
                                                            'MOD POL HIJA');
                        SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
                      
                        IF OP_RESULTADO = 0 THEN
                          --Dbms_Output.Put_Line('Control técnico 4');
                          --Controles Técnicos Primas(4)
                          L_NIVELCT := '4';
                          SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
                        
                          BEGIN
                            SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Inicio ejecuta control técnico',
                                                                'MOD POL HIJA');
                            SIM_PCK_CONTROL_TECNICO.PROC_EJECUTA_CONTROL_TECNICO(IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                                                 IP_NIVEL       => L_NIVELCT,
                                                                                 OP_EXISTE_CT   => L_EXISTE_CT,
                                                                                 IP_VALIDACION  => IP_VALIDACION,
                                                                                 IP_ARRCONTEXTO => LI_ARRCONTEXTO,
                                                                                 OP_ARRCONTEXTO => LO_ARRCONTEXTO,
                                                                                 IP_PROCESO     => L_PROCESO,
                                                                                 OP_RESULTADO   => OP_RESULTADO,
                                                                                 OP_ARRERRORES  => OP_ARRERRORES);
                          END;
                        
                          SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin ejecuta control técnico',
                                                              'MOD POL HIJA');
                          SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
                        
                          /**** 6.FIN: Reglas de Negocio - Controles Técnicos ****/
                        
                          /**** 7.INICIO: Grabar ****/
                        
                          /* ****** INICIO-001 ****** */
                          -- Adición de variable de contexto de control para ejecución el modifica
                          /*sim_pck_reglas.inicializaparametros(ip_nomparametro => 'B99_GRABA_POL',
                          ip_valor        => 'N');*/
                          --
                          -- Si viene valor, se respeta el valor asignado. En caso contrario
                          -- grabarló.
                          /*BEGIN
                              l_grabar := sim_pck_reglas.g_parametros('B99_GRABA_POL');
                          EXCEPTION
                              WHEN OTHERS THEN
                                  l_grabar := 'S';
                          END;*/
                          /* ****** FIN-001 ****** */
                        
                          IF OP_RESULTADO = 0 THEN
                            FOR REG_CTECNICO IN C_CTECNICO LOOP
                              IF REG_CTECNICO.COD_RECHAZO = 2 THEN
                                L_GRABAR := 'N';
                                L_ERROR  := SIM_TYP_ERROR(-20000,
                                                          'Control Tecnico Rechazado ' ||
                                                          REG_CTECNICO.COD_ERROR || '-' ||
                                                          REG_CTECNICO.DESC_ERROR,
                                                          'E');
                                OP_ARRERRORES.EXTEND;
                                OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
                                OP_RESULTADO := -1;
                                RAISE_APPLICATION_ERROR(-20000,
                                                        'Control Tecnico Rechazado');
                              END IF;
                            END LOOP;
                          
                            --Dbms_Output.Put_Line(l_Grabar);
                          
                            --Reales
                            IF L_GRABAR = 'S' THEN
                              L_TPROCESO    := L_PROCESO.P_PROCESO;
                              L_TSUBPROCESO := L_PROCESO.P_SUBPROCESO;
                            
                              DECLARE
                                LO_POLIZA SIM_TYP_POLIZAGEN;
                              BEGIN
                                LO_POLIZA := NEW SIM_TYP_POLIZAGEN();
                                SIM_PCK_PROCESO_DATOS_EMISION2.PROC_MAPEO_TEXTOS(IP_POLIZA      => L_POLIZA,
                                                                                 IP_NUMSECUPOL  => L_NUMSECUPOL,
                                                                                 IP_TIPOPROCESO => IP_TIPOPROCESO,
                                                                                 OP_POLIZA      => LO_POLIZA,
                                                                                 IP_VALIDACION  => IP_VALIDACION,
                                                                                 IP_ARRCONTEXTO => IP_ARRCONTEXTO,
                                                                                 OP_ARRCONTEXTO => OP_ARRCONTEXTO,
                                                                                 IP_PROCESO     => IP_PROCESO,
                                                                                 OP_RESULTADO   => OP_RESULTADO,
                                                                                 OP_ARRERRORES  => OP_ARRERRORES);
                              
                                IF OP_RESULTADO = -1 THEN
                                  RETURN;
                                END IF;
                              
                                L_POLIZA := LO_POLIZA;
                              END;
                            
                              --Grabar en Tablas Reales
                              SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(LI_ARRCONTEXTO);
                            
                              BEGIN
                                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Graba Endoso',
                                                                    'MOD POL HIJA');
                                SIM_PCK_PROCESO_DML_EMISION2.PROC_GRABA_ENDOSO(IP_NUMSECUPOL     => L_NUMSECUPOL,
                                                                               OP_NUMPOL1        => LO_NUMPOL1,
                                                                               OP_NUMEND         => LO_NUMEND,
                                                                               OP_MCA_PROVISORIA => LO_MCA_PROVISORIA,
                                                                               IP_VALIDACION     => IP_VALIDACION,
                                                                               IP_ARRCONTEXTO    => LI_ARRCONTEXTO,
                                                                               OP_ARRCONTEXTO    => LO_ARRCONTEXTO,
                                                                               IP_PROCESO        => L_PROCESO,
                                                                               OP_RESULTADO      => OP_RESULTADO,
                                                                               OP_ARRERRORES     => OP_ARRERRORES);
                                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('Fin graba endoso op_resultado ' ||
                                                                    OP_RESULTADO,
                                                                    'MOD POL HIJA');
                                L_POLIZA.DATOSFIJOS.NUM_POL1 := OP_NUMPOL1;
                              END;
                            
                              SIM_PCK_REGLAS.INICONTEXTOFROMARRRAY(LO_ARRCONTEXTO);
                            
                              IF OP_RESULTADO = 0 THEN
                                BEGIN
                                  SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('inicio updatetypedex',
                                                                      'MOD POL HIJA');
                                  SIM_PCK_PROCESO_DATOS_EMISION2.PROC_UPDATETYPEDEX(IP_POLIZA     => L_POLIZA,
                                                                                    OP_POLIZA     => OP_POLIZA,
                                                                                    IP_NUMSECUPOL => L_NUMSECUPOL,
                                                                                    IP_NUMEND     => L_NUMEND,
                                                                                    IP_PROCESO    => IP_PROCESO,
                                                                                    OP_RESULTADO  => OP_RESULTADO,
                                                                                    OP_ARRERRORES => OP_ARRERRORES);
                                END;
                              
                                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('fin updatetypedex',
                                                                    'MOD POL HIJA');
                              END IF;
                            END IF;
                          END IF;
                        END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  
    /**** 7.FIN: Grabar ****/
  
    SIM_PCK_REGLAS.INIARRAYFROMCONTEXTO(OP_ARRCONTEXTO);
  
    /*If Op_Arrerrores.Count > 0 Then
     For i In Op_Arrerrores.First .. Op_Arrerrores.Last Loop
      Dbms_Output.Put_Line('Error - ' || Sqlerrm || Op_Arrerrores(i)
                           .Desc_Error);
     End Loop;
    End If;*/
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
    
    /*If Op_Arrerrores.Count > 0 Then
     For i In Op_Arrerrores.First .. Op_Arrerrores.Last Loop
      Dbms_Output.Put_Line('Error - ' || Sqlerrm || Op_Arrerrores(i)
                           .Desc_Error);
     End Loop;
    End If;*/
  END PROC_SERVICE_MODIFICA_POLHIJA;

  PROCEDURE PROC_MAPEO_DFIJOS_POLHIJA(IP_POLIZA IN OUT SIM_TYP_POLIZAGEN,
                                      /* */
                                      IP_FECHAMINIMA IN VARCHAR2,
                                      IP_FECHAMAXIMA IN VARCHAR2,
                                      /* */
                                      IP_NUMSECUPOL IN NUMBER,
                                      IP_NUMEND     IN NUMBER,
                                      IP_PROCESO    IN SIM_TYP_PROCESO,
                                      OP_RESULTADO  OUT NUMBER,
                                      OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_Mapeo_DFijos_PolHija';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('' || IP_FECHAMAXIMA, 'HIJA');
    IP_POLIZA.DATOSFIJOS.NUM_END := IP_NUMEND;
  
    /*Dbms_Output.Put_Line(Ip_Numend);
    Dbms_Output.Put_Line(Ip_Poliza.Datosfijos.Desc_Pol);*/
  
    UPDATE X2000030
       SET FECHA_VIG_POL = TO_DATE(IP_FECHAMINIMA, 'DD/MM/RRRR'),
           FECHA_VIG_END = TO_DATE(IP_FECHAMINIMA, 'DD/MM/RRRR') /*fecha_vig_pol =
                                                                                                                                                                                                                                                                                                                                                                             NVL (ip_poliza.datosfijos.fecha_vig_pol, fecha_vig_pol),
                                                                                                                                                                                                                                                                                                                                                                          fecha_vig_end =
                                                                                                                                                                                                                                                                                                                                                                             NVL (ip_poliza.datosfijos.fecha_vig_end, fecha_vig_end)*/
           /*
           ,fecha_venc_pol = nvl(ip_poliza.datosfijos.fecha_venc_pol,
                                 fecha_venc_pol)
           ,fecha_venc_end = nvl(ip_poliza.datosfijos.fecha_venc_end,
                                 fecha_venc_end)*/,
           FECHA_VENC_POL = TO_DATE(IP_FECHAMAXIMA, 'DD/MM/RRRR'),
           FECHA_VENC_END = TO_DATE(IP_FECHAMAXIMA, 'DD/MM/RRRR'),
           COD_MON        = NVL(IP_POLIZA.DATOSFIJOS.COD_MON.CODIGO, COD_MON),
           NRO_DOCUMTO    = NVL(IP_POLIZA.DATOSFIJOS.NRO_DOCUMTO.CODIGO,
                                NRO_DOCUMTO),
           FOR_COBRO      = NVL(IP_POLIZA.DATOSFIJOS.FOR_COBRO.CODIGO,
                                FOR_COBRO),
           DESC_POL       = NVL(G_DESC_POL,
                                NVL(IP_POLIZA.DATOSFIJOS.DESC_POL, DESC_POL)),
           COD_END        = NVL(IP_POLIZA.DATOSFIJOS.COD_END, COD_END),
           SUB_COD_END    = NVL(IP_POLIZA.DATOSFIJOS.SUB_COD_END,
                                SUB_COD_END),
           TIPO_END       = NVL(IP_POLIZA.DATOSFIJOS.TIPO_END.CODIGO,
                                TIPO_END),
           TDOC_TERCERO   = NVL(IP_POLIZA.DATOSFIJOS.TDOC_TERCERO.CODIGO,
                                TDOC_TERCERO),
           MCA_FACTURA    = NVL(IP_POLIZA.DATOSFIJOS.MCA_FACTURA,
                                MCA_FACTURA) /* ****** INICIO-001 ****** */
           -- Adición del campo num_cop_fre de acuerdo con lo conversado con Rosario Puertas
          ,
           CANT_COP_FRE = 1
    /* ****** FIN-001 ****** */
     WHERE NUM_SECU_POL = IP_NUMSECUPOL;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_MAPEO_DFIJOS_POLHIJA;

  PROCEDURE PROC_MAPEO_DVARIABLES_POLHIJA(IP_POLIZA     IN OUT SIM_TYP_POLIZAGEN,
                                          IP_NUMSECUPOL IN NUMBER,
                                          IP_NUMEND     IN NUMBER,
                                          IP_PROCESO    IN SIM_TYP_PROCESO,
                                          OP_RESULTADO  OUT NUMBER,
                                          OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || 'Proc_Mapeo_DVariables_PolHija';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    IF IP_POLIZA.DV_POLIZA.EXISTS(1) THEN
      IF IP_POLIZA.DV_POLIZA.COUNT > 0 THEN
        FOR I IN IP_POLIZA.DV_POLIZA.FIRST .. IP_POLIZA.DV_POLIZA.LAST LOOP
          IP_POLIZA.DV_POLIZA(I).NUM_SECU_POL := IP_NUMSECUPOL;
          IP_POLIZA.DV_POLIZA(I).NUM_END := IP_NUMEND;
        
          BEGIN
            UPDATE X2000020 B
               SET B.VALOR_CAMPO_EN = NVL(IP_POLIZA.DV_POLIZA(I).VALOR_CAMPO,
                                          B.VALOR_CAMPO_EN)
            /* SGPM: 24/02/2016
             Se pone  en comentario por error en mapeo.
            ,b.valor_campo =
             NVL (ip_poliza.dv_poliza (i).valor_campo,
                  b.valor_campo)*/
             WHERE B.NUM_SECU_POL = IP_POLIZA.DV_POLIZA(I).NUM_SECU_POL
               AND NVL(B.COD_RIES, -1) =
                   NVL(IP_POLIZA.DV_POLIZA(I).COD_RIES, -1)
               AND B.COD_CAMPO = IP_POLIZA.DV_POLIZA(I).COD_CAMPO;
          
            IF SQL%NOTFOUND THEN
              INSERT INTO X2000020
                (NUM_SECU_POL,
                 COD_CAMPO,
                 VALOR_CAMPO,
                 VALOR_CAMPO_EN,
                 NUM_SECU,
                 COD_NIVEL)
              VALUES
                (IP_POLIZA.DV_POLIZA(I).NUM_SECU_POL,
                 IP_POLIZA.DV_POLIZA(I).COD_CAMPO,
                 IP_POLIZA.DV_POLIZA(I).VALOR_CAMPO,
                 IP_POLIZA.DV_POLIZA(I).VALOR_CAMPO,
                 -1,
                 -1);
            END IF;
          END;
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_MAPEO_DVARIABLES_POLHIJA;

  PROCEDURE PROC_MAPEO_DVRIESGOS_POLHIJA(IP_POLIZA     IN OUT SIM_TYP_POLIZAGEN,
                                         IP_NUMSECUPOL IN NUMBER,
                                         IP_NUMEND     IN NUMBER,
                                         IP_PROCESO    IN SIM_TYP_PROCESO,
                                         OP_RESULTADO  OUT NUMBER,
                                         OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_VALORCAMPO A2000020.VALOR_CAMPO%TYPE;
    L_CODCAMPO   A2000020.COD_CAMPO%TYPE;
  
    P_DIRECCION          VARCHAR2(32767);
    P_DIRECCION_ESTANDAR VARCHAR2(32767);
    P_MENSAJE_SALIDA     VARCHAR2(32767);
    P_CODIGO_SALIDA      NUMBER(10);
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || 'Proc_Mapeo_DVRiesgos_PolHija';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
      IF IP_POLIZA.DATOSRIESGOS.COUNT > 0 THEN
        FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
          --Datos Variables Riesgos
          IF IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES.EXISTS(1) THEN
            FOR DV IN IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                        .DATOSVARIABLES.LAST LOOP
              L_VALORCAMPO := IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                              .VALOR_CAMPO;
              L_CODCAMPO   := IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                              .COD_CAMPO;
            
              IF SIM_PCK_FUNCION_GEN.FUN_ES_DIRECCION(L_CODCAMPO,
                                                      IP_PROCESO.P_COD_CIA,
                                                      IP_PROCESO.P_COD_SECC,
                                                      IP_PROCESO.P_COD_PRODUCTO) THEN
                P_DIRECCION          := L_VALORCAMPO;
                P_DIRECCION_ESTANDAR := NULL;
                P_CODIGO_SALIDA      := NULL;
                P_MENSAJE_SALIDA     := NULL;
              
                PKG_VALIDACIONES_TER.PRC_VALIDAR_DIRECCION(P_DIRECCION,
                                                           P_DIRECCION_ESTANDAR,
                                                           P_CODIGO_SALIDA,
                                                           P_MENSAJE_SALIDA);
              
                IF TRIM(P_DIRECCION_ESTANDAR) IS NOT NULL THEN
                  L_VALORCAMPO := P_DIRECCION_ESTANDAR;
                ELSE
                  L_VALORCAMPO := P_DIRECCION || '- No homologada';
                END IF;
              END IF;
            
              IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).NUM_SECU_POL := IP_NUMSECUPOL;
              IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).NUM_END := IP_NUMEND;
            
              BEGIN
                UPDATE X2000020 B
                   SET B.VALOR_CAMPO_EN = NVL(L_VALORCAMPO, B.VALOR_CAMPO_EN),
                       -- COMENTARIO REALIZADO POR MCGA 2016/02/24
                       --                               b.valor_campo =
                       --                                  NVL (l_valorcampo, b.valor_campo),
                       B.CLAVE_COBERT = 'S'
                 WHERE B.NUM_SECU_POL = IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                      .NUM_SECU_POL
                   AND NVL(B.COD_RIES, -1) = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                                                 .COD_RIES,
                                                 -1)
                   AND B.COD_CAMPO = IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                      .COD_CAMPO;
              
                IF SQL%NOTFOUND THEN
                  INSERT INTO X2000020
                    (NUM_SECU_POL,
                     COD_CAMPO,
                     COD_RIES,
                     VALOR_CAMPO,
                     VALOR_CAMPO_EN,
                     NUM_SECU,
                     CLAVE_COBERT,
                     COD_NIVEL)
                  VALUES
                    (IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV)
                     .NUM_SECU_POL,
                     IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).COD_CAMPO,
                     IP_POLIZA.DATOSRIESGOS(R).DATOSVARIABLES(DV).COD_RIES,
                     L_VALORCAMPO,
                     L_VALORCAMPO,
                     -1,
                     'S',
                     -1);
                END IF;
              END;
            END LOOP;
          END IF;
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_MAPEO_DVRIESGOS_POLHIJA;

  PROCEDURE PROC_MAPEO_COBRIESGOS_POLHIJA(IP_POLIZA     IN OUT SIM_TYP_POLIZAGEN,
                                          IP_NUMSECUPOL IN NUMBER,
                                          IP_NUMEND     IN NUMBER,
                                          IP_PROCESO    IN SIM_TYP_PROCESO,
                                          OP_RESULTADO  OUT NUMBER,
                                          OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_SQL CLOB;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || 'Proc_Mapeo_CobRiesgos_PolHija';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    IF IP_POLIZA.DATOSRIESGOS.EXISTS(1) THEN
      IF IP_POLIZA.DATOSRIESGOS.COUNT > 0 THEN
        FOR R IN IP_POLIZA.DATOSRIESGOS.FIRST .. IP_POLIZA.DATOSRIESGOS.LAST LOOP
          --Coberturas
          IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.EXISTS(1) THEN
            FOR C IN IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS.FIRST .. IP_POLIZA.DATOSRIESGOS(R)
                                                                        .DATOSCOBERTURAS.LAST LOOP
              IF IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C).SUMA_ASEG >= 0 THEN
                SIM_CU_PCK_UTIL.PRC_CU_GRABAR_TRACE('VALOR ' || IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                    .PRIMA_COB,
                                                    'PRIMA_COB');
              
                UPDATE X2000040 A
                   SET A.END_SUMA_ASEG       = DECODE(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                      .SIM_MCA_SUMA_INF,
                                                      'S',
                                                      IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                      .SUMA_ASEG,
                                                      A.END_SUMA_ASEG),
                       A.END_TASA_COB        = DECODE(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                      .MCA_TASA_INF,
                                                      'S',
                                                      IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                      .TASA_COB,
                                                      A.END_TASA_COB),
                       A.END_PRIMA_COB       = DECODE(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                      .MCA_PRIMA_INF,
                                                      'S',
                                                      IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                      .PRIMA_COB,
                                                      A.END_PRIMA_COB),
                       A.SIM_MCA_SUMA_INF    = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .SIM_MCA_SUMA_INF,
                                                   A.SIM_MCA_SUMA_INF),
                       A.MCA_TASA_INF        = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .MCA_TASA_INF,
                                                   A.MCA_TASA_INF),
                       A.MCA_PRIMA_INF       = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .MCA_PRIMA_INF,
                                                   A.MCA_PRIMA_INF),
                       A.SIM_FECHA_INCLUSION = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .SIM_FECHA_INCLUSION,
                                                   A.SIM_FECHA_INCLUSION),
                       A.SIM_FECHA_EXCLUSION = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .SIM_FECHA_EXCLUSION,
                                                   A.SIM_FECHA_EXCLUSION),
                       A.SIM_FECHA_VIG_END   = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .SIM_FECHA_VIG_END,
                                                   A.SIM_FECHA_VIG_END),
                       A.SIM_FECHA_VENC_END  = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .SIM_FECHA_VENC_END,
                                                   A.SIM_FECHA_VENC_END),
                       A.SIM_COEFCOB         = NVL(IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                                                   .SIM_COEFCOB,
                                                   A.SIM_COEFCOB) /* ****** INICIO-001 ****** */,
                       A.MOD_DAT_VAR         = 'S'
                /* ****** FIN-001 ****** */
                 WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
                   AND A.COD_RIES = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                      .COD_RIES
                   AND A.COD_COB = IP_POLIZA.DATOSRIESGOS(R).DATOSCOBERTURAS(C)
                      .COD_COB.CODIGO;
              END IF;
            END LOOP;
          END IF;
        END LOOP;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_MAPEO_COBRIESGOS_POLHIJA;

  PROCEDURE PROC_CONVIERTE_DESC_POL(IP_DESC_POL IN VARCHAR2,
                                    OP_DESC_POL OUT VARCHAR2) IS
    -- Declaración de variables
    L_FRASE_TEMP VARCHAR2(120);
    L_SEPARADOR  VARCHAR2(20);
    P            PLS_INTEGER := 1; -- Contador de palabras
  
    -- Declaración de TYPES
    TYPE T_PALABRAS IS TABLE OF VARCHAR2(120) INDEX BY PLS_INTEGER;
  
    L_PALABRAS_ORIGINALES T_PALABRAS;
    L_PALABRAS_FRASE      T_PALABRAS;
    -- Definición de constantes
    C_CARACTER_DIV   CONSTANT VARCHAR2(1) := ',';
    C_LLAVE_BUSQUEDA CONSTANT VARCHAR2(20) := 'ENDOSO_UNIFICADO';
  BEGIN
    -- Filtrado inicial de valores
    -- Se elimina la palabra ENDOSOS, dada la parametrización inicial del campo DESC_POL.
    L_FRASE_TEMP := TRANSLATE(REPLACE(IP_DESC_POL, 'ENDOSOS'), ', .:;', ',');
  
    -- Bloque de extracción de palabras.
    DECLARE
      I PLS_INTEGER := 1;
    BEGIN
      WHILE I <= LENGTH(L_FRASE_TEMP) LOOP
        DECLARE
          -- Declaración de variable l_palabra.
          L_PALABRA    VARCHAR2(2000);
          L_SUB_CADENA CLOB;
        BEGIN
          -- Extracción de subcadena de longitud 1.
          L_SUB_CADENA := SUBSTR(SUBSTR(L_FRASE_TEMP, I, I), 1, 1);
        
          -- Verificación de caracter de STOP
          IF L_SUB_CADENA = C_CARACTER_DIV THEN
            L_PALABRA := SUBSTR(L_FRASE_TEMP, 1, I - 1);
            L_FRASE_TEMP := LTRIM(SUBSTR(L_FRASE_TEMP, I + 1));
            L_PALABRAS_ORIGINALES(P) := L_PALABRA;
            P := P + 1;
            I := 1;
          ELSE
            I := I + 1;
          END IF;
        END;
      END LOOP;
    
      L_PALABRAS_ORIGINALES(P) := SUBSTR(L_FRASE_TEMP, 1);
    END;
  
    --
    L_FRASE_TEMP := '';
  
    -- Extracción de palabras con el formato deseado en destino.
    FOR I IN L_PALABRAS_ORIGINALES.FIRST .. L_PALABRAS_ORIGINALES.LAST LOOP
      DECLARE
        L_PALABRA VARCHAR2(120) := '';
      BEGIN
        BEGIN
          SELECT LV.DESCRIPCION
            INTO L_PALABRA
            FROM SIM_CU_LISTAS_VALORES LV
           WHERE LV.COD_LISTA_VALOR = C_LLAVE_BUSQUEDA
             AND LV.VALOR_LISTA = L_PALABRAS_ORIGINALES(I);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            L_PALABRA := '';
        END;
      
        --Dbms_Output.Put_Line(l_Palabras_Originales(i));
        L_PALABRAS_FRASE(I) := L_PALABRA;
      END;
    END LOOP;
  
    -- Consulta de separador entre palabras en DESC_POL
    BEGIN
      SELECT LV.VALOR_LISTA
        INTO L_SEPARADOR
        FROM SIM_CU_LISTAS_VALORES LV
       WHERE LV.COD_LISTA_VALOR = 'SEPARADOR';
    EXCEPTION
      WHEN OTHERS THEN
        L_SEPARADOR := ', ';
    END;
  
    -- Transformación de cadena generada.
    DECLARE
      L_ES_INICIAL BOOLEAN := FALSE;
    BEGIN
      FOR I IN L_PALABRAS_FRASE.FIRST .. L_PALABRAS_FRASE.LAST LOOP
        BEGIN
          IF L_PALABRAS_FRASE(I) IS NOT NULL THEN
            IF NOT (L_ES_INICIAL) THEN
              L_FRASE_TEMP := L_PALABRAS_FRASE(I);
              L_ES_INICIAL := TRUE;
            ELSE
              -- Concatenación por izquierda del separador y la frase obtenida
              L_FRASE_TEMP := L_FRASE_TEMP || L_SEPARADOR ||
                              L_PALABRAS_FRASE(I);
            END IF;
          END IF;
        END;
      END LOOP;
    END;
  
    L_FRASE_TEMP := L_FRASE_TEMP || '.';
    --
    OP_DESC_POL := L_FRASE_TEMP;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001,
                              'Error en la línea ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() ||
                              '. Posible causa :' || SQLERRM);
  END PROC_CONVIERTE_DESC_POL;

  PROCEDURE PROC_IMPRIMEPPAL_DOC1(OP_IMPRIME    OUT VARCHAR2,
                                  IP_VALIDACION IN VARCHAR2,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NUMBER,
                                  OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_MARCAIMP SIM_PCK_TIPOS_GENERALES.T_CARACTER;
  BEGIN
    L_MARCAIMP := 'N';
  
    BEGIN
      SELECT A.DAT_CAR
        INTO L_MARCAIMP
        FROM C9999909 A
       WHERE A.COD_CIA = IP_PROCESO.P_COD_CIA
         AND A.COD_SECC = IP_PROCESO.P_COD_SECC
         AND A.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND A.CODIGO1 = IP_PROCESO.P_PROCESO
         AND A.COD_TAB = 'SIM_IMPRIME_PPALDOC1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    OP_IMPRIME   := L_MARCAIMP;
    OP_RESULTADO := 0;
  END PROC_IMPRIMEPPAL_DOC1;

  PROCEDURE PROC_CREAARRAYASEG(IP_NUMSECUPOL   IN A2000030.NUM_SECU_POL%TYPE,
                               OP_ARRAYTERCERO OUT SIM_TYP_ARRAY_TERCEROGEN,
                               IP_PROCESO      IN SIM_TYP_PROCESO,
                               OP_RESULTADO    OUT NUMBER,
                               OP_ARRERRORES   OUT SIM_TYP_ARRAY_ERROR) IS
    /*Crea type de asegurados*/
    CURSOR DV IS
      SELECT DISTINCT A.COD_RIES
        FROM X2000020 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL;
  
    L_CODRIES      NUMBER := 0;
    L_TERCEROGEN   SIM_TYP_TERCEROGEN;
    L_ARRAYTERCERO SIM_TYP_ARRAY_TERCEROGEN;
  BEGIN
    G_SUBPROGRAMA  := G_PROGRAMA || '.Proc_CreaArrayAseg';
    L_ERROR        := NEW SIM_TYP_ERROR;
    OP_ARRERRORES  := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO   := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_TERCEROGEN   := NEW SIM_TYP_TERCEROGEN();
    L_ARRAYTERCERO := NEW SIM_TYP_ARRAY_TERCEROGEN();
  
    --------------------Inicio Datos Variables
    FOR RDV IN DV LOOP
      IF L_CODRIES != RDV.COD_RIES THEN
        L_TERCEROGEN.TIPO_DOCUMENTO   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('TIPO_DOC_ASEG',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.NUMERO_DOCUMENTO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_ASEG',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.COD_RIES         := RDV.COD_RIES;
        L_TERCEROGEN.ROL              := 2;
        L_TERCEROGEN.NOMBRES          := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('NOM_ASEG',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.APELLIDOS        := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('APE_ASEG',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.OCUPACION        := SIM_TYP_LOOKUP(SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_OCU_ATGC',
                                                                                                 IP_NUMSECUPOL,
                                                                                                 RDV.COD_RIES),
                                                        SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_OCU_ATGC',
                                                                                                 IP_NUMSECUPOL,
                                                                                                 RDV.COD_RIES));
        L_TERCEROGEN.DIRECCION        := SUBSTR(SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('DIRECC_RIES',
                                                                                         IP_NUMSECUPOL,
                                                                                         RDV.COD_RIES),
                                                1,
                                                60);
      
        IF SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('FEC_NACIMIENTO',
                                                    IP_NUMSECUPOL,
                                                    RDV.COD_RIES) IS NOT NULL THEN
          L_TERCEROGEN.FECHA_NACIMIENTO := TO_DATE(SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('FEC_NACIMIENTO',
                                                                                            IP_NUMSECUPOL,
                                                                                            RDV.COD_RIES),
                                                   'DDMMYYYY');
        END IF;
      
        L_TERCEROGEN.SEXO          := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('SEXO_VIP',
                                                                               IP_NUMSECUPOL,
                                                                               RDV.COD_RIES);
        L_TERCEROGEN.CIUDAD.CODIGO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('CPOS_RIES',
                                                                               IP_NUMSECUPOL,
                                                                               RDV.COD_RIES);
        L_ARRAYTERCERO.EXTEND;
        L_ARRAYTERCERO(L_ARRAYTERCERO.COUNT) := L_TERCEROGEN;
      END IF;
    END LOOP;
  
    OP_ARRAYTERCERO := L_ARRAYTERCERO;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_CREAARRAYASEG;

  PROCEDURE PROC_PLACAVIGENTE(IP_PLACA      IN VARCHAR2,
                              IP_NUMSECUPOL IN NUMBER,
                              IP_PROCESO    IN SIM_TYP_PROCESO,
                              OP_RESULTADO  OUT NUMBER,
                              OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    /*Verifica si una placa tiene pólizas vigentes a la fecha */
  
    CURSOR C1 IS
      SELECT A.NUM_SECU_POL,
             A.COD_RIES,
             A.FECHA_BAJA,
             C.FECHA_VIG_END,
             C.FECHA_VENC_END,
             A.NUM_END,
             C.NUM_POL_COTIZ,
             C.NUM_POL1,
             C.MCA_PER_ANUL,
             C.MCA_ANU_POL,
             D.VALOR_CAMPO     NRO_DOCUMTO, --id asegurado
             C.SIM_SUBPRODUCTO,
             C.COD_PROD        AGENTE
        FROM A2040100 A, A2000030 C, A2000020 D
       WHERE A.PAT_VEH = IP_PLACA
         AND A.NUM_END = (SELECT MAX(B.NUM_END)
                            FROM A2040100 B
                           WHERE B.NUM_SECU_POL = A.NUM_SECU_POL
                             AND B.COD_RIES = A.COD_RIES)
         AND A.NUM_SECU_POL = C.NUM_SECU_POL
         AND C.NUM_SECU_POL = D.NUM_SECU_POL
         AND D.COD_CAMPO = 'COD_ASEG'
         AND D.MCA_VIGENTE = 'S'
         AND D.COD_RIES = A.COD_RIES
         AND A.NUM_END = C.NUM_END
         AND C.NUM_POL1 IS NOT NULL
       ORDER BY C.FECHA_VIG_POL DESC
      --COndicion incluida por HLC y WESV teniendo en cuenta que
      -- el endoso de anulacion no aparece en la a2040100, pero sí en la a2000030
      -- por lo que el join no esta funcionando -- 20160323
      -- morj, se identifica que los endosos 100-2 y otros no dejan la mca_anu_pol en S
      --Sino que marcan la mca_per_anul
      --         AND nvl(c.mca_per_anul,'N') = 'N'
      ;
    L_CANTVIGENTE NUMBER := 0;
    L_NRODOCUMTO  NUMBER;
    L_MARCAANUPOL VARCHAR2(1) := 'N';
    L_FECHAINI    DATE;
    L_FECHAFIN    DATE;
    L_FECHABAJA   DATE;
    L_FECHAANU    DATE;
    L_CREDIBILI   NUMBER := 0;
    --11/03/2019 lberbesi: Se incluye para identificar si aplica anula-reemplaza
    L_ESANULAREEMP VARCHAR2(1) := 'N';
    L_RESULTADO    NUMBER;
    L_ARRERRORES   SIM_TYP_ARRAY_ERROR;
    L_NUMEND       A2000030.NUM_END%TYPE := 0;
    L_CODRIES      A2000020.COD_RIES%TYPE := 1;
    --Autos x Opciones II-Modificaciones 2019
    --Marzo 2020
    L_TDOCRLNVO    A2000020.VALOR_CAMPO%TYPE;
    L_NDOCRLNVO    A2000020.VALOR_CAMPO%TYPE;
    L_TDOCLOCATNVO A2000020.VALOR_CAMPO%TYPE;
    L_NDOCLOCATNVO A2000020.VALOR_CAMPO%TYPE;
    L_NDOCRLANT    A2000020.VALOR_CAMPO%TYPE;
    L_NDOCLOCATANT A2000020.VALOR_CAMPO%TYPE;
    L_TDOCLOCATANT A2000020.VALOR_CAMPO%TYPE;
    L_TDOCRLANT    A2000020.VALOR_CAMPO%TYPE;
  
  BEGIN
  
    /*Sim_Proc_Log('Placa vigente',
    Ip_Placa || '*numsecupol:' || Ip_Numsecupol);*/
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_CreaArrayAseg';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    /*Iniciativa factor al 150*/
    L_RESULTADO  := 0;
    L_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    FOR REG_C1 IN C1 LOOP
      IF SIM_PCK_FUNCION_GEN.FUN_CREDIBILIDAD_150(IP_NUMSECUPOL,
                                                  REG_C1.COD_RIES) = 'S' THEN
        L_CREDIBILI := 1;
      ELSIF REG_C1.NUM_SECU_POL != IP_NUMSECUPOL THEN
        L_FECHAINI  := REG_C1.FECHA_VIG_END;
        L_FECHAFIN  := REG_C1.FECHA_VENC_END;
        L_FECHABAJA := REG_C1.FECHA_BAJA;
      
        IF NVL(REG_C1.MCA_PER_ANUL, 'N') = 'S' THEN
          BEGIN
            SELECT T.FECHA_VIG_END, T.FECHA_VENC_END, T.FEC_ANU_POL
              INTO L_FECHAINI, L_FECHAFIN, L_FECHAANU
              FROM A2000030 T
             WHERE T.NUM_SECU_POL = REG_C1.NUM_SECU_POL
               AND T.NUM_END =
                   (SELECT MAX(N.NUM_END)
                      FROM A2000030 N
                     WHERE N.NUM_SECU_POL = T.NUM_SECU_POL);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          IF TRUNC(SYSDATE) BETWEEN L_FECHAINI AND L_FECHAFIN THEN
            NULL;
          ELSE
            IF L_FECHAFIN >= TRUNC(SYSDATE) THEN
              L_CANTVIGENTE := L_CANTVIGENTE + 1;
            END IF;
          END IF;
          --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
          IF IP_PROCESO.P_SUBPRODUCTO IN (251, 360) AND
             REG_C1.SIM_SUBPRODUCTO IN (251, 360) THEN
            IF L_FECHAINI > ADD_MONTHS(TRUNC(SYSDATE), -3) THEN
              L_NRODOCUMTO := 0;
              BEGIN
                SELECT VALOR_CAMPO
                  INTO L_NRODOCUMTO
                  FROM A2000020
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'COD_ASEG'
                   AND COD_RIES = 1
                   AND NUM_END = 0;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    SELECT VALOR_CAMPO
                      INTO L_NRODOCUMTO
                      FROM X2000020
                     WHERE NUM_SECU_POL = IP_NUMSECUPOL
                       AND COD_CAMPO = 'COD_ASEG'
                       AND COD_RIES = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_NRODOCUMTO := 0;
                  END;
              END;
              --Autos x Opciones modificaciones 2019
              --Lberbesi
              --Marzo 2020
              --Locatario nuevo
              BEGIN
                SELECT VALOR_CAMPO
                  INTO L_NDOCLOCATNVO
                  FROM A2000020
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'NROIDLOCAT'
                   AND COD_RIES = 1
                   AND NUM_END = 0;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    SELECT VALOR_CAMPO
                      INTO L_NDOCLOCATNVO
                      FROM X2000020
                     WHERE NUM_SECU_POL = IP_NUMSECUPOL
                       AND COD_CAMPO = 'NROIDLOCAT'
                       AND COD_RIES = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_NDOCLOCATNVO := 0;
                  END;
              END;
              BEGIN
                SELECT VALOR_CAMPO
                  INTO L_TDOCLOCATNVO
                  FROM A2000020
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'TIPODOCLOCAT'
                   AND COD_RIES = 1
                   AND NUM_END = 0;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    SELECT VALOR_CAMPO
                      INTO L_TDOCLOCATNVO
                      FROM X2000020
                     WHERE NUM_SECU_POL = IP_NUMSECUPOL
                       AND COD_CAMPO = 'TIPODOCLOCAT'
                       AND COD_RIES = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_TDOCLOCATNVO := 0;
                  END;
              END;
              --Rep. legal nuevo
              BEGIN
                SELECT VALOR_CAMPO
                  INTO L_TDOCRLNVO
                  FROM A2000020
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'TIPODOCRL'
                   AND COD_RIES = 1
                   AND NUM_END = 0;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    SELECT VALOR_CAMPO
                      INTO L_TDOCRLNVO
                      FROM X2000020
                     WHERE NUM_SECU_POL = IP_NUMSECUPOL
                       AND COD_CAMPO = 'TIPODOCRL'
                       AND COD_RIES = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_TDOCRLNVO := 0;
                  END;
              END;
              BEGIN
                SELECT VALOR_CAMPO
                  INTO L_NDOCRLNVO
                  FROM A2000020
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'NROIDRL'
                   AND COD_RIES = 1
                   AND NUM_END = 0;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    SELECT VALOR_CAMPO
                      INTO L_NDOCRLNVO
                      FROM X2000020
                     WHERE NUM_SECU_POL = IP_NUMSECUPOL
                       AND COD_CAMPO = 'NROIDRL'
                       AND COD_RIES = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_NDOCRLNVO := 0;
                  END;
              END;
              --Locatario anterior
              BEGIN
                L_NDOCLOCATANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'NROIDLOCAT',
                                                       PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                                       PCODRIESGO => REG_C1.COD_RIES);
              EXCEPTION
                WHEN OTHERS THEN
                  L_NDOCLOCATANT := 0;
              END;
              BEGIN
                L_TDOCLOCATANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'TIPODOCLOCAT',
                                                       PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                                       PCODRIESGO => REG_C1.COD_RIES);
              EXCEPTION
                WHEN OTHERS THEN
                  L_TDOCLOCATANT := 0;
              END;
              --Rep. legal anterior
              BEGIN
                L_NDOCRLANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'NROIDRL',
                                                    PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                                    PCODRIESGO => REG_C1.COD_RIES);
              EXCEPTION
                WHEN OTHERS THEN
                  L_NDOCRLANT := 0;
              END;
            
              BEGIN
                L_TDOCRLANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'TIPODOCRL',
                                                    PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                                    PCODRIESGO => REG_C1.COD_RIES);
              EXCEPTION
                WHEN OTHERS THEN
                  L_TDOCRLANT := 0;
              END;
            
              IF L_NDOCRLANT = L_NDOCRLNVO AND L_TDOCRLANT = L_TDOCRLNVO THEN
                L_CANTVIGENTE := L_CANTVIGENTE + 1;
              END IF;
            
              IF L_NDOCLOCATANT = L_NDOCLOCATNVO AND
                 L_TDOCLOCATANT = L_TDOCLOCATNVO THEN
                L_CANTVIGENTE := L_CANTVIGENTE + 1;
              END IF;
              IF REG_C1.NRO_DOCUMTO = L_NRODOCUMTO THEN
                L_CANTVIGENTE := L_CANTVIGENTE + 1;
              END IF;
            END IF;
          END IF;
        ELSE
          --lberbesi 24/03/2024: Para autogestión la validación se realiza la validación antes desde el front (GD771-515)
          IF NVL(IP_PROCESO.P_INFO1, 'N') != 'AUT' THEN
            IF NVL(L_FECHABAJA, L_FECHAFIN) > TRUNC(SYSDATE) THEN
              L_CANTVIGENTE := L_CANTVIGENTE + 1;
            END IF;
          END IF;
        END IF;
      END IF;
    
    /*        If l_fechafin > trunc(Sysdate) Then
                                                                                                                   If nvl(Reg_c1.Mca_Per_Anul,'N')  = 'S' Then
                                                                                                                      If trunc(Sysdate) Between l_fechaini And l_fechafin Then
                                                                                                                           Null;
                                                                                                                      Else
                                                                                                                           l_CantVigente := l_CantVigente + 1;
                                                                                                                      End If;
                                                                                                                   Else
                                                                                                                    If Nvl(l_fechabaja, l_fechafin) >= Trunc(Sysdate) Then
                                                                                                                      l_CantVigente := l_CantVigente + 1;
                                                                                                                    End If;
                                                                                                                    l_Marcaanupol := 'N';
                                                                                                                    Begin
                                                                                                                      Select d.Mca_Anu_Pol
                                                                                                                        Into l_Marcaanupol
                                                                                                                        From A2000030 d
                                                                                                                       Where d.Num_Secu_Pol = Reg_C1.Num_Secu_Pol
                                                                                                                         And d.Num_Pol1 Is Not Null
                                                                                                                         And d.Num_End =
                                                                                                                             (Select Max(j.Num_End)
                                                                                                                                From A2000030 j
                                                                                                                               Where j.Num_Secu_Pol = d.Num_Secu_Pol)
                                                                                                                               ;
                                                                                                                    Exception
                                                                                                                      When Others Then
                                                                                                                        l_Marcaanupol := 'N';
                                                                                                                    End;
                                                                                                                    If l_Marcaanupol = 'N' Then
                                                                                                                      l_CantVigente := l_CantVigente + 1;
                                                                                                                    End If;
                                                                                                                   End If;
                                                                                                                  Else
                                                                                                                    --Polizas que ya vencieron
                                                                                                                    If ip_proceso.p_Subproducto = 251 Then
                                                                                                                       If l_fechafin > add_months(trunc(Sysdate),-3) Then
                                                                                                                            l_nrodocumto := 0;
                                                                                                                            Begin
                                                                                                                              Select nro_documto
                                                                                                                              Into   l_nrodocumto
                                                                                                                              From   A2000030
                                                                                                                              Where  num_secu_pol = Ip_Numsecupol
                                                                                                                              And    num_end = 0;
                                                                                                                            Exception
                                                                                                                              When no_data_found Then
                                                                                                                                 Begin
                                                                                                                                    Select nro_documto
                                                                                                                                    Into   l_nrodocumto
                                                                                                                                    From   x2000030
                                                                                                                                    Where  num_secu_pol = Ip_Numsecupol;
                                                                                                                                 Exception
                                                                                                                                   When Others Then
                                                                                                                                      l_nrodocumto := 0;
                                                                                                                                 End;
                                                                                                                            End;
                                                                                                                            If reg_c1.nro_documto = l_nrodocumto Then
                                                                                                                               l_CantVigente := l_CantVigente + 1;
                                                                                                                            End If;
                                                                                                                       End If;
                                                                                                                    End If;
                                                                                                                  End If;
                                                                                                                 End If;
                                                                                                          */
    END LOOP;
    --21/05/2019 lberbesi: Se saca del loop para que no vaya tantas veces al proc_anulareemplaza_renov.
    --11/03/2019 lberbesi: Se valida si aplica anula-reemplaza
    --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
    IF IP_PROCESO.P_SUBPRODUCTO IN (251, 263, 274, 360) THEN
      PROC_ANULAREEMPLAZA_RENOV(IP_NUMSECUPOL   => IP_NUMSECUPOL,
                                IP_NUMEND       => L_NUMEND,
                                IP_CODRIES      => L_CODRIES,
                                OP_ESANULAREEMP => L_ESANULAREEMP,
                                IP_PROCESO      => IP_PROCESO,
                                OP_RESULTADO    => L_RESULTADO,
                                OP_ARRERRORES   => L_ARRERRORES);
    END IF;
    IF L_CREDIBILI > 0 THEN
      --07/05/2019 lberbesi: Si es de anula reemplaza no se debe generar error.
      IF NVL(L_ESANULAREEMP, 'N') <> 'S' THEN
        OP_RESULTADO := -1;
        L_ERROR      := SIM_TYP_ERROR(-20000,
                                      'Esta Cotizacion se debe emitir por el canal tradicional, ' ||
                                      ' porque se encuentra vinculado en la compañia',
                                      'E');
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      END IF;
    ELSIF L_CANTVIGENTE > 0 THEN
      IF NVL(L_ESANULAREEMP, 'N') <> 'S' THEN
        OP_RESULTADO := -1;
        IF L_RESULTADO = 4 THEN
          L_ERROR := SIM_TYP_ERROR(-20000,
                                   'No es posible emitir por anula reemplaza, póliza con siniestros vigentes',
                                   'E');
        ELSE
          L_ERROR := SIM_TYP_ERROR(-20000,
                                   'Vehículo actualmente tiene póliza ' ||
                                   'vigente con otra clave u otro subproducto No se permite la emisión',
                                   'E');
        END IF;
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      END IF;
    END IF;
  
    --    Dbms_Output.Put_Line('Cantidad de polizas vigentes:' || l_Vigente);
  
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      L_ERROR      := SIM_TYP_ERROR(SQLCODE,
                                    'Error en Proc_PlacaVigente' || SQLERRM,
                                    'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
  END PROC_PLACAVIGENTE;
  --BANCAN3-177 version para ser llamado en cotizaciones desde API
  PROCEDURE PROC_PLACAVIGENTE(IP_PLACA             IN VARCHAR2, ---si
                              IP_NUMSECUPOL        IN NUMBER, --si es cotizacion debe llegar en nulo si es cotización
                              IP_PROCESO           IN SIM_TYP_PROCESO, --si
                              IP_NRO_DOCUMTO_ASEG  NUMBER, --si
                              IP_TIPP_DOCUMTO_ASEG VARCHAR2, --si
                              OP_RESULTADO         OUT NOCOPY NUMBER,
                              OP_ARRERRORES        OUT NOCOPY SIM_TYP_ARRAY_ERROR) IS
    /*Verifica si una placa tiene polizas vigentes a la fecha */
  
    CURSOR C1 IS
      SELECT A.NUM_SECU_POL,
             A.COD_RIES,
             A.FECHA_BAJA,
             C.FECHA_VIG_END,
             C.FECHA_VENC_END,
             A.NUM_END,
             C.NUM_POL_COTIZ,
             C.NUM_POL1,
             C.MCA_PER_ANUL,
             C.MCA_ANU_POL,
             D.VALOR_CAMPO     NRO_DOCUMTO, --id asegurado
             C.SIM_SUBPRODUCTO,
             C.COD_PROD        AGENTE
        FROM A2040100 A, A2000030 C, A2000020 D
       WHERE A.PAT_VEH = IP_PLACA
         AND A.NUM_END = (SELECT MAX(B.NUM_END)
                            FROM A2040100 B
                           WHERE B.NUM_SECU_POL = A.NUM_SECU_POL
                             AND B.COD_RIES = A.COD_RIES)
         AND A.NUM_SECU_POL = C.NUM_SECU_POL
         AND C.NUM_SECU_POL = D.NUM_SECU_POL
         AND D.COD_CAMPO = 'COD_ASEG'
         AND D.MCA_VIGENTE = 'S'
         AND D.COD_RIES = A.COD_RIES
         AND A.NUM_END = C.NUM_END
         AND C.NUM_POL1 IS NOT NULL
       ORDER BY C.FECHA_VIG_POL DESC
      --COndicion incluida por HLC y WESV teniendo en cuenta que
      -- el endoso de anulacion no aparece en la a2040100, pero s¿ en la a2000030
      -- por lo que el join no esta funcionando -- 20160323
      -- morj, se identifica que los endosos 100-2 y otros no dejan la mca_anu_pol en S
      --Sino que marcan la mca_per_anul
      --         AND nvl(c.mca_per_anul,'N') = 'N'
      ;
    V_STR_ERROR      VARCHAR2(2000);
    L_CANTVIGENTE    NUMBER := 0;
    L_NRODOCUMTO     NUMBER;
    L_NROTIPODOCUMTO VARCHAR2(100);
    L_MARCAANUPOL    VARCHAR2(1) := 'N';
    L_FECHAINI       DATE;
    L_FECHAFIN       DATE;
    L_FECHABAJA      DATE;
    L_FECHAANU       DATE;
    L_CREDIBILI      NUMBER := 0;
    --11/03/2019 lberbesi: Se incluye para identificar si aplica anula-reemplaza
    L_ESANULAREEMP  VARCHAR2(1) := 'N';
    L_RESULTADO     NUMBER;
    V_EXCLUYE_PARAM NUMBER;
    L_ARRERRORES    SIM_TYP_ARRAY_ERROR;
    L_NUMEND        A2000030.NUM_END%TYPE := 0;
    L_CODRIES       A2000020.COD_RIES%TYPE := 1;
    --Autos x Opciones II-Modificaciones 2019
    --Marzo 2020
    L_TDOCRLNVO    A2000020.VALOR_CAMPO%TYPE;
    L_NDOCRLNVO    A2000020.VALOR_CAMPO%TYPE;
    L_TDOCLOCATNVO A2000020.VALOR_CAMPO%TYPE;
    L_NDOCLOCATNVO A2000020.VALOR_CAMPO%TYPE;
    L_NDOCRLANT    A2000020.VALOR_CAMPO%TYPE;
    L_NDOCLOCATANT A2000020.VALOR_CAMPO%TYPE;
    L_TDOCLOCATANT A2000020.VALOR_CAMPO%TYPE;
    L_TDOCRLANT    A2000020.VALOR_CAMPO%TYPE;
    TYPE TP_REVISA IS RECORD(
      NRODOCUMTO      NUMBER,
      NROTIPODOCUMTO  VARCHAR2(50),
      COD_RIES        A2000020.COD_RIES%TYPE,
      NUM_POL1        A2000030.NUM_POL1%TYPE,
      NUM_POL1_IMPIDE A2000030.NUM_POL1%TYPE,
      ESTAN_COTIZANDO BOOLEAN DEFAULT FALSE);
    RC_REVISA       TP_REVISA;
    L_INCLUSION     VARCHAR2(1) := 'N';
    L_FECHAVIGENDYA DATE; --- bancan3-802  hlc     23092024
    L_CODENDYA      NUMBER(4); --- bancan3-802  hlc     23092024
    L_SUBCODENDYA   NUMBER(4); --- bancan3-802  hlc     23092024
    ---- funciones internas
    FUNCTION LOCAL_TRAE_CAMPO_2000020_X_A(PCODCAMPO  A2000020.COD_CAMPO%TYPE,
                                          PNUMSCUPOL A2000020.NUM_SECU_POL%TYPE,
                                          PCODRIESGO A2000020.COD_RIES%TYPE)
      RETURN A2000020.VALOR_CAMPO%TYPE IS
    BEGIN
      --
      BEGIN
        RETURN FUN_RESCATA_X2000020(PCODCAMPO  => PCODCAMPO,
                                    PNUMSCUPOL => PNUMSCUPOL,
                                    PCODRIESGO => PCODRIESGO);
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            RETURN FUN_RESCATA_A2000020(PCODCAMPO  => PCODCAMPO,
                                        PNUMSCUPOL => PNUMSCUPOL,
                                        PCODRIESGO => PCODRIESGO);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
      END;
      RETURN NULL;
      --
    END LOCAL_TRAE_CAMPO_2000020_X_A;
    --
    FUNCTION LOCAL_TRAE_2000020_A_X_ENDCERO(PCODCAMPO  A2000020.COD_CAMPO%TYPE,
                                            PNUMSCUPOL A2000020.NUM_SECU_POL%TYPE,
                                            PCODRIESGO A2000020.COD_RIES%TYPE)
      RETURN A2000020.VALOR_CAMPO%TYPE IS
      CAMPO_RETORNA A2000020.VALOR_CAMPO%TYPE;
    BEGIN
      --
      IF PNUMSCUPOL IS NULL THEN
        RETURN NULL;
      END IF;
      --
      CAMPO_RETORNA := 0;
      BEGIN
        SELECT VALOR_CAMPO
          INTO CAMPO_RETORNA
          FROM A2000020
         WHERE NUM_SECU_POL = PNUMSCUPOL
           AND COD_CAMPO = PCODCAMPO
           AND COD_RIES = PCODRIESGO
           AND NUM_END = 0;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT VALOR_CAMPO
              INTO CAMPO_RETORNA
              FROM X2000020
             WHERE NUM_SECU_POL = PNUMSCUPOL
               AND COD_CAMPO = PCODCAMPO
               AND COD_RIES = PCODRIESGO;
          EXCEPTION
            WHEN OTHERS THEN
              CAMPO_RETORNA := 0;
          END;
      END;
      RETURN CAMPO_RETORNA;
      --
    END LOCAL_TRAE_2000020_A_X_ENDCERO;
    --todo
  BEGIN
    SIM_PROC_LOG('SIM_PCK_PROCESO_DATOS_EMISION2.PROC_PLACAVIGENTE ' ||
                 'Ip_Placa=' || IP_PLACA || 'IP_NUMSECUPOL=' ||
                 IP_NUMSECUPOL || 'IP_PROCESO.P_PROCESO=' ||
                 IP_PROCESO.P_PROCESO || 'IP_PROCESO.p_subproceso=' ||
                 IP_PROCESO.P_SUBPROCESO || 'IP_NRO_DOCUMTO_ASEG=' ||
                 IP_NRO_DOCUMTO_ASEG || 'IP_TIPP_DOCUMTO_ASEG=' ||
                 IP_TIPP_DOCUMTO_ASEG,
                 NULL);
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_CreaArrayAseg';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    /*Iniciativa factor al 150*/
    L_RESULTADO  := 0;
    L_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    --verifica si es cotizacio.
    RC_REVISA.ESTAN_COTIZANDO := ((IP_PROCESO.P_PROCESO = 241 AND
                                 IP_PROCESO.P_SUBPROCESO = 240) OR
                                 (IP_PROCESO.P_PROCESO = 261 AND
                                 IP_PROCESO.P_SUBPROCESO = 260));
  
    --BANCAN3-709
    IF IP_NUMSECUPOL IS NOT NULL THEN
      --- SE RESCATAN DATOS DE LA POLIZA QUE SE ESTA TRABAJANDO  --- bancan3-802  hlc     23092024
      BEGIN
        SELECT S.FECHA_VIG_END, S.COD_END, S.SUB_COD_END
          INTO L_FECHAVIGENDYA, L_CODENDYA, L_SUBCODENDYA
          FROM X2000030 S
         WHERE S.NUM_SECU_POL = IP_NUMSECUPOL;
      EXCEPTION
        WHEN OTHERS THEN
          L_FECHAVIGENDYA := NULL;
          L_CODENDYA      := NULL;
          L_SUBCODENDYA   := NULL;
          L_INCLUSION     := 'N';
      END;
    END IF;
    ---
    IF IP_PROCESO.P_PROCESO = 293 AND ---- para inclusiones de vehículos se debe validar que no exista en la misma poliza  28062024  HLC
       IP_PROCESO.P_SUBPROCESO = 280 THEN
      --- SI ES ENDOSO NOMINATIVO Y EL ASEGURADO NO CAMBIA NO SE DEBE TOMAR COMO VIGENTE  18092024  HLC BANCAN3-802
      IF L_CODENDYA = 400 AND L_SUBCODENDYA = 10 THEN
        L_INCLUSION := 'N';
      ELSE
        L_INCLUSION := 'S';
      END IF;
    ELSE
      L_INCLUSION := 'N';
    END IF;
    --
    FOR REG_C1 IN C1 LOOP
      --
      IF IP_NUMSECUPOL IS NOT NULL THEN
        --la funcion siempre retorna N si la cotizacion aun no existe y error si Ip_Numsecupol es NULL
        IF NOT (RC_REVISA.ESTAN_COTIZANDO) AND
           SIM_PCK_FUNCION_GEN.FUN_CREDIBILIDAD_150(IP_NUMSECUPOL,
                                                    REG_C1.COD_RIES) = 'S' THEN
          L_CREDIBILI := 1;
          EXIT;
        END IF;
        --
      END IF;
      --
      SELECT COUNT(1)
        INTO V_EXCLUYE_PARAM
        FROM C9999909
       WHERE COD_TAB = 'VALIDA_VIG_AUTOS'
         AND REG_C1.SIM_SUBPRODUCTO = CODIGO;
      IF V_EXCLUYE_PARAM > 0 THEN
        CONTINUE;
      END IF;
      --SI ES LA MISMA POLIZA NO DEBE REVISARSE   BANCAN3-709
      IF REG_C1.NUM_SECU_POL = IP_NUMSECUPOL AND L_INCLUSION = 'N' THEN
        CONTINUE;
      END IF;
      --
      L_FECHAINI  := REG_C1.FECHA_VIG_END;
      L_FECHAFIN  := REG_C1.FECHA_VENC_END;
      L_FECHABAJA := REG_C1.FECHA_BAJA;
      --
      L_NROTIPODOCUMTO := LOCAL_TRAE_CAMPO_2000020_X_A(PCODCAMPO  => 'TIPO_DOC_ASEG',
                                                       PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                                       PCODRIESGO => REG_C1.COD_RIES);
      --SI ES EMISION, PERO HAY UNA POLIZA CON ESA PLACA QUE ESTA VIGENTE Y NO ANULADA, NO DEBE PERMITIRSE
      IF NOT (RC_REVISA.ESTAN_COTIZANDO) AND
         NVL(REG_C1.MCA_PER_ANUL, 'N') = 'N' THEN
        --
        IF NVL(L_FECHABAJA, L_FECHAFIN) > TRUNC(SYSDATE) AND
           IP_NRO_DOCUMTO_ASEG = REG_C1.NRO_DOCUMTO AND
           IP_TIPP_DOCUMTO_ASEG = L_NROTIPODOCUMTO AND
           L_FECHAVIGENDYA < NVL(L_FECHABAJA, L_FECHAFIN) THEN
          --- bancan3-802  hlc     23092024
          L_CANTVIGENTE := L_CANTVIGENTE + 1;
        END IF;
        CONTINUE;
        --
      END IF;
      --SI ES COTIZACION, PERO HAY UNA POLIZA CON ESA PLACA Y MISMO ASEGURADO
      --QUE ESTA VIGENTE Y NO ANULADA, NO DEBE PERMITIRSE
      IF RC_REVISA.ESTAN_COTIZANDO AND NVL(REG_C1.MCA_PER_ANUL, 'N') = 'N' THEN
        --
        IF NVL(L_FECHABAJA, L_FECHAFIN) > TRUNC(SYSDATE) AND
           IP_NRO_DOCUMTO_ASEG = REG_C1.NRO_DOCUMTO AND
           IP_TIPP_DOCUMTO_ASEG = L_NROTIPODOCUMTO AND
           L_FECHAVIGENDYA < NVL(L_FECHABAJA, L_FECHAFIN) THEN
          --- bancan3-802  hlc     23092024
          RC_REVISA.NUM_POL1_IMPIDE := REG_C1.NUM_SECU_POL;
          L_CANTVIGENTE             := L_CANTVIGENTE + 1;
          EXIT;
        END IF;
        CONTINUE;
        --
      END IF;
      --si llego aqui es porque la poliza reg_c1 esta anulada
      --se cargan datos del ultimo endoso
      BEGIN
        SELECT T.FECHA_VIG_END, T.FECHA_VENC_END, T.FEC_ANU_POL
          INTO L_FECHAINI, L_FECHAFIN, L_FECHAANU
          FROM A2000030 T
         WHERE T.NUM_SECU_POL = REG_C1.NUM_SECU_POL
           AND T.NUM_END =
               (SELECT MAX(N.NUM_END)
                  FROM A2000030 N
                 WHERE N.NUM_SECU_POL = T.NUM_SECU_POL);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --BANCAN3-177 AJUSTE POR ANULACIONES DE POLIZAS QUE AUN NO EMPIEZAN VIGENCIA
      IF NOT (RC_REVISA.ESTAN_COTIZANDO) AND L_FECHAINI >= TRUNC(SYSDATE) AND
         L_FECHAFIN >= TRUNC(SYSDATE) THEN
        --
        L_CANTVIGENTE := L_CANTVIGENTE + 1;
        CONTINUE;
        --
      END IF;
      --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
      IF IP_PROCESO.P_SUBPRODUCTO IN (251, 360) AND
         REG_C1.SIM_SUBPRODUCTO IN (251, 360) AND
         L_FECHAINI > ADD_MONTHS(TRUNC(SYSDATE), -3) AND
        --la logica debe aplicarse solo a emision
         (IP_PROCESO.P_PROCESO = 261 AND IP_PROCESO.P_SUBPROCESO = 260) THEN
        --
        L_NRODOCUMTO := IP_NRO_DOCUMTO_ASEG;
        --Autos x Opciones modificaciones 2019
        --Lberbesi
        --Marzo 2020
        --Locatario nuevo
        L_NDOCLOCATNVO := LOCAL_TRAE_2000020_A_X_ENDCERO(PCODCAMPO  => 'NROIDLOCAT',
                                                         PNUMSCUPOL => IP_NUMSECUPOL,
                                                         PCODRIESGO => 1);
        --
        L_TDOCLOCATNVO := LOCAL_TRAE_2000020_A_X_ENDCERO(PCODCAMPO  => 'TIPODOCLOCAT',
                                                         PNUMSCUPOL => IP_NUMSECUPOL,
                                                         PCODRIESGO => 1);
        --Rep. legal nuevo
        L_TDOCRLNVO := LOCAL_TRAE_2000020_A_X_ENDCERO(PCODCAMPO  => 'TIPODOCRL',
                                                      PNUMSCUPOL => IP_NUMSECUPOL,
                                                      PCODRIESGO => 1);
        --
        L_NDOCRLNVO := LOCAL_TRAE_2000020_A_X_ENDCERO(PCODCAMPO  => 'NROIDRL',
                                                      PNUMSCUPOL => IP_NUMSECUPOL,
                                                      PCODRIESGO => 1);
        --Locatario anterior
        BEGIN
          L_NDOCLOCATANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'NROIDLOCAT',
                                                 PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                                 PCODRIESGO => REG_C1.COD_RIES);
        EXCEPTION
          WHEN OTHERS THEN
            L_NDOCLOCATANT := 0;
        END;
        BEGIN
          L_TDOCLOCATANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'TIPODOCLOCAT',
                                                 PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                                 PCODRIESGO => REG_C1.COD_RIES);
        EXCEPTION
          WHEN OTHERS THEN
            L_TDOCLOCATANT := 0;
        END;
        --Rep. legal anterior
        BEGIN
          L_NDOCRLANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'NROIDRL',
                                              PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                              PCODRIESGO => REG_C1.COD_RIES);
        EXCEPTION
          WHEN OTHERS THEN
            L_NDOCRLANT := 0;
        END;
        --
        BEGIN
          L_TDOCRLANT := FUN_RESCATA_A2000020(PCODCAMPO  => 'TIPODOCRL',
                                              PNUMSCUPOL => REG_C1.NUM_SECU_POL,
                                              PCODRIESGO => REG_C1.COD_RIES);
        EXCEPTION
          WHEN OTHERS THEN
            L_TDOCRLANT := 0;
        END;
        --
        IF L_NDOCRLANT = L_NDOCRLNVO AND L_TDOCRLANT = L_TDOCRLNVO THEN
          L_CANTVIGENTE := L_CANTVIGENTE + 1;
        END IF;
      
        IF L_NDOCLOCATANT = L_NDOCLOCATNVO AND
           L_TDOCLOCATANT = L_TDOCLOCATNVO THEN
          L_CANTVIGENTE := L_CANTVIGENTE + 1;
        END IF;
        --
        IF NOT (RC_REVISA.ESTAN_COTIZANDO) AND
           REG_C1.NRO_DOCUMTO = L_NRODOCUMTO THEN
          L_CANTVIGENTE := L_CANTVIGENTE + 1;
        END IF;
        --
        IF (RC_REVISA.ESTAN_COTIZANDO) AND
           REG_C1.NRO_DOCUMTO = L_NRODOCUMTO AND
           IP_TIPP_DOCUMTO_ASEG = L_NROTIPODOCUMTO THEN
          --
          L_CANTVIGENTE             := L_CANTVIGENTE + 1;
          RC_REVISA.NUM_POL1_IMPIDE := REG_C1.NUM_SECU_POL;
          EXIT;
          --
        END IF;
      END IF;
    END LOOP;
    --21/05/2019 lberbesi: Se saca del loop para que no vaya tantas veces al proc_anulareemplaza_renov.
    --11/03/2019 lberbesi: Se valida si aplica anula-reemplaza
    --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
    IF IP_PROCESO.P_SUBPRODUCTO IN (251, 263, 274, 360) AND
       NOT (RC_REVISA.ESTAN_COTIZANDO) AND IP_NUMSECUPOL IS NOT NULL THEN
      --
      PROC_ANULAREEMPLAZA_RENOV(IP_NUMSECUPOL   => IP_NUMSECUPOL,
                                IP_NUMEND       => L_NUMEND,
                                IP_CODRIES      => L_CODRIES,
                                OP_ESANULAREEMP => L_ESANULAREEMP,
                                IP_PROCESO      => IP_PROCESO,
                                OP_RESULTADO    => L_RESULTADO,
                                OP_ARRERRORES   => L_ARRERRORES);
      --
    END IF;
    --
    --07/05/2019 lberbesi: Si es de anula reemplaza no se debe generar error.
    IF L_CREDIBILI > 0 AND NVL(L_ESANULAREEMP, 'N') <> 'S' THEN
      --
      OP_RESULTADO := -1;
      V_STR_ERROR  := 'Esta Cotizacion se debe emitir por el canal tradicional, ' ||
                      ' porque se encuentra vinculado en la compa¿ia';
      --
    ELSIF NOT (RC_REVISA.ESTAN_COTIZANDO) AND L_CANTVIGENTE > 0 THEN
      IF NVL(L_ESANULAREEMP, 'N') <> 'S' THEN
        OP_RESULTADO := -1;
        IF L_RESULTADO = 4 THEN
          V_STR_ERROR := 'No es posible emitir por anula reemplaza, p¿liza con siniestros vigentes';
        ELSE
          V_STR_ERROR := 'Veh¿culo actualmente tiene p¿liza ' ||
                         'vigente con otra clave u otro subproducto No se permite la emisi¿n';
        END IF;
      END IF;
    ELSIF (RC_REVISA.ESTAN_COTIZANDO) AND L_CANTVIGENTE > 0 THEN
      --
      OP_RESULTADO := -1;
      V_STR_ERROR  := 'Ya existe una poliza vigente con misma placa y asegurado num_pol1=' ||
                      RC_REVISA.NUM_POL1_IMPIDE;
      --
    END IF;
    --
    IF OP_RESULTADO = -1 THEN
      L_ERROR := SIM_TYP_ERROR(-20000, V_STR_ERROR, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
    END IF;
    --    Dbms_Output.Put_Line('Cantidad de polizas vigentes:' || l_Vigente);
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      L_ERROR      := SIM_TYP_ERROR(SQLCODE,
                                    'Error en Proc_PlacaVigente' || SQLERRM,
                                    'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
  END PROC_PLACAVIGENTE;

  PROCEDURE PROC_INSPECCIONVIGENTE(IP_PLACA         IN VARCHAR2,
                                   IP_CODMOD        IN A2040100.COD_MOD%TYPE,
                                   IP_CODMARCA      IN A2040100.COD_MARCA%TYPE,
                                   IP_CODUSO        IN A2040100.COD_USO%TYPE,
                                   OP_NROINSPECCION OUT NUMBER,
                                   IP_VALIDACION    IN VARCHAR2,
                                   IP_PROCESO       IN SIM_TYP_PROCESO,
                                   OP_RESULTADO     OUT NUMBER,
                                   OP_ARRERRORES    OUT SIM_TYP_ARRAY_ERROR) IS
    L_SQL VARCHAR2(1000);
    /*Verifica si una placa tiene inspecciones vigentes a la fecha */
  BEGIN
    OP_NROINSPECCION := 0;
    G_SUBPROGRAMA    := G_PROGRAMA || '.ProcInspeccionVigente';
    L_ERROR          := NEW SIM_TYP_ERROR;
    OP_ARRERRORES    := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO     := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    --BRGH Se ajusta query incluyendo marca, modelo y uso para dar solucion
    --al jira BANCAN3-384
    --Se agrega condicional para que en la creacion de la cotizacion no se tenga en cuenta marca, modelo y uso
    BEGIN
      IF IP_PROCESO.P_PROCESO = 241 AND IP_PROCESO.P_SUBPROCESO = 240 THEN
        BEGIN
          -- BRGH se ajusta con la fecha mayor ya que el NRO_INSPECCION no necesariamente es secuencial, tener en cuenta que esta número es del aliado y
          -- cada aliado maneja su númeración lo que hace que las inspecciones se traslapen
          -- ajuste del jira MDSB-622613
        
          /*SELECT NVL(MAX(A.NRO_INSPECCION), 0)
           INTO OP_NROINSPECCION
           FROM SIM_INSPECCION_AUTOS A, C1010791 B
          WHERE A.PLACA = IP_PLACA
            AND A.FECHA > SYSDATE - B.DIAS_INSPECCION
            AND B.COD_RAMO = IP_PROCESO.P_SUBPRODUCTO;*/
        
          SELECT NVL(MAX(A.NRO_INSPECCION), 0)
            INTO OP_NROINSPECCION
            FROM SIM_INSPECCION_AUTOS A, C1010791 B
           WHERE A.PLACA = IP_PLACA
             AND A.FECHA > SYSDATE - B.DIAS_INSPECCION
             AND B.COD_RAMO = IP_PROCESO.P_SUBPRODUCTO
             AND A.FECHA =
                 (SELECT MAX(A2.FECHA)
                    FROM SIM_INSPECCION_AUTOS A2
                   WHERE A2.PLACA = A.PLACA
                     AND A2.FECHA > SYSDATE - B.DIAS_INSPECCION);
        EXCEPTION
          WHEN OTHERS THEN
            OP_NROINSPECCION := 0;
        END;
      ELSE
        BEGIN
          -- POR FAVOR LEER:
          -- Ajuste importante, en el servicio de InspeccionAutosService de SimonWs, solo se envia la placa,
          -- por tal motivo se debe poner el NVL en marca, mod y uso ya que para cualquier proceso diferente
          -- al 241 y 240 desde Simon Ventas se debe validar si existe inspeccion vigente pero por dise?o de servicio solo recibe placa
          -- pero no se puede eliminar esta parte del where, ya que en la regla de tronador para validar el control 605
          -- es importante recibir esos tres datos.
          -- IMPORTANTE: Si usted considera que se debe ajustar, ya que se da?a o perjudica otro proceso, por favor validarlo
          -- contactar a benjamin.galindo@segurosbolivar.com Benjamin Ricardo Galindo Huertas (5 min hablando hara que no inyectemos errores en prd)
        
          -- BRGH se ajusta con la fecha mayor ya que el NRO_INSPECCION no necesariamente es secuencial, tener en cuenta que esta número es del aliado y
          -- cada aliado maneja su númeración lo que hace que las inspecciones se traslapen
          -- ajuste del jira MDSB-622613
        
          SELECT NVL(MAX(A.NRO_INSPECCION), 0)
            INTO OP_NROINSPECCION
            FROM SIM_INSPECCION_AUTOS A, C1010791 B
           WHERE A.PLACA = IP_PLACA
             AND A.COD_MARCA = NVL(IP_CODMARCA, A.COD_MARCA)
             AND A.COD_MOD = NVL(IP_CODMOD, A.COD_MOD)
             AND A.COD_USO = NVL(IP_CODUSO, A.COD_USO)
             AND A.FECHA > SYSDATE - B.DIAS_INSPECCION
             AND B.COD_RAMO = IP_PROCESO.P_SUBPRODUCTO
             AND A.FECHA =
                 (SELECT MAX(A2.FECHA)
                    FROM SIM_INSPECCION_AUTOS A2
                   WHERE A2.PLACA = A.PLACA
                     AND A2.COD_MARCA = NVL(IP_CODMARCA, A2.COD_MARCA)
                     AND A2.COD_MOD = NVL(IP_CODMOD, A2.COD_MOD)
                     AND A2.COD_USO = NVL(IP_CODUSO, A2.COD_USO)
                     AND A2.FECHA > SYSDATE - B.DIAS_INSPECCION);
        EXCEPTION
          WHEN OTHERS THEN
            OP_NROINSPECCION := 0;
        END;
      END IF;
    END;
  
    IF OP_NROINSPECCION = 0 THEN
      OP_RESULTADO := -1;
      L_ERROR      := SIM_TYP_ERROR(-20000,
                                    'Sin inspecciones Vigentes',
                                    'W');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
    ELSE
      --Mcga 2020-01-22 Se comentarean parametros de Marca, Modelo y Uso dado que desde la sobrecarga de la
      --Funcion de SIM_PCK_ACCESO_SERVICIOS no se envian los datos y falla
      -- BRGH 2022-03-22 Se coloca NVL en parametros de Marca, Modelo y Uso, ya que si esxiste una sobrecarga
      -- de funciones se debe manejar de esta manera
      -- 30/07/2022 RW : C?digo revivido debido a un borrado. CTR-Cambios 10476
      BEGIN
        L_SQL := ' SELECT A.NRO_INSPECCION
                   FROM SIM_INSPECCION_AUTOS A
                   WHERE UPPER(A.PLACA) = ''' || IP_PLACA || '''
                   AND A.NRO_INSPECCION = ' ||
                 OP_NROINSPECCION || '
                   AND A.COD_MARCA = NVL(''' || IP_CODMARCA ||
                 ''', A.COD_MARCA)
                   AND A.COD_MOD = NVL(''' || IP_CODMOD ||
                 ''', A.COD_MOD)
                   AND A.COD_USO = NVL(''' || IP_CODUSO ||
                 ''', A.COD_USO)';
      
        IF IP_PROCESO.P_SISTEMA_ORIGEN IS NULL OR
           IP_PROCESO.P_SISTEMA_ORIGEN <> 101 THEN
          L_SQL := L_SQL || ' AND NVL(A.ASEGURABLE_CALC, ''S'') = ''S''';
          L_SQL := L_SQL || ' AND NVL(A.ASEGURABLE, ''S'') = ''S''';
        END IF;
        EXECUTE IMMEDIATE L_SQL
          INTO OP_NROINSPECCION;
      EXCEPTION
        WHEN OTHERS THEN
          OP_NROINSPECCION := 0;
          OP_RESULTADO     := -1;
          L_ERROR          := SIM_TYP_ERROR(-20000,
                                            'Datos del vehiculo no coinciden para validar la inspeccion',
                                            'W');
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      L_ERROR      := SIM_TYP_ERROR(SQLCODE,
                                    'Error en Consultando Inspeccion Vigente' ||
                                    SQLERRM,
                                    'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
  END PROC_INSPECCIONVIGENTE;

  PROCEDURE PROC_EXISTECODIGOFAS(IP_MARCAFSECOLDA IN NUMBER,
                                 IP_DESCMARCA     IN VARCHAR2,
                                 OP_EXISTE        OUT VARCHAR2,
                                 IP_VALIDACION    IN VARCHAR2,
                                 IP_PROCESO       IN SIM_TYP_PROCESO,
                                 OP_RESULTADO     OUT NUMBER,
                                 OP_ARRERRORES    OUT SIM_TYP_ARRAY_ERROR) IS
    L_CANT        NUMBER;
    L_DESCRIPCION VARCHAR2(100);
    L_VARIABLE    VARCHAR2(100);
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.RecuperaDatosSoat ';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := 0;
    OP_EXISTE     := 'N';
    IF IP_MARCAFSECOLDA IS NULL AND IP_DESCMARCA IS NULL THEN
      OP_RESULTADO := -1;
      L_ERROR      := SIM_TYP_ERROR(-20000,
                                    'No registra información de Entrada',
                                    'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      RETURN;
    END IF;
  
    IF NVL(IP_MARCAFSECOLDA, 0) > 0 THEN
      SELECT COUNT(1)
        INTO L_CANT
        FROM A1040400
       WHERE COD_MARCA = IP_MARCAFSECOLDA;
    ELSE
      L_DESCRIPCION := TRIM(IP_DESCMARCA);
      L_VARIABLE    := SUBSTR(L_DESCRIPCION,
                              LENGTH(L_DESCRIPCION) - 3,
                              LENGTH(L_DESCRIPCION) - 1);
      IF SIM_PCK_GENERALES.ESNUMERICO(L_VARIABLE) THEN
        L_DESCRIPCION := SUBSTR(L_DESCRIPCION, 1, LENGTH(L_DESCRIPCION) - 4);
      END IF;
      L_DESCRIPCION := '%' || REPLACE(TRIM(L_DESCRIPCION), ' ', '%') || '%';
    
      --Dbms_Output.Put_Line('*' || l_Descripcion || '*');
      SELECT COUNT(1)
        INTO L_CANT
        FROM A1040400 A
       WHERE A.DESC_MARCA || ' ' || A.MARCA || ' ' || A.LINEA || ' ' ||
             A.TIPO_ESPECIFICO || ' ' || A.TIPO_GENERICO || ' ' ||
             A.COD_MARCA LIKE (L_DESCRIPCION);
    END IF;
    IF L_CANT > 0 THEN
      OP_EXISTE := 'S';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      OP_RESULTADO := -1;
      L_ERROR      := SIM_TYP_ERROR(SQLCODE,
                                    'Error en Consultando Inspeccion Vigente' ||
                                    SQLERRM,
                                    'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
  END PROC_EXISTECODIGOFAS;

  PROCEDURE PROC_VALIDAPROCPOLIZA(IP_NUMSECUPOL IN A2000030.NUM_SECU_POL%TYPE,
                                  OP_EXISTE     OUT VARCHAR2,
                                  IP_VALIDACION IN VARCHAR2,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NUMBER,
                                  OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    L_CANT  SIM_PCK_TIPOS_GENERALES.T_NUM_SECUENCIA;
    L_HORAS NUMBER;
    L_FECHA DATE;
    /*29Ene2016 Proc_ValidaProcPoliza
                Valida si el negocio esta en proceso de expedicion o ya fue expedido
    */
  BEGIN
    L_CANT        := 0;
    OP_EXISTE     := 'N';
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    BEGIN
      SELECT COUNT(1)
        INTO L_CANT
        FROM SIM_EXPEDICION_ENLINEA C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.PROCESO = IP_PROCESO.P_PROCESO;
    END;
    IF L_CANT > 0 THEN
      IF IP_PROCESO.P_PROCESO = 270 THEN
        BEGIN
          SELECT MAX(J.FECHA)
            INTO L_FECHA
            FROM SIM_EXPEDICION_ENLINEA J
           WHERE J.NUM_SECU_POL = IP_NUMSECUPOL
             AND J.PROCESO = IP_PROCESO.P_PROCESO;
        END;
        L_HORAS := TRUNC((SYSDATE - L_FECHA) * 24);
        IF L_HORAS >= 1 THEN
          OP_EXISTE := 'N';
          UPDATE SIM_EXPEDICION_ENLINEA
             SET PROCESO = 299
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND PROCESO = IP_PROCESO.P_PROCESO;
        
          INSERT INTO SIM_EXPEDICION_ENLINEA
            (NUM_SECU_POL, FECHA, PROCESO, USUARIO)
          VALUES
            (IP_NUMSECUPOL,
             SYSDATE,
             IP_PROCESO.P_PROCESO,
             IP_PROCESO.P_COD_USR);
        
          COMMIT;
        ELSE
          OP_EXISTE := 'S';
        END IF;
      END IF;
    ELSE
      INSERT INTO SIM_EXPEDICION_ENLINEA
        (NUM_SECU_POL, FECHA, PROCESO, USUARIO)
      VALUES
        (IP_NUMSECUPOL,
         SYSDATE,
         IP_PROCESO.P_PROCESO,
         IP_PROCESO.P_COD_USR);
      COMMIT;
    END IF;
  END PROC_VALIDAPROCPOLIZA;

  --intasi31 ATGC SALUD 07042016
  PROCEDURE PROC_CREAARRAYASEGSALUD(IP_NUMSECUPOL   IN A2000030.NUM_SECU_POL%TYPE,
                                    OP_ARRAYTERCERO OUT SIM_TYP_ARRAY_TERCEROGEN,
                                    IP_PROCESO      IN SIM_TYP_PROCESO,
                                    OP_RESULTADO    OUT NUMBER,
                                    OP_ARRERRORES   OUT SIM_TYP_ARRAY_ERROR) IS
    /*Crea type de asegurados*/
    CURSOR DV IS
      SELECT DISTINCT A.COD_RIES
        FROM X2000020 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL;
  
    L_CODRIES      NUMBER := 0;
    L_TERCEROGEN   SIM_TYP_TERCEROGEN;
    L_ARRAYTERCERO SIM_TYP_ARRAY_TERCEROGEN;
  BEGIN
    G_SUBPROGRAMA  := G_PROGRAMA || '.Proc_CreaArrayAseg';
    L_ERROR        := NEW SIM_TYP_ERROR;
    OP_ARRERRORES  := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO   := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_TERCEROGEN   := NEW SIM_TYP_TERCEROGEN();
    L_ARRAYTERCERO := NEW SIM_TYP_ARRAY_TERCEROGEN();
  
    --------------------Inicio Datos Variables
    FOR RDV IN DV LOOP
      IF L_CODRIES != RDV.COD_RIES THEN
        L_TERCEROGEN.TIPO_DOCUMENTO   := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_DOCUM',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.NUMERO_DOCUMENTO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_BENE',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.COD_RIES         := RDV.COD_RIES;
        L_TERCEROGEN.ROL              := 2;
        L_TERCEROGEN.NOMBRES          := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('NOM_ASEG',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.APELLIDOS        := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('APE_ASEG',
                                                                                  IP_NUMSECUPOL,
                                                                                  RDV.COD_RIES);
        L_TERCEROGEN.OCUPACION        := SIM_TYP_LOOKUP(SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_OCU',
                                                                                                 IP_NUMSECUPOL,
                                                                                                 RDV.COD_RIES),
                                                        SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('COD_OCU',
                                                                                                 IP_NUMSECUPOL,
                                                                                                 RDV.COD_RIES));
        L_TERCEROGEN.DIRECCION        := SUBSTR(SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('DIRECC_RIES',
                                                                                         IP_NUMSECUPOL,
                                                                                         RDV.COD_RIES),
                                                1,
                                                60);
      
        IF SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('FECHA_NACIMIEN',
                                                    IP_NUMSECUPOL,
                                                    RDV.COD_RIES) IS NOT NULL THEN
          L_TERCEROGEN.FECHA_NACIMIENTO := TO_DATE(SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('FECHA_NACIMIEN',
                                                                                            IP_NUMSECUPOL,
                                                                                            RDV.COD_RIES),
                                                   'DDMMYYYY');
        END IF;
      
        L_TERCEROGEN.SEXO          := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('SEXO',
                                                                               IP_NUMSECUPOL,
                                                                               RDV.COD_RIES);
        L_TERCEROGEN.CIUDAD.CODIGO := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('CPOS_RIES',
                                                                               IP_NUMSECUPOL,
                                                                               RDV.COD_RIES);
        L_ARRAYTERCERO.EXTEND;
        L_ARRAYTERCERO(L_ARRAYTERCERO.COUNT) := L_TERCEROGEN;
      END IF;
    END LOOP;
  
    OP_ARRAYTERCERO := L_ARRAYTERCERO;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END PROC_CREAARRAYASEGSALUD;

  PROCEDURE PROC_UPDEMAIL(IP_NUMSECUPOL IN NUMBER,
                          IP_NUMEND     IN NUMBER,
                          IP_CODRIES    IN NUMBER,
                          IP_VALIDACION IN VARCHAR2,
                          IP_PROCESO    IN SIM_TYP_PROCESO,
                          OP_RESULTADO  OUT NUMBER,
                          OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
  
    T_MODLOC         PKG_API1.T_MODIFICA_MEDIO;
    L_ID             NUMBER;
    L_TDOC           VARCHAR2(2);
    L_NRO_DOCUMENTO  NUMBER;
    L_TIPO_DOCUMENTO VARCHAR2(2);
    L_EMAIL          SIM_PCK_TIPOS_GENERALES.T_VAR_LARGO;
    T_TER            PKG_API_TERCEROS.T_TERCERO;
    L_RESULTADO      NUMBER;
  
  BEGIN
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
  
    IF SIM_PCK_FUNCION_GEN.FUN_MARCA_PE(IP_PROCESO.P_COD_CIA,
                                        IP_PROCESO.P_COD_SECC,
                                        IP_PROCESO.P_COD_PRODUCTO,
                                        IP_PROCESO.P_SUBPRODUCTO,
                                        IP_PROCESO.P_CANAL,
                                        IP_PROCESO.P_INFO5) = 'PE' THEN
      T_TER := NULL;
    
      L_NRO_DOCUMENTO  := NULL;
      L_TIPO_DOCUMENTO := NULL;
      BEGIN
        SELECT D.NRO_DOCUMTO, D.TDOC_TERCERO
          INTO L_NRO_DOCUMENTO, L_TIPO_DOCUMENTO
          FROM X2000030 D
         WHERE D.NUM_SECU_POL = IP_NUMSECUPOL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF NVL(L_TIPO_DOCUMENTO, 'NT') = 'CC' THEN
        T_TER.P_NUMERO_DOCUMENTO := L_NRO_DOCUMENTO;
        T_TER.P_TIPDOC_CODIGO    := L_TIPO_DOCUMENTO;
        PKG_API_TERCEROS.PRC_CONSULTA_TERCERO(T_TER);
      
        T_MODLOC := NULL;
        BEGIN
          SELECT C.TIPO_DOCUMENTO, C.NUMERO_DOCUMENTO, C.EMAIL
            INTO L_TDOC, L_ID, L_EMAIL
            FROM SIM_X_TERCEROS C
           WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
             AND C.NUM_END = IP_NUMEND
             AND C.ROL = 2;
        EXCEPTION
          WHEN OTHERS THEN
            L_RESULTADO := 1;
        END;
        IF L_RESULTADO = 0 THEN
          IF T_TER.P_EMAIL != L_EMAIL THEN
            T_MODLOC.P_NUMERO_DOCUMENTO := L_ID;
            T_MODLOC.P_TIPO_DOCUMENTO   := L_TDOC;
            T_MODLOC.P_TIPO_MEDIO       := 6;
          
            T_MODLOC.P_DESC_MEDIO_COMUNICACION := L_EMAIL;
            T_MODLOC.P_USUARIO_MODIFICACION    := IP_PROCESO.P_COD_USR; -- 'TRON2000D';
            PKG_API1.PRC_MODIFICA_MEDIO(T_MODLOC);
          
            /*
              if t_modloc.p_sqlerr <> 0 then
                         dbms_output.put_line  ('error al modificar telefono2 '||t_modloc.p_sqlerr||' '||t_modloc.p_sqlerrm);
              ELSE
                        dbms_output.put_line  ('resultado  modificar telefono2 '||t_modloc.p_sqlerr||' '||t_modloc.p_sqlerrm);
              end if;
            */
          
          END IF;
        END IF;
      END IF;
    END IF;
  
  END PROC_UPDEMAIL;

  FUNCTION FUN_VLRASEG(IP_NUMSECUPOL IN A2040300.NUM_SECU_POL%TYPE,
                       IP_CODRIES    IN A2040300.COD_RIES%TYPE,
                       IP_TIPO       IN NUMBER) RETURN NUMBER IS
    L_SUMASEG A2040300.SUMA_ASEG%TYPE;
    L_SUMACCE A2040300.SUMA_ACCES%TYPE;
  BEGIN
    L_SUMASEG := 0;
    L_SUMACCE := 0;
    BEGIN
      SELECT B.SUMA_ASEG, B.SUMA_ACCES
        INTO L_SUMASEG, L_SUMACCE
        FROM A2040300 B
       WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
         AND B.COD_RIES = 1
         AND B.NUM_END =
             (SELECT MAX(NUM_END)
                FROM A2040300 D
               WHERE D.NUM_SECU_POL = B.NUM_SECU_POL
                 AND NVL(D.COD_RIES, 0) = NVL(B.COD_RIES, 0));
    
      IF IP_TIPO = 1 THEN
        RETURN(L_SUMASEG);
      ELSE
        RETURN(L_SUMACCE);
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        L_SUMASEG := 0;
        L_SUMACCE := 0;
    END;
    IF IP_TIPO = 1 THEN
      RETURN L_SUMASEG;
    ELSE
      RETURN(L_SUMACCE);
    END IF;
  
  END FUN_VLRASEG;

  --04/03/2019 lberbesi: Procedimiento creado para el manejo de anula-reemplaza en renovaciones de autos
  PROCEDURE PROC_ANULAREEMPLAZA_RENOV(IP_NUMSECUPOL   IN A2000030.NUM_SECU_POL%TYPE,
                                      IP_NUMEND       IN A2000030.NUM_END%TYPE,
                                      IP_CODRIES      IN A2000020.COD_RIES%TYPE,
                                      OP_ESANULAREEMP OUT VARCHAR2,
                                      IP_PROCESO      IN SIM_TYP_PROCESO,
                                      OP_RESULTADO    OUT NUMBER,
                                      OP_ARRERRORES   OUT SIM_TYP_ARRAY_ERROR) IS
    L_NUM_POLIZA    A2000030.NUM_POL1%TYPE;
    L_FECHA_VIG     A2000030.FECHA_VIG_POL%TYPE;
    L_FECHA_VENC    A2000030.FECHA_VENC_POL%TYPE;
    L_CANT_ANUAL    A2000030.CANT_ANUAL%TYPE;
    L_ESONEROSO     A2000020.VALOR_CAMPO%TYPE;
    L_TDOC_BENEF    A2000020.VALOR_CAMPO%TYPE;
    L_NUMDOC_BENEF  A2000020.VALOR_CAMPO%TYPE;
    L_NSP           A2000030.NUM_SECU_POL%TYPE;
    L_RAZ_SOC_BENEF A2000020.VALOR_CAMPO%TYPE;
    L_SUBPROD       A2000020.VALOR_CAMPO%TYPE;
    L_FECHAVIGCOT   A2000030.FECHA_VIG_POL%TYPE;
    L_DESDE         DATE;
    L_HASTA         DATE;
    LX_USO          A2040100.COD_USO%TYPE;
    LA_USO          A2040100.COD_USO%TYPE;
    LA_ALT          A2040100.COD_RAMO_VEH%TYPE;
    L_TEL_BENEF     A2000020.VALOR_CAMPO%TYPE;
    LX_CODASEG      A2000020.VALOR_CAMPO%TYPE;
    LA_CODASEG      A2000020.VALOR_CAMPO%TYPE;
    L_SUBPRODUCTO   A2000020.VALOR_CAMPO%TYPE;
    LX_TDOCASEG     A2000020.VALOR_CAMPO%TYPE;
    LA_TDOCASEG     A2000020.VALOR_CAMPO%TYPE;
    LX_PLACA        A2040100.PAT_VEH%TYPE;
    L_CUMPLE_FECHAS VARCHAR2(1);
    LX_AGENTE       A2000030.COD_PROD%TYPE;
    LA_AGENTE       A2000030.COD_PROD%TYPE;
    L_MSGERR_SINI   VARCHAR2(200);
    L_RES_VAL_SINI  NUMBER;
    --09/05/2019 lberbesi: Se incluye marca oneroso
    L_MCA_ONEROSO A2000020.VALOR_CAMPO%TYPE;
    L_NUMSECUPOL  A2000030.NUM_SECU_POL%TYPE;
    CURSOR C_BUSCA_POLIZAS(IP_NSP IN A2000030.NUM_SECU_POL%TYPE) IS
      SELECT A30.NUM_POL1,
             A30.COD_PROD,
             A30.FECHA_VIG_POL,
             A30.FECHA_VENC_POL,
             A30.CANT_ANUAL,
             A30.NUM_SECU_POL,
             A30.NUM_END
        FROM A2000030 A30
       WHERE A30.NUM_SECU_POL = IP_NSP
         AND A30.RENOVADA_POR IS NULL
         AND CASE
               WHEN A30.MCA_PROVISORIO IS NULL THEN
                'N'
               ELSE
                A30.MCA_PROVISORIO
             END != 'S'
         AND A30.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO
         AND A30.COD_CIA = IP_PROCESO.P_COD_CIA
         AND A30.COD_SECC = IP_PROCESO.P_COD_SECC
         AND A30.NUM_POL1 IS NOT NULL
         AND A30.NUM_END =
             (SELECT MAX(P.NUM_END)
                FROM A2000030 P
               WHERE P.NUM_SECU_POL = A30.NUM_SECU_POL)
         AND A30.PERIODO_FACT = CASE
               WHEN IP_PROCESO.P_SUBPRODUCTO = 274 THEN
                12
               ELSE
                A30.PERIODO_FACT
             END --Anual
         AND CASE
               WHEN A30.MCA_ANU_POL IS NULL THEN
                'N'
               ELSE
                A30.MCA_ANU_POL
             END != 'S'
         AND TO_NUMBER(SUBSTR(A30.NUM_POL1, 12, 2)) > 1
       GROUP BY A30.NUM_POL1,
                A30.COD_PROD,
                A30.FECHA_VIG_POL,
                A30.FECHA_VENC_POL,
                A30.CANT_ANUAL,
                A30.NUM_SECU_POL,
                A30.NUM_END
       ORDER BY A30.FECHA_VIG_POL DESC;
    CURSOR C_BUSCA_PLACA(IP_PLACA IN A2040100.PAT_VEH%TYPE) IS
      SELECT NUM_SECU_POL, COD_USO, COD_RAMO_VEH
        FROM A2040100
       WHERE PAT_VEH = IP_PLACA
         AND FECHA_BAJA IS NULL;
  BEGIN
    OP_RESULTADO    := 0;
    OP_ARRERRORES   := NEW SIM_TYP_ARRAY_ERROR();
    OP_ESANULAREEMP := SIM_PCK_TIPOS_GENERALES.C_NO;
    --1. Recupera información de la cotización
    BEGIN
      SELECT X30.COD_PROD
        INTO LX_AGENTE
        FROM X2000030 X30
       WHERE X30.NUM_SECU_POL = IP_NUMSECUPOL
         AND X30.NUM_END = 0;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        OP_RESULTADO := -1;
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                            'Error obteniendo agente',
                                                            'e');
    END;
    BEGIN
      SELECT AUT.PAT_VEH, AUT.COD_USO
        INTO LX_PLACA, LX_USO
        FROM X2040100 AUT
       WHERE AUT.NUM_SECU_POL = IP_NUMSECUPOL
         AND AUT.COD_RIES = IP_CODRIES
         AND AUT.NUM_END = 0;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        OP_RESULTADO := -1;
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                            'Error obteniendo placa',
                                                            'e');
    END;
  
    BEGIN
      SELECT ASEG.VALOR_CAMPO_EN
        INTO LX_CODASEG
        FROM X2000020 ASEG
       WHERE ASEG.NUM_SECU_POL = IP_NUMSECUPOL
         AND ASEG.COD_RIES = IP_CODRIES
         AND ASEG.COD_CAMPO = 'COD_ASEG';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        OP_RESULTADO := -1;
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                            'Error obteniendo doc asegurado',
                                                            'e');
    END;
    BEGIN
      SELECT ASEG.VALOR_CAMPO_EN
        INTO LX_TDOCASEG
        FROM X2000020 ASEG
       WHERE ASEG.NUM_SECU_POL = IP_NUMSECUPOL
         AND ASEG.COD_RIES = IP_CODRIES
         AND ASEG.COD_CAMPO = 'TIPO_DOC_ASEG';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        OP_RESULTADO := -1;
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                            'Error obteniendo tipo doc asegurado',
                                                            'e');
    END;
  
    FOR I IN C_BUSCA_PLACA(LX_PLACA) LOOP
      L_NUMSECUPOL := I.NUM_SECU_POL;
      --2. Busca pólizas para el mismo producto y subproducto que puedan aplicar anula-reemplaza
      FOR C1 IN C_BUSCA_POLIZAS(L_NUMSECUPOL) LOOP
        BEGIN
          SELECT COD_PROD
            INTO LA_AGENTE
            FROM A2000030
           WHERE NUM_SECU_POL = C1.NUM_SECU_POL
             AND NUM_END = C1.NUM_END;
        EXCEPTION
          WHEN OTHERS THEN
            LA_AGENTE := NULL;
        END;
        BEGIN
          L_SUBPRODUCTO := FUN_RESCATA_A2000020(PCODCAMPO  => 'PRODUCTOS',
                                                PNUMSCUPOL => C1.NUM_SECU_POL,
                                                PCODRIESGO => NULL);
        EXCEPTION
          WHEN OTHERS THEN
            L_SUBPRODUCTO := NULL;
        END;
        BEGIN
          LA_CODASEG := FUN_RESCATA_A2000020(PCODCAMPO  => 'COD_ASEG',
                                             PNUMSCUPOL => C1.NUM_SECU_POL,
                                             PCODRIESGO => IP_CODRIES);
        EXCEPTION
          WHEN OTHERS THEN
            LA_CODASEG := NULL;
        END;
        BEGIN
          LA_TDOCASEG := FUN_RESCATA_A2000020(PCODCAMPO  => 'TIPO_DOC_ASEG',
                                              PNUMSCUPOL => C1.NUM_SECU_POL,
                                              PCODRIESGO => IP_CODRIES);
        EXCEPTION
          WHEN OTHERS THEN
            LA_TDOCASEG := NULL;
        END;
        --01/04/2019 lberbesi: Se incluye validación de siniestros
        VERIFICA_SINIESTROS_AUTOS(P_NUMSECUPOL  => C1.NUM_SECU_POL,
                                  P_CODRIES     => IP_CODRIES,
                                  P_FECHAVIGEND => C1.FECHA_VIG_POL,
                                  P_RESULTADO   => L_RES_VAL_SINI,
                                  P_MENSAJE     => L_MSGERR_SINI);
        IF LX_AGENTE = LA_AGENTE AND
           L_SUBPRODUCTO = IP_PROCESO.P_SUBPRODUCTO AND
           LX_CODASEG = LA_CODASEG AND LX_TDOCASEG = LA_TDOCASEG AND
           L_MSGERR_SINI IS NULL AND NVL(L_RES_VAL_SINI, 0) <> 4 THEN
          L_NUM_POLIZA    := C1.NUM_POL1;
          L_FECHA_VIG     := C1.FECHA_VIG_POL;
          L_FECHA_VENC    := C1.FECHA_VENC_POL;
          L_CANT_ANUAL    := SUBSTR(C1.NUM_POL1, 12, 13); --10/04/2019 lberbesi: Se recupera cant_anual a partir del Número de póliza dado que había pólizas con datos errados en la columna cant_anual
          L_NSP           := C1.NUM_SECU_POL;
          LA_USO          := I.COD_USO;
          LA_ALT          := I.COD_RAMO_VEH;
          OP_ESANULAREEMP := SIM_PCK_TIPOS_GENERALES.C_SI;
          EXIT;
        ELSIF L_MSGERR_SINI IS NOT NULL AND L_RES_VAL_SINI = 4 THEN
          OP_RESULTADO := 4;
          OP_ARRERRORES.EXTEND;
          OP_ARRERRORES(OP_ARRERRORES.COUNT) := SIM_TYP_ERROR(SQLCODE,
                                                              L_MSGERR_SINI,
                                                              'E');
          EXIT;
        END IF;
      END LOOP;
    END LOOP;
  
    --3. Realiza validaciones para confirmar que aplica anula-reemplaza
    IF OP_RESULTADO = 0 AND OP_ESANULAREEMP = SIM_PCK_TIPOS_GENERALES.C_SI THEN
      --08/03/2019 lberbesi: Se incluye manejo de fechas para condicionar si aplica el anula-reemplaza
      BEGIN
        SELECT X30.FECHA_VIG_POL
          INTO L_FECHAVIGCOT
          FROM X2000030 X30
         WHERE X30.NUM_SECU_POL = IP_NUMSECUPOL
           AND X30.COD_CIA = IP_PROCESO.P_COD_CIA
           AND X30.COD_SECC = IP_PROCESO.P_COD_SECC
           AND X30.COD_RAMO = IP_PROCESO.P_COD_PRODUCTO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          L_FECHAVIGCOT := NULL;
      END;
      IF L_FECHAVIGCOT >= L_FECHA_VIG THEN
        L_DESDE := L_FECHA_VIG - 30;
        L_HASTA := L_FECHA_VIG + 30;
      ELSIF L_FECHAVIGCOT < L_FECHA_VIG THEN
        L_DESDE := L_FECHA_VIG - 60;
        L_HASTA := L_FECHA_VIG + 60;
      END IF;
      IF L_FECHAVIGCOT NOT BETWEEN L_DESDE AND L_HASTA THEN
        L_CUMPLE_FECHAS := SIM_PCK_TIPOS_GENERALES.C_NO;
      ELSE
        L_CUMPLE_FECHAS := SIM_PCK_TIPOS_GENERALES.C_SI;
      END IF;
    
      --11/03/2019 lberbesi: Sólo aplica anula-reemplaza para uso 31 y alternativa 17
      IF L_CUMPLE_FECHAS = SIM_PCK_TIPOS_GENERALES.C_SI THEN
        IF LX_USO != 31 OR LA_USO != 31 OR LA_ALT != 17 THEN
          OP_ESANULAREEMP := SIM_PCK_TIPOS_GENERALES.C_NO;
        END IF;
      ELSE
        OP_ESANULAREEMP := SIM_PCK_TIPOS_GENERALES.C_NO;
      END IF;
    END IF;
  
    --4. Si aplica anula-reemplaza, actualiza datos en la nueva póliza
    IF OP_ESANULAREEMP = SIM_PCK_TIPOS_GENERALES.C_SI AND
       IP_PROCESO.P_PROCESO = 270 AND IP_PROCESO.P_SUBPROCESO = 260 THEN
      ---Actualiza datos fijos
      UPDATE X2000030 POL
         SET POL.NUM_POL_ANT    = L_NUM_POLIZA,
             POL.FECHA_VIG_POL  = L_FECHA_VIG,
             POL.FECHA_VENC_POL = L_FECHA_VENC,
             POL.CANT_ANUAL     = L_CANT_ANUAL
       WHERE POL.NUM_SECU_POL = IP_NUMSECUPOL;
    
      --Recupera datos variables
      BEGIN
        L_ESONEROSO := FUN_RESCATA_A2000020(PCODCAMPO  => 'BENEF_ONEROSO',
                                            PNUMSCUPOL => L_NSP,
                                            PCODRIESGO => IP_CODRIES);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      BEGIN
        L_TDOC_BENEF := FUN_RESCATA_A2000020(PCODCAMPO  => 'TIPO_DOC_BENEF',
                                             PNUMSCUPOL => L_NSP,
                                             PCODRIESGO => IP_CODRIES);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      BEGIN
        L_NUMDOC_BENEF := FUN_RESCATA_A2000020(PCODCAMPO  => 'BENEFICIARIO',
                                               PNUMSCUPOL => L_NSP,
                                               PCODRIESGO => IP_CODRIES);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      BEGIN
        L_RAZ_SOC_BENEF := FUN_RESCATA_A2000020(PCODCAMPO  => 'RAZ_SOC_BENEF',
                                                PNUMSCUPOL => L_NSP,
                                                PCODRIESGO => IP_CODRIES);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      BEGIN
        L_TEL_BENEF := FUN_RESCATA_A2000020(PCODCAMPO  => 'TEL_BENEF',
                                            PNUMSCUPOL => L_NSP,
                                            PCODRIESGO => IP_CODRIES);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --09/05/2019 lberbesi: Se recupera beneficiario oneroso de la póliza a reemplazar
      BEGIN
        L_MCA_ONEROSO := FUN_RESCATA_A2000020(PCODCAMPO  => 'BENEF_ONEROSO',
                                              PNUMSCUPOL => L_NSP,
                                              PCODRIESGO => IP_CODRIES);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --Actualiza datos variables
      PROC_ACTUALIZA_DV(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                        IP_COD_RIES     => IP_CODRIES,
                        IP_COD_CAMPO    => 'TIPO_DOC_BENEF',
                        IP_VALOR_CAMPO  => L_TDOC_BENEF);
      PROC_ACTUALIZA_DV(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                        IP_COD_RIES     => IP_CODRIES,
                        IP_COD_CAMPO    => 'BENEFICIARIO',
                        IP_VALOR_CAMPO  => L_NUMDOC_BENEF);
      PROC_ACTUALIZA_DV(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                        IP_COD_RIES     => IP_CODRIES,
                        IP_COD_CAMPO    => 'RAZ_SOC_BENEF',
                        IP_VALOR_CAMPO  => L_RAZ_SOC_BENEF);
      PROC_ACTUALIZA_DV(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                        IP_COD_RIES     => IP_CODRIES,
                        IP_COD_CAMPO    => 'TEL_BENEF',
                        IP_VALOR_CAMPO  => L_TEL_BENEF);
      --09/05/2019 lberbesi: Se actualiza beneficiario_oneroso para la nueva póliza
      PROC_ACTUALIZA_DV(IP_NUM_SECU_POL => IP_NUMSECUPOL,
                        IP_COD_RIES     => IP_CODRIES,
                        IP_COD_CAMPO    => 'BENEF_ONEROSO',
                        IP_VALOR_CAMPO  => L_MCA_ONEROSO);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      PRC999_AUTOS_CLTVAS_GRABALOG('ANULAREEMPLAZA12',
                                   'EN EXCEPCION ' || SQLERRM);
  END PROC_ANULAREEMPLAZA_RENOV;

  FUNCTION FUN_ES_ANULAREEMPLAZA(IP_NUMSECUPOL IN A2000030.NUM_SECU_POL%TYPE,
                                 IP_NUMEND     IN A2000030.NUM_END%TYPE,
                                 IP_CODRIES    IN A2000020.COD_RIES%TYPE,
                                 IP_PROCESO    IN SIM_TYP_PROCESO)
    RETURN VARCHAR2 IS
    L_ESANULAREEMP VARCHAR2(1);
    L_RESULTADO    NUMBER;
    L_ARRERRORES   SIM_TYP_ARRAY_ERROR;
  BEGIN
    PROC_ANULAREEMPLAZA_RENOV(IP_NUMSECUPOL   => IP_NUMSECUPOL,
                              IP_NUMEND       => IP_NUMEND,
                              IP_CODRIES      => IP_CODRIES,
                              OP_ESANULAREEMP => L_ESANULAREEMP,
                              IP_PROCESO      => IP_PROCESO,
                              OP_RESULTADO    => L_RESULTADO,
                              OP_ARRERRORES   => L_ARRERRORES);
    RETURN L_ESANULAREEMP;
  END FUN_ES_ANULAREEMPLAZA;

  PROCEDURE PROC_ACTUALIZA_DV(IP_NUM_SECU_POL IN A2000020.NUM_SECU_POL%TYPE,
                              IP_COD_RIES     IN A2000020.COD_RIES%TYPE,
                              IP_COD_CAMPO    IN A2000020.COD_CAMPO%TYPE,
                              IP_VALOR_CAMPO  IN A2000020.VALOR_CAMPO%TYPE) IS
    L_EXISTE  VARCHAR2(1);
    L_DATOS_V G2000020%ROWTYPE;
    CURSOR C_DATOS_DV IS
      SELECT *
        FROM G2000020
       WHERE COD_RAMO = 250
         AND COD_CAMPO = IP_COD_CAMPO;
  BEGIN
    L_EXISTE := SIM_PCK_TIPOS_GENERALES.C_SI;
    BEGIN
      SELECT SIM_PCK_TIPOS_GENERALES.C_SI
        INTO L_EXISTE
        FROM X2000020
       WHERE NUM_SECU_POL = IP_NUM_SECU_POL
         AND COD_CAMPO = IP_COD_CAMPO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        L_EXISTE := SIM_PCK_TIPOS_GENERALES.C_NO;
    END;
    IF L_EXISTE = SIM_PCK_TIPOS_GENERALES.C_SI THEN
      UPDATE X2000020 X20
         SET X20.VALOR_CAMPO_EN = IP_VALOR_CAMPO,
             X20.VALOR_CAMPO    = IP_VALOR_CAMPO
       WHERE X20.NUM_SECU_POL = IP_NUM_SECU_POL
         AND X20.COD_CAMPO = IP_COD_CAMPO
         AND NVL(X20.COD_RIES, 0) = NVL(IP_COD_RIES, 0)
         AND NVL(X20.MCA_BAJA_RIES, 'N') <> 'S';
    ELSE
      OPEN C_DATOS_DV;
      FETCH C_DATOS_DV
        INTO L_DATOS_V;
      CLOSE C_DATOS_DV;
    
      INSERT INTO X2000020
        (NUM_SECU_POL,
         COD_RIES,
         COD_CAMPO,
         NUM_SECU,
         COD_NIVEL,
         MCA_PPTO,
         TXT_TITULO,
         LONG_CAMPO,
         TIPO_CAMPO,
         COD_REG_VAL1,
         COD_REG_VAL2,
         VALOR_CAMPO,
         VALOR_CAMPO_EN,
         MCA_HAB_MOD,
         ACEPTA_NULL,
         OBLIGATORIO,
         INCLUYE,
         INCLUYE_ANT,
         MCA_BAJA_RIES,
         MCA_VISIBLE,
         MCA_TIPO_UTIL,
         TABLA_VAL,
         PGM_HELP,
         LISTA_VALORES,
         REG_PRE_FIELD,
         TEXTO_ERROR,
         VALOR_DEFECTO,
         COD_COB,
         COD_AGRAVANTE,
         TXT_HELP,
         CLAUSULAS,
         COD_LISTA,
         TAB_VAL_DEF_CAMPO,
         TABLA_VAL_DEFEC,
         TABLA_VALORES,
         CLAVE_COBERT,
         MCA_LISTA,
         HAY_VALIDACION,
         MCA_VALIDA_CIA,
         CLAVE_TARIFICA)
      VALUES
        (IP_NUM_SECU_POL,
         IP_COD_RIES,
         L_DATOS_V.COD_CAMPO,
         NULL,
         L_DATOS_V.COD_NIVEL,
         L_DATOS_V.MCA_PPTO,
         L_DATOS_V.MCA_BAJA,
         NULL,
         NULL,
         NULL,
         NULL,
         IP_VALOR_CAMPO,
         IP_VALOR_CAMPO,
         NULL,
         L_DATOS_V.ACEPTA_NULL,
         L_DATOS_V.OBLIGATORIO,
         NULL,
         NULL,
         NULL,
         L_DATOS_V.MCA_VISIBLE,
         NULL,
         L_DATOS_V.TABLA_VAL,
         L_DATOS_V.PGM_HELP,
         L_DATOS_V.LISTA_VALORES,
         L_DATOS_V.REG_PRE_FIELD,
         L_DATOS_V.TEXTO_ERROR,
         L_DATOS_V.VALOR_DEFECTO,
         L_DATOS_V.COD_COB,
         L_DATOS_V.COD_AGRAVANTE,
         L_DATOS_V.TXT_HELP,
         L_DATOS_V.CLAUSULAS,
         L_DATOS_V.COD_LISTA,
         L_DATOS_V.TAB_VAL_DEF_CAMPO,
         L_DATOS_V.TABLA_VAL_DEFEC,
         L_DATOS_V.TABLA_VALORES,
         L_DATOS_V.CLAVE_COBERT,
         L_DATOS_V.MCA_LISTA,
         NULL,
         L_DATOS_V.MCA_VALIDA_CIA,
         NULL);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END PROC_ACTUALIZA_DV;

  PROCEDURE PROC_UPDATETYPEDEXAPI(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                  OP_POLIZA     OUT SIM_TYP_POLIZAGEN,
                                  IP_NUMSECUPOL IN NUMBER,
                                  IP_NUMEND     IN NUMBER,
                                  IP_PROCESO    IN SIM_TYP_PROCESO,
                                  OP_RESULTADO  OUT NUMBER,
                                  OP_ARRERRORES OUT SIM_TYP_ARRAY_ERROR) IS
    L_CODRIESAPI NUMBER;
    CURSOR RIESGOAPI IS
      SELECT DISTINCT A.COD_RIES CODRIES
        FROM X2000020 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND (A.VALOR_CAMPO IS NOT NULL OR A.VALOR_CAMPO_EN IS NOT NULL)
         AND NVL(COD_RIES, 0) > 0
       ORDER BY COD_RIES;
    CURSOR DV IS
      SELECT A.COD_RIES,
             A.COD_CAMPO,
             A.VALOR_CAMPO,
             A.VALOR_CAMPO_EN,
             A.COD_NIVEL
        FROM X2000020 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND (A.VALOR_CAMPO IS NOT NULL OR A.VALOR_CAMPO_EN IS NOT NULL)
         AND NVL(A.COD_RIES, 0) = L_CODRIESAPI
       ORDER BY A.COD_RIES, A.COD_NIVEL, A.COD_CAMPO;
  
    CURSOR COB IS
      SELECT A.COD_RIES,
             A.COD_COB,
             A.TXT_COB,
             A.END_SUMA_ASEG,
             A.END_PRIMA_COB,
             A.END_TASA_COB,
             A.END_TASA_TOTAL,
             A.PORC_PPAGO,
             A.IND_AJUSTE,
             A.PORC_REBAJA,
             A.TASA_AGR,
             A.MCA_GRATUITA,
             A.NUM_SECU
        FROM X2000040 A
       WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
         AND (A.END_PRIMA_COB != 0 OR A.MCA_PRIMA_INF = 'S' OR
             A.MCA_GRATUITA = 'S' OR
             (A.MCA_TIPO_COB = '1' AND A.COD_SELECC = 'S'))
         AND A.COD_RIES = L_CODRIESAPI
       ORDER BY A.COD_RIES, A.NUM_SECU, A.COD_COB ASC;
  
    CURSOR PRIMAXRIE IS
      SELECT C.COD_RIES, SUM(C.END_PRIMA_COB) PRIMARIES
        FROM X2000040 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.COD_RIES = L_CODRIESAPI
       GROUP BY C.COD_RIES;
  
    CURSOR PRIMA IS
      SELECT B.IMP_PRIMA_END,
             B.IMP_DER_EMI_EN,
             B.IMP_IMPUESTO_E,
             B.PORC_BONIF_EN,
             B.IMP_BONIF_EN,
             B.PREMIO_END,
             B.SUMA_ASEG,
             B.PRIMA_ANU
        FROM X2000160 B
       WHERE B.NUM_SECU_POL = IP_NUMSECUPOL;
  
    CURSOR RIES IS
      SELECT DISTINCT C.COD_RIES
        FROM X2000020 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND NVL(C.COD_RIES, 0) > 0;
  
    L_ENCONTRO       SIM_PCK_TIPOS_GENERALES.T_CARACTER := 'N';
    L_ARRCOB         SIM_TYP_ARRAY_COBPOLIZASGEN;
    L_COBERTURA      SIM_TYP_COBERTURAPOLIZAGEN;
    L_DATOSVARIABLES SIM_TYP_DATOS_VARIABLESGEN;
    L_PRIMA          SIM_TYP_PRIMA;
    L_DATOSRIESGOS   SIM_TYP_RIESGOGEN;
    L_DATOSRIESGO    SIM_TYP_DATOSRIESGO;
    L_POLIZA         SIM_TYP_POLIZAGEN;
    L_CODCOB         NUMBER;
    L_TITULO         VARCHAR2(60);
    L_DESC           VARCHAR2(60);
    L_NOMBRECOB      VARCHAR2(120);
    L_PREMIOA        NUMBER;
    L_PREMIOX        NUMBER;
    L_EXISTE         VARCHAR2(1) := 'S';
    L_CANTIDAD       NUMBER;
    L_APLICAPREF     VARCHAR2(1) := 'N';
    L_ENTRACOB       VARCHAR2(1) := 'S';
    -- 17112016 sgpinto: Integración. Adición de variable para almacenar código de riesgo.
    L_CODRIES              NUMBER;
    L_CONTAH               NUMBER := 0;
    L_NSPAH                C2999300.NUM_SECU_POL_ANEXO%TYPE;
    L_NUMCONSEC            C2990020.CONSECUTIVO%TYPE;
    L_VALIDACION           VARCHAR2(1) := 'S';
    L_DATOSVARPOL          SIM_TYP_DATOS_VARIABLESGEN;
    L_ARRAYDATOSRIESGOS    SIM_TYP_ARRAY_RIESGOSGEN;
    L_ARRAYDATOSCOBERTURAS SIM_TYP_ARRAY_COBPOLIZASGEN;
    L_ARRAYDATOSVARIABLES  SIM_TYP_ARRAY_DV_GEN;
    L_ARRAYNOMINAS         SIM_TYP_ARRAY_DATOS_ADIC;
    L_ARRAYRECARGODCTO     SIM_TYP_ARRAY_RECDCTO;
  BEGIN
    G_SUBPROGRAMA := G_PROGRAMA || '.Proc_UpdateTypedeX';
    L_ERROR       := NEW SIM_TYP_ERROR;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    OP_RESULTADO  := SIM_PCK_TIPOS_GENERALES.C_CERO;
    L_POLIZA      := NEW SIM_TYP_POLIZAGEN;
  
    L_POLIZA := IP_POLIZA;
    --Valida emision de Anexo Hogar para que no se haga liquidación-->22/08/2017(Juan Gonzalez)
    IF IP_PROCESO.P_COD_PRODUCTO = 121 AND
       IP_PROCESO.P_PROCESO IN (241, 261, 270) THEN
      OP_POLIZA := IP_POLIZA;
      RETURN;
    END IF;
  
    BEGIN
      SELECT COD_PROD, NUM_POL_COTIZ
        INTO L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO,
             L_POLIZA.DATOSFIJOS.NUM_POL_COTIZ
        FROM A2000030
       WHERE NUM_SECU_POL = IP_NUMSECUPOL
         AND NUM_END = IP_NUMEND;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT COD_PROD
            INTO L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO
            FROM X2000030
           WHERE NUM_SECU_POL = IP_NUMSECUPOL
             AND NUM_END = IP_NUMEND;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      BEGIN
        SELECT A.PREMIO_END
          INTO L_PREMIOA
          FROM A2000160 A
         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
           AND A.NUM_END = IP_NUMEND
           AND A.TIPO_REG = 'T';
      EXCEPTION
        WHEN OTHERS THEN
          L_EXISTE := 'N';
      END;
    
      IF L_EXISTE = 'S' THEN
        BEGIN
          SELECT B.PREMIO_END
            INTO L_PREMIOX
            FROM X2000160 B
           WHERE B.NUM_SECU_POL = IP_NUMSECUPOL
             AND B.TIPO_REG = 'T';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        IF L_PREMIOA != L_PREMIOX THEN
          BEGIN
            L_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'N';
          END;
        ELSE
          BEGIN
            L_POLIZA.DATOSFIJOS.MCA_TERM_OK := 'S';
          END;
        END IF;
      END IF;
    END;
  
    BEGIN
      SELECT C.COD_PROD, C.COD_MON
        INTO L_POLIZA.DATOSFIJOS.COD_PROD.CODIGO,
             L_POLIZA.DATOSFIJOS.COD_MON.CODIGO
        FROM X2000030 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.NUM_END = IP_NUMEND;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --------------------Inicio Datos Variables
    IF L_POLIZA.DATOSRIESGOS.COUNT > 0 THEN
      L_ARRAYDATOSRIESGOS := NEW SIM_TYP_ARRAY_RIESGOSGEN();
      FOR R IN RIESGOAPI LOOP
        L_CODRIESAPI           := R.CODRIES;
        L_DATOSRIESGOS         := NEW SIM_TYP_RIESGOGEN;
        L_ARRAYDATOSVARIABLES  := NEW SIM_TYP_ARRAY_DV_GEN();
        L_ARRAYDATOSCOBERTURAS := NEW SIM_TYP_ARRAY_COBPOLIZASGEN();
        FOR RDV IN DV LOOP
          L_DATOSRIESGO    := NEW SIM_TYP_DATOSRIESGO;
          L_DATOSVARIABLES := NEW
                              SIM_TYP_DATOS_VARIABLESGEN(NUM_SECU_POL => IP_NUMSECUPOL,
                                                         COD_RIES     => RDV.COD_RIES,
                                                         NUM_END      => IP_NUMEND,
                                                         COD_CAMPO    => RDV.COD_CAMPO,
                                                         COD_NIVEL    => RDV.COD_NIVEL,
                                                         COD_COB      => L_CODCOB,
                                                         TITULO       => L_TITULO,
                                                         VALOR_CAMPO  => RDV.VALOR_CAMPO_EN,
                                                         DESCRIPCION  => L_DESC);
          L_ARRAYDATOSVARIABLES.EXTEND;
          L_ARRAYDATOSVARIABLES(L_ARRAYDATOSVARIABLES.COUNT) := L_DATOSVARIABLES;
        END LOOP;
        --  Coberturas
      
        FOR RCOB IN COB LOOP
          L_COBERTURA := NEW SIM_TYP_COBERTURAPOLIZAGEN;
          L_NOMBRECOB := NVL(SIM_PCK_FUNCION_GEN.COBERTURAS(L_POLIZA.DATOSFIJOS.COD_CIA.CODIGO,
                                                            L_POLIZA.DATOSFIJOS.COD_RAMO.CODIGO,
                                                            RCOB.COD_COB),
                             'Sin Informacion');
          L_COBERTURA := NEW
                         SIM_TYP_COBERTURAPOLIZAGEN(NUM_SECU_POL         => IP_NUMSECUPOL,
                                                    NUM_END              => IP_NUMEND,
                                                    COD_RIES             => RCOB.COD_RIES,
                                                    COD_COB              => SIM_TYP_LOOKUP(RCOB.COD_COB,
                                                                                           L_NOMBRECOB),
                                                    SUMA_ASEG            => RCOB.END_SUMA_ASEG,
                                                    TASA_COB             => RCOB.END_TASA_COB,
                                                    TASA_TOTAL           => RCOB.END_TASA_TOTAL,
                                                    PORC_PPAGO           => RCOB.PORC_PPAGO,
                                                    IND_AJUSTE           => RCOB.IND_AJUSTE,
                                                    PRIMA_COB            => RCOB.END_PRIMA_COB,
                                                    PORC_REBAJA          => RCOB.PORC_REBAJA,
                                                    TASA_AGR             => RCOB.TASA_AGR,
                                                    MCA_GRATUITA         => RCOB.MCA_GRATUITA,
                                                    NUM_SECU             => RCOB.NUM_SECU,
                                                    TIPO_REG             => '',
                                                    COD_CIACOA           => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    VAL_ASEGURABLE       => '',
                                                    PRIMA_ANU            => '',
                                                    COD_AGRUP_CONT       => '',
                                                    MCA_BAJA_COB         => '',
                                                    FECHA_INCLUSION      => '',
                                                    FECHA_EXCLUSION      => '',
                                                    COD_PROV             => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    MCA_VIGENTE          => '',
                                                    COD_COB_INF          => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    DESCUENT_PRIMA       => '',
                                                    MCA_PRIMA_INF        => '',
                                                    MCA_TASA_INF         => '',
                                                    MCA_TIPO_COB         => SIM_TYP_LOOKUP('',
                                                                                           ''),
                                                    NOMINA               => '',
                                                    TIPO_FRANQ           => '',
                                                    PORC_FRANQ           => '',
                                                    IMP_FRANQ            => '',
                                                    MIN_FRANQ            => '',
                                                    MAX_FRANQ            => '',
                                                    MCA_AHORRO           => '',
                                                    MCA_VALOR_ABLE       => '',
                                                    MCA_VAL_SINI         => '',
                                                    FECHA_VIG_FRANQ      => '',
                                                    MCA_REASEGURO        => '',
                                                    COD_SECC_REAS        => '',
                                                    NUM_BLOQUE_REAS      => '',
                                                    REGLA_CAP_REAS       => '',
                                                    CAPITAL_REAS         => '',
                                                    PRIMA_REAS           => '',
                                                    CAPITAL_CALCULO_REAS => '',
                                                    MCA_CAPITAL          => '',
                                                    CAPITAL_UNIDAD       => '',
                                                    COD_GRUPO            => '',
                                                    FECHA_ORI_VIDA       => '',
                                                    PRIMA_REAS_ORI       => '',
                                                    END_PRIMA_REAS_ORI   => '',
                                                    SIM_FECHA_INCLUSION  => '',
                                                    SIM_FECHA_EXCLUSION  => '',
                                                    SIM_MCA_SUMA_INF     => '',
                                                    SIM_FECHA_VIG_END    => '',
                                                    SIM_FECHA_VENC_END   => '',
                                                    SIM_COEFCOB          => '');
          L_ARRAYDATOSCOBERTURAS.EXTEND;
          L_ARRAYDATOSCOBERTURAS(L_ARRAYDATOSCOBERTURAS.COUNT) := L_COBERTURA;
        END LOOP;
        -- Datos Basicos del Riesgo
        FOR P IN PRIMAXRIE LOOP
          L_DATOSRIESGO.NUM_SECU_POL := IP_NUMSECUPOL;
          L_DATOSRIESGO.NUM_END      := IP_NUMEND;
          L_DATOSRIESGO.COD_RIES     := P.COD_RIES;
          L_DATOSRIESGO.IMP_PRIMA    := P.PRIMARIES;
        END LOOP;
        -- Datos Riesgo
      
        L_DATOSRIESGOS.DATOSRIESGO     := L_DATOSRIESGO;
        L_DATOSRIESGOS.DATOSCOBERTURAS := L_ARRAYDATOSCOBERTURAS;
        L_DATOSRIESGOS.DATOSVARIABLES  := L_ARRAYDATOSVARIABLES;
        L_ARRAYDATOSRIESGOS.EXTEND;
        L_ARRAYDATOSRIESGOS(L_ARRAYDATOSRIESGOS.COUNT) := L_DATOSRIESGOS;
      END LOOP;
      L_POLIZA.DATOSRIESGOS := L_ARRAYDATOSRIESGOS;
    END IF;
  
    FOR RPRIMA IN PRIMA LOOP
      L_PRIMA := NEW SIM_TYP_PRIMA(NUM_SECU_POL => IP_NUMSECUPOL,
                                   NUM_END      => IP_NUMEND,
                                   IMP_PRIMA    => RPRIMA.IMP_PRIMA_END,
                                   IMP_DER_EMI  => RPRIMA.IMP_DER_EMI_EN,
                                   IMP_IMPUESTO => RPRIMA.IMP_IMPUESTO_E,
                                   PORC_BONIF   => RPRIMA.PORC_BONIF_EN,
                                   IMP_BONIF    => RPRIMA.IMP_BONIF_EN,
                                   PREMIO       => RPRIMA.PREMIO_END,
                                   SUMA_ASEG    => RPRIMA.SUMA_ASEG,
                                   PRIMA_ANU    => RPRIMA.PRIMA_ANU);
    
      L_POLIZA.PRIMA := L_PRIMA;
    END LOOP;
    L_CANTIDAD := 0;
  
    BEGIN
      SELECT COUNT(1)
        INTO L_CANTIDAD
        FROM X2000220 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.COD_ERROR != 924 --no se tiene en cuenta por se un control de reaseguros que se dispara por error
         AND C.NUM_ORDEN = IP_NUMEND
         AND C.COD_RECHAZO > 1;
    END;
  
    IF L_CANTIDAD = 0 THEN
      BEGIN
        SELECT COUNT(1)
          INTO L_CANTIDAD
          FROM A2000220 C
         WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
           AND C.NUM_ORDEN = IP_NUMEND
           AND C.COD_RECHAZO > 1;
      END;
    END IF;
  
    IF L_CANTIDAD > 0 THEN
      L_POLIZA.DATOSFIJOS.MCA_PROVISORIO := 'S';
    ELSE
      L_POLIZA.DATOSFIJOS.MCA_PROVISORIO := 'N';
    END IF;
    L_POLIZA.DATOSFIJOS.COD_MON := SIM_TYP_LOOKUP('1', '1');
  
    OP_POLIZA := L_POLIZA;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR := SIM_TYP_ERROR(SQLCODE, SQLERRM, 'E');
      OP_ARRERRORES.EXTEND;
      OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      OP_RESULTADO := -1;
  END;
  --Autos x Opciones II- Modificaciones
  --Marzo 2020
  --lberbesi: Se crea procedimiento para validar chasis (wrike 37778)
  PROCEDURE PROC_VALIDA_CHASIS(IP_TDOC_ASEG   IN A2000020.VALOR_CAMPO%TYPE,
                               IP_NUMDOC_ASEG IN A2000020.VALOR_CAMPO%TYPE,
                               IP_CHASIS      IN A2040100.CHASIS_VEH%TYPE,
                               IP_NUMSECUPOL  IN A2040100.NUM_SECU_POL%TYPE,
                               IP_PROCESO     IN SIM_TYP_PROCESO,
                               OP_RESULTADO   OUT NUMBER,
                               OP_ARRERRORES  OUT SIM_TYP_ARRAY_ERROR) IS
    L_CANTVIGENTE NUMBER := 0;
    L_NRODOCUMTO  NUMBER;
    L_MARCAANUPOL VARCHAR2(1) := 'N';
    L_FECHAINI    DATE;
    L_FECHAFIN    DATE;
    L_FECHABAJA   DATE;
    L_FECHAANU    DATE;
    L_CREDIBILI   NUMBER := 0;
    --11/03/2019 lberbesi: Se incluye para identificar si aplica anula-reemplaza
    L_ESANULAREEMP VARCHAR2(1) := 'N';
    L_RESULTADO    NUMBER;
    L_ARRERRORES   SIM_TYP_ARRAY_ERROR;
    L_NUMEND       A2000030.NUM_END%TYPE := 0;
    L_CODRIES      A2000020.COD_RIES%TYPE := 1;
    L_ERROR        SIM_TYP_ERROR;
    CURSOR C1 IS
      SELECT A.NUM_SECU_POL,
             A.COD_RIES,
             A.FECHA_BAJA,
             C.FECHA_VIG_END,
             C.FECHA_VENC_END,
             A.NUM_END,
             C.NUM_POL_COTIZ,
             C.NUM_POL1,
             C.MCA_PER_ANUL,
             C.MCA_ANU_POL,
             D.VALOR_CAMPO     NRO_DOCUMTO, --id asegurado
             C.SIM_SUBPRODUCTO,
             C.COD_PROD        AGENTE
        FROM A2040100 A, A2000030 C, A2000020 D
       WHERE A.CHASIS_VEH = IP_CHASIS
         AND A.NUM_END = (SELECT MAX(B.NUM_END)
                            FROM A2040100 B
                           WHERE B.NUM_SECU_POL = A.NUM_SECU_POL
                             AND B.COD_RIES = A.COD_RIES)
         AND A.NUM_SECU_POL = C.NUM_SECU_POL
         AND C.NUM_SECU_POL = D.NUM_SECU_POL
         AND D.COD_CAMPO = 'COD_ASEG'
         AND D.MCA_VIGENTE = 'S'
         AND D.COD_RIES = A.COD_RIES
         AND A.NUM_END = C.NUM_END
         AND C.NUM_POL1 IS NOT NULL
       ORDER BY C.FECHA_VIG_POL DESC;
    /*Cursor c_busca_chasis(chasis In a2040100.chasis_veh%Type) Is
        Select num_secu_pol
              ,cod_ries
          From a2040100 a
         Where a.chasis_veh = chasis
           And a.fecha_baja Is Null; --validar si se debe incluir el m?ximo endoso
    l_tdoc_aseg    a2000020.valor_campo%Type;
    l_numdoc_aseg  a2000020.valor_campo%Type;
    lx_tdoc_aseg   a2000020.valor_campo%Type;
    lx_numdoc_aseg a2000020.valor_campo%Type;
    l_chasis       a2040100.chasis_veh%Type;*/
  BEGIN
    OP_RESULTADO  := 0;
    OP_ARRERRORES := NEW SIM_TYP_ARRAY_ERROR();
    L_ERROR       := NEW SIM_TYP_ERROR;
    PRC999_AUTOS_CLTVAS_GRABALOG('PROC_VALIDA_CHASIS',
                                 'TDOC_ASEG: ' || IP_TDOC_ASEG ||
                                 ' NUMDOC_ASEG: ' || IP_NUMDOC_ASEG ||
                                 ' CHASIS: ' || IP_CHASIS || ' nsp: ' ||
                                 IP_NUMSECUPOL);
    FOR REG_C1 IN C1 LOOP
      IF REG_C1.NUM_SECU_POL != IP_NUMSECUPOL THEN
        L_FECHAINI  := REG_C1.FECHA_VIG_END;
        L_FECHAFIN  := REG_C1.FECHA_VENC_END;
        L_FECHABAJA := REG_C1.FECHA_BAJA;
      
        IF NVL(REG_C1.MCA_PER_ANUL, 'N') = 'S' THEN
          BEGIN
            SELECT T.FECHA_VIG_END, T.FECHA_VENC_END, T.FEC_ANU_POL
              INTO L_FECHAINI, L_FECHAFIN, L_FECHAANU
              FROM A2000030 T
             WHERE T.NUM_SECU_POL = REG_C1.NUM_SECU_POL
               AND T.NUM_END =
                   (SELECT MAX(N.NUM_END)
                      FROM A2000030 N
                     WHERE N.NUM_SECU_POL = T.NUM_SECU_POL);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          IF TRUNC(SYSDATE) BETWEEN L_FECHAINI AND L_FECHAFIN THEN
            NULL;
          ELSE
            IF L_FECHAFIN >= TRUNC(SYSDATE) THEN
              L_CANTVIGENTE := L_CANTVIGENTE + 1;
            END IF;
          END IF;
          --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
          IF IP_PROCESO.P_SUBPRODUCTO IN (251, 360) AND
             REG_C1.SIM_SUBPRODUCTO IN (251, 360) THEN
            IF L_FECHAINI > ADD_MONTHS(TRUNC(SYSDATE), -3) THEN
              L_NRODOCUMTO := 0;
              BEGIN
                SELECT VALOR_CAMPO
                  INTO L_NRODOCUMTO
                  FROM A2000020
                 WHERE NUM_SECU_POL = IP_NUMSECUPOL
                   AND COD_CAMPO = 'COD_ASEG'
                   AND COD_RIES = 1
                   AND NUM_END = 0;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                    SELECT VALOR_CAMPO
                      INTO L_NRODOCUMTO
                      FROM X2000020
                     WHERE NUM_SECU_POL = IP_NUMSECUPOL
                       AND COD_CAMPO = 'COD_ASEG'
                       AND COD_RIES = 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      L_NRODOCUMTO := 0;
                  END;
              END;
              IF REG_C1.NRO_DOCUMTO = L_NRODOCUMTO THEN
                L_CANTVIGENTE := L_CANTVIGENTE + 1;
              END IF;
            END IF;
          END IF;
        ELSE
          IF NVL(L_FECHABAJA, L_FECHAFIN) > TRUNC(SYSDATE) THEN
            L_CANTVIGENTE := L_CANTVIGENTE + 1;
          END IF;
        END IF;
      END IF;
    END LOOP;
    --CPERILLA: Se incluye subproducto 360 para AUTOS LICITACION
    IF IP_PROCESO.P_SUBPRODUCTO IN (251, 263, 274, 360) THEN
      PROC_ANULAREEMPLAZA_RENOV(IP_NUMSECUPOL   => IP_NUMSECUPOL,
                                IP_NUMEND       => L_NUMEND,
                                IP_CODRIES      => L_CODRIES,
                                OP_ESANULAREEMP => L_ESANULAREEMP,
                                IP_PROCESO      => IP_PROCESO,
                                OP_RESULTADO    => L_RESULTADO,
                                OP_ARRERRORES   => L_ARRERRORES);
    END IF;
    IF L_CANTVIGENTE > 0 THEN
      IF NVL(L_ESANULAREEMP, 'N') <> 'S' THEN
        OP_RESULTADO := -1;
        IF L_RESULTADO = 4 THEN
          L_ERROR := SIM_TYP_ERROR(-20000,
                                   'No es posible emitir por anula reemplaza, poliza con siniestros vigentes',
                                   'E');
        ELSE
          L_ERROR := SIM_TYP_ERROR(-20000,
                                   'Vehiculo actualmente tiene poliza ' ||
                                   'vigente con chasis igual, con otra clave u otro subproducto No se permite la emision',
                                   'E');
        END IF;
        OP_ARRERRORES.EXTEND;
        OP_ARRERRORES(OP_ARRERRORES.COUNT) := L_ERROR;
      END IF;
    END IF;
    /*If ip_tdoc_aseg Is Null Or ip_numdoc_aseg Is Null Or ip_chasis Is Null Then
        If ip_numsecupol Is Not Null Then
            Begin
                Select chasis_veh
                  Into l_chasis
                  From x2040100
                 Where num_secu_pol = ip_numsecupol
                   And cod_ries = 1
                   And num_end = (Select Max(num_end)
                                    From x2040100
                                   Where num_secu_pol = ip_numsecupol
                                     And cod_ries = 1);
            Exception
                When no_data_found Then
                    l_chasis := Null;
            End;
            lx_tdoc_aseg   := fun_rescata_x2000020(pcodcampo => 'TIPO_DOC_ASEG', pnumscupol => ip_numsecupol, pcodriesgo => 1);
            lx_numdoc_aseg := fun_rescata_x2000020(pcodcampo => 'COD_ASEG', pnumscupol => ip_numsecupol, pcodriesgo => 1);
        End If;
    Else
        l_chasis       := ip_chasis;
        lx_tdoc_aseg   := ip_tdoc_aseg;
        lx_numdoc_aseg := ip_numdoc_aseg;
    End If;
    If l_chasis Is Not Null And lx_tdoc_aseg Is Not Null And lx_numdoc_aseg Is Not Null Then
        For i In c_busca_chasis(l_chasis)
        Loop
            If i.num_secu_pol Is Not Null Then
                --l_tdoc_aseg := 'CC';
                --l_numdoc_aseg := '1015426486';
                l_tdoc_aseg   := fun_rescata_a2000020(pcodcampo => 'TIPO_DOC_ASEG', pnumscupol => i.num_secu_pol, pcodriesgo => i.cod_ries);
                l_numdoc_aseg := fun_rescata_a2000020(pcodcampo => 'COD_ASEG', pnumscupol => i.num_secu_pol, pcodriesgo => i.cod_ries);
                If lx_tdoc_aseg = l_tdoc_aseg And lx_numdoc_aseg = l_numdoc_aseg Then
                    op_resultado := -1;
                    op_arrerrores.extend;
                    op_arrerrores(op_arrerrores.count) := sim_typ_error(Sqlcode, 'Riesgo vigente con el mismo chasis y asegurado', 'E');
                    Exit;
                End If;
            End If;
        End Loop;
    End If;*/
  END PROC_VALIDA_CHASIS;

  PROCEDURE VALIDAROPCIONAUTOSELECTRICOS(PCA_INFO5          IN VARCHAR2,
                                         PNU_NUM_SECU_POL   IN NUMBER,
                                         PCA_COD_CAMPO      IN VARCHAR2,
                                         PNU_COD_RIES       IN NUMBER,
                                         PNU_SISTEMA_ORIGEN IN NUMBER,
                                         PCA_VALOR_CAMPO    IN OUT VARCHAR2) IS
  BEGIN
  
    IF (PCA_COD_CAMPO = 'OPCION_AUTOS' AND PNU_SISTEMA_ORIGEN = 124 AND
       PCA_INFO5 = 1) THEN
    
      SELECT NVL(VALOR_CAMPO, PCA_VALOR_CAMPO)
        INTO PCA_VALOR_CAMPO
        FROM X2000020 X
       WHERE X.NUM_SECU_POL = PNU_NUM_SECU_POL
         AND X.COD_RIES = PNU_COD_RIES
         AND X.COD_CAMPO = PCA_COD_CAMPO
         AND ((X.COD_RIES = PNU_COD_RIES AND NVL(PNU_COD_RIES, 0) != 0) OR
             NVL(PNU_COD_RIES, 0) = 0)
         AND EXISTS
       (SELECT 1
                FROM X2000020 X2
               WHERE X2.COD_CAMPO = 'API_OFERTA_TRD'
                 AND X.NUM_SECU_POL = X2.NUM_SECU_POL
                 AND ((X2.COD_RIES = PNU_COD_RIES AND
                     NVL(PNU_COD_RIES, 0) != 0) OR NVL(PNU_COD_RIES, 0) = 0)
                 AND X2.VALOR_CAMPO IS NOT NULL);
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
    
      NULL;
    
  END VALIDAROPCIONAUTOSELECTRICOS;
  PROCEDURE PROC_UPDATE_DF_OFERTAS(IP_POLIZA     IN SIM_TYP_POLIZAGEN,
                                   IP_NUMSECUPOL IN NUMBER,
                                   IP_NUMEND     IN NUMBER) IS
    --AEEM OCTUBRE 19 2023
    --ACTUALIZA DATOS FIJOS PARA OFERTAS PARAMETRIZADAS
    --PARA ACTUALIZAR CAMPOS DEBEN ESTAR PARAMETRIZADOS CON LA OFERTA 
    --EN LA TABLA DE PARAMETROS
  BEGIN
    PROC_ACTUALIZA_DF_OFERTAS(IP_POLIZA, IP_NUMSECUPOL, IP_NUMEND);
  END PROC_UPDATE_DF_OFERTAS;

  PROCEDURE PROC_CT_MASIVO_DIGITAL(IP_NUMSECUPOL IN NUMBER,
                                   IP_PROCESO    SIM_TYP_PROCESO) IS
    L_POSI     NUMBER := 1;
    L_POS      NUMBER;
    L_POST     NUMBER := 0;
    L_CODERROR NUMBER := 0;
    L_CONTA    NUMBER := 0;
    L_TEXTO    VARCHAR2(4000) := IP_PROCESO.P_INFO1;
    L_CODRIES  NUMBER := 1;
    L_NUMEND   NUMBER := 0;
  
  BEGIN
    WHILE L_CODERROR != -1 OR L_CONTA < 5 LOOP
      L_CONTA := L_CONTA + 1;
      SELECT NVL(INSTR(SUBSTR(L_TEXTO, L_POSI), ';'), -1)
        INTO L_POS
        FROM DUAL;
    
      IF L_POS > 0 THEN
        BEGIN
          SELECT NVL(TO_CHAR(SUBSTR(L_TEXTO, L_POSI, L_POS - 1)), -1),
                 SUBSTR(L_TEXTO, L_POS + 1)
            INTO L_CODERROR, L_TEXTO
            FROM DUAL;
        
          IF L_CODERROR != -1 THEN
            BEGIN
              DELETE X2000220
               WHERE NUM_SECU_POL = IP_NUMSECUPOL
                 AND COD_ERROR = L_CODERROR;
            
              INSERT INTO X2000220
                (NUM_SECU_POL,
                 NUM_ORDEN,
                 COD_RIES,
                 NUM_COBERTURA,
                 COD_ERROR,
                 COD_RECHAZO,
                 DSNIVEL,
                 COD_SIST,
                 COD_USER_SECRE,
                 COD_USER_RESP,
                 NIVEL_AUT)
                SELECT IP_NUMSECUPOL,
                       L_NUMEND,
                       L_CODRIES,
                       NULL,
                       COD_ERROR,
                       3,
                       'C',
                       '2',
                       COD_USER_SECRE,
                       NULL,
                       NIVEL_AUT
                  FROM G2000210 M
                 WHERE COD_CIA = IP_PROCESO.P_COD_CIA
                   AND COD_ERROR = L_CODERROR;
            
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
              
            END;
          
          END IF;
        
        EXCEPTION
          WHEN OTHERS THEN
            L_CODERROR := -1;
          
        END;
      
      ELSE
        L_CODERROR := -1;
      
      END IF;
    
    END LOOP;
  
  END;

  PROCEDURE PROC_ACTUALIZA_NOMINA(IP_NUMSECUPOL NUMBER, IP_NUMEND NUMBER) IS
    L_SUMAASEG NUMBER;
    CURSOR C1 IS
      SELECT DISTINCT C.COD_RIES
        FROM X2000020 C
       WHERE C.NUM_SECU_POL = IP_NUMSECUPOL
         AND C.COD_RIES IS NOT NULL;
  
  BEGIN
    IF IP_NUMEND = 0 THEN
      FOR REG_C1 IN C1 LOOP
        L_SUMAASEG := SIM_PCK_FUNCION_GEN.FUN_RESCATA_X2000020('SUMA_ASEG',
                                                               IP_NUMSECUPOL,
                                                               REG_C1.COD_RIES);
        UPDATE X9990100 A
           SET A.PRIMA_CAT  = ROUND(L_SUMAASEG * A.SUMA_ASEG1 / 100, 2),
               A.ANO_FABRIC = 0
         WHERE A.NUM_SECU_POL = IP_NUMSECUPOL
           AND A.NUM_END = IP_NUMEND
           AND A.COD_RIES = REG_C1.COD_RIES;
      
      END LOOP;
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
    
  END;

END SHPC_PCK_PROCESO_DATOS_EMISION2;
/
