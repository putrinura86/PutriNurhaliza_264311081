... Create table zona lahan ...
CREATE TABLE zona_lahan (
    id_zona        INT AUTO_INCREMENT PRIMARY KEY,
    nama_zona      VARCHAR(100) NOT NULL,
    luas_lahan     DECIMAL(10,2) NOT NULL,
    jenis_tanaman  VARCHAR(100)
);

... Create table pengguna ...
CREATE TABLE pengguna (
    id_pengguna    INT AUTO_INCREMENT PRIMARY KEY,
    nama_pengguna  VARCHAR(100) NOT NULL,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password       VARCHAR(255) NOT NULL,
    role           ENUM('Admin_Sistem','Petugas_Lapangan','Operator','Koordinator') NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    no_telp        VARCHAR(13)
);

... Create table laporan ...
CREATE TABLE laporan (
    id_laporan       INT AUTO_INCREMENT PRIMARY KEY,
    id_zona          INT NOT NULL,
    id_pengguna      INT NOT NULL,
    tanggal_laporan  DATE NOT NULL,
    ringkasan        TEXT,
    rekomendasi      TEXT,
    CONSTRAINT fk_laporan_zona
        FOREIGN KEY (id_zona) REFERENCES zona_lahan(id_zona),
    CONSTRAINT fk_laporan_pengguna
        FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
);
