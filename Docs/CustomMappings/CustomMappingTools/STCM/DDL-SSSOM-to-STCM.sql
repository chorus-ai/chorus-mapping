SELECT DISTINCT CASE
         WHEN subject_id ~ 'B2AI' THEN SPLIT_PART(a.subject_id,'DelphiR2:B2AI:',2)
         ELSE SPLIT_PART(a.subject_id,':',2)
       END AS source_code,
       0 AS source_concept_id,
       SPLIT_PART(a.subject_id,':',1) AS source_vocabulary_id,
       subject_label AS source_code_description,
       CASE
         WHEN predicate_id ~ 'exactMatch' THEN 'Maps to'
         WHEN predicate_id ~ 'narrowMatch' THEN 'Subsumes'
         WHEN predicate_id ~ 'broadMatch' THEN 'Is a'
         WHEN predicate_id ~ 'hasComponent' THEN 'Has component'
         WHEN predicate_id ~ 'hasFocus' THEN 'Has focus'
         WHEN predicate_id ~ 'relatedMatch|closeMatch' AND c.domain_id = 'Procedure' THEN 'Has asso proc'
         WHEN predicate_id ~ 'relatedMatch|closeMatch' AND c.domain_id = 'Condition' THEN 'Has associated finding'
         WHEN predicate_id ~ 'relatedMatch|closeMatch' AND c.domain_id = 'Measurement' THEN 'Has measurement'
         ELSE 'Has relat context'
       END AS relationship_id,
       c.concept_id AS target_concept_id,
       c.concept_name AS target_concept_name,
       c.vocabulary_id AS target_vocabulary_id,
       c.domain_id AS target_domain_id,
       mapping_date AS valid_start_date,
       '12-31-2099' AS valid_end_date,
       NULL AS invalid_reason
FROM sssom_mapping_table a
  JOIN devv5.concept c
    ON c.concept_id = SPLIT_PART (a.object_id,':',2)::INT
   AND c.concept_id <> 0;
