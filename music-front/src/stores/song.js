import { defineStore } from 'pinia';
import { getSongList } from '@/api/music';

export const useSongStore = defineStore('song', {
  state: () => ({
    songs: [],
    currentTrack: {
      id: null,
      title: '暂无歌曲',
      artist: '未知歌手',
      album: '',
      coverUrl: '',
      url: '',
      duration: 0,
      fileSize: 0,
      mimeType: '',
    }
  }),

  actions: {
    async fetchSongs() {
      try {
        const response = await getSongList();
        if (response.code === 200 && response.data) {
          this.songs = response.data.map(song => ({
            id: song.id,
            title: song.title || '未知歌曲',
            artist: song.artist || '未知歌手',
            album: song.album || '',
            coverUrl: song.coverUrl || '',
            url: song.url,
            duration: song.duration || 0,
            fileSize: song.fileSize || 0,
            mimeType: song.mimeType || 'audio/mpeg'
          }));

          // If there are songs and no current track, set the first song as current
          if (this.songs.length > 0 && !this.currentTrack.id) {
            this.setCurrentTrack(this.songs[0]);
          }
        }
      } catch (error) {
        console.error('Failed to fetch songs:', error);
      }
    },

    setCurrentTrack(track) {
      this.currentTrack = {
        ...track,
        artist: track.artist || '未知歌手',
        album: track.album || '',
        coverUrl: track.coverUrl || '',
        duration: track.duration || 0
      };
    },

    playNext() {
      const currentIndex = this.songs.findIndex(song => song.id === this.currentTrack.id);
      const nextIndex = (currentIndex + 1) % this.songs.length;
      this.setCurrentTrack(this.songs[nextIndex]);
    },

    playPrevious() {
      const currentIndex = this.songs.findIndex(song => song.id === this.currentTrack.id);
      const prevIndex = (currentIndex - 1 + this.songs.length) % this.songs.length;
      this.setCurrentTrack(this.songs[prevIndex]);
    }
  }
}); 