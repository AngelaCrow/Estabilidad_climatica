library(terra)
rm(list = ls())

# 2011-2040####
# ssp126####
# Listar todos los archivos raster que comienzan con "ISC" y tienen la extensión ".tif"
futuro_files<-list.files("/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp126_2011-2040/ZVH/", pattern = "^ISC_.*\\.tif$", recursive = TRUE,full.names = TRUE);futuro_files

outputFolder<-"/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp126_2011-2040/ZVH/"

# Filtrar los archivos raster que corresponden a los modelos específicos
#ssp126_2011-2040
selected_rasters <- futuro_files[grepl("gfdl-esm4|ukesm1-0-ll|mri-esm2-0|mpi-esm1-2-hr", futuro_files)]

# Cargar los rasters seleccionados
raster_stack <- terra::rast(selected_rasters)

# Calcular el promedio de los rasters
raster_mean <- mean(raster_stack)

# Mostrar el raster promedio
plot(raster_mean, main = "ISC_avg")

# Guardar el raster promedio
writeRaster(raster_mean, paste0(outputFolder,"ISC_futuro_files_avg.tif"), overwrite = TRUE)

# Filtrar solo las áreas donde el valor es igual a 0
estable_avg <- classify(raster_mean, cbind(0.01,1, 0), others = 1)

# Mostrar área estables
plot(estable_avg, main = "estables_avg")

# Guardar el raster binario
writeRaster(raster_mean, paste0(outputFolder,"estable_futuro_files_avg.tif"), overwrite = TRUE)
rm(outputFolder)

# ssp370####
# Listar todos los archivos raster que comienzan con "ISC" y tienen la extensión ".tif"
futuro_files<-list.files("/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp370_2011-2040/ZVH/", pattern = "^ISC_.*\\.tif$", recursive = TRUE,full.names = TRUE);futuro_files

outputFolder<-"/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp370_2011-2040/ZVH/"

# Filtrar los archivos raster que corresponden a los modelos específicos
#ssp370_2011-2040
selected_rasters <- futuro_files[grepl("gfdl-esm4|ukesm1-0-ll|mri-esm2-0|mpi-esm1-2-hr", futuro_files)]

# Cargar los rasters seleccionados
raster_stack <- terra::rast(selected_rasters)

# Calcular el promedio de los rasters
raster_mean <- mean(raster_stack)

# Mostrar el raster promedio
plot(raster_mean, main = "ISC_avg")

# Guardar el raster promedio
writeRaster(raster_mean, paste0(outputFolder,"ISC_futuro_files_avg.tif"), overwrite = TRUE)

# Filtrar solo las áreas donde el valor es igual a 0
unique(raster_mean)
estable_avg <- classify(raster_mean, cbind(0.01,1, 0), others = 1)

# Mostrar área estables
plot(estable_avg, main = "estables_avg")

# Guardar el raster binario
writeRaster(raster_mean, paste0(outputFolder,"estable_futuro_files_avg.tif"), overwrite = TRUE)

# ssp585####
# Listar todos los archivos raster que comienzan con "ISC" y tienen la extensión ".tif"
futuro_files<-list.files("/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp585_2011-2040/ZVH/", pattern = "^ISC_.*\\.tif$", recursive = TRUE,full.names = TRUE);futuro_files

outputFolder<-"/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp585_2011-2040/ZVH/"

# Filtrar los archivos raster que corresponden a los modelos específicos
#ssp585_2011-2040
selected_rasters <- futuro_files[grepl("ipsl-cm6a-lr|ukesm1-0-ll|mri-esm2-0|mpi-esm1-2-hr", futuro_files)]

# Cargar los rasters seleccionados
raster_stack <- terra::rast(selected_rasters)

# Calcular el promedio de los rasters
raster_mean <- mean(raster_stack)

# Mostrar el raster promedio
plot(raster_mean, main = "ISC_avg")

# Guardar el raster promedio
writeRaster(raster_mean, paste0(outputFolder,"ISC_futuro_files_avg.tif"), overwrite = TRUE)

# Filtrar solo las áreas donde el valor es igual a 0
estable_avg <- classify(raster_mean, cbind(0.01,1, 0), others = 1)

# Mostrar área estables
plot(estable_avg, main = "estables_avg")

# Guardar el raster binario
writeRaster(raster_mean, paste0(outputFolder,"estable_futuro_files_avg.tif"), overwrite = TRUE)

