USE smart_agiculture_db;

-- 1. GANGGUAN_SENSOR
--    Mencatat setiap gangguan sensor (data tidak masuk, data anomali, sensor mati)
--    yang terdeteksi, beserta operator yang memverifikasinya.
CREATE TABLE gangguan_sensor (
    id_gangguan      INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor        INT NOT NULL,
    id_operator      INT NOT NULL,
    waktu_deteksi    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    jenis_gangguan   ENUM('Data Tidak Masuk','Data Anomali','Sensor Mati') NOT NULL,
    status_gangguan  ENUM('Terdeteksi','Diverifikasi','Ditangani','Selesai') NOT NULL DEFAULT 'Terdeteksi',
    CONSTRAINT fk_gangguan_sensor
        FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_gangguan_operator
        FOREIGN KEY (id_operator) REFERENCES pengguna(id_pengguna)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 2. PENANGANAN_GANGGUAN (entitas lemah: PK gabungan id_gangguan + no_urut)
--    Satu gangguan dapat ditangani lebih dari satu kali oleh petugas lapangan.
CREATE TABLE penanganan_gangguan (
    id_gangguan          INT NOT NULL,
    no_urut              INT NOT NULL,
    id_petugas           INT NOT NULL,
    tanggal_penanganan   DATE NOT NULL,
    tindakan             VARCHAR(150) NOT NULL,
    keterangan           TEXT NULL,
    PRIMARY KEY (id_gangguan, no_urut),
    CONSTRAINT fk_penanganan_gangguan
        FOREIGN KEY (id_gangguan) REFERENCES gangguan_sensor(id_gangguan)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_penanganan_petugas
        FOREIGN KEY (id_petugas) REFERENCES pengguna(id_pengguna)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_penanganan_no_urut CHECK (no_urut > 0)
);

-- 3. INDEX untuk pencarian gangguan yang belum selesai dan riwayat gangguan per sensor
CREATE INDEX idx_gangguan_status      ON gangguan_sensor (status_gangguan, jenis_gangguan);
CREATE INDEX idx_gangguan_sensor_waktu ON gangguan_sensor (id_sensor, waktu_deteksi);
