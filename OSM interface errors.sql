SELECT COUNT (distinct machine_serial_number), 'TMS Error  ' || error_message
    FROM apps.trex_telemetry
   WHERE error_message IS NOT NULL
GROUP BY error_message
UNION
  SELECT COUNT (distinct machine_serial_number), 'Boomi error  ' || SUBSTR (BOOMI_ERROR_MESSAGE, 1, 175)
    FROM apps.trex_telemetry
   WHERE BOOMI_ERROR_MESSAGE IS NOT NULL
GROUP BY SUBSTR (BOOMI_ERROR_MESSAGE, 1, 175)