  -- +======================================================================+
   -- File       : INC1023392_Table_Script.sql
   -- Name       : Supriya Nainglaj
   -- Date       : 31-JAN-2023
   -- Description: Script to create temp table to insert fnd messages.
   -- Modification History:
   -- --------------------
   --  Modified By          Date         Version    Description
   -- -------------        ----------   -------    ----------------------------------
   --  Supriya Nainglaj    31-01-2023   1.0        INC1077574 - To add/update new fnd messages

CREATE TABLE bolinf.trex_fnd_msg_stg (
    lang           VARCHAR2(50),
    message_name   VARCHAR2(50),
    message        VARCHAR2(2000)
)
TABLESPACE "TREX_SCRAP";

 

CREATE SYNONYM trex_fnd_msg_stg1 FOR bolinf.trex_fnd_msg_stg;

 