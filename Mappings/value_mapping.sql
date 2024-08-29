-- Demo table
SELECT * FROM flowsheet_values_to_be_mapped limit 5;
/*flowsheet_code	flowsheet_name	count_encounters	sample_values
1352171564	0-10 Pain Score	13165	0;0;9
1352159056	0-10 PCT Pain Score	133	0;0;9
231656151	Abortions	888	0;0;6
1352170622	Baker-Wong Score	168	0;0;9
138907572	Behavioral Rating Total	100	0;0;8*/

-- Parse values
 SELECT *,      REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value 
FROM flowsheet_values_to_be_mapped; -- 16163

DROP TABLE if EXISTS values_mapped;

-- Start by setting up a lookup table for value mapping, including columns for original and mapped values
-- Identify numeric values, use a regular expression to match digits at the beginning and end of the string to isolate numeric values from mapping.
CREATE TABLE values_mapped 
AS
(WITH t1
AS
(SELECT *,
       REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value -- parse values
FROM flowsheet_values_to_be_mapped)

  SELECT DISTINCT flowsheet_name,
       sample_value,
       'numeric' AS data_type,
       0 AS concept_id,
       '' AS concept_name,
       '' AS domain_id,
       '' AS concept_class_id,
       '' AS vocabulary_id,
       'value_as_number' AS cdm_field
FROM t1
WHERE sample_value ~ '^\d+$|^\d+,\d+$'); -- clean numeric values;

SELECT * FROM values_mapped;

-- Assign (map) each source value to the appropriate category within the Meas Value domain
INSERT INTO values_mapped
(
  flowsheet_name,
  sample_value,
  data_type,
  concept_id,
  concept_name,
  domain_id,
  concept_class_id,
  vocabulary_id,
  cdm_field
)
WITH t1
AS
(SELECT *,
       REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
FROM flowsheet_values_to_be_mapped) 
    SELECT DISTINCT flowsheet_name,
       sample_value,
       'string',
       c.concept_id AS concept_id,
       c.concept_name AS concept_name,
       c.domain_id,
       c.concept_class_id,
       c.vocabulary_id,
       'value_as_concept_id' AS cdm_field
     FROM t1 a
  JOIN concept c
    ON TRIM (lower (a.sample_value)) = lower (c.concept_name) -- ignore case
   AND c.domain_id = 'Meas Value'
WHERE sample_value !~ '^\d+$|^\d+,\d+$' -- exclude numeric values
AND   c.standard_concept = 'S' -- only standard concepts
; -- 7911
  
-- Eliminate any duplicate entries from the standard set
-- Execute the check query to verify data accuracy, ensure SNOMED concepts are processed first.
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'SNOMED')
AND   data_type = 'string'
AND   vocabulary_id <> 'SNOMED';

-- Remove duplicated standard values if a SNOMED mapping is available.
DELETE
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'SNOMED')
AND   data_type = 'string'
AND   vocabulary_id <> 'SNOMED'; -- 3951

-- Next, prioritize LOINC in duplicated pairs with LOINC and non-SNOMED vocabularies
-- check
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'LOINC')
AND   data_type = 'string'
AND   vocabulary_id <> 'LOINC';

-- Remove duplicated standard values if a LOINC mapping is available.
DELETE
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'LOINC')
AND   data_type = 'string'
AND   vocabulary_id <> 'LOINC'; -- 225

-- Check for duplicates within each vocabulary and remove LOINC documents related to Meas Values, as they are not actual answers.
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'LOINC'
                       AND   concept_class_id = 'Answer')
AND   data_type = 'string'
AND   concept_class_id <> 'Answer';

-- Remove them
DELETE
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'LOINC'
                       AND   concept_class_id = 'Answer')
AND   data_type = 'string'
AND   concept_class_id <> 'Answer'; -- 29

-- Verify if a single value has multiple mappings.
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   data_type = 'string'; -- 42 leave them for now
 
