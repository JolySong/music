package com.music.backend.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.music.backend.dto.LyricDTO;
import com.music.backend.entity.Lyric;
import com.music.backend.mapper.LyricMapper;
import com.music.backend.service.LyricService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LyricServiceImpl extends ServiceImpl<LyricMapper, Lyric> implements LyricService {

    private static final Pattern TIME_PATTERN = Pattern.compile("\\[(\\d{2}):(\\d{2})\\.(\\d{2,3})\\]");

    @Override
    public List<LyricDTO> getLyricsBySongId(Long songId) {
        return baseMapper.findBySongId(songId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public List<LyricDTO> uploadLyrics(Long songId, MultipartFile file) {
        try {
            // 删除现有歌词
            deleteLyrics(songId);

            List<Lyric> lyrics = new ArrayList<>();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    // 解析每行歌词
                    Matcher matcher = TIME_PATTERN.matcher(line);
                    while (matcher.find()) {
                        // 解析时间标记
                        int minutes = Integer.parseInt(matcher.group(1));
                        int seconds = Integer.parseInt(matcher.group(2));
                        int milliseconds = Integer.parseInt(matcher.group(3));
                        if (matcher.group(3).length() == 2) {
                            milliseconds *= 10; // 如果是两位数，需要乘以10
                        }
                        
                        // 计算总的毫秒数
                        long timePoint = (minutes * 60 * 1000L) + (seconds * 1000L) + milliseconds;
                        
                        // 提取歌词文本
                        String content = line.substring(matcher.end()).trim();
                        if (!content.isEmpty()) {
                            Lyric lyric = new Lyric();
                            lyric.setSongId(songId);
                            lyric.setTimePoint(timePoint);
                            lyric.setContent(content);
                            lyrics.add(lyric);
                        }
                    }
                }
            }

            // 保存所有歌词
            saveBatch(lyrics);

            return lyrics.stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            throw new RuntimeException("Failed to parse lyrics file", e);
        }
    }

    @Override
    @Transactional
    public void deleteLyrics(Long songId) {
        remove(new LambdaQueryWrapper<Lyric>()
                .eq(Lyric::getSongId, songId));
    }

    private LyricDTO convertToDTO(Lyric lyric) {
        if (lyric == null) {
            return null;
        }

        LyricDTO dto = new LyricDTO();
        dto.setId(lyric.getId());
        dto.setSongId(lyric.getSongId());
        dto.setContent(lyric.getContent());
        dto.setTimePoint(lyric.getTimePoint());
        return dto;
    }
} 