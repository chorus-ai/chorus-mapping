# Delphi Round 2

The Delphi R2 project aims to identify the core data elements that sites can use for data requests. The goal of this data harmonization effort is to support the Delphi project by providing sites with structured and standardized data elements compatible with the OMOP CHoRUS Common Data Model. The mappings are intended to be disseminated for use as a reference and are expected to be integrated into the ETL (Extract, Transform, Load) process.
## CHoRUS Common Data Elements 
The data source is represented in an Excel file named 'CHoRUS Delphi Round 2.xlsx,' which contains the following spreadsheets:
* **Instructions**: provides a description of the Delphi Round 2 effort.
* **Flowsheet Tiers and Categories**: contains a concept set with 1074 complex terms, categorized by source domains, subdomains, data groups, data elements, and original names of flowsheet measures.
* **%ofPatients w Value by ICU Type**: presents data about prioritization principles, such as the frequency of occurrence of various terms in real data across different departments.
* **#ofMeasurements**: details data on the prioritization principles of measurements, including their frequency of occurrence in real data across different departments.
* **#ofMeasurements_per_day**: contains similar data on measurement prioritization principles, focusing on their daily frequency of occurrence in various departments.

According to the 'Flowsheet Tiers and Categories' spreadsheet, the data source field identifies **3 main Data Sources**:
1. Flowsheet Data (893 items)
2. Flowsheet Modality (149 items)
3. Hospital Data Element (32 items).

Data sources contain **14 Data Domains**, categorized as follows:
1. Patient Assessment (253)
2. Observations/Measurements (186)
3. Image (149)
4. Organ Support (113)
5. Speech-Language Pathology (101)
6. Patient Care (81)
7. Surgical (52)
8. Patient Psychology & Behavior (50)
9. Anesthesia (29)
10. Observation/Measurements (23)
11. Patient Pathology (21)
12. Person (8)
13. Physical Therapy (7)
14. Observation (1)
  
As we can observe, there are similar data domains with slight differences in spelling, such as 'Observations/Measurements' versus 'Observation/Measurements.' These are unified during the harmonization process. 

Furthermore, each Data Domain is subdivided into **60 SubDomains**:

1. Vitals (190)
2. Swallow (88)
3. NERVOUS SYSTEM (59)
4. Mechanical Ventilation (53)
5. HEENT (48)
6. CT (39)
7. Renal System (37)
8. FL (36)
9. SKIN (34)
10. X-ray (28)
11. Fall (25)
12. ECMO (24)
13. Ultrasound (23)
14. CARDIAC (20)
15. Left Ventricular Assist Device (LVAD) (19)
16. Musculoskeletal (19)
17. Surgical Airway (18)
18. Agents (18)
19. C-SSRS (17)
20. VASCULAR (17)
21. Dialysis (17)
22. SCALES AND SCORES (16)
23. MRI (16)
24. Infectious Diseases (14)
25. GASTROINTESTINAL (14)
26. Speech (13)
27. Substance Use (13)
28. Chest Tube (13)
29. Daily Activity (12)
30. Gastrointestinal System (9)
31. GI Tube (9)
32. SDoH (8)
33. PATIENT'S SAFETY (8)
34. ASSISTANCE (7)
35. Physical Therapy (7)
36. NM (7)
37. Bronchiolitis (7)
38. PICU (6)
39. POSITIONING (6)
40. Person (6)
41. Post Anesthesia Recovery (6)
42. Toileting (5)
43. LINE CARE (5)
44. DRESSING (5)
45. GENITOURINARY (5)
46. Suction (4)
47. Substance (3)
48. Rectal Tube (3)
49. HYGIENE (3)
50. Medical History (3)
51. Waveform (2)
52. Psychosocial (2)
53. Devices (1)
54. Labs (1)
55. Health Outcome (1)
56. Psychological (1)
57. wound DRESSING (1)
58. Admission (1)
59. BEHAVIOR/MOOD (1)
60. Discharge (1)

## Mapping Value

The establishment of validated and reliable mappings for the data elements outlined in the Delphi R2 project offers significant potential benefits and can address critical global health challenges:

### Benefits and Potential Impact
* **Enhanced Clinical Decision Support**: Reliable data mappings ensure that clinicians have access to accurate and standardized information, improving clinical decision-making processes. This can lead to more personalized treatment plans and better patient outcomes in critical care settings.
* **Improved Patient Safety**: Standardized data elements help in monitoring patient vitals and conditions more effectively, potentially reducing medical errors and adverse events. This results in higher safety standards and better overall patient care.
* **Efficient Research and Development**: Researchers can leverage harmonized data for epidemiological studies and clinical trials, leading to faster discovery and implementation of effective treatments. This standardization also facilitates multicenter studies, allowing findings from diverse populations and settings to be more easily compared and validated.
* **Optimized Resource Allocation**: With standardized data, healthcare facilities can better predict and manage resource needs, such as ICU beds, ventilators, and staff allocation, especially during peak times like pandemics or outbreaks.
* **Policy and Healthcare Planning**: Harmonized data enable health authorities and policymakers to perform more accurate health surveillance, identify trends, assess the effectiveness of interventions, and make informed decisions regarding public health strategies and resource distribution.
### Addressable Global Health Challenges and Questions:
* **Managing Epidemics and Pandemics**: How can data-driven insights improve response strategies to infectious diseases? Standardized ICU data can help track disease progression, outcomes, and the effectiveness of treatment protocols across different regions and populations.
* **Chronic Disease Management**: How can we optimize the care for chronic conditions that frequently lead to ICU admissions, such as heart failure or COPD? Reliable data on patient assessments and organ support can lead to better management strategies and preventive measures.
* **Aging Populations**: How can healthcare systems adapt to the increasing demands of aging populations with higher risks of multiple comorbidities? Standardized data on patient assessments and care protocols can help tailor interventions that improve quality of life and reduce hospitalization rates.
* **Resource Scarcity in Low-Resource Settings**: How can data help mitigate the impact of resource scarcity? By understanding the patterns and needs through standardized data, healthcare systems can implement more effective triage systems and improve outcomes even with limited resources.
* **Interoperability and Data Sharing**: Different healthcare systems can effectively share and utilize data for better health outcomes by adhering to the OMOP CDM to ensure that data shared between institutions is interpretable and useful.



