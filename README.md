# EE283

The goal of the final project is to trick the DESeq2 packages to analyze ATAC data set on peaks instead of gene. Here is what I have found so far.

# file requirement:

Deseq2 requires 2 separated files. the first file is raw count of gene from samples (raw count of peak submit among all replicates in our case). The second files is a description files for all the sample with condition column can be change to a different classification system. Brain vs Eye disk vs wing disk etc. The two input files must be tab separated. 

# raw count example files (showing is only first 4 peaks. the sample file is called hwcount.txt contains 40 peaks): 

BR1     BR2     ED1     ED2
peak_1  1373    0       0       0
peak_2  2526    2530    2533    0
peak_3  10881   11026   11853   11496
peak_4  17342   0       0       0


For this file, the header need to contains only column name for all sample. The first column doesn't need a column name header. In fact, Deseq2 will not be happy and have error if there is 5 column header name vs only samples column name as shown. In addition, as this is only a test, peak name is labeled as 1,2,3 and so on; however, in reality, peak name can be the peak summit called by MACS2 on atac seq data and the number can be total occurence count of that summits among all replicates of Brain tissue or eye disk tissue. 

# column name input files (file name is hwcol.txt):

This file is description file for all sample column. shown below is the example used to test on deseq2 for the project. 

Sample  type    condition
BR1     ATAC    brain
BR2     ATAC    brain
ED1     ATAC    eyedisk
ED2     ATAC    eyedisk

For this file, it is typical column description files. There is one thing needs to be noted which is the requirements of the same samples description count vs all sample provided in raw count file. If the raw count file has 4 samples, the column description file must provided description for 4 samples. Other than that, header is a normal header for each column. 
