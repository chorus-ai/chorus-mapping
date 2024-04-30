from sys import argv
import db_conf as db
import psycopg2
import logging
import os
import functions as f
from datetime import datetime

# log files
_logger = logging.getLogger("SSSOM_to_OMOP")
_logger.setLevel(logging.DEBUG)
_logger.addHandler(logging.FileHandler(os.getcwd()+"/sssom_to_omop.log"))
_logger.addHandler(logging.StreamHandler())

# extract intent information
path_to_file=argv[1]

try:
    path_to_lookup=argv[2]
except:
    path_to_lookup = os.getcwd() + "/lookup/"

_logger.debug(f'{datetime.now()} Path to the file is {path_to_file}')
_logger.debug(f'{datetime.now()} Path to the lookup is {path_to_lookup}')

# connect to DB
_logger.debug(f'{datetime.now()} Trying to connect to {db.db["host"]}')
conn = psycopg2.connect(
    dbname = db.db["db"],
    host = db.db["host"],
    port = db.db["port"],
    user = db.db["user"],
    password = db.db["passwd"],
    options="-c search_path={}".format(db.db["schema"])
)

_logger.debug(f'{datetime.now()} Connection to {db.db["host"]} established')
cur = conn.cursor()
cur.execute('show search_path')
_logger.debug(f'{datetime.now()} Search path is {cur.fetchone()}')
with open("prerun.sql", "r") as s:
    sql = s.read()
cur.execute(sql)
conn.commit()

# split a source file to tables
_logger.debug(f'{datetime.now()} Splitting a source file to tables')
tables = f.split_table(path_to_file, _logger)

# create lookup tables
_logger.debug(f'{datetime.now()} Creating lookup tables')
f.lookup(tables, path_to_lookup, _logger)

# vocabulary checking
_logger.debug(f'{datetime.now()} Start checking vocabulary')
f.check_vocabulary(conn, cur, tables["vocabulary_version"], _logger)

# start process and upload tables to DB
_logger.debug(f'{datetime.now()} Start uploading tables to DB')
f.processing_n_upload(conn, cur, tables['concept'], _logger)

# create metatdata table
_logger.debug(f'{datetime.now()} Creating metadata table')
f.upload_to_db_meta(conn, cur, tables['justification'], _logger)

# close connection
cur.close()
conn.close()
