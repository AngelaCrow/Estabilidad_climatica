# Cargar el paquete necesario
library(terra)

# Limpiar el entorno
rm(list = ls())

# Crear directorio de salida si no existe
dir.create("Presente_1981-2010_ZVH", showWarnings = FALSE)

# Leer los datos necesarios
presente <- terra::rast("/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/1981-2010/CHELSA_bio_1981-2010_V.2.1.tif") 
ap <- presente[[4]] # Precipitación (mm)
at <- presente[[1]] # Temperatura

# Explorar datos
summary(at)
plot(at, main = "Temperatura (ºC)")

summary(ap)
plot(ap, main = "Precipitación (mm)")

# Proyectar y alinear los rasters
at <- terra::project(at, terra::crs(ap), method = "near")
terra::ext(at) <- terra::ext(ap)

# Verificar si los rasters tienen la misma extensión y proyección
terra::compareGeom(at, ap)

# Guardar los nuevos archivos
terra::writeRaster(at, filename = "Presente_1981-2010_ZVH/at.tif", overwrite = TRUE)
terra::writeRaster(ap, filename = "Presente_1981-2010_ZVH/ap.tif", overwrite = TRUE)

# Calcular biotemperature con temperatura y latitud
biotTem <- at
biotTem[biotTem < 0.0] <- 0
biotTem[biotTem > 30.0] <- 30
plot(biotTem, main = "BioTemperatura (ºC)")

# Guardar biotemperature
terra::writeRaster(biotTem, filename = "Presente_1981-2010_ZVH/biot.tif", overwrite = TRUE)

# Calcular evapotranspiración potencial (pet)
pet <- biotTem * 58.93
plot(pet,main = "Evapotranspiración potencial")
terra::writeRaster(pet, filename = "Presente_1981-2010_ZVH/pet.tif", overwrite = TRUE)

# Calcular ratio de evapotranspiración potencial
per <- pet / ap
plot(per, main = "Ratio de evapotranspiración potencial")
terra::writeRaster(per, filename = "Presente_1981-2010_ZVH/per.tif", overwrite = TRUE)

# Categorías de precipitación anual (mm)
apCat <- ap
apCat[ap <= 125.0] <- 1
apCat[ap > 125.0 & ap <= 250.0] <- 2
apCat[ap > 250.0 & ap <= 500.0] <- 3
apCat[ap > 500.0 & ap <= 1000.0] <- 4
apCat[ap > 1000.0 & ap <= 2000.0] <- 5
apCat[ap > 2000.0 & ap <= 4000.0] <- 6
apCat[ap > 4000.0 & ap <= 8000.0] <- 7
apCat[ap > 8000.0] <- 8
terra::writeRaster(apCat, filename = "Presente_1981-2010_ZVH/apCat.tif", overwrite = TRUE)

# Clasificación de regiones latitudinales
latr <- biotTem
latr[latr <= 1.5] <- 1 ## [1] Polar
latr[latr > 1.5 & latr <= 3.0] <- 2 ## [2] Subpolar
latr[latr > 3.0 & latr <= 6.0] <- 3 ## [3] Boreal
latr[latr > 6.0 & latr <= 12.0] <- 4 ## [4] Cool temperate
latr[latr > 12.0 & latr <= 18.0] <- 5 ## [5] Warm temperate
latr[latr > 18.0 & latr <= 24.0] <- 6 ## [6] Subtropical
latr[latr > 24.0] <- 7 ## [7] Tropical

terra::writeRaster(latr, filename = "Presente_1981-2010_ZVH/latr.tif", overwrite = TRUE)

# Clasificación de provincias de humedad
provhum <- per * 1000
provhum[provhum <= 250] <- 9 ## [9] Superhumid
provhum[provhum > 250 & provhum <= 500] <- 8 ## [8] Perhumid
provhum[provhum > 500 & provhum <= 1000] <- 7  ## [7] Humid
provhum[provhum > 1000 & provhum <= 2000] <- 6 ## [6] Subhumid 
provhum[provhum > 2000 & provhum <= 4000] <- 5 ## [5] Semiarid 
provhum[provhum > 4000 & provhum <= 8000] <- 4 ## [4] Arid  
provhum[provhum > 8000 & provhum <= 16000] <- 3 ## [3] Perarid 
provhum[provhum > 16000 & provhum <= 32000] <- 2 ## [2] Superarid
provhum[provhum > 32000] <- 1 ## [1] Semiparched
terra::writeRaster(provhum, filename = "Presente_1981-2010_ZVH/provhum.tif", overwrite = TRUE)

