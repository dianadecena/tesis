import os 
from sqlti import guardarDatosVar
import pandas as pd 

def obtenerArchivos(ruta):
	with os.scandir(ruta) as ficheros:
		for fichero in ficheros:
			tipo_indicador = ruta.split("/")
			path = ruta+fichero.name
			mostrarErrores(path)
			if tipo_indicador[7] == "Ataques Bloqueados":
				guardarDatosVar(3, 'seguridad', path, 'id_ataque', 'seg_ataque')
			elif tipo_indicador[7] == "Incidentes":
				guardarDatosVar(3, 'seguridad', path, 'id_incidente', 'seg_incidente')
			elif tipo_indicador[7] == "Cambios":
				guardarDatosVar(3, 'seguridad', path, 'id_cambios', 'seg_cambios')

def mostrarErrores(path):
	df = pd.read_excel(path, engine='openpyxl')
	error_en_archivo = verificarValores(df)
	if error_en_archivo != 'sin errores':
		errorArchivo(error_en_archivo)
		exit()

def verificarValores(df):

	negativo = False
	nulo = False
	iguales = False

	for nombre_columna in df:
		for v in df[nombre_columna]:
			if nombre_columna != 'fecha' and v<=0:
				negativo = True
		
	if df.isnull().values.any():
		nulo = True

	bool_series = df.duplicated()
	bool_array = bool_series.values.tolist()

	for bool_value in bool_array:
		if bool_value == True:
			iguales = True

	if negativo and nulo and iguales:
		return 'todos'
	elif negativo and nulo:
		return 'negativo y nulo'    
	elif negativo and iguales:
		return 'negativo e iguales'
	elif nulo and iguales:
		return 'nulo e iguales'
	elif negativo:
		return 'negativo'
	elif nulo:
		return 'nulo'
	elif iguales:
		return 'iguales'
	else:
		return 'sin errores'

def errorArchivo(tipo):
	if tipo == 'negativo':
		tipo_error = 'valores negativos'
	elif tipo == 'nulo':
		tipo_error = 'valores nulos'
	elif tipo == 'iguales':
		tipo_error = 'filas iguales'
	elif tipo == 'negativo y nulo' :
		tipo_error = 'valores negativos y nulos'    
	elif tipo == 'negativo e iguales':
		tipo_error = 'valores negativos y filas iguales'
	elif tipo == 'nulo e iguales':
		tipo_error = 'valores nulos y filas iguales'
	elif tipo == 'todos':
		tipo_error = 'valores nulos y negativos y filas iguales'
	print("Se detect?? un error en el archivo: "+tipo_error) 

nombres_indicadores = ["Ataques Bloqueados", "Incidentes", "Cambios"]

for nombre in nombres_indicadores:
	ruta = "/Users/Usuario/Documents/Tesis Diana 2021/Codigo/Indicadores de Seguridad/"+nombre+"/"
	obtenerArchivos(ruta)
print("Los datos se han guardado correctamente en la base de datos") 

