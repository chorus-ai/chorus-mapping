# Standard Operating Procedure for Clinical Validation of Health Data Mappings

# Introduction

This Standard Operating Procedure (SOP) is meticulously crafted to guide clinical experts, researchers, data scientists, and healthcare IT professionals through the nuances of health data harmonization within the OHDSI/OMOP framework. Its core aim is to delineate the procedures for clinical validation of health data mappings, emphasizing accuracy, reliability, reusability, and adherence to clinical standards.

This SOP presents a structured approach to the clinical validation process, crucial for preserving the fidelity of data translations. It is designed to facilitate seamless collaboration among various experts, providing detailed instructions, methodologies, and clear definitions for navigating mapping scenarios and review mechanisms. Ultimately, this document seeks to elevate the caliber of harmonized data utilized in healthcare research, ensuring it reflects true clinical semantics and practices.

# Value

The clinical validation of mappings plays a pivotal role in enhancing the _quality and efficacy of health data analytics_. By ensuring that mappings accurately represent real-world clinical data, healthcare professionals can rely on them for precise decision-making, research, and patient care optimization. Below, we delve into the key benefits of this validation process to demonstrate its impact:

1. **Improved data quality and consistency:** clinical validation of mappings ensures that data from varied sources are consistently and accurately translated into the standard OMOP format. This uniformity is crucial for reliable data analysis across different healthcare settings. After implementing validated mappings, the consistency of patient data across their facilities will be improved, significantly enhancing the reliability of cross-institutional studies.
2. **Enhanced predictive analytics:** validated mappings contribute to more accurate predictive models in healthcare. For example, a research project utilized clinically validated mappings for patient data, resulting in an increase in the accuracy of predictive models for patient readmissions. This improvement will be directly translated into better patient care strategies and resource allocation.
3. **Facilitated data sharing and collaboration:** with clinically validated mappings, data sharing across different healthcare entities becomes seamless and efficient. Validated mappings enable quicker and more accurate data pooling for a large-scale study, reducing data preparation time.
4. **Compliance with clinical standards:** сlinically validated mappings ensure compliance with evolving clinical standards and practices, thereby maintaining the relevance and applicability of the data. The use of validated mappings can reduce compliance-related discrepancies, aligning their data more closely with real-world scenarios.

# Validation Approach

The mappings’ clinical validation approach is a meticulous and multi-faceted process designed to ensure the highest level of data reliability and applicability. This section provides a detailed overview of the essential steps and methodologies in the validation process, _specifically designed for clinical experts_ tasked with or responsible for performing the clinical validation of mappings.

## General principles of clinical validation of mappings

1. Although clinical validation of mappings is not a standard requirement in ETL processes, we regard it as an essential component of the mapping axis within our ETL pipeline to guarantee the medical accuracy and utility of the data.
2. Clinical validation of mappings is conducted by _clinical experts_.
3. An efficient, centralized, real-time _collaborative workspace_ is essential to streamline asynchronous work and maintain transparency by attributing feedback to contributors.
4. _Asynchronous review methodology_ enables healthcare experts from diverse sites to participate in the review process at their own pace, ensuring continuous updates.
5. _Flexible participation_ allows reviewers to contribute voluntarily or through assigned tasks, offering varying levels of engagement.
6. Scheduled _regular reviews_ (monthly, quarterly, or biannually) and _ad hoc reviews of mappings_ are recommended to stay aligned with workflow changes or vocabulary updates.

## 1\. Mapping table discovery

Familiarize yourself with the structure of the table containing mappings, use a data dictionary if present to get information about each field meaning.

#### Mapping Table Structure

The structure of a mapping table is a fundamental component in the clinical validation process. This section outlines the key elements and design of the mapping table, which is instrumental for ensuring the accuracy of data mappings. A mapping table may vary in its fields depending on the chosen format for mapping sharing. It could be an SSSOM mapping table, an extended source_to_concept_map (enhanced with additional fields like target_domain_id and relationship_id), staging tables, or any other type of lookup table that is familiar to a participating site.

#### Mapping Table Design Considerations

