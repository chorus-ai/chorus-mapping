# SOURCE_TO_CONCEPT_MAP table

**The SOURCE_TO_CONCEPT_MAP (STCM)** table is an integral component within the OMOP CDM, primarily designed to facilitate mapping integration with ETL processes. STCM serves the critical function of preserving local source codes that do not have direct equivalents in the OHDSI Standardized Vocabularies, while also establishing mappings from each source code to a Standard Concept, identified by target_concept_ids. These mappings are essential for accurately populating the OMOP CDM tables with coherent data.

* Despite an OHDSI-led initiative aiming to retire the SOURCE_TO_CONCEPT_MAP table because of its legacy designation, it remains in active use across the community. This continued utilization, albeit with certain modifications, is attributed to its proven stability and specific utility in various contexts.
* It is crucial to highlight that the choice of mapping table format is less critical than strict adherence to the comprehensive rules and guidelines that dictate the population of OMOP Vocabulary and CDM tables. Upholding these standards is essential for preserving the data's integrity and ensuring its seamless integration within the OMOP framework.

  ## STCM Table Schema

|Field|Required|Type|Description|
| --- | --- | --- | --- |
|source_code|Yes|varchar(50)|The source code being translated into a Standard Concept.|
|source_concept_id|Yes|integer|A foreign key to the Source Concept that is being translated into a Standard Concept.|
|source_vocabulary_id|No|varchar(20)|A foreign key to the VOCABULARY table defining the vocabulary of the source code that is being translated to a Standard Concept.|
|source_code_description|Yes|varchar(255)|An optional description for the source code. This is included as a convenience to compare the description of the source code to the name of the concept.|
|relationship_id|No|varchar(50)|An identifier of association type: Maps to - exact match; Maps to value - exact match value of Meas or Obs, Is a - broad match to a parent; Subsumes - narrow match to a child; Has component/Has asso - supplemental.|
|target_concept_id|Yes|integer|A foreign key to the target Concept to which the source code is being mapped.|
|target_vocabulary_id|Yes|varchar(20)|A foreign key to the VOCABULARY table defining the vocabulary of the target Concept.|
|target_domain_id|No|varchar(20)|Standard concept domain (OMOP or Delphi).| 
|valid_start_date|Yes|date|The date when the mapping instance was first recorded.|
|valid_end_date|Yes|date|The date when the mapping instance became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.|
|invalid_reason|No|varchar(1)|Reason the mapping instance was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default value.|

# Recommended Practices

* Leadership within OHDSI strongly advises employing the CONCEPT and CONCEPT_RELATIONSHIP table for the exchange of mappings. This recommendation stems from the table’s structured approach to delineating clear relationships between standardized concepts, thereby facilitating accurate and comprehensive data integration.
* Despite the primary recommendation, the Source to Concept Map (STCM) table is recognized for its utility in translating local source codes to Standard Concepts. This table serves as an alternative, especially when dealing with unique or site-specific codes that require precise mapping to the standardized vocabulary.
  
# Guiding Principles for Code Translation

* Unique identification of source information is achieved through either the **source_concept_id** or a **combination of source_code and source_vocabulary_id**, paralleling the **concept_id_1** field in the CONCEPT_RELATIONSHIP table. In instances where source_concept_id is unavailable due to local codes not aligning with the Standard Vocabulary, a value of 0 (zero) is assigned, signifying an undefined concept. Notably, legitimate local Source Concepts are denoted by concept_id values exceeding 2 billion.
* If source codes in your database are not in the correct format (e.g., missing 'dots' in ICD-9-CM codes), the ETL process should include a step to correct this, such as adding the missing 'dot' to match the standard format.
* The source_code_description field offers an optional venue for elaborating on the source code, providing contextual clarity.
* The target_concept_id signifies the standard concept assigned to the source code, aligning with the concept_id_2 in the CONCEPT_RELATIONSHIP table. Furthermore, the target_vocabulary_id echoes the target concept’s vocabulary ID, duplicating information found within the target concept’s CONCEPT record.
* The integrity and relevance of mapping information are managed through valid_start_date, valid_end_date, and invalid_reason fields, ensuring that only valid and current mappings are utilized. Mapping records deemed invalid are excluded from use to maintain data accuracy and integrity.
* If a source_concept_id is not available (e.g., for local codes not covered by the Standard Vocabulary), the field should be set to 0 (zero), indicating an undefined concept. Note that defined local Source Concepts have concept_id values above 2 billion (2,000,000,000).
