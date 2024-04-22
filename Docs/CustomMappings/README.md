# Custom Mappings

In the OHDSI/OMOP world, **custom mappings** refer to the specialized, user-defined associations (or maps) between source data terminology and the OHDSI standardized vocabulary terms. These mappings are crafted to address unique or uncommon data elements that are not directly covered by the default vocabularies and mappings provided by the OMOP framework.

This directory serves as a conduit between various health data sources and the OMOP CDM. Within the framework of this project, we prioritize the seamless integration of specialized datasets into our analytical infrastructure. 
These datasets are integral to the project for several reasons, particularly due to their focus on intensive care settings:
* **Flowsheet Data (Delphi R2)**: Flowsheet data are critical as they provide granular, time-stamped observations of patient status and treatments in intensive care units (ICUs) and other acute care settings. They include vital signs, medication administration, lab results, and nursing observations, offering a detailed timeline of patient care.
* **MIMIC-IV Database**: The Medical Information Mart for Intensive Care (MIMIC-IV) is a vast repository of de-identified health data associated with over forty thousand patients who stayed in critical care units of the Beth Israel Deaconess Medical Center in Boston, Massachusetts. Its importance lies in the depth and breadth of ICU data it provides, including demographic details, vital signs, laboratory test results, medications, and more. This database is invaluable for modeling critical care processes, understanding patient trajectories in ICUs, and developing predictive models for patient outcomes.
* **Case Report Forms (CRFs) for the Coma Curing Campaign**: These CRFs are tailored to capture specialized data on coma recovery, including interventions, patient responses, and long-term outcomes. The data gathered through these forms are crucial for research into coma recovery techniques, helping to identify effective treatments and care strategies for patients in comatose states. By focusing on coma recovery, the project addresses a critical area of intensive care and neurology, contributing valuable insights into patient rehabilitation and prognosis.

## Collaboration and Contribution

We warmly invite the sites to actively participate in enhancing our custom mapping collection. Your contributions, whether through the refinement of existing mappings or the introduction of new datasets, are invaluable. Leveraging your expertise can substantially enrich the scope and precision of health data harmonization and analysis, driving forward our collective understanding and capabilities in this critical field.

## Access and Utilization

The `CustomMappings` directory is designed for user-friendly access and engagement. We invite you to explore the mappings, apply them in your ETL and research, and contribute feedback for continuous improvement, fostering a collaborative environment for health data science.

## Future Plans

Our forward-looking vision encompasses the creation of a Unified Vocabulary and Mapping Browser as a central hub, offering streamlined access to an extensive collection of mapping resources. It will facilitate effortless exploration of mappings and enhance the ETL workflow with features supporting real-time collaboration and documentation, ensuring a more efficient and integrated experience.
