
get.level.df <- function(df, level =NULL) {
  if (!is.null(level)) {
    df |> 
      dplyr:: filter(level == level) |>
      dplyr::select(GO, Gene)
  }else{
    df |> 
      dplyr::select(GO, Gene)
  }
}

get.go.info <- function(){
  goterms  <-  AnnotationDbi::Ontology(GO.db::GOTERM)
  termname  <-  AnnotationDbi::Term(GO.db::GOTERM)
  df.terms <- data.frame(GO = names(goterms),
                         level = goterms,
                         name = termname[names(goterms)]
                         )
  return(df.terms)
}


parse.eggNOG.GO <- function(eggNOG.file) {
  
  eggno <- readr::read_delim(file = eggNOG.file, 
                      col_names = T, delim = "\t", comment = "##")
  
  # parse egoNOG
  go.info <- get.go.info()
  
  anno.GO <- eggno |>
    #select( `#query`, GOs, Description ) %>% 
    dplyr::rename(Gene = `#query`, GO = GOs)  |>
    
    dplyr::filter(GO != "-") |> 
    dplyr::group_by(Gene, Description) |> 
    
    dplyr::summarise(GO=stringr::str_split(GO, ",")) |>
    tidyr::unnest(GO)  |>
    dplyr::left_join(go.info, by = "GO")  |>
    dplyr::select(Gene, GO, level, Description)  |>
    dplyr::ungroup()
  
  TERM2GENE.df <- anno.GO[, c("GO", "Gene" ,"level")] |> tidyr::drop_na()
  TERM2NAME.df <- go.info[, c("GO", "name")] 
  
  return(
    list(
      TERM2GENE.CC = TERM2GENE.df |> get.level.df(level = 'CC'),
      TERM2GENE.BP = TERM2GENE.df |> get.level.df(level = 'BP'),
      TERM2GENE.MF = TERM2GENE.df |> get.level.df(level = 'MF'),
      TERM2GENE.ALL = TERM2GENE.df |> get.level.df(level = NULL),
      TERM2NAME = TERM2NAME.df
    )
  )
}














