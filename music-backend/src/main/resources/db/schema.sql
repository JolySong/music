CREATE DATABASE IF NOT EXISTS music_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE music_db;

CREATE TABLE IF NOT EXISTS t_songs (
    id BIGINT AUTO_INCREMENT COMMENT '主键ID',
    title VARCHAR(255) NOT NULL COMMENT '歌曲标题',
    artist VARCHAR(255) NOT NULL COMMENT '艺术家',
    album VARCHAR(255) COMMENT '专辑名',
    cover_url VARCHAR(255) COMMENT '封面图片URL',
    file_name VARCHAR(255) NOT NULL COMMENT '文件名',
    file_size BIGINT COMMENT '文件大小(字节)',
    mime_type VARCHAR(100) COMMENT '文件类型',
    duration INTEGER COMMENT '时长(秒)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '是否删除: 0-未删除, 1-已删除',
    PRIMARY KEY (id),
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='歌曲信息表';

CREATE TABLE IF NOT EXISTS t_lyrics (
    id BIGINT AUTO_INCREMENT COMMENT '主键ID',
    song_id BIGINT NOT NULL COMMENT '关联的歌曲ID',
    content TEXT NOT NULL COMMENT '歌词内容',
    time_point BIGINT NOT NULL COMMENT '时间点(毫秒)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT NOT NULL DEFAULT 0 COMMENT '是否删除: 0-未删除, 1-已删除',
    PRIMARY KEY (id),
    INDEX idx_song_id (song_id),
    INDEX idx_deleted (deleted),
    FOREIGN KEY (song_id) REFERENCES t_songs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='歌词信息表'; 