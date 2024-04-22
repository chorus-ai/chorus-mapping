# Custom Vocabularies

Welcome to the Custom Vocabularies section of our project. This directory houses collections (or vocabularies) of terms (or concepts), that have been specifically developed, augmented, or refined, to address nuanced data representation challenges not adequately captured by the OHDSI Standardized Vocabularies integrated within the OMOP framework. These tailored vocabularies are pivotal in securing extensive coverage, precise accuracy, and effortless integration across the sites within our real-world data corpus.

## Overview

Custom vocabularies are essential for capturing data elements that are unique to certain datasets, locations, or specific research questions. They allow us to standardize and harmonize data that would otherwise be left out or poorly categorized within the broader framework of standard vocabularies.

### Purpose

The main objectives of maintaining this collection of custom vocabularies include:

- Enhancing the specificity and coverage of our data mappings.
- Addressing gaps in OHDSI Standardized Vocabularies for the project's unique requirements.
- Facilitating better data integration, analysis, and research outcomes by providing more granular and relevant categorization options.

### Structure

The Custom Vocabularies directory is organized as follows:

- **Dataset-Specific Folders:** Each folder is tailored to a specific dataset.
- **Vocabulary Files:** Within each dataset-specific folder, you will find CSV files containing the custom vocabulary terms, their codes, and relevant metadata.
- **Vocabulary Tools Folder** A comprehensive suite designed to enhance the exploration, integration, and utilization of custom vocabularies within our data ecosystem.

### How to Contribute

1. **Review Existing Vocabularies:** Before adding a new custom vocabulary, please review the existing files to avoid duplication.
2. **Format Your Data:** Ensure your custom vocabulary adheres to the predefined format (CSV), including all required [OMOP fields](https://ohdsi.github.io/CommonDataModel/cdm54.html#concept).
3. **Document Your Changes:** Include a brief description of your contribution in the `CHANGELOG.md` file, specifying the nature of the addition or modification.
4. **Submit a Pull Request:** Once your vocabulary is prepared and documented, submit a pull request for review. Please include any relevant background information or data sources that support your submission.

## Usage Guidelines

To utilize these custom vocabularies in your projects:

1. **Identify Your Needs:** Determine which vocabularies are relevant to your dataset or research question.
2. **Download and Integrate:** Download the necessary vocabulary files and integrate them into your data transformation or mapping process.
3. **Vocabulary Validation:** Use the tools provided in the `ToolsAndScripts/VocabularyValidation` directory to validate the integration of the custom vocabularies into your data.

## Support

For questions, suggestions, or contributions, please reach out to the project maintainers via [GitHub Issues](https://github.com/chorus-ai/StandardsModule/issues). We're dedicated to continuously improving our custom vocabularies and appreciate your input and collaboration.

## Acknowledgements

We thank all contributors and community members who have dedicated their time and expertise to develop and maintain these custom vocabularies. Your efforts are instrumental in advancing global health!
