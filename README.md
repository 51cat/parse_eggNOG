# parse_eggNOG
https://github.com/YuLab-SMU/ProjectYulab/issues/16

从eggNOG结果中解析GO数据库的信息，用于富集分析：

`R/parse.GO.r`: 

`parse.eggNOG.GO `函数负责解析eggNOG结果

输入： eggNOG的注释结果文件

输出：解析后的结果，储存在一个list中，list的每个元素如下

```
TERM2GENE.CC -> Cellular Component的通路-gene数据
TERM2GENE.BP -> Biological Process的通路-gene数据
TERM2GENE.MF -> Molecular Function的通路-gene数据
TERM2GENE.ALL-> 全部的通路-gene数据
TERM2NAME -> 通路id-name信息
```

## 测试

物种为*Bacillus velezensis FZB42* 

```SHELL
# clone
git clone https://github.com/51cat/parse_eggNOG.git
```

## 富集分析

```r
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

```

