library(tidyverse)
library(maps)
library(magick)
library(here)

## https://taraskaduk.com/2017/11/26/pixel-maps/
 
#ggplot(map_data("state") %>% filter(region == "michigan")) + geom_polygon(aes(long, lat, group = group), color = "white")

mi_data <- map_data("state") %>% filter(region == "michigan")                                    

lat <- data_frame(lat = seq(min(mi_data$lat)-5,max(mi_data$lat)+5, by = .3))
long <- data_frame(long = seq(min(mi_data$long)-5,max(mi_data$long)+5, by = .3))
dots <- lat %>% 
  merge(long, all = TRUE)

## Only include dots that are within borders. Also, exclude lakes.
dots <- dots %>% 
  mutate(country = map.where('state', long, lat)) %>% 
  filter(country %in% c("michigan:north", "michigan:south"))

dots %>% count(country)


ggplot() +  
  geom_point(data = dots, aes(x=long, y = lat), col = "#0065a4", size = 5) +
  ggthemes::theme_map()
ggsave(filename = paste0(here("img/mi-dot-plot.png")),
       width = 5, height = 4, dpi = 300)

##https://www.danielphadley.com/ggplot-logo/

plot <- image_read(paste0(here("img/mi-dot-plot.png")))

raw_datafest <- image_read(paste0(here("img/datafest_logo_gvsu.png")))
                                  
datafest <- raw_datafest %>% 
  image_scale("100") %>% 
  image_background("white", flatten = TRUE)

final_plot <- image_append(image_scale(c(plot, datafest), "100"), stack = TRUE)
image_write(final_plot, paste0(here("mi-dot.png")))

## Large dots

lat <- data_frame(lat = seq(min(mi_data$lat)-5,max(mi_data$lat)+5, by = .5))
long <- data_frame(long = seq(min(mi_data$long)-5,max(mi_data$long)+5, by = .5))
dots <- lat %>% 
  merge(long, all = TRUE)

## Only include dots that are within borders. Also, exclude lakes.
dots <- dots %>% 
  mutate(country = map.where('state', long, lat)) %>% 
  filter(country %in% c("michigan:north", "michigan:south"))

dots %>% count(country)


ggplot() +  
  geom_point(data = dots, aes(x=long, y = lat), col = "#0065a4", size = 10) + 
  ggthemes::theme_map()
ggsave(filename = paste0(here("img//mi-large-dot.png")),
       width = 5, height = 4, dpi = 300)

plot <- image_read(paste0(here("img/mi-large-dot.png")))

final_plot <- image_append(image_scale(c(plot, datafest), "100"), stack = TRUE)
image_write(final_plot, paste0(here("img/mi-large-dot.png")))
