#!/usr/bin/python
import os
import MySQLdb
import csv
from shutil import copyfile
import sys


#Connecting to MYSQL.

db = MySQLdb.connect(sys.argv[1], sys.argv[2], sys.argv[3])
cursor = db.cursor()

#Creating the database and then using it.

cursor.execute("DROP DATABASE facultyInfo")
cursor.execute("CREATE DATABASE facultyInfo")
cursor.execute("USE facultyInfo")

#opening the Directory containing the CSV files.

database = os.listdir('Tables')

sql = ""
for t in database:
	N = 0

	#Opening each CSV file.

	with open("Tables/" + t, 'rb') as csvfile:
		table = csv.reader(csvfile, delimiter = ';')

		#Reading each row in the table.

		for row in table:
			if N == 0:

				#Using first row to create the table.

				for i in range(0, len(row)):
					row[i] += " CHAR(200) NOT NULL"
				sql = """CREATE TABLE %s (%s);"""%(t.split('.')[0], ','.join(row))
				cursor.execute(sql)
			else:

				#Entering the data into the table.

				sql = """INSERT INTO %s VALUES (%s);"""%(t.split('.')[0], ','.join(["'" + s.replace(',', '') + "'" for s in row]))
				cursor.execute(sql)
			N += 1

# Commiting and closong the database.	

db.commit()			
db.close()