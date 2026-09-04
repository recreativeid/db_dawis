CREATE DATABASE IF NOT EXISTS db_pendataandawis;
USE db_pendataandawis;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NULL,
    password VARCHAR(255) NOT NULL,
    nama_lengkap VARCHAR(150) NOT NULL,
    role ENUM('warga', 'kader', 'kades') NOT NULL,
    nik VARCHAR(16) NULL
);

CREATE TABLE IF NOT EXISTS dawis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_dawis VARCHAR(100) NOT NULL,
    rt_rw VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS master_bantuan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_bantuan VARCHAR(100) NOT NULL,
    keterangan TEXT
);

CREATE TABLE IF NOT EXISTS keluarga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    no_kk VARCHAR(16) UNIQUE NOT NULL,
    nik_head VARCHAR(16) NULL,
    nama_kepala_keluarga VARCHAR(150) NULL,
    desa VARCHAR(100) DEFAULT 'Japan',
    alamat VARCHAR(255) NULL,
    rt VARCHAR(10) DEFAULT '1',
    rw VARCHAR(10) DEFAULT '4',
    dawis_id INT,
    nama_dawis VARCHAR(100) DEFAULT 'Dahlia 1',
    bantuan_id INT NULL,
    nama_bantuan VARCHAR(100) DEFAULT '-',
    total_anggota INT DEFAULT 1,
    laki INT DEFAULT 1,
    perempuan INT DEFAULT 0,
    balita_l INT DEFAULT 0,
    balita_p INT DEFAULT 0,
    lansia INT DEFAULT 0,
    pus INT DEFAULT 0,
    wus INT DEFAULT 0,
    hamil INT DEFAULT 0,
    menyusui INT DEFAULT 0,
    tuna_huruf INT DEFAULT 0,
    tuna_netra INT DEFAULT 0,
    tuna_rungu INT DEFAULT 0,
    khusus INT DEFAULT 0,
    kriteria_rumah VARCHAR(100) DEFAULT 'Sehat Layak Huni',
    fasilitas_sampah BOOLEAN DEFAULT 1,
    fasilitas_spal BOOLEAN DEFAULT 1,
    fasilitas_jamban BOOLEAN DEFAULT 1,
    stiker_p4k BOOLEAN DEFAULT 1,
    listrik BOOLEAN DEFAULT 1,
    sumber_air VARCHAR(50) DEFAULT 'PDAM',
    makanan_pokok VARCHAR(50) DEFAULT 'Beras',
    partisipasi VARCHAR(50) DEFAULT 'UP2K',
    is_penerima_bantuan BOOLEAN DEFAULT 0,
    FOREIGN KEY (dawis_id) REFERENCES dawis(id) ON DELETE SET NULL,
    FOREIGN KEY (bantuan_id) REFERENCES master_bantuan(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS anggota_keluarga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    keluarga_id INT NOT NULL,
    nik VARCHAR(16) UNIQUE,
    nama_lengkap VARCHAR(150) NOT NULL,
    hubungan VARCHAR(50) NOT NULL,
    jenis_kelamin VARCHAR(20) NOT NULL,
    usia INT DEFAULT 0,
    tanggal_lahir DATE NULL,
    status_pus BOOLEAN DEFAULT 0,
    status_wus BOOLEAN DEFAULT 0,
    sedang_hamil BOOLEAN DEFAULT 0,
    sedang_menyusui BOOLEAN DEFAULT 0,
    is_head BOOLEAN DEFAULT 0,
    disabilitas VARCHAR(100) DEFAULT 'Tidak Ada',
    FOREIGN KEY (keluarga_id) REFERENCES keluarga(id) ON DELETE CASCADE
);

-- Seed Data Users --
INSERT INTO users (username, email, password, nama_lengkap, role, nik) VALUES 
('3319011205800002', 'budi.santoso@japan.desa.id', '123', 'Budi Santoso', 'warga', '3319011205800002'),
('kader', 'kader@japan.desa.id', '123', 'Siti Aminah (Kader)', 'kader', NULL),
('kades', 'kades@japan.desa.id', '123', 'Bapak Kepala Desa', 'kades', NULL)
ON DUPLICATE KEY UPDATE nama_lengkap=VALUES(nama_lengkap);

