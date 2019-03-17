#!/usr/bin/env Rscript

Mnemiopsis_count_data = read.table(file = "hwcount.txt", header = T, sep = "\t")
Mnemiopsis_col_data = read.table(file = "hwcol.txt", header = T, sep = "\t")

jpeg("betweensampleboxplot.jpeg")
boxplot(Mnemiopsis_count_data)
dev.off()

library(DESeq2)
dds = DESeqDataSetFromMatrix(countData=Mnemiopsis_count_data,colData = Mnemiopsis_col_data,design = ~ condition)

rld = rlogTransformation(dds)

jpeg("effectoftransformation.jpeg")
par( mfrow = c( 1, 2 ) )
plot(log2( 1 + counts(dds)[ , 1:2] ),pch=16, cex=0.3, main = "log2")
plot(assay(rld)[ , 1:2],pch=16, cex=0.3, main = "rlog")
dev.off()

library("RColorBrewer") # Load a package giving more colors
library("pheatmap") # load a package for making heatmaps
distsRL <- dist(t(assay(rld))) # Calculate distances using transformed (and normalized) counts
mat <- as.matrix(distsRL) # convert to matrix
rownames(mat) <- colnames(mat) <- with(colData(dds), paste(condition)) # set rownames in the matrix
colnames(mat) = NULL # remove column names
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)

jpeg("sampletosampledistance.jpeg")
pheatmap(mat,clustering_distance_rows=distsRL,clustering_distance_cols=distsRL,col=colors)
dev.off()


jpeg("PCAplot.jpeg")
plotPCA(rld, intgroup=c("condition"))
dev.off()


#differential analysis
dds = DESeq(dds)

res <- results(dds)
mcols(res, use.names=TRUE)
summary(res)
