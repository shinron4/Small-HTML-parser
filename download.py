import urllib2
import os
 
#Openin the CS department page.

req = urllib2.Request(url="http://www.iitkgp.ac.in/department/CS")

#Creating a directory for storing the faculty HTML files.

os.mkdir('facultyInfo2')

for line in urllib2.urlopen(req).readlines():
	if "/department/CS/faculty/cs" in line:

		#Getting the faculty HTML page.
		
		link = line[line.find("href=") + 6 : line.find(";")]
		req = urllib2.Request(url = 'http://www.iitkgp.ac.in' + link)

		#Storing the page in an HTML file.

		f = open('facultyInfo2/' + 'cs-' + link.split(';')[0].split('-')[1] + '.html', "w")
		f.write(urllib2.urlopen(req).read())

		#Closing the file.

		f.close()