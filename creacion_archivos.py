import pandas as pd
import os 

ruta = "/Users/Usuario/Documents/Tesis Diana 2021/Codigo/Nuevas Plantillas/Desarrollo"
os.makedirs(ruta)

df = pd.DataFrame({'id_desarrollo': [],
                   'fecha': []})

df.to_excel(r'/Users/Usuario/Documents/Tesis Diana 2021/Codigo/Nuevas Plantillas/Desarrollo/proyectos_desarrollo.xlsx', index = False, header=True)
