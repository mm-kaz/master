#! usr/bin/env python

import pandas as pd
import sys

ref = sys.argv

df = pd.read_csv('./'+ref[1]+'/fimo.tsv',sep='\t')

df2 = pd.concat([df, df['sequence_name'].str.split(':', expand=True)], axis=1)
df2 = df2.rename(columns = {0:'chr',1:'read'})

df2 = pd.concat([df2, df2['read'].str.split('-', expand=True)], axis=1)
df2 = df2.rename(columns = {0:'Start',1:'End'})
df2[['Start','End']] = df2[['Start','End']].astype('float64')

df2 = df2.dropna()

df2['End'] = df2['Start'] + df2['stop']
df2['Start'] = df2['Start'] + df2['start']

df3 = df2[['chr','Start','End','motif_alt_id','score','strand','motif_id']]

df3[['Start','End']] = df3[['Start','End']].astype('str')
df3['Start'] = df3['Start'].str.replace('\.0','')
df3['End'] = df3['End'].str.replace('\.0','')

df3 = df3.drop_duplicates()

df3.to_csv('./bedOutput/'+ref[2]+'_'+ref[1]+'.bed', sep='\t',index=None ,header=None)