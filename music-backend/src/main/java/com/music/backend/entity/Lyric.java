package com.music.backend.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("t_lyrics")
public class Lyric {
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 关联的歌曲ID
     */
    private Long songId;

    /**
     * 歌词内容
     */
    private String content;

    /**
     * 歌词时间点（毫秒）
     */
    private Long timePoint;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /**
     * 是否删除: 0-未删除, 1-已删除
     */
    @TableLogic
    private Integer deleted;
} 