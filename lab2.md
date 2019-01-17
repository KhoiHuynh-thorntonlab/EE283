
### Answer to question 1 to 8 with python

```
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


```



### Answer for question 1 to 8 with R:


```
#!/usr/bin/env Rscript


for (number in seq(0,50,by=1)){
        name1 <-paste("outfile.",number,".a.out",sep="")
        name2 <-paste("outfile.",number,".b.out",sep="")
        if(file.exists(name1)){
                print(paste(name1,"exist"))
        } else {
                print(paste(name1,"not exist"))
        }
        if(file.exists(name2)){
                print(paste(name2,"exist"))
        } else {
                print(paste(name2,"not exist"))
        }
}



# check if a file is directory or not

file_test("-d","outfile.10.a.out")
#check if a file exist and is not directory:
file_test("-f","outfile.10.a.out")

#  remove a file:
file.remove("trashtest.txt")
#check file size in bytes

file.info("outfile.10.a.out")

#get all filename matching pattern:

list.files(path = ".", pattern = ".a.out", all.files = TRUE, full.names = FALSE, recursive = FALSE, ignore.case = FALSE)

#get all filename recursively:

list.files(path = ".", pattern = ".a.out", all.files = TRUE, full.names = FALSE, recursive = TRUE, ignore.case = FALSE)

#iterate over file matching pattern:

files <- list.files(path = ".", pattern = ".a.out", all.files = TRUE, full.names = FALSE, recursive = TRUE, ignore.case = FALSE)
for (file in files){
        print(file)
}
#open gzip file with gzip

foo <- data.frame(a=LETTERS[1:3], b=rnorm(3))
write.table(foo, file="filename.csv")
system("gzip filename.csv")

read.table(gzfile("filename.csv.gz"))

#read gz file directly without unzip:
read.table("filename.csv.gz")

```
