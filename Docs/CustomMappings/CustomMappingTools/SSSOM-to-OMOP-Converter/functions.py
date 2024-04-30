from datetime import datetime, date
import pandas as pd
import csv

def get_delimiter(file_path, bytes = 4096):
    sniffer = csv.Sniffer()
    data = open(file_path, "r").read(bytes)
    delimiter = sniffer.sniff(data).delimiter
    return delimiter

def check_req_fields(file, _logger):
    col = file.columns
    req_fields = ["mapping_source", "subject_id",
                  "subject_label","predicate_id", "object_id","object_label", "confidence",
                  "mapping_cardinality","mapping_justification","mapping_date","author_label",
                  "reviewer_label"]
    missing_fields = []
    for field in req_fields:
        if field not in col:
            missing_fields.append(field)
        else:
            pass
    if len(missing_fields) > 0:
        raise ValueError(f"Required fields {missing_fields} are not found in the file")
    else:
        pass
    return _logger.debug(f'{datetime.now()} Required fields found in the file')

def split_table(path_to_file, _logger) -> dict:
    file=pd.read_csv(path_to_file, sep=get_delimiter(path_to_file))

    check_req_fields(file, _logger)

    # extract source vocabulary metadata
    source_vocabulary = file[["mapping_source",
                              "subject_source_version"]].drop_duplicates()

    meta_fields =["mapping_source","mapping_set_id","mapping_set_label","mapping_set_description","subject_category",
                  "confidence","mapping_cardinality","mapping_justification","author_id","author_label","reviewer_id",
                  "reviewer_label","mapping_provider","mapping_date","mapping_tool","mapping_tool_version","subject_id",
                  "predicate_id","object_id"]

    # extract mapping information
    mapping_metadata = file[[x for x in file.columns if x in meta_fields]].drop_duplicates()

    # concept_relationship (CR) creation
    cr_stage = file[["mapping_source","subject_id","subject_label","predicate_id","object_id","mapping_date"]].drop_duplicates()

    return {
        "concept": cr_stage,
        "justification": mapping_metadata,
        "vocabulary_version": source_vocabulary
    }

def check_vocabulary(conn, cur, source_table, _logger):
    source_vocabulary = source_table["mapping_source"].unique()
    cur.execute("SELECT MAX(concept_id) + 1 FROM concept")
    ex_concept_id = cur.fetchone()[0]
    i = 1
    for voc in source_vocabulary:
        voc = voc.split(":")[1]
        cur.execute("SELECT vocabulary_id FROM vocabulary WHERE vocabulary_id = %s",(voc,))
        concept_id=ex_concept_id+i
        i += 1
        if cur.rowcount == 0:
            _logger.debug(f'{datetime.now()} Vocabulary {voc} not found in vocabulary table')
            cur.execute("INSERT INTO concept (concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason) VALUES (%s, %s, 'Metadata', 'Vocabulary', 'Vocabulary', NULL, 'OMOP generated', TO_DATE ('19700101', 'YYYYMMDD'), TO_DATE ('20991231', 'YYYYMMDD'), NULL)",(concept_id, voc))
            conn.commit()
            cur.execute("INSERT INTO vocabulary (vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id) VALUES (%s, %s, %s, %s, %s)",(voc, voc, voc, voc, concept_id))
            conn.commit()
            _logger.debug(f'{datetime.now()} Vocabulary {voc} added to vocabulary table')
        else:
            _logger.debug(f'{datetime.now()} Vocabulary {voc} found in vocabulary table')
            cur.execute("UPDATE vocabulary SET vocabulary_version = %s WHERE vocabulary_id = %s",(voc, voc))
            _logger.debug(f'{datetime.now()} Vocabulary {voc} updated in vocabulary table')
    conn.commit()
    return _logger.debug(f'{datetime.now()} Vocabulary checking finished')