-- Utilize the concept_synonym table to identify additional Meas Values.
INSERT INTO values_mapped
(
  flowsheet_name,
  sample_value,
  data_type,
  concept_id,
  concept_name,
  domain_id,
  concept_class_id,
  cdm_field
)
WITH t1
AS
(SELECT *,
       REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
FROM flowsheet_values_to_be_mapped) 
    SELECT DISTINCT flowsheet_name,
       sample_value,
       'string',
       c.concept_id AS concept_id,
       c.concept_name AS concept_name,
       c.domain_id,
       c.concept_class_id,
       'value_as_concept_id' AS cdm_field
     FROM t1 a
  JOIN concept_synonym cs ON TRIM (lower (a.sample_value)) = lower (cs.concept_synonym_name)
  JOIN concept c
    ON c.concept_id = cs.concept_id
   AND c.domain_id = 'Meas Value'
   AND c.standard_concept = 'S'
WHERE sample_value !~ '^\d+$|^\d+,\d+$'
AND   sample_value NOT IN (SELECT sample_value FROM values_mapped); -- 45
 
-- Map all remaining concepts that are not covered by the Meas Value domain using the concept table
INSERT INTO values_mapped
(
  flowsheet_name,
  sample_value,
  data_type,
  concept_id,
  concept_name,
  domain_id,
  concept_class_id,
  vocabulary_id,
  cdm_field
)
WITH t1
AS
(SELECT *,
       REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
FROM flowsheet_values_to_be_mapped) 
     SELECT DISTINCT flowsheet_name,sample_value,'string',c.concept_id AS concept_id,c.concept_name AS concept_name,c.domain_id,c.concept_class_id,c.vocabulary_id,'value_as_concept_id' AS cdm_field 
     FROM t1 a
  JOIN concept c
    ON TRIM (lower (a.sample_value)) = lower (c.concept_name)
   AND c.domain_id IN ('Condition', 'Spec Anatomic Site', 'Measurement', 'Procedure', 'Observation', 'Device', 'Drug') -- limit domains
  WHERE sample_value !~ '^\d+$|^\d+,\d+$'-- exclude numbers
AND   c.standard_concept = 'S'
AND   sample_value NOT IN (SELECT sample_value FROM values_mapped); -- 354
    
-- Check for duplicates 
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   data_type = 'string'; -- 119
 
-- SNOMED first
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'SNOMED')
AND   data_type = 'string'
AND   vocabulary_id <> 'SNOMED';

DELETE
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE vocabulary_id = 'SNOMED')
AND   data_type = 'string'
AND   vocabulary_id <> 'SNOMED'; -- 29

-- Give priority to Clinical Findings when they exist in duplicated pairs.
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE concept_class_id = 'Clinical Finding')
AND   data_type = 'string'
AND   concept_class_id <> 'Clinical Finding';

DELETE
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   sample_value IN (SELECT sample_value
                       FROM values_mapped
                       WHERE concept_class_id = 'Clinical Finding')
AND   data_type = 'string'
AND   concept_class_id <> 'Clinical Finding'; -- 4

-- Eliminate other heterogeneous duplicates using the FIRST_VALUE function.
-- Check:
WITH t1 AS
(
  SELECT flowsheet_name,
         sample_value,
         data_type,
         FIRST_VALUE(concept_id) OVER (PARTITION BY flowsheet_name) AS concept_id
  FROM values_mapped
  WHERE sample_value IN (SELECT sample_value
                         FROM values_mapped
                         GROUP BY flowsheet_name,
                                  sample_value
                         HAVING COUNT(1) > 1)
  AND   data_type = 'string'
)
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   data_type = 'string'
AND   (concept_id) NOT IN (SELECT concept_id FROM t1) ; -- 0 

-- Remove duplicates
WITH t1 AS
(
  SELECT flowsheet_name,
         sample_value,
         data_type,
         FIRST_VALUE(concept_id) OVER (PARTITION BY flowsheet_name) AS concept_id
  FROM values_mapped
  WHERE sample_value IN (SELECT sample_value
                         FROM values_mapped
                         GROUP BY flowsheet_name,
                                  sample_value
                         HAVING COUNT(1) > 1)
  AND   data_type = 'string'
) DELETE
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   data_type = 'string'
AND   (concept_id) NOT IN (SELECT concept_id FROM t1) ; -- 36
 
