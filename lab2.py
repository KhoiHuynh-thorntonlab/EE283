import os
import glob
import gzip
import fnmatch
for i in range(0,51):
	filename1="outfile."+str(i)+".a.out"
	filename2="outfile."+str(i)+".b.out"
#check if file exist
	exists1 = os.path.isfile(filename1)
	if exists1:
		print(filename1,"exist")
	else:
		print(filename1,"not exist")
	exists2 = os.path.isfile(filename2)
        if exists2:
                print(filename2,"exist")
        else:
                print(filename2,"not exist")
#check if file is directory
	dir1 = os.path.isdir(filename1)
	if dir1:
		print(filename1,"is directory")
	else:
		print(filename1,"is not directory")
	dir2 = os.path.isdir(filename2)
        if dir2:
                print(filename2,"is directory")
        else:
                print(filename2,"is not directory")

#delete a file
with open("trash.txt",'w') as f:
	f.write("my first file\n")

os.remove("trash.txt")

#check file size:

statinfo = os.stat('outfile.10.a.out')
print(statinfo)

#get filename matching a pattern:
filename="*.a.out"
matching1 = glob.glob(filename)
print(matching1)
#get filename matching apttern recursively:

substring="out"
for root, dirs, files in os.walk(".", topdown=False):
	for name in files:
		if substring in name:
			print(os.path.join(root, name))


#iterate over files that match pattern


for i in range(0,51):
	filename1="outfile."+str(i)+".a.out"
        filename2="outfile."+str(i)+".b.out"
	list=[ filename1, filename2 ] 
	for i in list:
		print(i)

#or 
for i in matching1:
	print(i)


#OPEN GZIP FILE to read :

with gzip.open("file.txt.gz","w") as f:
	f.write('hello')

with gzip.open('file.txt.gz', 'rb') as f:
	file_content = f.read()
	print(file_content)
#open gzip to write 
content = "abc"
with gzip.open('file.txt.gz', 'wb') as f:
	f.write(content)
