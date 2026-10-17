# Klasifikasi Tutupan Lahan Kabupaten Wonogiri Menggunakan Sentinel-2 L2A

Tugas Besar ETS Pemrograman Spasial A, Teknik Geomatika, Institut Teknologi Sepuluh Nopember.

Proyek ini mengklasifikasikan tutupan lahan Kabupaten Wonogiri menjadi empat kelas (**vegetasi, bangunan, perairan, awan**) dari citra Sentinel-2 L2A tanggal 14 Oktober 2026. Hasilnya dihitung per kecamatan (zonal statistics) dan ditampilkan dalam dashboard interaktif Shiny dan Leaflet.

## Peta Klasifikasi Tutupan Lahan

**Layout peta (QGIS)**

![Layout peta QGIS](output/peta_layout_qgis.png)

**Peta hasil script R**

![Peta hasil R](output/peta_klasifikasi_layout.png)

## Dashboard Interaktif (Shiny dan Leaflet)

Dashboard memiliki empat menu:

1. **Tutupan Lahan**: peta interaktif dengan layer batas kabupaten, batas kecamatan, nama kecamatan, serta kelas vegetasi, bangunan, perairan, dan awan yang dapat dinyalakan atau dimatikan. Basemap dapat dipilih (OpenStreetMap atau Citra Satelit).
2. **Zonal Indeks per Kecamatan**: peta rata-rata NDVI, NDBI, NDWI, dan NDCI per kecamatan.
3. **Statistik per Kecamatan**: tabel zonal statistics, histogram, dan grafik rata-rata indeks.
4. **Luas Kelas per Kecamatan**: tabel luas dan grafik komposisi tutupan lahan.

Dashboard berjalan lewat R, bukan langsung di GitHub. Lihat bagian *Cara Menjalankan Dashboard*.

## Hasil Utama

| Kelas | Persentase luas |
|---|---|
| Vegetasi | 83,74% |
| Bangunan | 13,93% |
| Perairan | 1,50% |
| Awan | 0,83% |

- Wilayah studi terdiri dari **25 kecamatan**, dan citra menutupi seluruh wilayah (cakupan sekitar 100%).
- Rata-rata NDVI tertinggi: **Kecamatan Jatipurno (0,610)**.
- Rata-rata NDVI terendah: **Kecamatan Baturetno (0,334)**.

## Metode

1. Batas kecamatan RBI 25K difilter untuk Kabupaten Wonogiri dan diubah ke UTM zona 49S (EPSG:32749).
2. Band Sentinel-2 L2A (B03, B04, B05, B08, B11) dipotong, digabung (mosaic) dari tile yang menutupi wilayah, dan di-mask ke batas kabupaten.
3. Nilai piksel dikonversi ke reflektansi: `(DN - 1000) / 10000`.
4. Empat indeks spektral dihitung:

| Indeks | Rumus | Kegunaan |
|---|---|---|
| NDVI | (B08 - B04) / (B08 + B04) | Vegetasi |
| NDBI | (B11 - B08) / (B11 + B08) | Lahan terbangun |
| NDWI | (B03 - B08) / (B03 + B08) | Perairan |
| NDCI | (B05 - B04) / (B05 + B04) | Indikator awan |

5. Klasifikasi berbasis ambang batas:

| Kelas | Aturan |
|---|---|
| Vegetasi | NDVI ≥ 0,30 |
| Bangunan | NDVI < 0,30 dan NDBI > 0,15 |
| Perairan | NDWI > 0 (menimpa vegetasi dan bangunan) |
| Awan | NDCI ≤ 0,03 dan reflektansi merah ≥ 0,20 (diterapkan terakhir) |

6. Statistik indeks (mean, min, max, median, standar deviasi) dan luas tiap kelas dihitung per kecamatan.
7. Peta akhir disusun dalam layout QGIS (judul, legenda, skala, panah utara, grid koordinat, dan sumber data).

**Keterbatasan:** klasifikasi berbasis ambang batas sederhana, sehingga lahan terbuka tanpa vegetasi dapat terklasifikasi sebagai bangunan.

## Struktur Repository

```
.
├── Klasifikasi tutupan lahan.R   # script analisis lengkap
├── WebGIS.R                      # dashboard Shiny dan Leaflet
├── Tutupan lahan.Rproj           # file project RStudio
└── output/
    ├── kecamatan_wonogiri.*      # batas kecamatan (shapefile)
    ├── kabupaten_wonogiri.*      # batas kabupaten (shapefile)
    ├── zonal_statistics_kecamatan.csv
    ├── luas_kelas_kecamatan.csv
    ├── tabel_zonal_statistics.docx
    ├── peta_layout_qgis.png      # layout peta dari QGIS
    ├── peta_klasifikasi_layout.png   # peta dari script R
    ├── klasifikasi_50m.tif       # klasifikasi resolusi 50 m
    └── web/                      # raster per kelas untuk dashboard
```

## Sumber Data

- Citra satelit: Sentinel-2 L2A, akuisisi 14 Oktober 2026. Contains modified Copernicus Sentinel data (2026), Copernicus Data Space Ecosystem.
- Batas administrasi: Peta RBI skala 1:25.000 (2022), Badan Informasi Geospasial (BIG), melalui Ina-Geoportal.
- Peta dasar pada layout QGIS: Google Satellite © Google, diakses melalui plugin HCMGIS.

Citra mentah, geodatabase, dan raster beresolusi 10 m tidak disertakan karena ukurannya melebihi batas GitHub.

## Cara Menjalankan Dashboard

1. Clone repository ini, lalu buka `Tutupan lahan.Rproj` di RStudio.
2. Pasang package yang dibutuhkan:
```r
   install.packages(c("shiny", "shinydashboard", "leaflet", "leaflet.extras", "raster", "sf"))
```
3. Buka `WebGIS.R`, lalu klik **Run App**.

Data yang dibaca dashboard sudah tersedia di folder `output/`, sehingga analisis tidak perlu dijalankan ulang. Untuk mengulang seluruh analisis dari citra mentah, jalankan `Klasifikasi tutupan lahan.R` dengan menyesuaikan lokasi data di bagian awal script.

## Anggota Kelompok

- Adam Budi Kusumo    (5016241135)
- Alif Putra Dewangga (5016241121)
- (tambahkan anggota lain jika ada)