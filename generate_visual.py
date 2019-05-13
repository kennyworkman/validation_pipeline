import numpy as np
import pandas as pd
import re
import xlsxwriter

df = pd.read_csv('output.csv', encoding="utf-8-sig")

writer = pd.ExcelWriter('visual.xlsx', engine='xlsxwriter')

df.columns = df.columns.str.strip()

#add color column
conditions = [
    (df['Position_Reference_Alternate'].isnull()) & (df['Depth Score'] == 100.0), #Conditions jor a 'green' colony
    (df['Position_Reference_Alternate'].str.count('\n') >= 5) | (df['Depth Score'] < 90.0)] #Conditions for a 'red' colony
choices = [3, 1]
df['color'] = np.select(conditions, choices, default=2) #All other colonies are 'yellow'

#add construct column
df['construct'] = df['Filename'].str.extract(r'([A-Z]+-[0-9]+)-col[0-9].*')

#groups colors by construct
groups = df.groupby(['construct']).color.apply(list)
colonies = pd.DataFrame({'construct':groups.index, 'colony':groups.values})
final = pd.concat([colonies['construct'], pd.DataFrame(colonies['colony'].values.tolist())], axis=1)

#convert datafield into an excel file
final.to_excel(writer, sheet_name='Colonies')

workbook  = writer.book
worksheet = writer.sheets['Colonies']

worksheet.conditional_format(1, 2, len(final), len(final.columns),
                             {'type': 'icon_set',
                              'icon_style': '3_symbols_circled',
                              'icons': [{'criteria': '==', 'type': 'number',  'value': 3},
                                        {'criteria': '==',  'type': 'number', 'value': 2},
                                        {'criteria': '==', 'type': 'number',  'value': 1}
                                        ],
                              'icons_only': True})
writer.save()
