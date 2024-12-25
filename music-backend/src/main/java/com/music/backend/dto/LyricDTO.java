package com.music.backend.dto;

import lombok.Data;

@Data
public class LyricDTO {
    private Long id;
    private Long songId;
    private String content;
    private Long timePoint;
} 