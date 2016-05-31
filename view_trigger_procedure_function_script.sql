--------------------------------------------------------
--  DDL for View CONCENTRADO_CLIENTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINLOL"."CONCENTRADO_CLIENTE" ("IDCLIENTE", "IDCUENTA", "TIPOTRANSACCION", "MONTO") AS 
  SELECT IDCLIENTE, IDCUENTA, TIPOTRANSACCION, MONTO
  FROM TRANSACCIONES
  WHERE IDCLIENTE = 1;
--------------------------------------------------------
--  DDL for View TRANSACCIONES_FECHAS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINLOL"."TRANSACCIONES_FECHAS" ("IDTRANSACCION", "IDCUENTA", "MONTO", "FECHA") AS 
  SELECT IDTRANSACCION, IDCUENTA, MONTO, FECHA
  FROM TRANSACCIONES
  WHERE FECHA BETWEEN TO_DATE ('2016/05/29', 'yyyy/mm/dd')
AND TO_DATE ('2016/06/01', 'yyyy/mm/dd');
--------------------------------------------------------
--  DDL for View TRANSACCIONES_FECHAS_TIPO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINLOL"."TRANSACCIONES_FECHAS_TIPO" ("IDTRANSACCION", "IDCUENTA", "TIPOTRANSACCION", "MONTO", "FECHA") AS 
  SELECT IDTRANSACCION, IDCUENTA, TIPOTRANSACCION, MONTO, FECHA
  FROM TRANSACCIONES
  WHERE FECHA BETWEEN TO_DATE ('2016/05/29', 'yyyy/mm/dd')
AND TO_DATE ('2016/06/01', 'yyyy/mm/dd');
--------------------------------------------------------
--  DDL for View TRANSACCIONES_TIPO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINLOL"."TRANSACCIONES_TIPO" ("IDTRANSACCION", "IDCUENTA", "TIPOTRANSACCION", "MONTO") AS 
  SELECT IDTRANSACCION, IDCUENTA, TIPOTRANSACCION, MONTO
  FROM TRANSACCIONES
  WHERE TIPOTRANSACCION = 'DEPOSITO';
--------------------------------------------------------
--  DDL for Trigger AUTO_FECHA
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ADMINLOL"."AUTO_FECHA" 
BEFORE
insert on TRANSACCIONES
FOR EACH ROW
begin
  :new.FECHA := SYSDATE;
end;
/
ALTER TRIGGER "ADMINLOL"."AUTO_FECHA" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AUTO_MONTO_INSERT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ADMINLOL"."AUTO_MONTO_INSERT" 
BEFORE INSERT ON TRANSACCIONES
FOR EACH ROW
begin
  :new.MONTO := :new.DEPOSITO - :new.RETIRO;
END;
/
ALTER TRIGGER "ADMINLOL"."AUTO_MONTO_INSERT" ENABLE;
--------------------------------------------------------
--  DDL for Trigger AUTO_MONTO_UPDATE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ADMINLOL"."AUTO_MONTO_UPDATE" 
BEFORE UPDATE ON TRANSACCIONES
FOR EACH ROW
begin
  :new.MONTO := :new.DEPOSITO - :new.RETIRO;
END;
/
ALTER TRIGGER "ADMINLOL"."AUTO_MONTO_UPDATE" ENABLE;
--------------------------------------------------------
--  DDL for Function CLIENTES_C
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINLOL"."CLIENTES_C" 
RETURN number IS
  t_clientes number := 0;
BEGIN  
  SELECT count(IDCLIENTE) into t_clientes FROM CLIENTE;  
  return t_clientes;
END;

/
--------------------------------------------------------
--  DDL for Function DEPOSITOS_C
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINLOL"."DEPOSITOS_C" 
RETURN number IS
  p_depositos number := 0;
BEGIN  
  SELECT count(TIPOTRANSACCION) into p_depositos FROM TRANSACCIONES WHERE TIPOTRANSACCION = 'DEPOSITO';  
  return p_depositos;
END;

/
--------------------------------------------------------
--  DDL for Function RETIROS_C
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINLOL"."RETIROS_C" 
RETURN number IS
  p_retiros number := 0;
BEGIN  
  SELECT count(TIPOTRANSACCION) into p_retiros FROM TRANSACCIONES WHERE TIPOTRANSACCION = 'RETIRO';  
  return p_retiros;
END;

/
--------------------------------------------------------
--  DDL for Function TRANSACCIONES_C
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINLOL"."TRANSACCIONES_C" 
RETURN number IS
  t_transacciones number := 0;
BEGIN  
  SELECT count(IDTRANSACCION) into t_transacciones FROM TRANSACCIONES;  
  return t_transacciones;
END;

/
--------------------------------------------------------
--  DDL for Procedure GETCLIENTBYCLIENTID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ADMINLOL"."GETCLIENTBYCLIENTID" (
	   p_userid IN CLIENTE.IDCLIENTE%TYPE,
	   o_username OUT CLIENTE.NOMBRECLIENTE%TYPE,
	   o_contact OUT  CLIENTE.CONTACTO%TYPE,
	   o_RFC OUT CLIENTE.RFC%TYPE)
IS
BEGIN

  SELECT NOMBRECLIENTE , CONTACTO, RFC
  INTO o_username, o_contact,  o_RFC 
  from  CLIENTE WHERE IDCLIENTE = p_userid;

END;