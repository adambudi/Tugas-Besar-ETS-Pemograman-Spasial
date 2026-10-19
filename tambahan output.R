# ==============================================================
# Tambahan output Wonogiri: peta, tabel per indeks, dan GeoPackage
# Membaca data dari folder output/ (tidak mengulang analisis)
# ==============================================================
library(sf)
library(terra)

setwd("D:/adam/Semester 5/PEMSPA/Tubes ETS/Tutupan lahan")

nama_kelas <- c("Vegetasi", "Bangunan", "Perairan", "Awan")
warna      <- c("#2E7D32", "#E53935", "#1E88E5", "#B0BEC5")

# 1. Baca data -----------------------------------------------------------
kec_sf <- st_read("output/kecamatan_wonogiri.shp", quiet = TRUE)
kec_v  <- vect("output/kecamatan_wonogiri.shp")
kab_v  <- vect("output/kabupaten_wonogiri.shp")
zs     <- read.csv("output/zonal_statistics_kecamatan.csv", check.names = FALSE)

b03 <- rast("output/band/B03_wonogiri.tif")
b04 <- rast("output/band/B04_wonogiri.tif")
b08 <- rast("output/band/B08_wonogiri.tif")

idx <- list(NDVI = rast("output/indeks/NDVI_wonogiri.tif"),
            NDBI = rast("output/indeks/NDBI_wonogiri.tif"),
            NDWI = rast("output/indeks/NDWI_wonogiri.tif"),
            NDCI = rast("output/indeks/NDCI_wonogiri.tif"))

kelas <- rast("output/klasifikasi_wonogiri.tif")
k50   <- rast("output/klasifikasi_50m.tif")

kelas_plot <- kelas
levels(kelas_plot) <- data.frame(id = 1:4, kelas = nama_kelas)

# 2. Peta ROI (batas wilayah studi) ---------------------------------------
png("output/peta_roi_wonogiri.png", width = 2400, height = 2400, res = 300)
plot(kec_v, border = "grey40", lwd = 0.6,
     main = "Wilayah Studi: Kabupaten Wonogiri")
plot(kab_v, add = TRUE, border = "red", lwd = 2)
text(kec_v, "WADMKC", cex = 0.45)
dev.off()

# 3. Citra hasil crop (komposit false color NIR-Red-Green) ----------------
png("output/citra_crop_wonogiri.png", width = 2400, height = 2400, res = 300)
plotRGB(c(b08, b04, b03), r = 1, g = 2, b = 3, stretch = "lin",
        main = "Citra Sentinel-2 hasil crop (false color NIR-Red-Green)")
plot(kab_v, add = TRUE, border = "yellow", lwd = 2)
dev.off()

# 4. Peta indeks spektral (2 x 2) ------------------------------------------
png("output/peta_indeks_wonogiri.png", width = 3000, height = 3000, res = 300)
par(mfrow = c(2, 2))
for (n in names(idx)) {
  plot(idx[[n]], main = n, range = c(-1, 1))
  plot(kab_v, add = TRUE, border = "black", lwd = 1)
}
par(mfrow = c(1, 1))
dev.off()

# 5. Peta klasifikasi ---------------------------------------------------------
png("output/peta_klasifikasi_wonogiri.png", width = 2400, height = 2400, res = 300)
plot(kelas_plot, col = warna,
     main = "Klasifikasi Tutupan Lahan Kabupaten Wonogiri")
plot(kab_v, add = TRUE, border = "black", lwd = 1.2)
dev.off()

# 6. Peta komposit: citra dan klasifikasi berdampingan ---------------------
png("output/peta_komposit_klasifikasi_wonogiri.png", width = 4000, height = 2000, res = 300)
par(mfrow = c(1, 2))
plotRGB(c(b08, b04, b03), r = 1, g = 2, b = 3, stretch = "lin",
        main = "Citra (false color)")
plot(kab_v, add = TRUE, border = "yellow", lwd = 1.5)
plot(kelas_plot, col = warna, main = "Klasifikasi tutupan lahan")
plot(kab_v, add = TRUE, border = "black", lwd = 1.2)
par(mfrow = c(1, 1))
dev.off()

# 7. Tabel zonal statistics per indeks (CSV) -----------------------------------
for (n in names(idx)) {
  kol <- paste0(n, c("_mean", "_min", "_max", "_median", "_sd"))
  d <- zs[, c("Kecamatan", kol)]
  names(d) <- c("Kecamatan", "Mean", "Min", "Max", "Median", "SD")
  write.csv(d, sprintf("output/tabel_zonal_%s.csv", n), row.names = FALSE)
}

# 8. GeoPackage: kecamatan, kecamatan + zonal, dan poligon klasifikasi -------
st_write(kec_sf, "output/kecamatan_wonogiri.gpkg", delete_dsn = TRUE, quiet = TRUE)

kec_zonal <- merge(kec_sf, zs, by.x = "WADMKC", by.y = "Kecamatan")
st_write(kec_zonal, "output/kecamatan_zonal_wonogiri.gpkg", delete_dsn = TRUE, quiet = TRUE)

poli <- as.polygons(k50, dissolve = TRUE)    # dari raster 50 m agar ringan
names(poli) <- "kode"
poli_sf <- st_as_sf(poli)
poli_sf$kelas <- nama_kelas[poli_sf$kode]
poli_sf <- st_transform(poli_sf, 4326)
st_write(poli_sf, "output/klasifikasi_poligon_wgs84_wonogiri.gpkg",
         delete_dsn = TRUE, quiet = TRUE)

# 9. Cek ukuran semua file di output ---------------------------------------------
f <- list.files("output", recursive = TRUE, full.names = TRUE)
info <- file.info(f)
head(data.frame(file = f, MB = round(info$size / 1024^2, 1))[order(-info$size), ], 10)