-- Map the remaining values utilizing the concept_synonym table.
INSERT INTO values_mapped
(
  flowsheet_name,
  sample_value,
  data_type,
  concept_id,
  concept_name,
  domain_id,
  concept_class_id,
  vocabulary_id,
  cdm_field
)
WITH t1
AS
(SELECT *,
       REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
FROM flowsheet_values_to_be_mapped) 
     SELECT DISTINCT flowsheet_name,sample_value,'string',c.concept_id AS concept_id,c.concept_name,c.domain_id,c.concept_class_id,c.vocabulary_id,'value_as_concept_id' AS cdm_field 
     FROM t1 a
  JOIN concept_synonym cs ON TRIM (lower (a.sample_value)) = lower (cs.concept_synonym_name)
  JOIN concept c
    ON c.concept_id = cs.concept_id
   AND c.domain_id IN ('Condition', 'Measurement', 'Observation', 'Procedure', 'Device', 'Drug', 'Spec Anatomic Site')
   AND c.vocabulary_id NOT IN ('OMOP Genomic')
   AND c.standard_concept = 'S'
WHERE sample_value !~ '^\d+$'
AND   sample_value NOT IN (SELECT sample_value FROM values_mapped); -- 122

-- Check for duplicates
SELECT *
FROM values_mapped
WHERE sample_value IN (SELECT sample_value
                       FROM values_mapped
                       GROUP BY flowsheet_name,
                                sample_value
                       HAVING COUNT(1) > 1)
AND   data_type = 'string'; -- 0

-- Examine duplicates by applying the CASE function to identify terms for removal, allowing for rule adjustments as necessary.
WITH t1 AS
(
  SELECT *,
         CASE
           WHEN domain_id = 'Condition' OR concept_class_id IN ('Procedure','Physical Object') THEN 'remain'
           ELSE 'remove'
         END AS action
  FROM values_mapped
  WHERE data_type = 'string'
  AND   sample_value IN (SELECT sample_value
                         FROM values_mapped
                         GROUP BY flowsheet_name,
                                  sample_value
                         HAVING COUNT(1) > 1)
)
SELECT *
FROM values_mapped a
  JOIN t1 b
    ON b.flowsheet_name = a.flowsheet_name
   AND b.sample_value = a.sample_value
   AND b.concept_id = a.concept_id
WHERE action = 'remove';

-- Delete such duplicates
WITH t1 AS
(
  SELECT *,
         CASE
           WHEN domain_id = 'Condition' OR concept_class_id IN ('Procedure','Physical Object') THEN 'remain'
           ELSE 'remove'
         END AS action
  FROM values_mapped
  WHERE data_type = 'string'
  AND   sample_value IN (SELECT sample_value
                         FROM values_mapped
                         GROUP BY flowsheet_name,
                                  sample_value
                         HAVING COUNT(1) > 1)
) DELETE
FROM values_mapped
WHERE (sample_value,concept_id) IN (SELECT a.sample_value,
                                           a.concept_id
                                    FROM values_mapped a
                                      JOIN t1 b
                                        ON b.flowsheet_name = a.flowsheet_name
                                       AND b.sample_value = a.sample_value
                                       AND b.concept_id = a.concept_id
                                    WHERE action = 'remove'); -- 30
-- Look at mapping results
SELECT DISTINCT sample_value,
       concept_id,
       concept_name,
       domain_id,
       concept_class_id,
       vocabulary_id
FROM values_mapped
WHERE data_type = 'string';


-- Ensure that all distinct vocabularies used for mapping are properly downloaded and integrated into your OMOP CDM instance, especially within the Vocabulary Tables
-- Document this process thoroughly. Additionally, consider limiting the list of vocabularies used at sites, based on discussions or established rules.

SELECT DISTINCT vocabulary_id
FROM values_mapped
WHERE vocabulary_id <> '';

