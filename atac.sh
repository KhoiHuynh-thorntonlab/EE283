#!/bin/bash
#$ -N ATACseq
#$ -q krt2
#$ -pe openmp 4
#$ -R y
#$ -t 1-89

module clear
module load Cluster_Defaults solarese/conda3
source activate ucsc
module load enthought_python/7.3.2
module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load gatk/2.4-7
module load picard-tools/1.87
module load java/1.7
module load bedtools/2.25.0
module load java
module load bowtie2/2.2.7
module load solarese/kent


newdata="/bio/khoih/data"
# the folders...with the data
files="/bio/khoih/filename.txt"
# I gave you a tar of this directoryref="/bio/khoih/ref/dm6.fa"
rawfix=`head -n $SGE_TASK_ID $files | tail -n 1`


# to check for fastq format

perl ../../fastqFormatDetect.pl ADL06_1_1.fq.gz

#to convert to new fastq format
mkdir ./converted 

/bio/khoih/seqtk/seqtk seq -Q64 -V <(zcat ${rawfix}_R1.fq.gz) | gzip -c > ./converted/${rawfix}_R1.fq.gz
/bio/khoih/seqtk/seqtk seq -Q64 -V <(zcat ${rawfix}_R2.fq.gz) | gzip -c > ./converted/${rawfix}_R2.fq.gz

#####
###createa index reference
###
wget --timestamping 'ftp://hgdownload.cse.ucsc.edu/goldenPath/dm6/bigZips/dm6.fa.gz' 
zcat dm6.fa.gz
bwa index dm6.fa
samtools faidx dm6.fa

#====================
# matching ref and output bam:
#=================
bwa mem -t 8 -M ./dm6.fa <(zcat ./converted/${rawfix}_R1.fq.gz) <(zcat ./converted/${rawfix}_R2.fq.gz) | samtools view -bS - > $newdata/$rawfix.bam



# =============================
# Remove unmapped, mate unmapped
# not primary alignment, reads failing platform
# Only keep properly paired reads
# Obtain name sorted BAM file
# ==================



samtools view -F 524 -f 2 -u $newdata/$rawfix.bam > /bio/khoih/data/$rawfix.2.bam

samtools sort -n /bio/khoih/data/$rawfix.2.bam -o /bio/khoih/data/$rawfix.sorted.bam

samtools index /bio/khoih/data/$rawfix.sorted.bam

echo "ready for fixmate"

#===================================
# Remove orphan reads (pair was removed)
# and read pairs mapping to different chromosomes
# Obtain position sorted BAM
#====================================

samtools fixmate -r /bio/khoih/data/$rawfix.sorted.bam /bio/khoih/data/$rawfix.fixmate.bam

samtools view -F 1804 -f 2 -u /bio/khoih/data/$rawfix.fixmate.bam > /bio/khoih/data/$rawfix.fixmate.temp.bam

samtools sort /bio/khoih/data/$rawfix.fixmate.temp.bam -o /bio/khoih/data/$rawfix.fixmate.sort.bam

samtools index /bio/khoih/data/$rawfix.fixmate.sort.bam

echo "fixmate done"

# =============
# Mark duplicates
# =============


java -jar /bio/khoih/picard_2_18_7.jar MarkDuplicates I=/bio/khoih/data/$rawfix.fixmate.sort.bam O=/bio/khoih/data/$rawfix.dedup.bam M=/bio/khoih/data/$rawfix.dups.txt REMOVE_DUPLICATES=true


#===========
# REMOVE MITO
#=============
samtools sort /bio/khoih/data/$rawfix.dedup.bam -o /bio/khoih/data/$rawfix.dedup.sort.bam

samtools index /bio/khoih/data/$rawfix.dedup.sort.bam

samtools view -h /bio/khoih/data/$rawfix.dedup.sort.bam | awk -F $'\t' 'BEGIN {OFS = FS}{ if(($3="X")||($3="3R")||($3="3L")||($3="2R")||($3="2L")) print $1,$2,"chr"+$3,$4,$5,$6,$7,$8,$9,$10,$11; else print $0;}' | samtools view -bSh > /bio/khoih/data/$rawfix.dedup.sort.2.bam

samtools view -b /bio/khoih/data/$rawfix.dedup.sort.bam chrX chr2L chr2R chr3L chr3R > /bio/khoih/data/$rawfix.nomt.bam

samtools sort -n /bio/khoih/data/$rawfix.nomt.bam -o /bio/khoih/data/$rawfix.nomtsort.bam


#===============
# shift read in bam
#===========

samtools view -h /bio/khoih/data/$rawfix.nomtsort.2.bam | awk -F $'\t' 'BEGIN {OFS = FS}{ if($9 > 0) print $1, $2, $3, $4+4, $5, $6, $7, $8-5, $9, $10, $11, $12, $13, $14, $15, $16, $17; else print $1, $2, $3, $4-5, $5, $6, $7, $8+4, $9, $10, $11, $12, $13, $14, $15, $16, $17;}' | samtools view -bSh > /bio/khoih/data/${rawfix}.corrected.bam


#================
# convert bam to bedpe file
#================

bedtools bamtobed -i /bio/khoih/data/$rawfix.nomtsort.bam > /bio/khoih/data/$rawfix.bed


####
# print header  and generate bedgraph

####

echo `track type=bedGraph name="${rawfix} BedGraph Format" description="BedGraph format" visibility=full color=200,100,0 altColor=0,100,200 priority=20` > /bio/khoih/data/${rawfix}.bedgraph
awk '{ print $1"\t"$2"\t"$3"\t"$5 }' /bio/khoih/data/$rawfix.bed >> /bio/khoih/data/${rawfix}.bedgraph

tail -n +2 /bio/khoih/data/${rawfix}.bedgraph | sort -k1,1 -k2,2n > /bio/khoih/data/${rawfix}.bedgraph.sorted


######
#generate bigwig file
######
Nreads=`samtools view -c -F 4 /bio/khoih/data/${rawfix}.corrected.bam`
Scale=`echo "1.0/($Nreads/1000000)" | bc -l`
samtools view -b /bio/khoih/data/${rawfix}.corrected.bam | genomeCoverageBed -ibam - -g ./dm6.fa -bg -scale $Scale > /bio/khoih/data/$rawfix.coverage
bedGraphToBigWig /bio/khoih/data/$rawfix.coverage ./dm6.fa.fai /bio/khoih/data/$rawfix.bw


##############
### generate peak file and its bigwig:
############

macs2 callpeak -t /bio/khoih/data/${rawfix}.corrected.bam -f BAMPE -n cut.${rawfix} -g 142573024 -p 0.01 --shift 100 --extsize 200 --nomodel -B --SPMR --keep-dup all --call-summits


name1=cut."$rawfix"_treat_pileup.bdg""
name2=cut."$rawfix"_control_lambda.bdg""

macs2 bdgcmp -t /bio/khoih/data/$name1 -c /bio/khoih/data/$name2 -o /bio/khoih/data/cut.$rawfix.FE.bdg -m FE

########################
# dm6.len is the chrominfo file downloaded from ucsc browser which contain all chromosome information:
#macs2bdg2bw.sh is the author of MACS2 script to fix and convert generated bdg file to bigwig.
###########
bash /dfs3/bio/khoih/kent/macs2bdg2bw.sh /bio/khoih/data/cut.$rawfix.FE.bdg /bio/khoih/kent/dm6.len
