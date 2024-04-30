# ETL Specification Guide: Mapping Section

## Glossary
* **CDM**  - Common Data Model and a prefix indicating an OMOP CDM table
* **ETL** - Extract, Transform, Load
* **Event table** - any event table from OMOP CDM: drug_exposure, device_exposure, condition_occurrence, procedure_occurrence, measurement, etc.
* **Mapping**:
    * also known as a **map**, is an association between a particular concept in one code system or dataset and code in another, rarely the same, code system that has the same (or similar) meaning. 
    * the process to transform one concept into a Standard one. In OMOP CDM, the Standardized Clinical Data Tables allow only Standard concepts. Thus, all codes used in the source databases have to be translated to Standard concepts. Mapping is implemented through the records, which connect each source concept to a Standard concept by a particular type of the relationship_id via the CONCEPT_RELATIONSHIP table.
* **OMOP CDM** - The Observational Medical Outcomes Partnership Common Data Model
source_code / subject_id - a field or combination of fields (data elements) in source data that identify a medical event (measure / procedure / drug prescription / diagnosis, etc.).source code can be:
    * a code from a known vocabulary or coding system, e.g. “A40” (Streptococcal sepsis)
    * a description, e.g.: “PA pressure systolic” 
* **SSSOM** - A Simple Standard for Sharing Ontological Mappings
 
## Related Documentation and Materials
* [OMOP CDM ETL convention v.5.3](https://ohdsi.github.io/CommonDataModel/cdm53.html)
* [OMOP CDM ETL convention v.5.4](https://ohdsi.github.io/CommonDataModel/cdm54.html)
* [OMOP CDM ETL convention v.6.0](https://ohdsi.github.io/CommonDataModel/cdm60.html)
* [OMOP Vocabulary Wiki](https://github.com/OHDSI/Vocabulary-v5.0/wiki)
* [THEMIS OMOP CDM conventions](https://github.com/OHDSI/Themis)
* [OMOP CDM ETL Tutorials](https://github.com/OHDSI/Tutorial-ETL)
* [CDM Conversion Best Practices](https://www.ohdsi.org/web/wiki/doku.php?id=welcome:overview:cdm:cdm_conversion_best_practices) (2017)
* [Perseus DEMO at Electronic Health Record Work Group](https://ohdsiorg.sharepoint.com/sites/Workgroup-EHRElectronicHealthRecord/_layouts/15/stream.aspx?id=%2Fsites%2FWorkgroup%2DEHRElectronicHealthRecord%2FShared%20Documents%2FGeneral%2FRecordings%2FElectronic%20Health%20Record%20Work%20Group%20%28EHR%20WG%29%2D20211112%5F080645%2DMeeting%20Recording%2Emp4)(Nov, 2021)
* [Perseus Symposium Showcase](https://www.ohdsi.org/2021-global-symposium-showcase-79/) (2022)
* [Perseus DEMO by SoftwareCountry](https://www.youtube.com/watch?v=1pqblOaR_EQ&embeds_euri=https%3A%2F%2Fsoftwarecountry.com%2F&feature=emb_imp_woyt) (2022)
* [Perseus GitHub](https://github.com/OHDSI/Perseus)  (last update Feb, 2023)
* [Perseus Tutorials](https://github.com/SoftwareCountry/Perseus/wiki)  (last update Oct, 2022)
* [10-Minute Tutorials: ACHILLES](https://www.youtube.com/watch?v=UyS-LAUql-A) (Frank DeFalco, April 13, OHDSI Community Call) (2022)
* [Running Achilles on Your CDM](https://ohdsi.github.io/Achilles/articles/RunningAchilles.html) (2022)
* [Data Quality Dashboard Tutorial](https://www.youtube.com/watch?v=RSUgYA6_Kb4) (2019) (DQD is the part of Perseus)
* [ARES Tutorial](https://www.youtube.com/watch?v=v7MKAamCqQk&t=5s) (Ares combines results from DQD and Achilles) (2022)

## Overview
This document aims to serve as a comprehensive guide for crafting an Extract, Transform, Load (ETL) specification based on the Observational Medical Outcomes Partnership Common Data Model (OMOP CDM) for your project. While an initial ETL specification can be auto-generated via the Rabbit-in-a-Hat tool in a Word document adhering to the OMOP template, we strongly recommend an expert review. This ensures the inclusion of all crucial details necessary for successful ETL implementation

## Selection of Source Data Files
In this section, kindly populate a table enumerating all source files or data elements, specifying their formats. Additionally, include a concise summary of each file's content and its relevance to the OMOP CDM framework. This approach is designed to guarantee the comprehensive identification and inclusion of all vital files within the ETL process. See below an example of the source data representation in an ETL specification:
| #  | Source File Name  | Description                                                                                      | Cab be used in OMOP CDM? |
|----|-------------------|--------------------------------------------------------------------------------------------------|-------------------|
| 1  | t1_procedure         | It is a subset of all procedures                                                                 | Yes               |
| 2  | t2_date           | The table is about date dimension                                                                | Yes               |
| 3  | t3_demographics   | Current patient information including date of birth, birthplace, address, vital status, date of death. | Yes               |
| 4  | t4_suppl          | N/A                                                                                              | No                |

## Selection of Source Data Mapping Approach
This section provides a structured framework for transforming raw source data into the OMOP CDM format, aligning with both project-specific high-level assumptions and OHDSI standards. It's essential to apply this approach uniformly across all data sources undergoing conversion to OMOP CDM. Any substantial modifications to the approach should be duly documented within this section for transparency and consistency.

## Established Mapping Rules
This subsection details the specific rules employed for mapping source data elements to their corresponding fields in the OMOP CDM. By elucidating the mapping logic in a granular manner, these guidelines empower you to gain a deeper comprehension of the data transformation process. OMOP CDM dictates rules that have to be applied during ETL conversion. These rules cover the mapping process from source data to OMOP CDM tables including cleaning rules, deduplication logic, mapping source codes to standard concepts, etc.
