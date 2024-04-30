# SSSOM-to-OMOP Converter

The SSSOM-to-OMOP Converter is a Python tool that generates INSERTS from a SSSOM mapping table into the OMOP Vocabulary basic tables (concept, concept_relationship).

## Required Source Fields
| Field Name              | Required |
|-------------------------|----------|
| mapping_source          | Y        |
| mapping_set_id          | N        |
| mapping_set_label       | Y        |
| subject_category        | N        |
| subject_id              | Y        |
| subject_label           | Y        |
| predicate_id            | Y        |
| object_id               | Y        |
| object_label            | Y        |
| confidence              | Y        |
| mapping_cardinality     | Y        |
| mapping_justification   | Y        |
| author_id               | N        |
| author_label            | Y        |
| reviewer_id             | N        |
| reviewer_label          | Y        |
| mapping_provider        | N        |
| mapping_date            | Y        |
| mapping_tool            | N        |
| mapping_tool_version    | N        |
| subject_source_version  | N        |
| subject_type            | N        |

## Functions
1. **get_delimiter**:
    * Determines the delimiter used in a CSV file by reading a sample of the file.
    *    Uses csv.Sniffer() to infer the format of the CSV and returns the delimiter found.
2. **check_req_fields**:
    * Ensures that a DataFrame contains all required columns for processing.
    * Checks against a list of expected column names (req_fields) and raises an error if any are missing.
    * Logs the verification process using a provided logger object.
3. **split_table**:
    * Splits a CSV file into different components based on the OMOP CDM structure and relevant data fields.
    * Reads the CSV file, determines its delimiter, and verifies required fields.
    * Extracts and deduplicates specific data subsets: source vocabulary metadata, mapping metadata, and concept relationships.
    * Returns these subsets as separate tables.
4. **check_vocabulary**:
    * Validates and updates the vocabulary information in the database.
    * Checks if each vocabulary in the source data exists in the database; if not, inserts it.
    * Logs each step of the process, indicating whether vocabularies were found, added, or updated.
5. **upload_concept**:
    * Inserts a new concept record into a staging table in the database.
    * Commits the changes to ensure data persistence.
6. **upload_concept_relationship**:
    * Inserts a new relationship record between concepts into a staging table in the database.
    * Commits the changes for data persistence.
7. **get_concept_info**:
    * Retrieves concept information from the database based on the concept identifier or concept code.
    * Supports identifiers prefixed with "OMOP" and others, catering to different concept referencing methods.
8. **processing_n_upload**:
    * Processes and uploads data regarding concepts and their relationships.
    * For each record, it checks if an object ID corresponds to a concept and handles data accordingly.
    * Inserts both concept and relationship data into the database.
9. **upload_to_db_meta**:
    * Manages the database table for metadata mapping.
    * Checks if the mapping_metadata table exists, creates it if necessary, and uploads data to it.
    * Handles tuple-based insertion of rows to avoid SQL injection.
10. **lookup**:
    * Prepares and saves tables into CSV files in a specified directory for further lookup or analysis.
    * Logs the completion of the file creation process.

## Instructions
1. Review the Field Req.xlsx to understand what fields are required in the source table.
2. Ensure that the required fields are present in the source table.
3. Modify db_conf.py with your database settings.
4. Run the main.py script using the following command: main.py --path_to_the_file/--path_to_lookup (path_to_lookup is optional).

As a result, a file called _**sssom_to_omop.log**_ will be created in the working folder, which will show the progress of the conversion.

## Next Steps
1. Preprocessing of a SSSOM mapping table, such as deduplication and filling empty fields
2. Processing of unmapped source terms in a SSSOM mapping table
3. Implementation of the concept_ancestor and concept_synonym tables.