- The table's structure should be intuitive and user-friendly for clinical experts and data scientists. For example, source values should be positioned on the left, while target values are aligned on the right, facilitating ease of navigation and comparison.
- The presence of a data dictionary is always beneficial.
- The design should accommodate future expansions or modifications, such as adding new fields.
- Ensure that the naming conventions and data formats employed are not only consistent but also in compliance with the established standards relevant to your project.
- Implement measures to prevent the entry of secure, sensitive data into the mapping table.

Below is a table detailing _potential_ fields (columns) and their definitions, which are commonly encountered in a mapping table:

| **column name** | **data type** | **definition** |
| --- | --- | --- |
| source_code/subject_id | varchar | Represents the original code used in the source data. This is the primary identifier for the data element before it is mapped to the standardized OMOP format. |
| source_concept_id | integer | An auto-generated ID for the source term, serving as a unique identifier within the source system. |
| source_vocabulary_id | text | Identifies the vocabulary or coding system used in the source data. Can reflect the origin of the dataset. |
| source_description / subject_label / source_name | varchar | Provides a descriptive name or label for the source term, aiding in its identification and contextual understanding. |
| source_description_synonym/<br><br>subject_synonym | varchar | Includes additional names or synonyms for the source term. |
| predicate_id | varchar | Denotes the relationship between the source (subject) and target (object), essential for understanding the mapping direction and logic (see Mapping Scenarios). |
| confidence | float8 | A score between 0 and 1 indicating the confidence or probability that the mapping is correct, with 1 denoting total confidence. Essential for understanding the mapping logic (see Mapping Scenarios). |
| target_concept_id | integer | The standard OMOP concept ID to which the source term is mapped. |
| target_concept_name | varchar | The name of the standard OMOP concept to which the source term is mapped. |
| target_vocabulary_id | varchar | Identifies the vocabulary or coding system used in the target OMOP data. |
| target_domain_id | varchar | Specifies the domain or category of the target OMOP concept, such as Measurement, Drug, Condition, Procedure, etc. |

## 2\. Source data exploration

