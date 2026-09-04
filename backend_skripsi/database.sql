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
    nama_kepala_keluarga VARCHAR(150) NULL,
    alamat VARCHAR(255) NULL,
    dawis_id INT,
    bantuan_id INT NULL,
    kriteria_rumah ENUM('Ya (Layak Huni)', 'Tidak (Tidak Layak Huni)'),
    fasilitas_sampah BOOLEAN DEFAULT 1,
    fasilitas_spal BOOLEAN DEFAULT 1,
    fasilitas_jamban BOOLEAN DEFAULT 1,
    stiker_p4k BOOLEAN DEFAULT 1,
    sumber_air ENUM('PDAM', 'Sumur', 'Mata Air', 'Lainnya'),
    makanan_pokok ENUM('Beras', 'Non Beras'),
    ikut_up2k BOOLEAN DEFAULT 1,
    ikut_kegiatan_2k BOOLEAN DEFAULT 1,
    ikut_ptp BOOLEAN DEFAULT 1,
    ikut_industri_rt BOOLEAN DEFAULT 1,
    ikut_kerja_bakti BOOLEAN DEFAULT 1,
    FOREIGN KEY (dawis_id) REFERENCES dawis(id) ON DELETE SET NULL,
    FOREIGN KEY (bantuan_id) REFERENCES master_bantuan(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS anggota_keluarga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    keluarga_id INT NOT NULL,
    nik VARCHAR(16) UNIQUE,
    nama_lengkap VARCHAR(150) NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    tanggal_lahir DATE NOT NULL,
    status_keluarga ENUM('Kepala Keluarga', 'Istri', 'Anak', 'Lainnya') NOT NULL,
    status_pus BOOLEAN DEFAULT 0,
    status_wus BOOLEAN DEFAULT 0,
    sedang_hamil BOOLEAN DEFAULT 0,
    sedang_menyusui BOOLEAN DEFAULT 0,
    disabilitas ENUM('Tidak Ada', 'Tuna Huruf', 'Tuna Netra', 'Tuna Rungu', 'Berkebutuhan Khusus Lainnya') DEFAULT 'Tidak Ada',
    FOREIGN KEY (keluarga_id) REFERENCES keluarga(id) ON DELETE CASCADE
);

-- Insert dummy data --
INSERT INTO users (username, password, nama_lengkap, role, nik) VALUES 
('3319011205800002', '123', 'Budi Santoso', 'warga', '3319011205800002'),
('kader', '123', 'Siti Aminah (Kader)', 'kader', NULL),
('kades', '123', 'Bapak Kepala Desa', 'kades', NULL);

INSERT INTO dawis (nama_dawis, rt_rw) VALUES ('Dawis Mawar', 'RT 01 / RW 02');
