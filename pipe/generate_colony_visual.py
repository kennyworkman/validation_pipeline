# This module will generate an excel file from the ouptu.csv that is sorted by colonies according to a preset file format parsed by regex

import sys
import numpy as np
import pandas as pd
import re
import xlsxwriter

# Load output.csv as a dataframe and create dataframe for the excel output
df = pd.read_csv('output.csv', encoding="utf-8-sig")
writer = pd.ExcelWriter('visual.xlsx', engine='xlsxwriter')
df.columns = df.columns.str.strip()

# Establish a color based on number of variants and depth score
conditions = [
                (df['Position Reference Alternate'].isnull()) & (df['Depth Score'] == 100.0), # Green
                (df['Position Reference Alternate'].str.count('\n') >= 5) | (df['Depth Score'] < 90.0) # Red
 
             ] 
choices = [3, 1]
df['color'] = np.select(conditions, choices, default=2) # All other colonies are 'yellow'

# Add construct column
df['construct'] = df['Filename'].str.extract(r'([A-Z]+-[0-9]+)-col[0-9].*')

# Groups colors by construct
groups = df.groupby(['construct']).color.apply(list)
colonies = pd.DataFrame({'construct':groups.index, 'colony':groups.values})
final = pd.concat([colonies['construct'], pd.DataFrame(colonies['colony'].values.tolist())], axis=1)

# Convert datafield into an excel file
final.to_excel(writer, sheet_name='Colonies')

workbook  = writer.book
worksheet = writer.sheets['Colonies']

# Apply conditional format to excel file, replace values with icons
worksheet.conditional_format(1, 2, len(final), len(final.columns),
                             {'type': 'icon_set',
                              'icon_style': '3_symbols_circled',
                              'icons': [{'criteria': '==', 'type': 'number',  'value': 3},
                                        {'criteria': '==',  'type': 'number', 'value': 2},
                                        {'criteria': '==', 'type': 'number',  'value': 1}
                                        ],
                              'icons_only': True})
writer.save()
