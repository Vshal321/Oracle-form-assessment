SELECT trunc(es.creation_date),es.transaction_type, es.field7, erv.MESSAGE_TEXT
  FROM apps.ece_stage es, apps.ECE_RULE_VIOLATIONS erv
 WHERE es.stage_id = erv.stage_id
 order by 1 desc