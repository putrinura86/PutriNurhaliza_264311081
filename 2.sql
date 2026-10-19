... Tabel zona lahan ...
INSERT INTO zona_lahan (id_zona, nama_zona, luas_lahan, jenis_tanaman) VALUES
(1, 'Zona A', 2.50, 'Padi'),
(2, 'Zona B', 1.75, 'Jagung'),
(3, 'Zona C', 3.00, 'Cabai');

... Tabel pengguna ...
INSERT INTO pengguna (id_pengguna, nama_pengguna, username, password, role, email, no_telp) VALUES
(1, 'Meisa Putri', 'meisa', 'hash_dummy_1', 'Petugas_Lapangan', 'meisa@example.com', '081234567890'),
(2, 'Putri Zahrani', 'putri', 'hash_dummy_2', 'Koordinator', 'putri@example.com', '081234567891'),
(3, 'Alifa Nurhayati', 'alifa', 'hash_dummy_3', 'Operator', 'alifa@example.com', '081234567892');

... Tabel laporan ...
INSERT INTO laporan (id_laporan, id_zona, id_pengguna, tanggal_laporan, ringkasan, rekomendasi) VALUES
(1, 1, 1, '2026-10-01', 'Kelembapan tanah stabil', 'Pertahankan jadwal penyiraman'),
(2, 2, 2, '2026-10-05', 'Suhu sedikit tinggi', 'Tambah frekuensi penyiraman'),
(3, 1, 3, '2026-10-10', 'Sensor perlu dicek', 'Jadwalkan pengecekan sensor');

... Read ...
SELECT * FROM zona_lahan;

... Update ...
UPDATE laporan
SET rekomendasi = 'Kurangi frekuensi penyiraman'
WHERE id_laporan = 2;

... Delete ...
DELETE FROM laporan
WHERE id_laporan = 3;
