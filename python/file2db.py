# encoding: utf-8


import sqlite3
from PIL import Image
import os

'''
from file2db import *

dbname='kx.db'
pathbase='image'
paraList=os.listdir(pathbase)
mdx2db(dbname,paraList,pathbase)

'''



def mdx2db(dbname,paraList,pathbase):

	if os.path.isfile(dbname):
		os.remove(dbname)

	createdb(dbname)
		
	#sqlite
	import sqlite3
	conn = sqlite3.connect(dbname)
	c = conn.cursor()
	for item in paraList:
		
		#msql='''INSERT INTO mword (tupian,geshi ) VALUES (?,?)''' 
		msql='''INSERT INTO mword (tupian,geshi,image ) VALUES (?,?,?)''' 

		filename, file_extension = os.path.splitext(item) 
		imgPath=pathbase+'/'+item
		with open(imgPath, 'rb') as input_file:image = input_file.read()

		para=(filename,file_extension,image)
		c.execute(msql,para)
		
	conn.commit()
	conn.close()


def  createdb(dbname):
	conn = sqlite3.connect(dbname)
	c = conn.cursor()
	c.execute('''CREATE TABLE mword
       	(ID INTEGER PRIMARY KEY  AUTOINCREMENT,
       	tupian          TEXT    ,
       	geshi          TEXT    ,
       	image          blob     

      	 );''')
	conn.commit()
	conn.close()
	return 'ok'
