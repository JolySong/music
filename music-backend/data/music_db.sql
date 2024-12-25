/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 90100 (9.1.0)
 Source Host           : localhost:3306
 Source Schema         : music_db

 Target Server Type    : MySQL
 Target Server Version : 90100 (9.1.0)
 File Encoding         : 65001

 Date: 25/12/2024 15:20:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_lyrics
-- ----------------------------
DROP TABLE IF EXISTS `t_lyrics`;
CREATE TABLE `t_lyrics` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `song_id` bigint NOT NULL COMMENT '关联的歌曲ID',
  `content` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌词内容',
  `time_point` bigint NOT NULL COMMENT '时间点(毫秒)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除: 0-未删除, 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_song_id` (`song_id`),
  KEY `idx_deleted` (`deleted`),
  CONSTRAINT `t_lyrics_ibfk_1` FOREIGN KEY (`song_id`) REFERENCES `t_songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='歌词信息表';

-- ----------------------------
-- Records of t_lyrics
-- ----------------------------
BEGIN;
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (1, 1, '词：唐恬', 1180, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (2, 1, '曲：钱雷', 1860, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (3, 1, '编曲：张亦江@MyMindMusic/郭俊江@MyMindMusic', 2530, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (4, 1, '制作人：张亦江@MyMindMusic', 4730, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (5, 1, '吉他：高飞/张星', 6250, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (6, 1, 'BASS：张星', 7610, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (7, 1, '伴唱：孙楠/张亦江@MyMindMusic', 8110, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (8, 1, '弦乐：国际首席爱乐乐团', 9970, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (9, 1, '人声录音室：55 TEC BEIJING', 11830, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (10, 1, '混音/母带工程师：赵靖', 13360, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (11, 1, '统筹/宣传：王山山/十七', 15220, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (12, 1, '监制：高航', 17250, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (13, 1, '发行总监：张柏生', 18090, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (14, 1, '发行监制：杨杰', 19440, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (15, 1, '发行统筹：高演音', 20630, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (16, 1, '发行：QQ音乐·新鲜制造工作室', 21980, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (17, 1, '词曲版权管理方：索尼音乐版权代理（北京）有限公司', 24350, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (18, 1, '出品：勇士音乐', 28410, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (19, 1, '特别鸣谢：孙楠工作室', 29590, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (20, 1, '我是这路上 没名字的人', 31280, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (21, 1, '我没有新闻 没有人评论', 38390, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (22, 1, '要拼尽所有 换得普通的剧本', 45520, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (23, 1, '曲折辗转 不过谋生', 52480, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (24, 1, '我是离开 小镇上的人', 59320, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (25, 1, '是赶路的人 是养家的人', 73850, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (26, 1, '是城市背景的 无声', 81050, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (27, 1, '我不过 想亲手触摸', 88310, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (28, 1, '弯过腰的每一刻', 90850, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (29, 1, '这哽咽 若你也相同', 102610, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (30, 1, '无名的人啊 我敬你一杯酒', 116850, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (31, 1, '敬你的沉默 和每一声怒吼', 120250, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (32, 1, '敬你弯着腰 上山往高处走', 123970, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (33, 1, '头顶 苍穹 努力地生活', 127550, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (34, 1, '你来自于 南方的村落', 163510, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (35, 1, '来自粗糙的双手', 166010, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (36, 1, '我来自于 北方的春天', 177730, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (37, 1, '背后有 告别的路口 温暖每个日落', 183450, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (38, 1, '当家乡入冬 的时候', 190480, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (39, 1, '小时候的风 再吹过', 194710, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (40, 1, '回忆起单纯 的快乐', 197660, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (41, 1, '在熟悉的 街头', 199880, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (42, 1, '有人 会用所有的温柔 喊出你的', 201860, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (43, 1, '名字', 208650, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (44, 1, '离家的人啊 我敬你一杯酒', 209990, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (45, 1, '敬你的沉默 和每一声怒吼', 213480, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (46, 1, '头顶 苍穹 努力地生活', 220690, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (47, 1, '敬你弯着腰 上山往高处走', 231330, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (48, 1, '头顶 苍穹 努力地生活', 234930, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (49, 1, '无名的人啊', 238610, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (50, 1, '无名的人啊', 253140, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (51, 1, '太多牵挂就 别回头啊', 274430, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (52, 1, '无名的人啊 车开啦', 281570, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
INSERT INTO `t_lyrics` (`id`, `song_id`, `content`, `time_point`, `created_at`, `updated_at`, `deleted`) VALUES (53, 1, '往前吧 带着你的梦', 290650, '2024-12-21 20:50:06', '2024-12-21 20:50:06', 0);
COMMIT;

-- ----------------------------
-- Table structure for t_songs
-- ----------------------------
DROP TABLE IF EXISTS `t_songs`;
CREATE TABLE `t_songs` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '歌曲标题',
  `artist` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '艺术家',
  `album` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '专辑名',
  `cover_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面图片URL',
  `file_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `mime_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文件类型',
  `duration` int DEFAULT NULL COMMENT '时长(秒)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '是否删除: 0-未删除, 1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_deleted` (`deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='歌曲信息表';

-- ----------------------------
-- Records of t_songs
-- ----------------------------
BEGIN;
INSERT INTO `t_songs` (`id`, `title`, `artist`, `album`, `cover_url`, `file_name`, `file_size`, `mime_type`, `duration`, `created_at`, `updated_at`, `deleted`) VALUES (1, '无名的人', '无名的人', '孙楠', 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/94/e1/e6/94e1e664-6b76-0191-f3ca-4205163fc0c5/cover.jpg/1200x1200bb.webp', 'f8c92d57-2018-4bef-a307-806d5e648521.mp3', 5118037, 'audio/mpeg', 319, '2024-12-21 18:31:48', '2024-12-22 01:31:09', 0);
INSERT INTO `t_songs` (`id`, `title`, `artist`, `album`, `cover_url`, `file_name`, `file_size`, `mime_type`, `duration`, `created_at`, `updated_at`, `deleted`) VALUES (2, '爱情转移', 'chen', '陈奕迅', NULL, 'baac94e3-b538-4466-9bfd-0d1ad4da5fac.mp3', 10405305, 'audio/mpeg', 260, '2024-12-21 19:01:15', '2024-12-22 01:31:29', 0);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
