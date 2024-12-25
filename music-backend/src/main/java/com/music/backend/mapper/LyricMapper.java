package com.music.backend.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.music.backend.entity.Lyric;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface LyricMapper extends BaseMapper<Lyric> {
    @Select("SELECT * FROM t_lyrics WHERE song_id = #{songId} ORDER BY time_point ASC")
    List<Lyric> findBySongId(Long songId);
} 