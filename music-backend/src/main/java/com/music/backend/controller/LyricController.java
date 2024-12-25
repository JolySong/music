package com.music.backend.controller;

import com.music.backend.common.Result;
import com.music.backend.dto.LyricDTO;
import com.music.backend.service.LyricService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/lyrics")
@RequiredArgsConstructor
public class LyricController {

    private final LyricService lyricService;

    @GetMapping("/{songId}")
    public Result<List<LyricDTO>> getLyrics(@PathVariable Long songId) {
        try {
            List<LyricDTO> lyrics = lyricService.getLyricsBySongId(songId);
            return Result.success(lyrics);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping(value = "/{songId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<List<LyricDTO>> uploadLyrics(
            @PathVariable Long songId,
            @RequestParam("file") MultipartFile file
    ) {
        try {
            List<LyricDTO> lyrics = lyricService.uploadLyrics(songId, file);
            return Result.success(lyrics);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @DeleteMapping("/{songId}")
    public Result<Void> deleteLyrics(@PathVariable Long songId) {
        try {
            lyricService.deleteLyrics(songId);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
} 