-- Review all mapped source values
WITH t1 AS
(
  SELECT *,
         REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
  FROM flowsheet_values_to_be_mapped
)
SELECT a.*,
       b.concept_id,
       b.concept_name,
       b.domain_id,
       b.concept_class_id,
       b.vocabulary_id,
       b.cdm_field
FROM t1 a
  JOIN values_mapped b
    ON b.sample_value = a.sample_value
   AND a.flowsheet_name = b.flowsheet_name; -- 8522
--WHERE data_type = 'string'; -- 5819

-- look at unmapped
WITH t1 AS
(
  SELECT *,
         REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
  FROM flowsheet_values_to_be_mapped
),
t2 AS
(
  SELECT a.*,
         b.concept_id,
         b.concept_name,
         b.domain_id,
         b.concept_class_id,
         b.vocabulary_id,
         b.cdm_field
  FROM t1 a
    JOIN values_mapped b
      ON b.sample_value = a.sample_value
     AND a.flowsheet_name = b.flowsheet_name
)
SELECT DISTINCT sample_value
FROM t1
WHERE sample_value NOT IN (SELECT sample_value FROM t2);

--consider what other patterns we may have overlooked, such as units or operators
WITH t1 AS
(
  SELECT *,
         REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
  FROM flowsheet_values_to_be_mapped
),
t2 AS
(
  SELECT a.*,
         b.concept_id,
         b.concept_name,
         b.domain_id,
         b.concept_class_id,
         b.vocabulary_id,
         b.cdm_field
  FROM t1 a
    JOIN values_mapped b
      ON b.sample_value = a.sample_value
     AND a.flowsheet_name = b.flowsheet_name
)
SELECT DISTINCT sample_value
FROM t1
WHERE sample_value NOT IN (SELECT sample_value FROM t2)
and sample_value ~ '^\+|^\-|^\=|^\>|^\<';

-- We can map numeric values along with their corresponding units (e.g., /120mL/min, 120mmHg/), but this mapping effort should be treated as a separate sub-task
WITH t1 AS
(
  SELECT *,
         REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
  FROM flowsheet_values_to_be_mapped
),
t2 AS
(
  SELECT a.*,
         b.concept_id,
         b.concept_name,
         b.domain_id,
         b.concept_class_id,
         b.vocabulary_id,
         b.cdm_field
  FROM t1 a
    JOIN values_mapped b
      ON b.sample_value = a.sample_value
     AND a.flowsheet_name = b.flowsheet_name
)
SELECT DISTINCT sample_value,
       TRIM(REGEXP_REPLACE(sample_value,'\d+\.?\d+?|\d+-\d+|^\d+','')) AS unit_to_map
FROM t1
WHERE sample_value NOT IN (SELECT sample_value FROM t2)
AND   sample_value ~* 'mcg$|kg\y$|lb\y$|ml$|units?$|min$|mg$|minute$|db\y$|mmhg$|ounces?$|meq$|cm$|amp$|DegC$|bpm$|cmh2o$|kcal$|week$'
AND   sample_value ~* '^\d+';

-- Examine unmapped values while excluding operators and units through pattern matching.
WITH t1 AS
(
  SELECT *,
         REGEXP_SPLIT_TO_TABLE(sample_values,';') AS sample_value
  FROM flowsheet_values_to_be_mapped
),
t2 AS
(
  SELECT a.*,
         b.concept_id,
         b.concept_name,
         b.domain_id,
         b.concept_class_id,
         b.vocabulary_id,
         b.cdm_field
  FROM t1 a
    JOIN values_mapped b
      ON b.sample_value = a.sample_value
     AND a.flowsheet_name = b.flowsheet_name
)
SELECT DISTINCT sample_value, count_encounters
FROM t1 
WHERE sample_value NOT IN (SELECT sample_value FROM t2)
AND   sample_value !~*' mcg$|kg\y$|lb\y$|ml$|units?$|min$|mg$|minute$|db\y$|mmhg$|ounces?$|meq$|cm$|amp$|DegC$|bpm$|cmh2o$|kcal$|week$' -- can be extended
and sample_value !~ '^\+|^\-|^\=|^\>|^\<'; -- 4397

-- Collect unmapped values and share them with Standards Team
