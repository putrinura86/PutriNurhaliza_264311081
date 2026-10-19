... Laporan Ringkasan ...
SELECT z.nama_zona, COUNT(l.id_laporan) AS total_laporan
FROM laporan l
JOIN zona_lahan z ON l.id_zona = z.id_zona
WHERE l.tanggal_laporan >= '2026-10-01'
GROUP BY z.nama_zona; 
