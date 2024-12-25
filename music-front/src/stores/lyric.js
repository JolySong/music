import { defineStore } from 'pinia';
import { getSongLyrics } from '@/api/music';

export const useLyricStore = defineStore('lyric', {
  state: () => ({
    lyrics: [],
    error: null
  }),

  actions: {
    async fetchLyrics(songId) {
      try {
        const response = await getSongLyrics(songId);
        if (response.code === 200 && response.data) {
          this.lyrics = response.data
            .map(lyric => ({
              timestamp: lyric.timePoint,
              text: lyric.content || ''
            }))
            .sort((a, b) => a.timestamp - b.timestamp);
          this.error = null;
        } else {
          this.lyrics = [];
          this.error = response.message || '获取歌词失败';
        }
      } catch (error) {
        console.error('Failed to fetch lyrics:', error);
        this.lyrics = [];
        this.error = error.message || '获取歌词失败';
      }
    },

    async saveLyrics(songId, lyrics) {
      try {
        // TODO: 实现保存歌词的 API
        const response = await fetch(`/api/lyrics/${songId}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(lyrics)
        });

        if (!response.ok) {
          throw new Error('保存歌词失败');
        }

        // 更新本地歌词
        this.lyrics = lyrics.map(lyric => ({
          timestamp: lyric.timePoint,
          text: lyric.content
        })).sort((a, b) => a.timestamp - b.timestamp);

        this.error = null;
      } catch (error) {
        console.error('Failed to save lyrics:', error);
        this.error = error.message || '保存歌词失败';
        throw error;
      }
    },

    clearLyrics() {
      this.lyrics = [];
      this.error = null;
    }
  }
}); 