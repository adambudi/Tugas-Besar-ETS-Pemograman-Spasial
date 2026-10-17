# Klasifikasi Tutupan Lahan Kabupaten Wonogiri Menggunakan Sentinel-2 L2A

Tugas Besar ETS Pemrograman Spasial A, Teknik Geomatika, Institut Teknologi Sepuluh Nopember.

Proyek ini mengklasifikasikan tutupan lahan Kabupaten Wonogiri menjadi empat kelas (**vegetasi, bangunan, perairan, awan**) dari citra Sentinel-2 L2A tanggal 14 Oktober 2026. Hasilnya dihitung per kecamatan (zonal statistics) dan ditampilkan dalam dashboard interaktif Shiny dan Leaflet.

## Peta Klasifikasi Tutupan Lahan

![Peta Klasifikasi Tutupan Lahan Kabupaten Wonogiri](output/peta_klasifikasi_layout.png)

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
2. Band Sentinel-2 L2A (B03, B04, B05, B08, B11) dipotong, digabung (mosaic) dari tiga tile, dan di-mask ke batas kabupaten.
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
    ├── peta_klasifikasi_layout.png
    ├── klasifikasi_50m.tif       # klasifikasi resolusi 50 m
    └── web/                      # raster per kelas untuk dashboard
```

## Data

- Batas administrasi: RBI skala 1:25.000, Ina-Geoportal, Badan Informasi Geospasial (BIG).
- Citra satelit: Sentinel-2 L2A (14 Oktober 2026), tile T49MDM, T49MEM, dan T49LDL, Copernicus (ESA).

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

- Adam Budi Kusumo
- Alif Putra Dewangga
- (tambahkan anggota lain jika ada)
