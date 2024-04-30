# MIMIC4-to-OMOP Mappings

## Overview

This repository contains mappings of source terms from the Medical Information Mart for Intensive Care (MIMIC)-IV to the Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM). MIMIC-IV is an extensive database consisting of de-identified ICU-related electronic health records (EHRs) for patients admitted to Beth Israel Deaconess Medical Center. It includes data like patient demographics, vital signs, laboratory tests, medications, and more. This resource facilitates a broad range of epidemiological and clinical studies and promotes improvement in critical care outcomes research.

## Access to MIMIC-IV

Access to the full MIMIC-IV dataset is restricted to users who complete a recognized data use agreement and are approved by the MIMIC team. For more information and to apply for access, please visit the [MIMIC-IV Official Website](https://mimic.mit.edu/).

## About the Mappings

The mappings in this repository are designed to help researchers translate MIMIC-IV data into the OMOP CDM format. The OMOP CDM harmonizes data to a common standard, enhancing the comparability and combinability of research findings across studies. 

### What is Included

This dataset includes mappings for the following:
| Table Name                       | Count |
|----------------------------------|-------|
| mimic-medication-formulary-drug-cd | 2777  |
| mimic-hcpcs-cd                    | 2227  |
| chartevents-d-items               | 1550  |
| d-labitems                        | 1337  |
| d-items                           | 488   |
| mimic-microbiology-organism       | 478   |
| mimic-units                       | 427   |
| mimic-medication-icu              | 395   |
| mimic-medication-site             | 255   |
| mimic-microbiology-test           | 215   |
| mimic-spec-type-desc              | 133   |
| mimic-medication-frequency        | 105   |
| mimic-medication-route            | 77    |
| mimic-microbiology-antibiotic     | 24    |
| bodysite                          | 24    |
| mimic-lab-fluid                   | 10    |

The  mapping set includes source terms from MIMIC-IV along with their corresponding OMOP CDM concepts, presented in two formats: SSSOM-LinkML and the OMOP source_to_concept_map (STCM) table.

### File Structure

| Field                | Description                                                                                                                                                                                     |
|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| mapping_set_id       | A unique identifier for the mapping set.                                                                                                                                                        |
| subject_category     | The conceptual category to which the subject belongs.                                                                                               |
| subject_id           | The ID of the subject of the mapping. It is formed by concatenating the name of the mapping source (e.g., MIMIC4) with the subject source identifier.                  |
| subject_label        | A human-readable label for the subject.                                                                                                                                   |
| predicate_id         | Represents the type of relationship/assertion between a source (subject) and target (object): exactMatch, narrowMatch (mapping to child), broadMatch (mapping to parent), relatedMatch (related). |
| confidence           | Score between 0 and 1 (0.0-1.0 in fact) - the confidence or probability that the match is correct, where 1 denotes total confidence; 0.8 - 80% confidence, 0.5 - 50% confidence.                |
| object_id            | The identifier for the object in the target dataset. It is formed by concatenating the name of the mapping target terminological system (e.g., OMOP) with the object (target) identifier.         |
| object_label         | A descriptive label for the object.                                                                                                                                                             |
| mapping_justification| The rationale behind the mapping decision. It is represented by an action (or the written representation of that action) from Semantic Vocabulary Mapping (semapv) showing a mapping to be reasonable. Example: "semapv:ManualMappingCuration". |
| author_id            | Identifier (ORCID) for the individual who established the mapping.                                                                                          |
| author_label         | The name of the author responsible for the mapping.                                                                                                                                             |
| mapping_date         | The date on which the mapping was recorded.                                                                                                                                                    |


### How to Use These Mappings

These mappings serve as an initial foundation for researchers aiming to convert MIMIC-IV data into the OMOP format. It is important for users to validate and, if necessary, modify these mappings to align with the specific requirements and contexts of their research projects. Additionally, these mappings can be effectively utilized in the ETL (Extract, Transform, Load) process.

## Contributing

Contributions to this mapping are welcome. If you discover any issues with the mappings or have suggestions for improvement, please feel free to open an issue or submit a pull request.

## Citation

If you use these mappings in your research, please cite this repository as well as the MIMIC-IV dataset appropriately. For MIMIC-IV citation guidelines, refer to their website.

## License

The MIMIC-IV dataset is distributed under separate terms; please refer to the MIMIC-IV data use agreement for more details.

## Contact

For any queries regarding these mappings or the MIMIC-IV dataset, please [open an issue](https://github.com/chorus-ai/chorus-mapping/issues) on this GitHub repository.


