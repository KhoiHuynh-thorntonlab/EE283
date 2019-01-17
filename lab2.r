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

