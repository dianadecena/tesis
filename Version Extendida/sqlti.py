import psycopg2
from sqlalchemy import create_engine
from PyQt5.QtWidgets import QMessageBox
import pandas as pd


def guardarCerrados(num_area, area, id_area, ticket, archivo):
        connection = conectarBD()
        df = pd.read_excel(archivo, engine='openpyxl')
        ultimo_ind = selectUltimoInd(connection)
        guardarInd(connection, df)
        if num_area == 1 and ticket:
            try:
                df_tickets = df[['id_desarrollo', 'id_ticket']]     
                df_tickets.to_sql('des_ticket', con=connection[1], if_exists='append', index=False)
                caso = 2
                df_area = df['id_desarrollo'] 
            except Exception as e: 
                alertaError()
        elif num_area == 1 and ticket==False: 
            caso = 4
            df_area = df['id_desarrollo'] 
        elif num_area == 2 and ticket:
            try:
                df_tickets = df[['id_operaciones', 'id_ticket']]     
                df_tickets.to_sql('op_ticket', con=connection[1], if_exists='append', index=False)
                caso = 2
                df_area = df['id_operaciones'] 
            except Exception as e: 
                alertaError()

        for no_id in df_area.tolist():
            cur = connection[0].cursor()
            if area == "desarrollo":
                cur.execute("UPDATE desarrollo SET id_caso = (%s) WHERE id_desarrollo = (%s)", (caso, no_id))
            else: 
                cur.execute("UPDATE operaciones SET id_caso = (%s) WHERE id_operaciones = (%s)", (caso, no_id))
            connection[0].commit()
            cur.close()
        selectIndicador(num_area, connection, ultimo_ind, df_area)
    
def guardarDatosVar(num_area, area, archivo, id_var, tablas_var):
        #conectar con la base de datos 
        df_var = []
        connection = conectarBD()
        df = pd.read_excel(archivo, engine='openpyxl')
        for id in id_var:
            df_var.append(df[[id]])
        df_area = selectArea(num_area, area, connection, df)
        guardarTablaVar(connection, df_area, df_var, tablas_var)
        ultimo_ind = selectUltimoInd(connection)
        guardarInd(connection, df)
        selectIndicador(num_area, connection, ultimo_ind, df_area)

def guardarDatos(num_area, area, archivo):
        #conectar con la base de datos
        connection = conectarBD()
        df = pd.read_excel(archivo, engine='openpyxl')
        df_area = selectArea(num_area, area, connection, df)
        ultimo_ind = selectUltimoInd(connection)
        guardarInd(connection, df)
        selectIndicador(num_area, connection, ultimo_ind, df_area)

def selectIndicador(num_area, connection, ultimo_ind, df_area):
        query = "SELECT id_dato FROM dato_indicador WHERE id_dato > '%s';"
        records = selectVariable(query, connection[0], ultimo_ind)
        df_ind = pd.DataFrame(records, columns=['id_dato'])
        nuevo_df = pd.concat([df_ind, df_area], axis=1)
        if num_area == 1:
            tabla_area = 'dato_des'
        elif num_area == 2:
            tabla_area = 'dato_op'
        else:
            tabla_area = 'dato_seg'

        try:
            nuevo_df.to_sql(tabla_area, con=connection[1], if_exists='append', index=False)
            alertaDatos()
        except Exception as e: 
            print(e)
            alertaError()
  
def selectVariable(query, connection, s_variable):
        cur = connection.cursor()
        try:
            cur.execute(query %s_variable)
        except Exception as e:
            connection.commit()
            print('Error:', e)
        else:
            records = cur.fetchall()
            cur.close()
            return records

def select(query, connection):
        cur = connection.cursor()
        try:
            cur.execute(query)
        except Exception as e:
            connection.commit()
            print('Error:', e)
        else:
            records = cur.fetchall()
            cur.close()
            return records

def selectArea(num_area, area, connection, df):
        if num_area == 1:
            query = """
            SELECT id_desarrollo FROM desarrollo ORDER BY id_desarrollo DESC LIMIT 1; 
            """
        elif num_area == 2:
            query = """
            SELECT id_operaciones FROM operaciones ORDER BY id_operaciones DESC LIMIT 1; 
            """
        else:
            query = """
            SELECT id_seguridad FROM seguridad ORDER BY id_seguridad DESC LIMIT 1; 
            """
        select(query, connection[0])
        resultados = list(select(query, connection[0]))
        if resultados != []:
            ultimo = int(resultados[0][0])
        else:
            ultimo = 0

        try:
            df_caso = df[['id_caso']]
            df_caso.to_sql(area, con=connection[1], if_exists='append', index=False)
        except Exception as e:
            alertaError() 

        if num_area == 1:
            query = "SELECT id_desarrollo FROM desarrollo WHERE id_desarrollo > '%s';"
            id_area = 'id_desarrollo'
        elif num_area == 2:
            query = "SELECT id_operaciones FROM operaciones WHERE id_operaciones > '%s';"
            id_area = 'id_operaciones'
        else:
            query = "SELECT id_seguridad FROM seguridad WHERE id_seguridad > '%s';"
            id_area = 'id_seguridad'

        records = selectVariable(query, connection[0], ultimo)
        df_area = pd.DataFrame(records, columns=[id_area])

        return df_area

def guardarTablaVar(connection, df_des, df_var, tablas_var):
        nuevo_df = []
        try:
            for ids in df_var:
                nuevo_df.append(pd.concat([df_des, ids], axis=1))
            for i in range(len(tablas_var)):
                nuevo_df[i].to_sql(tablas_var[i], con=connection[1], if_exists='append', index=False)
        except Exception as e: 
            print(e)
            alertaError()

def selectUltimoInd(connection):
        query = """
        SELECT id_dato FROM dato_indicador ORDER BY id_dato DESC LIMIT 1; 
        """
        select(query, connection[0])
        resultados = list(select(query, connection[0]))
        if resultados != []:
            ultimo_ind = int(resultados[0][0])
        else:
            ultimo_ind = 0

        return ultimo_ind

def alertaDatos():
        alerta = QMessageBox() 
        alerta.setIcon(QMessageBox.Information) 
        alerta.setText("Los datos se han guardado correctamente en la base de datos") 
        alerta.setInformativeText("Presione OK para continuar") 
        alerta.setWindowTitle("IMPORTANTE") 
        alerta.setStandardButtons(QMessageBox.Ok) 
        alerta.exec_()

def guardarInd(connection, df):
        try:
            df_indicador = df[['fecha', 'id_area']]     
            df_indicador.to_sql('dato_indicador', con=connection[1], if_exists='append', index=False)
        except Exception as e: 
            alertaError()

def alertaError():
        alerta = QMessageBox() 
        alerta.setIcon(QMessageBox.Information) 
        alerta.setText("No ha sido posible guardar los datos en la base de datos porque no poseen el formato correcto") 
        alerta.setInformativeText("Presione OK para continuar") 
        alerta.setWindowTitle("IMPORTANTE") 
        alerta.setStandardButtons(QMessageBox.Ok) 
        alerta.exec_()
        exit()

def conectarBD():
        host='localhost'
        user ='postgres'
        password='crush7878'
        dbname='tesis_ext'

        connection = psycopg2.connect(host = host, user= user, password =password, dbname= dbname)
        db_connection = 'postgresql://{}:{}@{}:5432/{}'.format(user, password, host, dbname)
        engine = create_engine(db_connection)

        return [connection, engine]

