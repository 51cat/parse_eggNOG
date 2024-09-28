library(tidyverse)

df.obo <- read_tsv('go.db.tsv') %>% select(id, level) %>% 
  rename(GOs = id)

eggno <- read_delim(file = "out.emapper.annotations", 
                    col_names = T, delim = "\t", comment = "##")

test <- eggno %>% 
  select( `#query`, GOs, Description ) %>% 
  rename(query = `#query`) %>% 
  filter(GOs != "-") %>% 
  group_by(query, Description) %>% summarise(GOs=str_split(GOs, ",")) %>% 
  unnest(GOs) %>% ungroup() %>% left_join(df.obo, by = "GOs") %>% 
  select(query, GOs, level, Description) %>% 
  rename(Gene = query, GO=GOs)
  
test.genelist <- unique(sample(test$Gene, 100))

GOannotation <- split(test, with(test, level))


library(clusterProfiler)

?enricher

GOinfo <- read_tsv('go.db.tsv') %>% select(id, def, level)

s <- enricher(test.genelist,
  TERM2GENE=GOannotation[['molecular_function']][c(2,1)],
TERM2NAME=GOinfo[1:2])

ab <- s@result



# list
# anno: GOannotation
# info: GO info

parse.eggNOG.GO <- function(eggNOG.file, go.obo.file) {
  # 暂时如此
  library(yulab.utils)
  library(obolite)
  
  go.list <- read.obo(go.obo.file)
  
  eggno <- read_delim(file = eggNOG.file, 
                      col_names = T, delim = "\t", comment = "##")
  
  go.info <- go.list$info[,c("id", "name", "level")]
  colnames(go.info) <- c("GO", "name", "level")
  
  # parse egoNOG
  anno.GO <- eggno %>% 
    select( `#query`, GOs, Description ) %>% 
    rename(Gene = `#query`, GO = GOs) %>% 
    
    filter(GO != "-") %>% 
    group_by(Gene, Description) %>% 
    
    summarise(GO=str_split(GO, ",")) %>% 
    unnest(GO) %>% 
    left_join(go.info, by = "GO") %>% 
    select(Gene, GO, level, Description)
  
  return(
    list(
      egg.res = anno.GO[, c("GO", "Gene" ,"level")],
      GO.info = go.info[, c("GO", "name")]
    )
  )
  
}


res <- parse.eggNOG.GO("./out.emapper.annotations", "./go-basic.obo")



### test

test <- read_delim(file = "out.emapper.annotations", 
                    col_names = T, delim = "\t", comment = "##")
test.genelist <- unique(sample(test$`#query`, 100))

GOannotation <- split(res$egg.res, with(res$egg.res, level))

test.res <- enricher(test.genelist, TERM2GENE = 
                       GOannotation[["cellular_component"]][, c("GO","Gene")], TERM2NAME = res$GO.info, 
                     pvalueCutoff = 1, qvalueCutoff = 1)



dotplot(test.res)
barplot(test.res)


a <- test.res@result
a







