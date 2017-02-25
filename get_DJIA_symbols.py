#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 23 20:45:23 2017

@author: kasperipalkama
"""

from bs4 import BeautifulSoup
import pickle
import requests
import csv


resp = requests.get('https://fi.wikipedia.org/wiki/OMX_Helsinki_25')
soup = BeautifulSoup(resp.text)
table = soup.find('table', {'class': 'wikitable sortable'})
tickers = []
for row in table.findAll('tr')[1:]:
    ticker = row.findAll('td')[1].text
    tickers.append(ticker)
    
with open("DJIAtickers.pickle","wb") as f:
    pickle.dump(tickers,f)


tickers = [w.replace('.', '-') for w in tickers]
with open('OMX25_symbols', 'w',newline = '') as f:
    for element in tickers:
        writer = csv.writer(f)
        writer.writerow(element.split())
        
    



