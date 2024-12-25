package com.music.backend.controller;

import com.music.backend.common.Result;
import com.music.backend.dto.SongDTO;
import com.music.backend.service.SongService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/songs")
@RequiredArgsConstructor
public class SongController {

    private final SongService songService;

    @GetMapping
    public Result<List<SongDTO>> getAllSongs() {
        try {
            List<SongDTO> songs = songService.getAllSongs();
            return Result.success(songs);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<SongDTO> getSongById(@PathVariable Long id) {
        try {
            SongDTO song = songService.getSongById(id);
            return Result.success(song);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<SongDTO> uploadSong(
            @RequestParam("file") MultipartFile file,
            @RequestParam("title") String title,
            @RequestParam("artist") String artist,
            @RequestParam(value = "album", required = false) String album
    ) {
        try {
            SongDTO songDTO = songService.uploadSong(file, title, artist, album);
            return Result.success(songDTO);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/{id}/audio")
    public ResponseEntity<Resource> getAudio(
            @PathVariable Long id,
            @RequestHeader(value = "Range", required = false) String rangeHeader
    ) {
        try {
            Resource resource = songService.getAudioFile(id);
            long contentLength = resource.contentLength();

            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "*");
            headers.setContentType(MediaType.parseMediaType("audio/mpeg"));
            headers.add("Accept-Ranges", "bytes");

            // 处理范围请求
            if (rangeHeader != null && rangeHeader.startsWith("bytes=")) {
                String[] ranges = rangeHeader.substring(6).split("-");
                long start = Long.parseLong(ranges[0]);
                long end = ranges.length > 1 ? Long.parseLong(ranges[1]) : contentLength - 1;
                long contentSize = end - start + 1;

                headers.add("Content-Range", String.format("bytes %d-%d/%d", start, end, contentLength));
                headers.setContentLength(contentSize);
                return ResponseEntity.status(HttpStatus.PARTIAL_CONTENT)
                        .headers(headers)
                        .body(resource);
            } else {
                headers.setContentLength(contentLength);
                return ResponseEntity.ok()
                        .headers(headers)
                        .body(resource);
            }
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteSong(@PathVariable Long id) {
        try {
            songService.deleteSong(id);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
} 