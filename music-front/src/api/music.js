import request from '@/utils/request';

// 音乐API服务
  // 获取歌曲列表
export const getSongList = () => {
    return request.get('/songs');
  }
  // 获取歌曲详情
export const getSongDetail = (id) => {
    return request.get(`/songs/${id}`);
  }
  // 获取歌词
export const getSongLyrics = (id) => {
    return request.get(`/lyrics/${id}`);
  }

  // 上传歌曲
export const uploadSong = (params) => {
    return request.upload('/songs/upload', params);
  }

  // 更新歌曲信息
export const updateSong = (id, data) => {
    return request.put(`/songs/${id}`, data);
  }

  // 删除歌曲
export const deleteSong = (id) => {
    return request.delete(`/songs/${id}`);
  }

  // 获取播放列表
export const getPlaylist = () => {
    return request.get('/playlist');
  }

  // 添加歌曲到播放列表
export const addToPlaylist = (songId) => {
    return request.post('/playlist', { songId });
  }

  // 从播放列表移除歌曲
export const removeFromPlaylist = (songId) => {
    return request.delete(`/playlist/${songId}`);
  }

  // 获取推荐歌曲
export const getRecommendations = () => {
    return request.get('/songs/recommendations');
  }

  // 搜索歌曲
export const searchSongs = (query) => {
    return request.get('/songs/search', { params: { q: query } });
  }