# Crear zonas de vida Holdridge
raster1 <- terra::rast("Presente_1981-2010_ZVH/latr.tif")
raster2 <- terra::rast("Presente_1981-2010_ZVH/apCat.tif")

# Combinación de categorías de latitud y precipitación
combinations <- list(
  c(1, 1, 1), c(1, 2, 1), c(1, 3, 1),
  c(2, 1, 2), c(2, 2, 3), c(2, 3, 4), c(2, 4, 5),
  c(3, 1, 6), c(3, 2, 7), c(3, 3, 8), c(3, 4, 9), c(3, 5, 10), c(3, 6, 10),
  c(4, 1, 11), c(4, 2, 12), c(4, 3, 13), c(4, 4, 14), c(4, 5, 15), c(4, 6, 16),
  c(5, 1, 17), c(5, 2, 18), c(5, 3, 19), c(5, 4, 20), c(5, 5, 21), c(5, 6, 22), c(5, 7, 23),
  c(6, 1, 24), c(6, 2, 25), c(6, 3, 26), c(6, 4, 27), c(6, 5, 28), c(6, 6, 29), c(6, 7, 30),
  c(7, 1, 31), c(7, 2, 32), c(7, 3, 33), c(7, 4, 34), c(7, 5, 35), c(7, 6, 36), c(7, 7, 37), c(7, 8, 38)
)

for (comb in combinations) {
  raster1[raster1 == comb[1] & raster2 == comb[2]] <- comb[3]
}

raster3 <- terra::rast("Presente_1981-2010_ZVH/provhum.tif")

# Combinación con provincias de humedad
prov_combinations <- list(
  c(1, 7, 1), c(1, 8, 1), c(1, 9, 1),
  c(2, 6, 2), c(3, 7, 3), c(4, 8, 4), c(5, 9, 5),
  c(6, 5, 6), c(7, 6, 7), c(8, 7, 8), c(9, 8, 9), c(10, 9, 10),
  c(11, 4, 11), c(12, 5, 12), c(13, 6, 13), c(14, 7, 14), c(15, 8, 15), c(16, 9, 16),
  c(17, 3, 17), c(18, 4, 18), c(19, 5, 19), c(20, 6, 20), c(21, 7, 21), c(22, 8, 22), c(23, 9, 23),
  c(24, 3, 24), c(25, 4, 25), c(26, 5, 26), c(27, 6, 27), c(28, 7, 28), c(29, 8, 29), c(30, 9, 30),
  c(31, 2, 31), c(32, 3, 32), c(33, 4, 33), c(34, 5, 34), c(35, 6, 35), c(36, 7, 36), c(37, 8, 37), c(38, 9, 38)
)

for (comb in prov_combinations) {
  raster1[raster1 == comb[1] & raster3 == comb[2]] <- comb[3]
}

# Renombrar zonas de vida Holdridge con otros ID
zvh_combinations <- list(
  c(1, 117), c(2, 216), c(3, 227), c(4, 238), c(5, 249),
  c(6, 315), c(7, 326), c(8, 337), c(9, 348), c(10, 359),
  c(11, 414), c(12, 425), c(13, 436), c(14, 447), c(15, 458),
  c(16, 469), c(17, 513), c(18, 524), c(19, 535), c(20, 546),
  c(21, 557), c(22, 568), c(23, 579), c(24, 613), c(25, 624),
  c(26, 635), c(27, 646), c(28, 657), c(29, 668), c(30, 679),
  c(31, 712), c(32, 723), c(33, 734), c(34, 745), c(35, 756),
  c(36, 767), c(37, 778), c(38, 789)
)

for (comb in zvh_combinations) {
  raster1[raster1 == comb[1]] <- comb[2]
}

# Guardar el raster final
terra::writeRaster(raster1, filename = "Presente_1981-2010_ZVH/zvh.tif", overwrite = TRUE)
plot(raster1, main = "Zonas de vida")
unique(raster1)
