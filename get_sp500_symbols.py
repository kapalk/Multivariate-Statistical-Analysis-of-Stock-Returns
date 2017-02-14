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


resp = requests.get('http://en.wikipedia.org/wiki/List_of_S%26P_500_companies')
soup = BeautifulSoup(resp.text)
table = soup.find('table', {'class': 'wikitable sortable'})
tickers = []
for row in table.findAll('tr')[1:]:
    ticker = row.findAll('td')[0].text
    tickers.append(ticker)
    
with open("sp500tickers.pickle","wb") as f:
    pickle.dump(tickers,f)


tickers = [w.replace('.', '-') for w in tickers]
with open('sp500_symbols', 'w',newline = '') as f:
    for element in tickers:
        writer = csv.writer(f)
        writer.writerow(element.split())
        
    



