# Mapping Metadata Table

A Mapping Metadata Table is a table that records detailed information about mappings between different concepts from various ontologies or vocabularies. This table extends the concept_relationship table by preserving metadata that clarifies the mapping's origin, intent, maintenance, and precision. 

## Schema Definition


| Field | Description | Datatype | Required | Foreign Key | FK Table |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|----------|-------------------|----------------------|
| concept_id_1 | The unique identifier for the first concept in the relationship | integer | YES |  YES|concept_relationship |
| concept_id_2 | The unique identifier for the second concept in the relationship. | integer | YES | YES |concept_relationship|
| confidence | Score between 0 and 1 (0.0-1.0) representing the confidence or probability that the match is correct, where 1 denotes total confidence; e.g., 0.8 indicates 80% confidence | float | YES | NO | |
| predicate_id | Relation between a source (subject) and target (object). It can be exactMatch (1-to-1 full equivalent mapping), narrowMatch (mapping to child), broadMatch (mapping to parent), relatedMatch (mapping to something related) | varchar | YES | NO | |
| mapping_justification| An action or written representation showing a mapping to be right or reasonable | varchar | YES | NO | |
| mapping_provider | URL or description of the source that provided the mapping | varchar | YES | NO | |
| author_id | Unique identifier for the persons or groups responsible for asserting the mappings (auto-generated) | integer | YES | NO | |
| author_label | Names or descriptors of the persons or groups responsible for asserting the mappings | varchar | YES | NO | |
| reviewer_id | Unique identifier for the persons or groups that reviewed and confirmed the mapping (auto-generated) | integer | NO | NO| |
| reviewer_label | Names or descriptors of the persons or groups that reviewed and confirmed the mapping | varchar | NO | NO| |
| mapping_tool | Represents the individual mapping tool used | varchar | NO | NO | |
| mapping_tool_version | Description of the version of the instrument used for mapping | varchar | NO | NO | |

## Recommendations
1) If some concept_id values are unstable in your OMOP instance, it is advisable to use a unique identifier for each mapping. This can be represented by concatenating fields from the concept_relationship table as follows: "concept_code_1||'-'||vocabulary_id_1||'-'||concept_code_2||'-'||vocabulary_id_2". This unique identifier can serve as a foreign key to the concept_relationship table.
   
2) The mapping_justification field utilizes the lexicon from the Semantic Mapping Vocabulary (SEMAPV), which provides and defines terms for creating and maintaining semantic mappings, particularly mapping metadata. Some available values for mapping_justification are:
* **semapv:ManualMappingCuration**: represents valid and unknown mappings that have been manually curated. 
* **semapv:LexicalSimilarityThresholdMatching**: indicates valid mappings established based on lexical similarity between code terms, using techniques such as fuzzymatch (difference), Levenshtein, and Jaro-Winkler. 
* **semapv:LexicalMatching**: represents valid mappings established purely based on lexical matching between the source name and target name or synonym
* **semapv:CompositeMatching**: denotes valid mappings established using a combination of different matching techniques (e.g., regexps, case, digit, character suppression) and criteria (similarity thresholds).
* **semapv:LevenshteinEditDistance**: indicates valid mappings established solely based on the Levenshtein Edit Distance algorithm.
* **semapv:DigitSuppression**: represents valid mappings confirmed by suppressing or ignoring digits in names.
* **semapv:LinkStripping**: indicates valid mappings confirmed by removing or stripping specific parts of the codes.
