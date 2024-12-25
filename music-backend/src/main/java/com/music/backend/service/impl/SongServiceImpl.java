package com.music.backend.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.music.backend.dto.SongDTO;
import com.music.backend.entity.Song;
import com.music.backend.mapper.SongMapper;
import com.music.backend.service.SongService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SongServiceImpl extends ServiceImpl<SongMapper, Song> implements SongService {

    @Value("${music.upload.path}")
    private String uploadPath;

    @Override
    public List<SongDTO> getAllSongs() {
        return list().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public SongDTO getSongById(Long id) {
        return convertToDTO(getById(id));
    }

    @Override
    public SongDTO uploadSong(MultipartFile file, String title, String artist, String album) {
        try {
            // 创建上传目录
            Path uploadDir = Paths.get(uploadPath);
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            // 生成唯一文件名
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String filename = UUID.randomUUID().toString() + extension;

            // 保存文件
            Path filePath = uploadDir.resolve(filename);
            Files.copy(file.getInputStream(), filePath);

            // 创建歌曲记录
            Song song = new Song();
            song.setTitle(title);
            song.setArtist(artist);
            song.setAlbum(album);
            song.setFileName(filename);
            song.setFileSize(file.getSize());
            song.setMimeType(file.getContentType());

            // 保存到数据库
            save(song);
            return convertToDTO(song);

        } catch (IOException e) {
            throw new RuntimeException("Failed to store file", e);
        }
    }

    @Override
    public Resource getAudioFile(Long id) {
        try {
            Song song = getById(id);
            if (song == null) {
                throw new RuntimeException("Song not found");
            }

            Path filePath = Paths.get(uploadPath).resolve(song.getFileName());
            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists() && resource.isReadable()) {
                return resource;
            } else {
                throw new RuntimeException("Could not read file");
            }
        } catch (MalformedURLException e) {
            throw new RuntimeException("Error: " + e.getMessage());
        }
    }

    @Override
    public void deleteSong(Long id) {
        Song song = getById(id);
        if (song == null) {
            throw new RuntimeException("Song not found");
        }

        // 删除文件
        try {
            Path filePath = Paths.get(uploadPath).resolve(song.getFileName());
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            throw new RuntimeException("Failed to delete file", e);
        }

        // 删除数据库记录
        removeById(id);
    }

    private SongDTO convertToDTO(Song song) {
        if (song == null) {
            throw new RuntimeException("Song not found");
        }

        SongDTO dto = new SongDTO();
        dto.setId(song.getId());
        dto.setTitle(song.getTitle());
        dto.setArtist(song.getArtist());
        dto.setAlbum(song.getAlbum());
        dto.setCoverUrl(song.getCoverUrl());
        dto.setDuration(song.getDuration());
        dto.setFileSize(song.getFileSize());
        dto.setMimeType(song.getMimeType());

        // 生成音频文件URL - 使用相对路径
        String audioUrl = "/api/songs/" + song.getId() + "/audio";
        dto.setUrl(audioUrl);

        return dto;
    }
} 