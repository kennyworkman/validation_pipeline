import numpy as np
import pandas as pd
import re
import matplotlib.pyplot as plt

df = pd.read_csv('output.csv', encoding="utf-8-sig")
df.columns = df.columns.str.strip()

#add a color descriptor column based on tunable thresholds for variants and depth score
conditions = [
    (df['Position_Reference_Alternate'].isnull()) & (df['Depth Score'] == 100.0),
    (df['Position_Reference_Alternate'].str.count('\n') >= 5) | (df['Depth Score'] < 90.0)]
choices = ['green', 'red']
df['color'] = np.select(conditions, choices, default='yellow')

#add construct name and colony number columns
df['construct'] = df['Filename'].str.extract(r'([A-Z]+-[0-9]+)-col[0-9].*')

info = df.groupby(['construct']).color.apply(list)
visual = pd.DataFrame({'construct':info.index, 'colony':info.values}) #, 'colony2':np.nan, 'colony3':np.nan, 'colony4':np.nan, 'colony5':np.nan, 'colony6':np.nan, 'colony7':np.nan, 'colony8':np.nan})
final = pd.DataFrame(visual.colony.tolist(), columns=['colony1', 'colony2', 'colony3', 'colony4'])
final.insert(loc=0, column='construct', value=visual['construct'])
print(final)

final.to_csv('visual.csv')