-- Seed Data Dawis --
INSERT INTO dawis (id, nama_dawis, rt_rw) VALUES 
(1, 'dahlia 1', 'RT 01 / RW 04'),
(2, 'dahlia 2', 'RT 02 / RW 04'),
(3, 'dahlia 9', 'RT 03 / RW 04'),
(4, 'mawar 2', 'RT 02 / RW 04')
ON DUPLICATE KEY UPDATE nama_dawis=VALUES(nama_dawis);

-- Seed Data Master Bantuan --
INSERT INTO master_bantuan (id, nama_bantuan, keterangan) VALUES 
(1, 'PKH', 'Program Keluarga Harapan'),
(2, 'BPNT', 'Bantuan Pangan Non Tunai'),
(3, 'BLT', 'Bantuan Langsung Tunai'),
(4, 'PJK', 'Program Jaminan Kesejahteraan')
ON DUPLICATE KEY UPDATE nama_bantuan=VALUES(nama_bantuan);

-- Seed Data Keluarga (2 KK) --
INSERT INTO keluarga (id, no_kk, nik_head, nama_kepala_keluarga, desa, alamat, rt, rw, dawis_id, nama_dawis, nama_bantuan, total_anggota, laki, perempuan, balita_l, balita_p, lansia, pus, wus, hamil, menyusui, tuna_huruf, tuna_netra, tuna_rungu, khusus, kriteria_rumah, fasilitas_sampah, fasilitas_spal, fasilitas_jamban, stiker_p4k, listrik, sumber_air, makanan_pokok, partisipasi, is_penerima_bantuan) VALUES 
(1, '3319012345670001', '3319011205800002', 'Budi Santoso', 'Japan', 'RT 01 / RW 04', '1', '4', 1, 'Dahlia 1', 'PJK', 3, 1, 2, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 'Sehat Layak Huni', 1, 1, 1, 1, 1, 'PDAM', 'Beras', 'UP2K', 1),
(2, '3319012345670002', '3319011508850005', 'Slamet Riyadi', 'Japan', 'RT 02 / RW 04', '2', '4', 2, 'Dahlia 2', 'PJK', 4, 3, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 'RTLH Ringan / Sedang', 0, 0, 1, 1, 1, 'Sumur', 'Beras', 'UP2K', 1)
ON DUPLICATE KEY UPDATE nama_kepala_keluarga=VALUES(nama_kepala_keluarga);

-- Seed Data Anggota Keluarga (Total 7 Anggota) --
INSERT INTO anggota_keluarga (keluarga_id, nik, nama_lengkap, hubungan, jenis_kelamin, usia, status_pus, status_wus, sedang_hamil, sedang_menyusui, is_head) VALUES
(1, '3319011205800002', 'Budi Santoso', 'Kepala Keluarga', 'Laki-laki', 45, 1, 0, 0, 0, 1),
(1, '3319015506820003', 'Siti Aminah', 'Istri', 'Perempuan', 40, 0, 1, 1, 1, 0),
(1, '3319016003210001', 'Rina Santoso', 'Anak', 'Perempuan', 3, 0, 0, 0, 0, 0),
(2, '3319011508850005', 'Slamet Riyadi', 'Kepala Keluarga', 'Laki-laki', 50, 1, 0, 0, 0, 1),
(2, '3319015809860002', 'Sri Wahyuni', 'Istri', 'Perempuan', 42, 0, 1, 0, 1, 0),
(2, '3319010107540001', 'Mbah Joyo', 'Orang Tua', 'Laki-laki', 70, 0, 0, 0, 0, 0),
(2, '3319011204220003', 'Doni Riyadi', 'Anak', 'Laki-laki', 4, 0, 0, 0, 0, 0)
ON DUPLICATE KEY UPDATE nama_lengkap=VALUES(nama_lengkap);
