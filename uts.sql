-- =====================================================================
-- PENAMBAHAN PROSES BISNIS: NOTIFIKASI PERINGATAN
-- =====================================================================

-- ---------------------------------------------------------------------
-- A. ALASAN BISNIS
-- ---------------------------------------------------------------------
-- Sebelumnya peringatan hanya tersimpan di database, tanpa bukti siapa
-- yang sudah diberi tahu dan siapa yang sudah membacanya. Proses baru:
-- setiap peringatan dikirim ke satu atau banyak pengguna, dan sistem
-- mencatat saluran, waktu kirim, serta status baca tiap penerima.
-- Relasi PERINGATAN dan PENGGUNA menjadi M:N, dipecah lewat tabel
-- NOTIFIKASI_PERINGATAN.

-- ---------------------------------------------------------------------
-- B. ANALISIS NORMALISASI
-- ---------------------------------------------------------------------
-- Rancangan awal (semua di tabel peringatan):
--   peringatan(id_peringatan, id_pengukuran, waktu_peringatan,
--              status_peringatan, penerima, saluran_kirim, waktu_baca)
--   contoh: (1, 10, ..., 'Diproses', 'budi, sari', 'WA, Email', ...)
--
-- 1NF : TIDAK terpenuhi. Kolom penerima dan saluran_kirim berisi banyak
--       nilai dalam satu sel. Solusi: satu baris per pasangan
--       (peringatan, penerima), PK gabungan (id_peringatan, id_pengguna).
--   notifikasi(id_peringatan, id_pengguna, nama_pengguna, role,
--              saluran, waktu_kirim, status_baca, waktu_baca)
--
-- 2NF : TIDAK terpenuhi. id_pengguna -> nama_pengguna, role adalah
--       ketergantungan parsial terhadap PK gabungan. Solusi: atribut
--       itu dipisahkan ke tabel pengguna (sudah ada).
--   notifikasi_peringatan(id_peringatan, id_pengguna, saluran,
--                         waktu_kirim, status_baca, waktu_baca)
--
-- 3NF : TERPENUHI. Tidak ada ketergantungan transitif antar atribut
--       non-key; semuanya bergantung langsung pada PK gabungan.
--
-- Relasi: PENGGUNA (1) --- (N) NOTIFIKASI_PERINGATAN (N) --- (1) PERINGATAN

-- ---------------------------------------------------------------------
-- C. DDL
-- ---------------------------------------------------------------------
-- Tabel pengguna dan peringatan sudah ada pada skema sebelumnya.

CREATE TABLE notifikasi_peringatan (
  id_peringatan  INT         NOT NULL,
  id_pengguna    INT         NOT NULL,
  saluran        VARCHAR(20) NOT NULL DEFAULT 'Aplikasi',
  waktu_kirim    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_baca    VARCHAR(20) NOT NULL DEFAULT 'Terkirim',
  waktu_baca     DATETIME    NULL,

  PRIMARY KEY (id_peringatan, id_pengguna),
  KEY idx_notif_pengguna (id_pengguna, status_baca),

  CONSTRAINT fk_notif_peringatan FOREIGN KEY (id_peringatan)
    REFERENCES peringatan (id_peringatan)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_notif_pengguna FOREIGN KEY (id_pengguna)
    REFERENCES pengguna (id_pengguna)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT chk_notif_saluran
    CHECK (saluran IN ('Aplikasi','Email','WhatsApp','SMS')),
  CONSTRAINT chk_notif_status_baca
    CHECK (status_baca IN ('Terkirim','Dibaca','Gagal')),
  CONSTRAINT chk_notif_waktu_baca CHECK (
    (status_baca = 'Dibaca' AND waktu_baca IS NOT NULL
       AND waktu_baca >= waktu_kirim)
    OR (status_baca <> 'Dibaca' AND waktu_baca IS NULL)
  )
);

-- ---------------------------------------------------------------------
-- D. DATA CONTOH
-- ---------------------------------------------------------------------
-- Mengasumsikan peringatan id 1-2 dan pengguna id 1-3 sudah ada.

INSERT INTO notifikasi_peringatan
  (id_peringatan, id_pengguna, saluran, waktu_kirim, status_baca, waktu_baca) VALUES
(1, 1, 'WhatsApp', '2026-10-24 08:02:00', 'Dibaca',   '2026-10-24 08:10:00'),
(1, 2, 'Aplikasi', '2026-10-24 08:02:00', 'Dibaca',   '2026-10-24 08:30:00'),
(2, 1, 'WhatsApp', '2026-10-24 09:17:00', 'Terkirim', NULL),
(2, 2, 'Email',    '2026-10-24 09:17:00', 'Gagal',    NULL),
(2, 3, 'Aplikasi', '2026-10-24 09:17:00', 'Terkirim', NULL);
