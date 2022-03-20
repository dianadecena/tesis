import psycopg2
from sqlalchemy import create_engine

#datos de la conexión con la bd 
host='localhost'
user ='postgres'
password='crush7878'
dbname='tesis_dw'

#crear conexión 
def crear_conexion(): 
    connection = psycopg2.connect(host = host, user= user, password =password, dbname= dbname)
    db_connection = 'postgresql://{}:{}@{}:5432/{}'.format(user, password, host, dbname)
    engine = create_engine(db_connection)

    return connection

#crear tablas
def crear_tablas():
    query_file = open("tablas_dw.sql",'r') 
    query = query_file.read()
    conn = crear_conexion()
    cur = conn.cursor()
    cur.execute(query)
    cur.close()
    conn.commit()
    
crear_tablas()