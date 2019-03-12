#!/bin/bash

# to change name for atacseq
for i in $(ls *R1.fq.gz);do ln -s $i $(grep $(echo $i |cut -f5 -d"_") README.ATACseq.txt | awk -v OFS="_" '{print "ATAC",$2,$3,$4,"R1"}'); done
for i in $(ls *R2.fq.gz);do ln -s $i $(grep $(echo $i |cut -f5 -d"_") README.ATACseq.txt | awk -v OFS="_" '{print "ATAC",$2,$3,$4,"R2"}'); done


