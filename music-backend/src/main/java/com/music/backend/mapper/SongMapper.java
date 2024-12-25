package com.music.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.backend.entity.Song;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SongMapper extends BaseMapper<Song> {
} 