#!/bin/bash

# to change name for atacseq
for i in $(ls *R1.fq.gz);do ln -s $i $(grep $(echo $i |cut -f5 -d"_") README.ATACseq.txt | awk -v OFS="_" '{print "ATAC",$2,$3,$4,"R1"}'); done
for i in $(ls *R2.fq.gz);do ln -s $i $(grep $(echo $i |cut -f5 -d"_") README.ATACseq.txt | awk -v OFS="_" '{print "ATAC",$2,$3,$4,"R2"}'); done

#to change name for DNAseq

for i in $(ls *$i_1.fq.gz);do ln -s $i $(grep $(echo $i |cut -f1 -d"_") README.txt | awk -v i=$i -v OFS="_" '{print "DNA",$2,i}'); done

# to check for fastq format

perl ../../fastqFormatDetect.pl ADL06_1_1.fq.gz

#to convert to new fastq format
for i in $(ls *.fq.gz);do
/bio/khoih/seqtk/seqtk seq -Q64 -V <(zcat ADL06_1_1.fq.gz) | gzip -c > ./converted/$i
done

