source("../parse_eggNOG/R/parse.GO.r")

res <- parse.eggNOG.GO("test_data/out.emapper.annotations")

gene.list <- read.table("test_data/test_genes.txt", sep = "\t", header = T)[["gene"]]

enrich.res <- clusterProfiler::enricher(
  gene.list, 
  
  TERM2GENE = res$TERM2GENE.CC, 
  TERM2NAME = res$TERM2NAME, 
  
  pvalueCutoff = 0.05, 
  qvalueCutoff = 0.05)

enrichplot::dotplot(enrich.res, showCategory = 5)
enrichplot::dotplot(enrich.res, showCategory = 5, title = "test")

df <- enrich.res@result
