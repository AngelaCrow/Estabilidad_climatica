library(terra)
library(tidyverse)
library(scales)
rm(list = ls())

# Listar todos los archivos raster que contienen la palabra "zvh" y tienen la extensión ".tif"
futuro_files <- list.files("/Volumes/TOSHIBA EXT/COBERTURAS/GIZ_GCM_compareR", pattern = "zvh_.*\\.tif$", recursive = TRUE, full.names = TRUE)
# Mostrar la lista de archivos encontrados
print(futuro_files)

zv <- terra::rast("/Volumes/TOSHIBA EXT/COBERTURAS/GIZ_GCM_compareR/Presente_1981-2010_ZVH/zvh.tif")
# Convertir raster a puntos
matriz <- terra::as.points(zv)
m <- terra::crds(matriz)

#x<-futuro_files [[1]];x 

lapply(futuro_files, function(x){
  parts <- strsplit(x, "_")[[1]]
model_name <- parts[4]
print(model_name)

#### Preparacion de matrices ####
# Importar raster de las zonas de vida de cada tiempo
# Llamar raster de las zonas de vida de cada tiempo y mexbio
zvrcp_fut <- terra::rast(x)
# Apilar los rasters
zonas <- c(zv, zvrcp_fut)
m.zonas <- terra::extract(zonas, m)

# Combinar coordenadas con datos extraídos
coor.m.zonas <- as.data.frame(cbind(m, m.zonas))
names(coor.m.zonas)

# Separar los números del ID en columnas para LatReg (biotemperatura), Ppt_P (Precipitación) y Phum (Piso de Humedad)
m_final <- coor.m.zonas %>%
  separate("CHELSA_bio1_1981-2010_V.2.1", into = c("LatReg_P", "Ppt_P", "Phum_P"), sep = "(?<=.)") %>%
  separate(paste0("CHELSA_bio1_2011-2040_", model_name,"_ssp370_V.2.1"), into = c("LatReg_fut", "Ppt_fut", "Phum_fut"), sep = "(?<=.)") %>%
  mutate(across(c(LatReg_P, Ppt_P, Phum_P, LatReg_fut, Ppt_fut, Phum_fut), as.numeric))

# Calcular la diferencia entre los vectores de cada variable entre tiempos
Lat.vector_fut <- abs(m_final$LatReg_P - m_final$LatReg_fut)
Ppt.vector_fut <- abs(m_final$Ppt_P - m_final$Ppt_fut)
Phum.vector_fut <- abs(m_final$Phum_P - m_final$Phum_fut)

# Sumar las diferencias para identificar zonas que cambian o se mantienen estables
suma.vec_fut <- Lat.vector_fut + Ppt.vector_fut + Phum.vector_fut
names(suma.vec_fut) <- "suma.vec_fut"

# Añadir vectores de diferencia y suma a la matriz final
m_final_fut <- cbind(m_final, Lat.vector_fut, Ppt.vector_fut, Phum.vector_fut, suma.vec_fut) %>%
  rename(
    Lat.vec_fut = Lat.vector_fut,
    Ppt.vec_fut = Ppt.vector_fut,
    Phum.vec_fut = Phum.vector_fut
  )

# Identificar zonas de clima estable
estables_fut <- subset(m_final_fut, suma.vec_fut == 0)
coor.ref <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
estables_fut <-terra::vect(estables_fut,geom=c("x", "y"), crs=coor.ref)
estables <- terra::rasterize(estables_fut,zv, field=1)
plot(estables)
terra::writeRaster(estables, filename=paste0("ssp370_",model_name,"_2011-2040_ZVH/estable_",model_name,".tif"), overwrite = TRUE)

# Identificar zonas de clima que cambian
cambio_fut <- subset(m_final_fut, suma.vec_fut != 0)
cambio_fut <-terra::vect(cambio_fut,geom=c("x", "y"), crs=coor.ref)
cambio <- terra::rasterize(cambio_fut,zv, field="suma.vec_fut")
plot(cambio)
terra::writeRaster(cambio, filename=paste0("ssp370_",model_name,"_2011-2040_ZVH/cambio_",model_name,".tif"), overwrite = TRUE)

# Indice
id_fut <-terra::vect(m_final_fut,geom=c("x", "y"), crs=coor.ref)
id <- terra::rasterize(id_fut,zv, field="suma.vec_fut")
plot(id)
# Reescalar los valores de 0 a 8 a un rango de 0 a 1
id_rescaled <- rescale(values(id), to = c(0, 1), from = c(0, 8))
# Asignar los valores reescalados de vuelta al raster
values(id) <- id_rescaled
plot(id)
terra::writeRaster(id, filename=paste0("ssp370_",model_name,"_2011-2040_ZVH/ISC_",model_name,".tif"), overwrite = TRUE)
}
)
