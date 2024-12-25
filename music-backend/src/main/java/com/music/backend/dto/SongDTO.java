package com.music.backend.dto;

import lombok.Data;

@Data
public class SongDTO {
    private Long id;
    private String title;
    private String artist;
    private String album;
    private String coverUrl;
    private String url;
    private Integer duration;
    private Long fileSize;
    private String mimeType;
} 