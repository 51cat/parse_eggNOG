library(RCurl)


parse.eggNOG.EC <- function(){
  
}


get.EC <- function(ec.number) {
  # databse: https://metabolicatlas.org/gotenzymes
  # Li F, Chen Y, Anton M, Nielsen J.
  
  # GotEnzymes: an extensive database of enzyme parameter predictions.
  # NAR (2022): gkac831
  # API document:https://metabolicatlas.org/api/v2/#/GotEnzymes/gotEnzymesECInfo
  # 
  
  url <- stringr::str_glue("https://metabolicatlas.org/api/v2/gotenzymes/ecs/{ec.number}")
  ec.json <- RCurl::getURL(url)
  
  if (ec.json == 'Not Found') {
    return("Not found from GotEnzymes")
  }
  
  ec.info <- jsonlite::fromJSON(ec.json)$info$name
  
  if (!str_detect(ec.info, 'Transferred to', )) {
    return(ec.info)
  }else{
    ec.num.new <-stringr::str_replace_all(ec.info,"Transferred to ", "")
    warning(stringr::str_glue("{ec.number} --> {ec.info}"))
    return(get.EC(ec.num.new))
  }
}

### test #### 
ec.1 <- "1.10.3.12"

A <- get.EC(ec.1)
A

ec.2 <- "2.4.2.9"

B <- get.EC(ec.2)
B

ec.3 <- "2.4.2999.999999"

c <- get.EC(ec.3)
c

