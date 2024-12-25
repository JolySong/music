package com.music.backend.service;

import com.music.backend.dto.SongDTO;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface SongService {
    List<SongDTO> getAllSongs();
    SongDTO getSongById(Long id);
    SongDTO uploadSong(MultipartFile file, String title, String artist, String album);
    Resource getAudioFile(Long id);
    void deleteSong(Long id);
} 