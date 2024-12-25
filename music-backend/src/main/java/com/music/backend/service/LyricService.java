package com.music.backend.service;

import com.music.backend.dto.LyricDTO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface LyricService {
    List<LyricDTO> getLyricsBySongId(Long songId);
    List<LyricDTO> uploadLyrics(Long songId, MultipartFile file);
    void deleteLyrics(Long songId);
} 