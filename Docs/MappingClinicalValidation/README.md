# Mapping Clinical Validation

The clinical validation of mappings is a cornerstone in elevating the integrity and effectiveness of health data analytics. It guarantees that mappings are true reflections of clinical realities, thereby empowering healthcare professionals to make decisions with confidence, conduct robust research, and optimize patient care. Clinical experts, through meticulous semantic assessments of vocabulary mappings, are instrumental in ensuring the fidelity of data representation. This README serves as a comprehensive guide, detailing the validation tasks, decision scenarios, and protocols for submission, all designed for experts engaged in the critical task of clinical validation of mappings.

## Task Objectives

Clinical Experts are tasked with evaluating the semantic congruence between `source_description` and `target_concept_name`. Expert judgment is crucial in verifying that mappings are semantically consistent and that each pair of terms correctly reflects the same clinical concept.

**Key Responsibilities:**
- Review the provided mappings critically, considering clinical knowledge and context.
- Note any discrepancies or potential improvements that could enhance the mapping accuracy.
- Maintain confidentiality and follow all guidelines for data security and ethical review.

## Scenarios for Decision Making

You will encounter two primary scenarios during the review:

1. **Equivalent Concepts (Correct Mapping)**
   - Indicate a correct mapping by entering '**1**' in the `decision` field.

2. **Divergent Concepts (Incorrect Mapping)**
   - Signal an incorrect mapping by entering '**2**' in the `decision` field.

## Introducing New Mappings

- If a new mapping is deemed necessary, please add a new row(s) to the dataset with the proposed terms and your rationale.

## Review Requirements

Before commencing the review, experts are advised to study the "SOP for Clinical Validation of Mappings." This guide details evaluation criteria, semantic analysis methods, and documentation best practices, ensuring a uniform and high-quality review process.

For each review, document the following:

- `review_date`: The date of review.
- `reviewer_name`: Full name or group name if reviewing as a collective.
- `reviewer_comment`: Justifications for decisions or proposed mappings.
- `orcid_id`: Your ORCID iD, if applicable.

## Submission of Review

Please submit your review in CSV file format using one of the following submission methods:

1. **Google Drive Submission**
   - Upload to the specified [Google Drive folder](https://drive.google.com/drive/folders/1R-8PQ8PUV1aSQyDGQ0O4ltP11Ycco6lM?usp=drive_link).

2. **Email Submission**
   - Send the reviewed document to the provided email address.

3. **GitHub Repository Submission**
   - Submit your review directly by making a pull request to this GitHub repository within the `MappingReviewSubmission` directory. A recommended submission naming rule: MapRev_SiteName_ReviewerFirstName_ReviewerLastName_MMDDYY.csv


## Support

For assistance during your review, please contact the Standards Module team via the [GitHub Issues](https://github.com/chorus-ai/StandardsModule/issues).
