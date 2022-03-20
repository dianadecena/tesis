import pandas as pd
import os
import psycopg2
from sqlalchemy import create_engine

def transformarArchivo():
    ruta = "/Users/Usuario/Documents/Tesis Diana 2021/Codigo/Transformar Archivos/"

    with os.scandir(ruta) as ficheros:
        for fichero in ficheros:
            archivo = ruta+fichero.name

    df = pd.read_excel(archivo, engine='openpyxl')
    estados = df['Estado']
    estados = estados.values.tolist()
    for estado in estados:
        if estado == 'Cerrado exitosamente':
            fechas_inicio = df['Creado']
            tickets_abiertos = pd.DataFrame()
            tickets_abiertos['fecha'] = fechas_inicio
            id_area = []
            id_ticket = []
            id_caso = []
            for i in range(len(estados)):
                id_area.append(1)
                id_ticket.append(2)
                id_caso.append(1)
            tickets_abiertos['id_area'] = id_area
            tickets_abiertos['id_ticket'] = id_ticket
            tickets_abiertos['id_caso'] = id_caso
            df_area = selectArea(estados)
            tickets_abiertos= pd.concat([tickets_abiertos, df_area], axis=1)
            tickets_abiertos.to_excel(r'/Users/Usuario/Documents/Tesis Diana 2021/Codigo/Transformar Archivos/tickets_abiertos.xlsx', index = False, header = True)

            id_area = []
            id_ticket = []
            id_caso = []
            for i in range(len(estados)):
                id_area.append(1)
                id_ticket.append(1)
                id_caso.append(2)
            
            tickets_abiertos['id_area'] = id_area
            tickets_abiertos['id_ticket'] = id_ticket
            tickets_abiertos['id_caso'] = id_caso

            fechas_cierre = df['Fecha de cierre']
            tickets_cerrados = pd.DataFrame()
            tickets_cerrados['fecha'] = fechas_cierre
            df_area = selectArea(estados)
            tickets_cerrados = pd.concat([tickets_cerrados, df_area], axis=1)
            tickets_cerrados.to_excel(r'/Users/Usuario/Documents/Tesis Diana 2021/Codigo/Transformar Archivos/tickets_cerrados.xlsx', index = False, header = True)
    
def selectArea(estados):
        connection = conectarBD()
        query = "SELECT id_desarrollo FROM desarrollo ORDER BY id_desarrollo DESC LIMIT 1;"
        select(query, connection[0])
        resultados = list(select(query, connection[0]))
        ultimo = int(resultados[0][0])
        id_desarrollo = []

        for i in range(len(estados)):
            id_desarrollo.append(ultimo+1)
            ultimo = ultimo+1
        
        df_area = pd.DataFrame()
        df_area['id_desarrollo'] = id_desarrollo
        
        return df_area

def select(query, connection):
        cur = connection.cursor()
        try:
            cur.execute(query)
        except Exception as e:
            connection.commit()
        else:
            records = cur.fetchall()
            cur.close()
            return records

def conectarBD():
        host='localhost'
        user ='postgres'
        password='crush7878'
        dbname='tesis_db'

        connection = psycopg2.connect(host = host, user= user, password =password, dbname= dbname)
        db_connection = 'postgresql://{}:{}@{}:5432/{}'.format(user, password, host, dbname)
        engine = create_engine(db_connection)

        return [connection, engine]

transformarArchivo()