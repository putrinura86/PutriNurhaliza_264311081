... Laporan ringkasan ...
SELECT z.nama_zona, COUNT(l.id_laporan) AS total_laporan
FROM laporan l
JOIN zona_lahan z ON l.id_zona = z.id_zona
WHERE l.tanggal_laporan >= '2026-10-01'
GROUP BY z.nama_zona; 

... Alur eksekusi ...
1. JOIN    : laporan (transaksi) digabung dengan zona_lahan (induk) lewat id_zona
2. WHERE   : hanya laporan dengan tanggal_laporan >= 2026-10-01 yang diambil
3. GROUP BY: laporan dikelompokkan per nama_zona
4. SELECT  : tampilkan nama_zona dan hitung jumlah laporan (COUNT) tiap kelompok