def upload_concept(conn, cur, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date):
    cur.execute("INSERT INTO concept_stage (concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                (concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code, valid_start_date, valid_end_date))
    conn.commit()
    return True

def upload_concept_relationship(conn, cur, concept_code_1, vocabulary_id_1, concept_code_2, vocabulary_id_2, relationship_id, valid_start_date,valid_end_date):
    cur.execute("INSERT INTO concept_relationship_stage (concept_code_1, vocabulary_id_1, concept_code_2, vocabulary_id_2, relationship_id, valid_start_date, valid_end_date) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (concept_code_1, vocabulary_id_1, concept_code_2, vocabulary_id_2, relationship_id, valid_start_date,valid_end_date))
    conn.commit()
    return True

def get_concept_info(cur, concept):
    if concept.split(':')[0] == 'OMOP':
        cur.execute("SELECT concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code FROM concept WHERE concept_id = %s",(concept.split(':')[1], ))
    else:
        cur.execute("SELECT concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept, concept_code FROM concept WHERE concept_code = %s AND vocabulary_id = %s",(concept.split(':')[1],concept.split(':')[0]))
    return cur.fetchone()

def processing_n_upload(conn, cur, table, _logger):
    valid_start_date=date.today().strftime("%Y-%m-%d")
    valid_end_date="2099-01-01"
    for ind, row in table.iterrows():
        if ":" in row["object_id"]:
            _logger.debug(f'{datetime.now()} {row["object_id"]} is a concept')
            info=get_concept_info(cur, row["object_id"])
            concept_name=row["subject_label"]
            vocabulary_id=row["mapping_source"].split(":")[1]
            standard_concept=None
            domain_id=info[2]
            concept_class_id=info[4]
            concept_code=row["subject_id"].split(":")[1]
            upload_concept(conn, cur, concept_name, domain_id, vocabulary_id, concept_class_id, standard_concept,
                           concept_code, valid_start_date, valid_end_date)

            concept_code_1=concept_code
            vocabulary_id_1=vocabulary_id
            concept_code_2=info[6]
            vocabulary_id_2=info[3]
            relationships={'skos:broadMatch': 'Is a', 'skos:exactMatch': 'Maps to', 'skos:narrowMatch': 'Subsumes',
                           'skos:closeMatch': 'Related to'}
            upload_concept_relationship(conn, cur, concept_code_1, vocabulary_id_1, concept_code_2, vocabulary_id_2,
                                        relationships[row['predicate_id']], row["mapping_date"], valid_end_date)
        else:
            _logger.debug(f'{datetime.now()} {row["object_id"]} is not a concept, source conept will not be processed')
            pass

    return _logger.debug(f'{datetime.now()} Tables concept_stage and concept_relationship_stage uploaded to DB')

def upload_to_db_meta(conn, cur, table, _logger):
    cur.execute(f"SELECT EXISTS(SELECT relname FROM pg_class WHERE relname = 'mapping_metadata');")
    if cur.fetchone()[0] == False:
        _logger.debug(f'{datetime.now()} Table mapping_metadata does not exist, creating table')
        cur.execute('''Create table mapping_metadata(
            mapping_source text,
            mapping_set_id text,
            mapping_set_label text,
            mapping_set_description text,
            subject_category text,
            confidence text,
            mapping_cardinality text,
            mapping_justification text,
            author_id text,
            author_label text,
            reviewer_id text,
            reviewer_label text,
            mapping_provider text,
            mapping_date text,
            mapping_tool text,
            mapping_tool_version text,
            subject_id text,
            predicate_id text,
            object_id text)
            ''')
        conn.commit()
        _logger.debug(f'{datetime.now()} Table mapping_metadata is created, uploading data')
    else:
        _logger.debug(f'{datetime.now()} Table mapping_metadata exists, uploading data')
    tuples=list(set([tuple(x) for x in table.to_numpy()]))
    cols=','.join(list(table.columns))
    query="INSERT INTO mapping_metadata(%s) VALUES(%%s,%%s,%%s,%%s)" % (
        cols,)
    for t in tuples:
        cur.execute(query, t)
    conn.commit()
    return _logger.debug(f'{datetime.now()} Table mapping_metadata is uploaded to DB')

def lookup(tables, path_to_lookup, _logger):
    for r in tables:
        tables[r].to_csv(path_to_lookup + "Table_" + str(r), index=False)
    return _logger.debug(f'Tables are prepared for lookup in {path_to_lookup}')
