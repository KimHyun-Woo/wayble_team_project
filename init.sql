CREATE DATABASE IF NOT EXISTS wayble_db;
USE wayble_db;

-- 1. 사용자 테이블
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    login_id VARCHAR(50) NOT NULL UNIQUE,
    login_password VARCHAR(255) NOT NULL,
    mobility_type VARCHAR(30),
    preferences JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 경로 정보
CREATE TABLE routes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100),
    description TEXT,
    start_lat DOUBLE NOT NULL,
    start_lng DOUBLE NOT NULL,
    end_lat DOUBLE NOT NULL,
    end_lng DOUBLE NOT NULL,
    source_type ENUM('USER', 'API') DEFAULT 'USER',
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 3. 고정밀 경로 좌표
CREATE TABLE route_points (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    lat DOUBLE NOT NULL,
    lng DOUBLE NOT NULL,
    sequence_order INT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE
);

-- 4. 태그 시스템
CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE
);

CREATE TABLE route_tags (
    route_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (route_id, tag_id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- 5. 장애물 및 이벤트
CREATE TABLE place_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lat DOUBLE NOT NULL,
    lng DOUBLE NOT NULL,
    title VARCHAR(100),
    description TEXT,
    type VARCHAR(50),
    is_verified BOOLEAN DEFAULT FALSE,
    start_date TIMESTAMP NULL,
    end_date TIMESTAMP NULL,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 6. 리뷰 및 통계
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    route_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    content TEXT,
    status ENUM('VISIBLE', 'BLINDED') DEFAULT 'VISIBLE',
    report_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (route_id) REFERENCES routes(id)
);

CREATE TABLE route_stats (
    route_id INT PRIMARY KEY,
    avg_rating FLOAT DEFAULT 0,
    review_count INT DEFAULT 0,
    popularity_score DOUBLE DEFAULT 0,
    FOREIGN KEY (route_id) REFERENCES routes(id)
);

-- 7. 이미지 관리
CREATE TABLE images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    user_id INT,
    route_id INT,
    place_event_id INT,
    image_category ENUM('START', 'MIDDLE', 'END', 'OBSTACLE') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (place_event_id) REFERENCES place_events(id)
);

-- 8. 기타 기능
CREATE TABLE bookmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    route_id INT,
    lat DOUBLE,
    lng DOUBLE,
    type ENUM('ROUTE', 'LOCATION'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (route_id) REFERENCES routes(id)
);

CREATE TABLE reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    route_id INT,
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (route_id) REFERENCES routes(id)
);