Ensure that the mapping table exclusively includes mappings of high-priority source terms that warrant your validation efforts. If feasible, establish criteria to discern the priority of these source term mappings. Criteria may include the frequency of concept usage, its clinical significance, impact on patient outcomes, and relevance to current research. For instance, in clinical validation of flowsheet mappings, we used prioritized terms by Delphi Round 2. Another SQL-based data prioritization approach focused on pattern matching was presented in [Office Hours](https://drive.google.com/drive/u/4/folders/16ZtT6FATdpjhciXo8rkE_A6OaLLYs_K6).

After ensuring that the list of mappings for validation is properly prioritized, perform an analysis of the source data. This analysis should concentrate on aspects such as structure, content, and context, encompassing an examination of source codes, descriptions, and associated metadata. Additionally, assess the domains and categories to gain a more comprehensive understanding of the context.

## 3\. Comparative mapping analysis

Perform a comprehensive, row-by-row comparison between the source and target labels (names) taking into account all relevant metadata (synonyms, categories, domains, units). Utilize clinical expertise to evaluate the appropriateness of each mapping. This involves consulting with other healthcare professionals and referencing key clinical literature to validate the clinical relevance of the mappings. Utilize the [OHDSI Athena](https://athena.ohdsi.org/search-terms/start) tool for browsing OMOP concepts and mappings. Review carefully concepts from the source data that do not have a match in the OMOP standard vocabulary. This step is critical in pinpointing areas where the existing vocabulary may need expansion or refinement. If you find the appropriate mapping, replace the existing mapping to 0 with the mapping you found.

### Mapping Scenarios

This various mapping scenarios might be encountered in the process of mapping validation. Understanding these scenarios is crucial for clinical experts and researchers, data scientists, and healthcare IT professionals to effectively navigate the complexities of data harmonization and ensure the accuracy and reliability of mappings. Scenarios 1 through 3 shows good coverage by OMOP Standardized Vocabularies, while scenarios 4 through 11 highlight potential gaps:

| **Scenario Number** | **Scenario Name** | **Description** | **OMOP relationship** | **Action** |
| --- | --- | --- | --- | --- |
| 1   | Single Exact Match with High Confidence (1-to-1) | The source term matches exactly with one target term in the OMOP standard, and the confidence level is high (close to 1). | Maps to | Validate the mapping, despite high confidence, to confirm its accuracy. |
| 2   | Multiple Exact Matches with Varying Confidence Levels (1-to-1 with a Rule) | Several target terms in OMOP exactly match the source term, but with different confidence scores. | Maps to | Reviewer must decide on the most appropriate match, considering context and confidence scores. |
| 3   | Single Exact Match with High Confidence (1-to-1) AND Exact Match Value | Suggests that the source term's mapping includes an extra layer of information, - a value or result of observation or measurement | Maps to + Maps to value | Verify the accuracy of how a value is represented in relation to its associated variable. |
| 4   | Single Broad Match with High Confidence (1-to-1 but broad, “Is a”) | The source term broadly matches with one or more less specific (parent) target terms in OMOP, with high confidence. | Maps to/Is a | Validate the best fit, noting some detail may be lost in this broader categorization. |
| 5   | Single Narrow Match with High Confidence (1-to-1 but narrow, “Subsumes”) | The source term narrowly matches with one or more specific (child) target terms in OMOP, with high confidence. | Maps to/Subsumes | Ensure the added granularity of the target term is relevant and beneficial. |
| 6   | Multiple Broad Matches with Different Confidence Levels (1-to-1 but broad, “Is a” and Rule) | Several less specific (parent) target terms in OMOP match the source term, each with varying confidence levels. | Maps to/Is a | Identify and validate the most appropriate parent term, prioritizing higher confidence scores. |
| 7   | Multiple Narrow Matches with Different Confidence Levels (1-to-1 but narrow, “Subsumes” and a Rule) | A number of less specific (parent) target terms in OMOP correspond to the source term, all sharing the same level of confidence. This implies that each of these parent terms is equally relevant. | Subsumes | Verify that each target concept is a semantically appropriate parent. |
| 8   | Multiple Broad Matches with Identical Confidence Levels (1-to-many, “Is a”) | Several more specific (child) target terms in OMOP are aligned with the source term, each displaying equal confidence levels. | Maps to/Is a | Validate that all target concepts are semantic parents. |
| 9   | Multiple Narrow Matches with Identical Confidence Levels (1-to-many, “Subsumes”) | Several more specific (child) target terms in OMOP match the source term, each with equal confidence levels. This implies that each of these child terms is equally relevant. | Subsumes | Confirm that all target concepts are semantically valid children and relevant. |
| 10  | Related Match Only (no “Maps to” to OMOP standard) | The source term only has a related match in OMOP, without a direct equivalent. | Has asso finding/Has asso device/Has asso procedure | Assess if the related term sufficiently captures the essence of the source term. |
| 11  | No Match | There is no suitable mapping available in OMOP for the source term. | no “Maps to” to OMOP standard | Consider submitting the term as a candidate for addition to the OMOP vocabulary, following the [community contribution](https://github.com/OHDSI/Vocabulary-v5.0/wiki/Community-contribution) process. |

Each of these scenarios requires a careful and context-specific approach. The validation process must take into account the nuances of each case, leveraging clinical expertise and data analysis skills to ensure that the mappings are technically accurate, clinically meaningful and useful.

### Evaluating Mappings

When comparing two terms (concepts) semantically, especially in a clinical context, we are evaluating the meaning and usage of each term to determine their equivalence, hierarchy, or relationship. Usually, the comparison involves _several layers of linguistic and clinical analysis_:

- **Lexical analysis:** compare the fundamental words (lexemes) in both terms. Key lexemes which are present in both terms, suggesting a conceptual link.
- **Synonyms and naming variations:** determine if different words or phrases are used to express similar concepts, such as "CT" and "Computed Tomography”.
- **Syntax and structure:** analyze the grammatical structure of each term. Identify whether the subject is the same even if it is not stated but implied. Note the presence of modifiers that qualify the main action.
- **Semantic analysis:** when comparing terms semantically, it can be helpful to analyze and compare the six semantic dimensions (LOINC-borrowed Parts):

1. **COMPONENT (ANALYTE)**: describes the main focus of the observation or measurement.
2. **PROPERTY**: is the attribute or characteristic observed. Some terms might not distinctly define a PROPERTY, as they are more procedural than observational.
3. **TIME**: is typically a single point or a duration. If terms seem to describe a single procedure, they would likely share the same TIME part, such as "Pt" for Point in time.
4. **SYSTEM (SPECIMEN)**: describes the specimen or site of the observation or measurement.
5. **SCALE**: indicates how the observation or measurement is expressed. It can be Quantitative(Qn), Ordinal(Ord), Nominal(Nom), Narrative(Nar).
6. **METHOD**: used if the technique affects the clinical interpretation.

- **Contextual usage:** consider the context in which the terms are used.
- **Clinical equivalence:** despite differences in specificity, terms might be considered clinically equivalent if they refer to the same event, but this depends on the context in which the terms are used.
- **Pragmatic analysis:** reflect on how the terms are used in clinical communication.
- **Implication and inference:** deduce implicit meanings, as certain terms may lack explicit information in their names, but implicit connotations can be inferred.

## 4\. Decision Making

The decision making is a crucial phase in the clinical validation process of mappings. It involves making informed choices based on clinical experience and knowledge. This section will guide you through the key steps and considerations in the decision-making process.

1. **Analyzing validation results:** compile and synthesize the results from the validation steps. Look for patterns or recurring issues in the validation data that might influence mapping decisions.
2. **Making informed decisions:** use established criteria to make decisions on mappings. This includes assessing accuracy, clinical relevance, and consistency with the OHDSI/OMOP standards and real-world settings. Strive to find a balance between technical accuracy and practical applicability in clinical settings.
3. **Documenting decisions:** record each decision made during the process, including the rationale and supporting evidence. This documentation is vital for transparency and future reference (see Review feedback submission).
4. **Updating the mapping table:** reflect these decisions in the mapping table, ensuring that it remains an accurate and up-to-date resource.
5. **Continuous improvement:** establish a feedback loop to review the impact of these decisions on data quality and clinical utility, making adjustments as necessary. Regularly communicate with all stakeholders, including other clinical experts and data scientists, to ensure the decisions meet the needs of all users.

## 5\. Testing Methodology

Here, we present a potential methodology for conducting large-scale testing of mapping validation outcomes:

- Establish a _controlled testing environment for mapping integration_ that mirrors real-world usage scenarios as closely as possible.
- Develop _test cases_ for high-priority mappings. These should cover _concrete use cases_ and data conditions to ensure comprehensive testing.
- Incorporate confidence scores in testing to evaluate the probability of each mapping’s correctness and adjust tests accordingly.
- Implement a feedback system to capture insights from the testing phase. Feedback should be detailed, indicating successes, failures, and areas for improvement.
- Adopt an iterative approach, where test results lead to adjustments in mappings, followed by further rounds of testing. This _continuous loop_ enhances the accuracy and reliability of the mappings.
- Document all testing procedures, results, and subsequent modifications. Reporting should be clear and accessible to all stakeholders involved in the mapping process.
- Analyze test results to identify _patterns, successes, and areas needing improvement_.
- _Integrate successful mappings into the main mapping table._ For mappings that need revision, document the required changes and rationale.
- Use the insights gained from testing to _continually refine the mapping_, enhancing their overall quality and utility.

## 6\. Review feedback submission
To streamline the review process and enhance the precision of health data mappings, we advocate for the implementation of a standardized protocol for submitting **mapping clinical validation feedback** within each participating site. This approach is especially crucial given the lack of a centralized vocabulary browser for reviewing validated terms and mappings.

### Recommendations for Each Review:

- **Leverage predicate_id values and confidence scores:** utilize the information provided by predicate_id values and confidence scores to define specific mapping scenarios.
- **Populate the reviewer_name and review_date fields:** enter relevant information in the reviewer_name and review_date fields to accurately record the reviewer's identity and the date of the review process.
- **Populate the decision field:** after determining the correctness of a mapping, populate the decision field accordingly. If the mapping is correct, mark it as '1' in the decision field ('correctly mapped'). If the mapping is incorrect or requires removal, mark it as '2'. In cases where mappings need to be removed, provide comments explaining the rationale for the changes. Ensure any unresolved cases are highlighted for further review.
- **Propose new mappings:** if an exact match exists elsewhere or a related, broad, or narrow match is deemed appropriate, propose a new mapping. Comment this addition with a clear justification to maintain transparency and traceability in the decision-making process.

### Essential Documentation for Each Review:

- `review_date`: Date when the review was conducted.
- `reviewer_name`: The full name of the individual reviewer or the name of the reviewing group.
- `reviewer_comment`: Explanations or rationales behind the review decisions or suggestions.
- `orcid_id`: The ORCID iD of the reviewer, if available.

### Submission Methods

Reviews should be submitted in CSV format through one of the below channels:

#### Google Drive Submission

- Files should be uploaded to the designated [Google Drive folder](https://drive.google.com/drive/folders/1R-8PQ8PUV1aSQyDGQ0O4ltP11Ycco6lM?usp=drive_link).

#### Email Submission

- Reviewed documents should be sent to the specified email address.

#### GitHub Repository Submission (the best option)

- Reviews can be directly submitted by creating a pull request to the [`MappingReviewSubmission`]() directory within this GitHub repository. 

**Recommended Naming Convention for Submissions:** 

`MapRev_SiteName_ReviewerFirstName_ReviewerLastName_MMDDYY.csv`

This structured submission protocol ensures efficient feedback collection and enhances the traceability and integrity of the clinical validation process.

## 7\. Ongoing review and updates

If possible, establish a schedule for regular sessions for clinical validation of mappings, and actively update mappings in response to findings from regular reviews. This involves anticipating and adapting to changes in the data based on feedback and new information. Ensure timely reporting of these updates to the individuals responsible for maintaining standards.

# Conclusion

The process of clinical validation of mappings to OHDSI/OMOP is a meticulous and ongoing endeavor. It requires a collaborative effort among clinical experts and researchers to ensure that mappings are accurate, clinically relevant, and aligned with current healthcare standards and practices.

We extend our appreciation to the dedicated professionals who have contributed their collective expertise and collaborative effort to shape the clinical validation of mapping. This endeavor has brought together individuals from diverse backgrounds, united by a shared objective: _precision and reliability within the realm of healthcare data standards._ Our success in publishing this guide has been built on a foundation of collaboration and open communication. Through this validation process, we have collectively deepened our understanding of available health data standards. The lessons learned from each validation effort contribute to our evolving knowledge base, making us better equipped to navigate the complexities of health data harmonization. Our commitment to learning ensures that we continue to refine our practices and elevate our standards.

The journey of clinical validation of mappings is not a destination but an ongoing commitment to excellence. It demands our unwavering dedication, diligence, and a relentless pursuit of precision. Our work in healthcare data analytics directly impacts patient care and drives advancements in healthcare research. All of us are the custodians of data quality, and our commitment to maintaining the highest standards is our pledge to those who rely on our work. Together, we stand at the forefront of healthcare data quality, poised to shape the future of healthcare for the better.

# Future Plans

1) **Unified CHoRUS Vocabulary and Mapping Browser**: looking ahead, our vision includes the development of a unified online environment that will revolutionize the way we approach mapping browsing and clinical validation. This platform will serve as a central hub, bringing together the entire community of healthcare data professionals. It will offer a seamless experience for mapping exploration, ensuring easy access to comprehensive mapping resources. Additionally, it will streamline the clinical validation process, providing real-time collaboration and documentation features.

2) **Embracing the power of Natural Language Processing (NLP)** is another exciting avenue on our roadmap. NLP has the potential to significantly enhance our ability to compare and validate mappings by analyzing and understanding the semantic nuances of healthcare terms. We plan to explore NLP-driven solutions that can automate certain aspects of the validation process, making it more efficient and accurate. LLMs can be implemented for terms comparison by utilizing their natural language understanding and semantic analysis capabilities to assess the similarity or relatedness between terms based on context, meaning, and language patterns.
