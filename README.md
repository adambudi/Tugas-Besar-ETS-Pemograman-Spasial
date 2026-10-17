# Klasifikasi Tutupan Lahan Kabupaten Wonogiri (Sentinel-2 L2A)

Tugas Besar ETS Pemrograman Spasial A, Teknik Geomatika ITS.

## Deskripsi
Klasifikasi tutupan lahan Kabupaten Wonogiri menjadi empat kelas
(vegetasi, bangunan, perairan, awan) memakai indeks spektral NDVI, NDBI,
NDWI, dan NDCI dari citra Sentinel-2 L2A (14 Oktober 2026), lalu dihitung
zonal statistics per kecamatan dan ditampilkan dalam dashboard Shiny.

## Isi Repository
- `Klasifikasi tutupan lahan.R` : script analisis (batas administrasi, indeks, klasifikasi, zonal statistics, tabel Word)
- `WebGIS.R` : dashboard Shiny dan Leaflet
- `output/` : hasil analisis (shapefile batas, CSV statistik, tabel Word, peta, raster 50 m untuk dashboard)

## Data
- Batas administrasi: RBI 25K (Ina-Geoportal, BIG)
- Citra: Sentinel-2 L2A, tile T49MDM, T49MEM, T49LDL (Copernicus)
Citra mentah dan geodatabase tidak disertakan karena ukurannya besar.

## Cara Menjalankan Dashboard
1. Buka `Tutupan lahan.Rproj` di RStudio.
2. Install package: `install.packages(c("shiny", "shinydashboard", "leaflet", "leaflet.extras", "raster", "sf"))`
3. Buka `WebGIS.R`, lalu klik **Run App**.

## Anggota Kelompok
- Adam Budi Kusumo     (5016241135)
- Alif Putra Dewangga  (5016241121)