# 2041-2070####
# ssp126####
# Listar todos los archivos raster que comienzan con "ISC" y tienen la extensión ".tif"
futuro_files<-list.files("/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp126_2041-2070/ZVH/", pattern = "^ISC_.*\\.tif$", recursive = TRUE,full.names = TRUE);futuro_files

outputFolder<-"/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp126_2041-2070/ZVH/"

# Filtrar los archivos raster que corresponden a los modelos específicos
#ssp126_2041-2070
selected_rasters <- futuro_files[grepl("gfdl-esm4|ukesm1-0-ll|mpi-esm1-2-hr", futuro_files)]

# Cargar los rasters seleccionados
raster_stack <- terra::rast(selected_rasters)

# Calcular el promedio de los rasters
raster_mean <- mean(raster_stack)

# Mostrar el raster promedio
plot(raster_mean, main = "ISC_avg")

# Guardar el raster promedio
writeRaster(raster_mean, paste0(outputFolder,"ISC_futuro_files_avg.tif"), overwrite = TRUE)

# Filtrar solo las áreas donde el valor es igual a 0
estable_avg <- classify(raster_mean, cbind(0.01,1, 0), others = 1)

# Mostrar área estables
plot(estable_avg, main = "estables_avg")

# Guardar el raster binario
writeRaster(raster_mean, paste0(outputFolder,"estable_futuro_files_avg.tif"), overwrite = TRUE)
rm(outputFolder)

# ssp370####
# Listar todos los archivos raster que comienzan con "ISC" y tienen la extensión ".tif"
futuro_files<-list.files("/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp370_2041-2070/ZVH/", pattern = "^ISC_.*\\.tif$", recursive = TRUE,full.names = TRUE);futuro_files

outputFolder<-"/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp370_2041-2070/ZVH/"

# Filtrar los archivos raster que corresponden a los modelos específicos
#ssp370_2041-2070
selected_rasters <- futuro_files[grepl("ukesm1-0-ll|mpi-esm1-2-hr", futuro_files)]

# Cargar los rasters seleccionados
raster_stack <- terra::rast(selected_rasters)

# Calcular el promedio de los rasters
raster_mean <- mean(raster_stack)

# Mostrar el raster promedio
plot(raster_mean, main = "ISC_avg")

# Guardar el raster promedio
writeRaster(raster_mean, paste0(outputFolder,"ISC_futuro_files_avg.tif"), overwrite = TRUE)

# Filtrar solo las áreas donde el valor es igual a 0
estable_avg <- classify(raster_mean, cbind(0.01,1, 0), others = 1)

# Mostrar área estables
plot(estable_avg, main = "estables_avg")

# Guardar el raster binario
writeRaster(raster_mean, paste0(outputFolder,"estable_futuro_files_avg.tif"), overwrite = TRUE)

# ssp585####
# Listar todos los archivos raster que comienzan con "ISC" y tienen la extensión ".tif"
futuro_files<-list.files("/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp585_2041-2070/ZVH/", pattern = "^ISC_.*\\.tif$", recursive = TRUE,full.names = TRUE);futuro_files

outputFolder<-"/Volumes/TOSHIBA EXT/COBERTURAS/CHELSA/ssp585_2041-2070/ZVH/"

# Filtrar los archivos raster que corresponden a los modelos específicos
#ssp585_2041-2070
selected_rasters <- futuro_files[grepl("ipsl-cm6a-lr|ukesm1-0-ll|mri-esm2-0|mpi-esm1-2-hr", futuro_files)]

# Cargar los rasters seleccionados
raster_stack <- terra::rast(selected_rasters)

# Calcular el promedio de los rasters
raster_mean <- mean(raster_stack)

# Mostrar el raster promedio
plot(raster_mean, main = "ISC_avg")

# Guardar el raster promedio
writeRaster(raster_mean, paste0(outputFolder,"ISC_futuro_files_avg.tif"), overwrite = TRUE)

# Filtrar solo las áreas donde el valor es igual a 0
estable_avg <- classify(raster_mean, cbind(0.01,1, 0), others = 1)

# Mostrar área estables
plot(estable_avg, main = "estables_avg")

# Guardar el raster binario
writeRaster(raster_mean, paste0(outputFolder,"estable_futuro_files_avg.tif"), overwrite = TRUE)