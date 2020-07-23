library(rvest)
library(dplyr)


link = 'https://www.letras.mus.br/mais-acessadas/funk/'
pagina = read_html(link)

# Obtendo dados da música
cantor = pagina %>% html_nodes('#js-cnt-tops span') %>% html_text() # Obtendo o nome do cantor
musica = pagina %>% html_nodes('.cnt-list--col1-3 b') %>% html_text() # Obtendo o nome da música
url_musica = pagina %>% html_nodes('.top-list_mus a') %>% html_attr('href') %>% 
  paste('https://www.letras.mus.br', ., sep='') # Obtendo a url da música

# Obtendo letra da música
get_letra = function(link_musica) {
  pagina_letra = read_html(link_musica)
  letra_musica = pagina_letra %>%
    html_nodes('#js-lyric-cnt > article > div.cnt-letra-trad.g-pr.g-sp > div.cnt-letra.p402_premium') %>%
    html_text()
  return(letra_musica)
  
}

letra = sapply(url_musica, FUN = get_letra, USE.NAMES = FALSE)

# Criando dataframe com os dados.
top_funk = data.frame(cantor, musica, letra, url_musica, stringsAsFactors = FALSE)

# Exportando dataframe
write.csv(top_funk, file = 'top1000.csv', fileEncoding = 'UTF-8', row.names = FALSE)
