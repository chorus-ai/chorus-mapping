# USAGI output conversion into SSSOM

The standard output from the OHDSI Usagi mapping tool can be converted into SSSOM for subsequent review and appropriate re-mapping:

| Usagi Field                  | SSSOM Field                |
|------------------------------|----------------------------|
| sourceCode                   | subject_id                 |
| sourceName                   | subject_label              |
| sourceFrequency              | cnt                        |
| sourceAutoAssignedConceptIds | -                          |
| matchScore                   | confidence + rule-based logic for predicate_id |
| mappingStatus                | -                          |
| targetConceptId              | object_id                  |
| targetConceptName            | object_label               |
| targetVocabularyId           | object_vocabulary          |
| targetDomainId               | object_category            |
| targetStandardConcept        | -                          |
| targetChildCount             | -                          |
| targetParentCount            | -                          |
| targetConceptClassId         | object_class               |
| targetConceptCode            | object_code                |
| targetValidStartDate         | mapping_date               |
| targetValidEndDate           | -                          |

DDL example:

``` sql
SELECT 
  CASE WHEN mappingType = 'MAPS_TO_VALUE' THEN 'Item Value' 
       ELSE 'Item' END AS subject_type, -- optional
  sourceFrequency AS cnt,    
  sourceCode AS subject_id,
  sourceName AS subject_label,
  matchScore AS confidence,
  CASE WHEN matchScore > 0.95 THEN 'skos:exactMatch'
       ELSE 'skos:uncheckedMatch' END AS predicate_id, 
  'OMOP:' || targetConceptId AS object_id, -- concatenation with 'OMOP:' can be avoided for an initial mapping
  targetConceptName AS object_label,
  targetVocabularyId AS object_vocabulary,
  targetDomainId AS object_category,
  targetConceptClassId AS object_class,
  targetConceptCode AS object_code,
  targetValidStartDate AS mapping_date,
  'OHDSI Usagi' AS mapping_tool,
  'v.1.4.3' AS mapping_tool_version
FROM usagi_output_table;
```
