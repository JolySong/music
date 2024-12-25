<template>
  <div :class="['player', { dark: isDarkMode }]" class="player-container">
    <div class="main-content" :class="{ collapsed: isControlBarCollapsed }">
      <div class="player-section">
        <div class="track-info">
          <div class="cover-container">
            <img 
              :src="currentTrack.coverUrl || defaultCover" 
              :alt="currentTrack.title"
              @error="handleImageError"
              class="cover-image" 
            />
          </div>
          <div class="track-details-container">
            <h2 class="track-title">{{ currentTrack.title }}</h2>
            <p class="track-artist">{{ currentTrack.artist }}</p>
            <p class="track-album" v-if="currentTrack.album">{{ currentTrack.album }}</p>
          </div>
          <div class="lyrics-container">
            <div class="lyrics-scroll">
              <transition-group name="fade">
                <p v-for="(line, index) in displayLyrics" 
                   :key="line.time"
                   :class="{ 
                     'lyric-line': true,
                     'current': index === (currentLyricIndex - (displayLyrics[0] ? this.lyrics.indexOf(displayLyrics[0]) : 0))
                   }"
                   @click="seekToLyric(line.time)">
                  <span class="lyric-time" v-if="line.time >= 0">{{ formatTime(line.time / 1000) }}</span>
                  <span class="lyric-content" v-html="renderLyricContent(line.content, index === (currentLyricIndex - (displayLyrics[0] ? this.lyrics.indexOf(displayLyrics[0]) : 0)))"></span>
                </p>
              </transition-group>
            </div>
          </div>
        </div>
        

        <div class="controls" :class="{ collapsed: isControlBarCollapsed }">
          <div class="control-bar-header">
            <button class="collapse-button" @click="toggleControlBar">
              <i class="fas" :class="isControlBarCollapsed ? 'fa-chevron-up' : 'fa-chevron-down'"></i>
            </button>
            <div class="top-right-controls">
              <button @click="toggleTheme" class="theme-toggle">
                <i class="fas" :class="isDarkMode ? 'fa-sun' : 'fa-moon'"></i>
              </button>
            </div>
          </div>
          <div class="control-bar-content">
            <div class="progress-bar">
              <span class="current-time">{{ formatTime(currentTime) }}</span>
              <div class="progress-wrapper" 
                   @mousedown="startDragging"
                   @mousemove="handleDragging"
                   @mouseup="stopDragging"
                   @mouseleave="stopDragging">
                <div class="progress-buffer" :style="{ width: `${bufferedProgress}%` }"></div>
                <div class="progress" :style="{ width: `${isDragging ? dragProgress : progress}%` }"></div>
                <div class="progress-hover-time" 
                     v-if="isDragging"
                     :style="{ left: `${dragProgress}%` }">
                  {{ formatTime(dragProgress * currentTrack.duration / 100) }}
                </div>
              </div>
              <span class="total-time">{{ formatTime(currentTrack.duration) }}</span>
            </div>
            <div class="control-panel">
              <div class="now-playing">
                <img 
                  :src="currentTrack.coverUrl || defaultCover" 
                  :alt="currentTrack.title"
                  @error="handleImageError"
                  class="now-playing-cover"
                />
                <div class="now-playing-info">
                  <span class="now-playing-title">{{ currentTrack.title }}</span>
                  <div class="now-playing-details">
                    <span class="now-playing-artist">{{ currentTrack.artist }}</span>
                    <span v-if="currentTrack.album" class="now-playing-album"> - {{ currentTrack.album }}</span>
                  </div>
                </div>
              </div>
              <div class="control-buttons-container">
                <div class="control-buttons">
                  <button class="control-button secondary" @click="playPrevious">
                    <i class="fas fa-step-backward"></i>
                  </button>
                  <button @click="togglePlay" class="control-button primary">
                    <i class="fas" :class="isPlaying ? 'fa-pause' : 'fa-play'"></i>
                  </button>
                  <button class="control-button secondary" @click="playNext">
                    <i class="fas fa-step-forward"></i>
                  </button>
                </div>
              </div>
              <div class="right-controls">
                <div class="volume-control" 
                     @mouseleave="isVolumeVisible = false"
                     @mouseenter="isVolumeVisible = true">
                  <button class="volume-button" @click="toggleMute">
                    <i class="fas" :class="volumeIcon"></i>
                  </button>
                  <div class="volume-slider-container" 
                       v-show="isVolumeVisible">
                    <input 
                      type="range" 
                      id="volume" 
                      v-model="volume" 
                      @input="updateVolume" 
                      min="0" 
                      max="100"
                      orient="vertical"
                    />
                  </div>
                </div>
                <button @click="toggleFullscreen" class="fullscreen-button">
                  <i class="fas fa-expand"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="playlist-section">
        <div class="playlist-header">
          <h2>播放列表</h2>
          <div class="playlist-controls">
            <button 
              class="playlist-button" 
              :class="{ active: isRandomPlay }"
              @click="toggleRandomPlay">
              <i class="fas fa-random"></i>
            </button>
            <button 
              class="playlist-button" 
              :class="{ active: repeatMode !== 'off' }"
              @click="toggleRepeatMode">
              <i class="fas" 
                 :class="{
                   'fa-redo': repeatMode === 'all',
                   'fa-redo-alt': repeatMode === 'one'
                 }">
              </i>
            </button>
          </div>
        </div>
        <ul class="playlist">
          <li v-for="(track, index) in playlist" 
              :key="track.id" 
              @click="selectTrack(track)"
              :class="{ active: currentTrack.id === track.id }">
            <div class="track-info-container">
              <span class="track-number">{{ index + 1 }}</span>
              <img 
                :src="track.coverUrl || defaultCover" 
                :alt="track.title"
                @error="handleImageError"
                class="mini-cover" 
              />
              <div class="track-details">
                <span class="track-title">{{ track.title }}</span>
                <div class="track-info-text">
                  <span class="track-artist">{{ track.artist || '未知歌手' }}</span>
                  <span v-if="track.album" class="track-album"> - {{ track.album }}</span>
                </div>
              </div>
            </div>
            <span class="track-duration">{{ formatTime(track.duration || 0) }}</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import { getSongList, getSongLyrics } from '@/api/music';

export default {
  data() {
    return {
      audioPlayer: null, // 添加音频播放器实例
      currentTime: 0, // 当前播放时间
      defaultCover: '/images/default-cover.jpg',
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
      },
      lyrics: [], // 存储解析后的歌词
      currentLyricIndex: -1, // 当前播放的歌词索引
      playlist: [],
      isDarkMode: window.matchMedia('(prefers-color-scheme: dark)').matches, // 初始化时检查系统主题
      volume: 50, // 默认音量
      isPlaying: false, // 添加播放状态
      isRandomPlay: false, // 随机播放状态
      repeatMode: 'off', // 循环模式：'off', 'all', 'one'
      previousVolume: 50, // 存储静音前的音量
      isMuted: false,
      isVolumeVisible: false,
      isDragging: false,
      dragProgress: 0,
      bufferedProgress: 0,
      isControlBarCollapsed: false,
    };
  },
  async created() {
    // 初始化时加载歌曲列表
    await this.loadSongList();
    // 监听系统主题变化
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', this.handleSystemThemeChange);
  },
  mounted() {
    // 创建音频播放器实例
    this.audioPlayer = new Audio();
    this.audioPlayer.volume = this.volume / 100;

    // 添加音频事件监听
    this.audioPlayer.addEventListener('timeupdate', this.handleTimeUpdate);
    this.audioPlayer.addEventListener('ended', this.handleTrackEnd);
    this.audioPlayer.addEventListener('error', this.handleAudioError);
    this.audioPlayer.addEventListener('loadedmetadata', this.handleLoadedMetadata);
    this.audioPlayer.addEventListener('canplay', this.handleCanPlay);
    this.audioPlayer.addEventListener('progress', this.handleProgress);
  },
  beforeDestroy() {
    // 组件销毁时清理事件监听
    if (this.audioPlayer) {
      this.audioPlayer.removeEventListener('timeupdate', this.handleTimeUpdate);
      this.audioPlayer.removeEventListener('ended', this.handleTrackEnd);
      this.audioPlayer.removeEventListener('error', this.handleAudioError);
      this.audioPlayer.removeEventListener('loadedmetadata', this.handleLoadedMetadata);
      this.audioPlayer.removeEventListener('canplay', this.handleCanPlay);
      this.audioPlayer.removeEventListener('progress', this.handleProgress);
      this.audioPlayer.pause();
      this.audioPlayer = null;
    }
    // 组件销毁时移除监听器
    window.matchMedia('(prefers-color-scheme: dark)').removeEventListener('change', this.handleSystemThemeChange);
  },
  computed: {
    volumeIcon() {
      if (this.isMuted || this.volume === 0) {
        return 'fa-volume-mute';
      } else if (this.volume < 30) {
        return 'fa-volume-off';
      } else if (this.volume < 70) {
        return 'fa-volume-down';
      } else {
        return 'fa-volume-up';
      }
    },
    // 当前歌词
    currentLyric() {
      if (this.currentLyricIndex >= 0 && this.lyrics[this.currentLyricIndex]) {
        return this.lyrics[this.currentLyricIndex].content;
      }
      return '暂无歌词';
    },
    progress() {
      if (!this.audioPlayer || !this.currentTrack.duration) return 0;
      return (this.currentTime / this.currentTrack.duration) * 100;
    },
    // 显示固定的8条歌词
    displayLyrics() {
      if (!this.lyrics.length) return [];
      
      const currentIndex = this.currentLyricIndex;
      const totalLyrics = this.lyrics.length;
      
      // 始终显示当前歌词和前后的歌词，总共8条
      let startIndex = Math.max(0, currentIndex - 3);
      let endIndex = Math.min(startIndex + 8, totalLyrics);
      
      // 如果endIndex到达末尾，从后往前取8条
      if (endIndex === totalLyrics) {
        startIndex = Math.max(0, totalLyrics - 8);
      }
      
      // 如果startIndex在开头，从前往后取8条
      if (startIndex === 0) {
        endIndex = Math.min(8, totalLyrics);
      }
      
      return this.lyrics.slice(startIndex, endIndex);
    },
  },
  methods: {
    // 处理图片加载错误
    handleImageError(event) {
      event.target.src = this.defaultCover;
    },
    
    // 加载歌曲列表
    async loadSongList() {
      try {
        const response = await getSongList();
        if (response.code === 200 && response.data) {
          this.playlist = response.data.map(song => ({
            id: song.id,
            title: song.title || '未歌曲',
            artist: song.artist || '未知歌手',
            album: song.album || '',
            coverUrl: song.coverUrl || this.defaultCover,
            url: song.url,
            duration: song.duration || 0,
            fileSize: song.fileSize || 0,
            mimeType: song.mimeType || 'audio/mpeg'
          }));
          
          // 如果加载歌曲，默认选择第一首
          if (this.playlist.length > 0) {
            await this.selectTrack(this.playlist[0]);
          }
        } else {
          console.error('加载歌曲列表失败:', response.data.message);
        }
      } catch (error) {
        console.error('加载歌曲列表失败:', error);
      }
    },

    // 加载歌词
    async loadLyrics(songId) {
      try {
        const response = await getSongLyrics(songId);
        // 检查响应状态
        if (response.code === 200 && response.data) {
          // 解析歌词数据
          this.lyrics = response.data.map(lyric => ({
            time: lyric.timePoint,
            content: lyric.content || '',
          })).sort((a, b) => a.time - b.time);
          
          // 重置歌词位置
          this.currentLyricIndex = 0;
          this.$nextTick(() => {
            this.scrollToCurrentLyric(false);
          });
        } else {
          console.error('加载歌词失败:', response.message);
          this.lyrics = [];
          this.currentLyricIndex = -1;
        }
      } catch (error) {
        console.error('加载歌词失败:', error);
        this.lyrics = [];
        this.currentLyricIndex = -1;
      }
    },

    // 选择歌曲
    async selectTrack(track) {
      this.currentTrack = {
        ...track,
        artist: track.artist || '未知歌手',
        album: track.album || '',
        coverUrl: track.coverUrl || this.defaultCover,
        duration: track.duration || 0
      };
      
      // 重置播放状态
      this.currentTime = 0;
      
      await this.loadLyrics(track.id);
      // 初始化歌词位置为第一句
      this.currentLyricIndex = 0;
      this.$nextTick(() => {
        this.scrollToCurrentLyric(false);
      });

      // 如果正在播放，则立即播放新选择的歌曲
      if (this.isPlaying) {
        this.play();
      } else if (this.audioPlayer) {
        // 如果没有播放，也要加载音频以获取时长
        this.audioPlayer.src = track.url;
        this.audioPlayer.load();
      }
    },

    // 格式化时间
    formatTime(seconds) {
      const mins = Math.floor(seconds / 60);
      const secs = Math.floor(seconds % 60);
      return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    },

    // 更新当前播放的歌词
    updateLyric(currentTime) {
      if (!this.lyrics.length) return;
      
      const time = currentTime * 1000; // 转换为毫秒
      let closestIndex = 0;
      let minDiff = Number.MAX_VALUE;
      
      // 找到时间差最小的歌词
      this.lyrics.forEach((lyric, index) => {
        // 只考虑当前时间之前的歌词
        if (lyric.time <= time) {
          const diff = time - lyric.time;
          if (diff < minDiff) {
            minDiff = diff;
            closestIndex = index;
          }
        }
      });
      
      // 只有当索���变化才更新，避免不必要的重渲染
      if (this.currentLyricIndex !== closestIndex) {
        this.currentLyricIndex = closestIndex;
        // 使用 nextTick 确保 DOM 更新后再滚动
        this.$nextTick(() => {
          this.scrollToCurrentLyric(true);
        });
      }
    },

    // 滚动到当前歌词
    scrollToCurrentLyric(smooth = false) {
      const currentLyricEl = this.$refs.currentLyric?.[0];
      const scrollContainer = this.$refs.lyricsScroll;
      
      if (currentLyricEl && scrollContainer) {
        const containerHeight = scrollContainer.clientHeight;
        const elementHeight = currentLyricEl.clientHeight;
        const elementTop = currentLyricEl.offsetTop;
        
        // 计算目标滚动位置，使当前歌词保持在容器中间
        const targetScrollTop = elementTop - (containerHeight - elementHeight) / 2;
        
        // 使用平滑滚动或即时滚动
        scrollContainer.scrollTo({
          top: targetScrollTop,
          behavior: smooth ? 'smooth' : 'auto'
        });
      }
    },

    // 跳转到歌词时间点
    seekToLyric(time) {
      if (!this.audioPlayer || !this.currentTrack.duration) return;
      
      const seconds = time / 1000;
      if (seconds >= 0 && seconds <= this.currentTrack.duration) {
        this.audioPlayer.currentTime = seconds;
        this.currentTime = seconds;
        
        // 立即更新歌词位置，不使用平滑滚动
        this.updateLyric(seconds);
        this.$nextTick(() => {
          this.scrollToCurrentLyric(false);
        });
      }
    },

    // 更新跳转方法
    seekTo(event) {
      if (!this.audioPlayer || !this.currentTrack.duration) return;
      
      const progressBar = event.currentTarget;
      const rect = progressBar.getBoundingClientRect();
      const x = Math.max(0, Math.min(event.clientX - rect.left, rect.width));
      const percent = x / rect.width;
      const time = percent * this.currentTrack.duration;
      
      this.audioPlayer.currentTime = time;
      this.currentTime = time;
      this.dragProgress = 0;

      // 立即更新歌词位置，不使用平滑滚动
      this.updateLyric(time);
      this.$nextTick(() => {
        this.scrollToCurrentLyric(false);
      });
    },

    togglePlay() {
      this.isPlaying = !this.isPlaying;
      if (this.isPlaying) {
        this.play();
      } else {
        this.pause();
      }
    },
    play() {
      if (this.audioPlayer && this.currentTrack.url) {
        // 如果是新的音频源，设置新的URL
        if (this.audioPlayer.src !== this.currentTrack.url) {
          this.audioPlayer.src = this.currentTrack.url;
          this.audioPlayer.load();
        }
        this.audioPlayer.play().catch(error => {
          console.error('播放失败:', error);
          this.isPlaying = false;
        });
      }
    },
    pause() {
      if (this.audioPlayer) {
        this.audioPlayer.pause();
      }
    },
    toggleTheme() {
      this.isDarkMode = !this.isDarkMode;
    },
    toggleFullscreen() {
      const playerContainer = document.querySelector('.player-container');
      if (playerContainer.requestFullscreen) {
        playerContainer.requestFullscreen();
      } else if (playerContainer.mozRequestFullScreen) { // Firefox
        playerContainer.mozRequestFullScreen();
      } else if (playerContainer.webkitRequestFullscreen) { // Chrome, Safari and Opera
        playerContainer.webkitRequestFullscreen();
      } else if (playerContainer.msRequestFullscreen) { // IE/Edge
        playerContainer.msRequestFullscreen();
      }
    },
    updateVolume() {
      if (this.audioPlayer) {
        this.audioPlayer.volume = this.volume / 100;
      }
      if (this.volume > 0) {
        this.isMuted = false;
      }
    },
    toggleRandomPlay() {
      this.isRandomPlay = !this.isRandomPlay;
      console.log(`随机播放: ${this.isRandomPlay ? '开启' : '关闭'}`);
    },
    toggleRepeatMode() {
      // 循环切换：关闭 -> 列表循环 -> 单曲循环
      switch (this.repeatMode) {
        case 'off':
          this.repeatMode = 'all';
          console.log('列表循环');
          break;
        case 'all':
          this.repeatMode = 'one';
          console.log('单曲循环');
          break;
        case 'one':
          this.repeatMode = 'off';
          console.log('关闭循环');
          break;
      }
    },
    toggleMute() {
      if (this.audioPlayer) {
        if (this.isMuted) {
          this.volume = this.previousVolume;
          this.isMuted = false;
        } else {
          this.previousVolume = this.volume;
          this.volume = 0;
          this.isMuted = true;
        }
        this.audioPlayer.volume = this.volume / 100;
      }
    },
    handleSystemThemeChange(e) {
      this.isDarkMode = e.matches;
    },
    // 处理音频时间更新
    handleTimeUpdate() {
      if (this.audioPlayer) {
        this.currentTime = this.audioPlayer.currentTime;
        this.updateLyric(this.currentTime);
      }
    },

    // 处理音轨结束
    handleTrackEnd() {
      this.isPlaying = false;
      if (this.repeatMode === 'one') {
        // 单曲循环
        this.play();
      } else if (this.repeatMode === 'all') {
        // 列表循环
        this.playNext();
      } else if (this.isRandomPlay) {
        // 随机播放
        this.playRandom();
      } else {
        // 顺序播放下一首
        this.playNext();
      }
    },

    // 处理音频错误
    handleAudioError(error) {
      console.error('音频播放错误:', error);
      this.isPlaying = false;
    },

    // 播放下一首
    playNext() {
      const currentIndex = this.playlist.findIndex(track => track.id === this.currentTrack.id);
      const nextIndex = (currentIndex + 1) % this.playlist.length;
      this.selectTrack(this.playlist[nextIndex]);
    },

    // 播放上一首
    playPrevious() {
      const currentIndex = this.playlist.findIndex(track => track.id === this.currentTrack.id);
      const prevIndex = (currentIndex - 1 + this.playlist.length) % this.playlist.length;
      this.selectTrack(this.playlist[prevIndex]);
    },

    // 随机播放
    playRandom() {
      const currentIndex = this.playlist.findIndex(track => track.id === this.currentTrack.id);
      let randomIndex;
      do {
        randomIndex = Math.floor(Math.random() * this.playlist.length);
      } while (randomIndex === currentIndex && this.playlist.length > 1);
      this.selectTrack(this.playlist[randomIndex]);
    },

    // 开始拖动
    startDragging(event) {
      this.isDragging = true;
      this.handleDragging(event);
    },

    // 处理拖动
    handleDragging(event) {
      if (!this.isDragging) return;
      
      const progressBar = event.currentTarget;
      const rect = progressBar.getBoundingClientRect();
      const x = Math.max(0, Math.min(event.clientX - rect.left, rect.width));
      const percent = (x / rect.width) * 100;
      this.dragProgress = percent;
    },

    // 停止拖动
    stopDragging(event) {
      if (this.isDragging) {
        this.isDragging = false;
        this.seekTo(event);
      }
    },

    // 处理缓冲进度
    handleProgress() {
      if (this.audioPlayer && this.audioPlayer.buffered.length > 0) {
        const buffered = this.audioPlayer.buffered;
        const currentBuffered = buffered.end(buffered.length - 1);
        this.bufferedProgress = (currentBuffered / this.currentTrack.duration) * 100;
      }
    },

    // 处理音频元数据加载完成
    handleLoadedMetadata() {
      if (this.audioPlayer) {
        this.currentTrack.duration = this.audioPlayer.duration;
      }
    },

    // 处理音频可以播放
    handleCanPlay() {
      if (this.audioPlayer) {
        this.currentTrack.duration = this.audioPlayer.duration;
      }
    },

    toggleControlBar() {
      this.isControlBarCollapsed = !this.isControlBarCollapsed;
    },

    renderLyricContent(content, isCurrent) {
      if (!isCurrent) return content;
      
      // 获取当前歌词的时间点和下一句歌词的时间点
      const currentLyricTime = this.lyrics[this.currentLyricIndex]?.time || 0;
      const nextLyricTime = this.lyrics[this.currentLyricIndex + 1]?.time || (currentLyricTime + 3000); // 如果没有下一句，默认3秒
      
      // 计算当前时间在当前歌词中的进度
      const currentTimeMs = this.currentTime * 1000;
      const progress = Math.max(0, (currentTimeMs - currentLyricTime) / (nextLyricTime - currentLyricTime));
      
      // 计算应该高亮的字符数
      const totalChars = content.length;
      const highlightLength = Math.floor(progress * totalChars);
      
      if (highlightLength <= 0) return content;
      
      // 将整句歌词分为已播放和未播放两部分
      const highlighted = content.substring(0, highlightLength);
      const rest = content.substring(highlightLength);
      
      return `<span class="highlight">${highlighted}</span>${rest}`;
    }
  },
  watch: {
    // 监听音量变化
    volume(newValue) {
      if (this.audioPlayer) {
        this.audioPlayer.volume = newValue / 100;
      }
    }
  }
};
</script>

<style>
:root {
  /* 浅色主题变量 */
  --primary-color: #1db954;
  --primary-color-dark: #1ed760;
  --bg-color: #ffffff;
  --text-color: #333333;
  --text-color-secondary: #666666;
  --hover-color: #f5f5f5;
  --border-color: #e0e0e0;
  --card-bg: rgba(0, 0, 0, 0.05);
  --backdrop-blur: blur(10px);
  --header-height: 64px;
  --control-bar-height: 150px;
  --collapsed-control-bar-height: 40px;
}

/* 深色主题样式 */
.dark {
  --primary-color: #1db954;
  --primary-color-dark: #1ed760;
  --bg-color: #121212;
  --text-color: #ffffff;
  --text-color-secondary: #b3b3b3;
  --hover-color: #282828;
  --border-color: #333333;
  --card-bg: rgba(255, 255, 255, 0.05);
}
</style>

<style scoped>
.player-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  height: 100vh; /* 添加固定高度 */
  width: 100%;
  margin: 0;
  padding: 0;
  background: var(--bg-color);
  color: var(--text-color);
  transition: all 0.3s ease;
  position: fixed; /* 固定定位 */
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}

.theme-toggle {
  position: fixed;
  top: 1rem;
  right: 1rem;
  padding: 0.5rem;
  border: none;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  cursor: pointer;
  background: var(--card-bg);
  color: var(--text-color);
  transition: all 0.3s ease;
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.theme-toggle:hover {
  background: var(--hover-color);
  transform: scale(1.1);
}

.right-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.fullscreen-button {
  padding: 0.5rem;
  border: none;
  border-radius: 50%;
  width: 35px;
  height: 35px;
  cursor: pointer;
  background: var(--card-bg);
  color: var(--text-color);
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.fullscreen-button:hover {
  background: var(--hover-color);
  transform: scale(1.1);
}

.main-content {
  display: flex;
  flex: 1;
  gap: 2rem;
  padding: 2rem;
  height: 100vh;
  overflow: hidden;
  transition: all 0.3s ease;
  padding-bottom: calc(var(--control-bar-height) + 2rem);
}

.main-content.collapsed {
  padding-bottom: calc(var(--collapsed-control-bar-height) + 2rem);
}

@media (max-width: 768px) {
  .theme-toggle {
    top: 0.5rem;
    right: 0.5rem;
    width: 35px;
    height: 35px;
  }

  .fullscreen-button {
    width: 30px;
    height: 30px;
  }
}

.player-section {
  flex: 1;
  min-width: 0;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow-y: auto;
  padding-bottom: 2rem;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE and Edge */
}

.player-section::-webkit-scrollbar {
  display: none; /* Chrome, Safari, Opera */
}

.playlist-section {
  width: 350px;
  min-width: 300px;
  flex-shrink: 0;
  background: var(--card-bg);
  border-radius: 20px;
  padding: 1.5rem;
  backdrop-filter: blur(10px);
  overflow-y: auto;
  overflow-x: hidden;
  transition: all 0.3s ease;
}

.playlist-section.collapsed {
  height: calc(100vh - var(--collapsed-control-bar-height) - 4rem);
}

/* 移除全局滚动条样式 */
::-webkit-scrollbar {
  display: none;
}

::-webkit-scrollbar-track {
  display: none;
}

::-webkit-scrollbar-thumb {
  display: none;
}

/* 确保所有可滚动容器都隐藏滚动条 */
* {
  scrollbar-width: none;
  -ms-overflow-style: none;
}

*::-webkit-scrollbar {
  display: none;
}

.track-info {
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  height: 100%; /* 添加高度 100% */
}

.cover-container {
  width: 250px;
  height: 250px;
  margin: 0 auto;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  transition: transform 0.3s ease;
  flex-shrink: 0; /* 防止封面被压缩 */
}

.cover-container:hover {
  transform: scale(1.02);
}

.cover-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.track-details-container {
  margin: 1.5rem 0;
  text-align: center;
  flex-shrink: 0; /* 防止歌曲信息被压缩 */
}

.track-title {
  font-size: 1.5rem;
  font-weight: 600;
  margin: 0;
  color: var(--text-color);
}

.track-artist {
  font-size: 1rem;
  color: var(--text-color-secondary);
  margin-top: 0.5rem;
}

.lyrics-container {
  margin-top: 1.5rem;
  padding: 1.5rem;
  background: var(--card-bg);
  border-radius: 15px;
  flex: 1;
  min-height: 200px;
  overflow: hidden;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
  isolation: isolate;
  width: 100%;
  max-width: 100%;
}

.lyrics-scroll {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  height: 100%;
  position: relative;
  padding: 20px 0;
}

.lyric-line {
  font-size: 1rem;
  line-height: 32px;
  color: var(--text-color-secondary);
  transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  opacity: 0.6;
  text-align: center;
  width: 100%;
  padding: 8px 1rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin: 4px 0;
  box-sizing: border-box;
  transform-origin: center;
}

.lyric-line.current {
  color: var(--text-color);
  font-size: 1.1rem;
  font-weight: 500;
  opacity: 1;
  transform: scale(1.05);
  padding: 12px 1rem;
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.fade-enter-from {
  opacity: 0;
  transform: translateY(20px) scale(0.95);
}

.fade-enter-to {
  opacity: 0.6;
  transform: translateY(0) scale(1);
}

.fade-leave-from {
  opacity: 0.6;
  transform: translateY(0) scale(1);
}

.fade-leave-to {
  opacity: 0;
  transform: translateY(-20px) scale(0.95);
}

.lyric-line.current.fade-enter-from {
  opacity: 0;
  transform: translateY(20px) scale(1);
}

.lyric-line.current.fade-enter-to {
  opacity: 1;
  transform: translateY(0) scale(1.05);
}

.lyric-line.current.fade-leave-from {
  opacity: 1;
  transform: translateY(0) scale(1.05);
}

.lyric-line.current.fade-leave-to {
  opacity: 0;
  transform: translateY(-20px) scale(1);
}

.lyric-time {
  font-size: 0.8rem;
  color: var(--text-color-secondary);
  opacity: 0.6;
  min-width: 45px;
  text-align: right;
}

.lyric-content {
  flex: 1;
  text-align: left;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  padding: 0 10px;
  box-sizing: border-box;
  position: relative;
}

.lyric-content .highlight {
  color: var(--primary-color);
  font-weight: 600;
  position: relative;
  display: inline-block;
  transition: color 0.3s ease;
}

.current .lyric-time {
  color: var(--primary-color);
  opacity: 1;
}

/* 添加歌词滚动动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.lyric-line {
  animation: fadeInUp 0.5s ease-out;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .lyrics-container {
    min-height: 150px; /* 减小最小高度 */
  }

  .lyrics-scroll {
    padding: 40px 0; /* 减小上下内边距 */
  }

  .lyric-line {
    font-size: 0.9rem;
    line-height: 28px;
  }

  .lyric-time {
    font-size: 0.7rem;
    min-width: 40px;
  }
}

.controls {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  /* padding: 20px; */
  background: var(--card-bg);
  backdrop-filter: var(--backdrop-blur);
  border-top: 1px solid var(--border-color);
  z-index: 1000;
  transition: transform 0.3s ease;
  height: var(--control-bar-height);
}

.controls.collapsed {
  height: var(--collapsed-control-bar-height);
}

.controls.collapsed .control-bar-content {
  display: none;
}

.control-bar-header {
  display: flex;
  justify-content: center;
  padding: 4px 0;
  border-bottom: 1px solid var(--border-color);
  position: relative; /* 添加相对定位 */
  width: 100%;
}

.top-right-controls {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.theme-toggle {
  padding: 0.5rem;
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  cursor: pointer;
  background: var(--card-bg);
  color: var(--text-color);
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.theme-toggle:hover {
  background: var(--hover-color);
  transform: scale(1.1);
}

@media (max-width: 768px) {
  .theme-toggle {
    width: 28px;
    height: 28px;
  }

  .top-right-controls {
    right: 0.5rem;
  }
}

.collapse-button {
  background: transparent;
  border: none;
  color: var(--text-color);
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 4px;
  transition: all 0.3s ease;
}

.collapse-button:hover {
  background: var(--hover-color);
}

.collapse-button i {
  font-size: 0.8rem;
}

.control-bar-content {
  padding: 20px;
}

.progress-bar {
  width: 800px;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0 1rem;
  margin-bottom: 10px;
}

.control-panel {
  width: 100%;
  max-width: 800px;
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 1rem;
  padding: 0 20px;
}

.now-playing {
  display: flex;
  align-items: center;
  gap: 1rem;
  min-width: 0;
}

.now-playing-cover {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  object-fit: cover;
}

.now-playing-info {
  display: flex;
  flex-direction: column;
  min-width: 0;
  gap: 2px;
}

.now-playing-title {
  font-size: 0.9rem;
  font-weight: 500;
  color: var(--text-color);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.now-playing-details {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 0.8rem;
  color: var(--text-color-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.now-playing-artist,
.now-playing-album {
  overflow: hidden;
  text-overflow: ellipsis;
}

.control-buttons-container {
  display: flex;
  justify-content: center; /* 居中对齐 */
  width: 100%;
}

.control-buttons {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.volume-control {
  position: relative;
  display: flex;
  align-items: center;
  padding: 0.5rem;
  border-radius: 20px;
  background: var(--card-bg);
  margin-left: 20px;
  z-index: 1001;
}

.progress-bar {
  width: 800px;
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0 1rem;
}

.progress-wrapper {
  flex: 1;
  height: 4px;
  background: var(--card-bg);
  border-radius: 2px;
  cursor: pointer;
  position: relative;
  transition: height 0.2s ease;
}

.progress-wrapper:hover {
  height: 6px;
}

.progress-buffer {
  position: absolute;
  height: 100%;
  background: var(--card-bg);
  opacity: 0.5;
  border-radius: 2px;
  pointer-events: none;
}

.progress {
  height: 100%;
  background: var(--primary-color);
  border-radius: 2px;
  position: relative;
  transition: width 0.1s linear;
}

.progress::after {
  content: '';
  position: absolute;
  right: -6px;
  top: 50%;
  transform: translateY(-50%) scale(0);
  width: 12px;
  height: 12px;
  background: var(--primary-color);
  border-radius: 50%;
  transition: transform 0.2s ease;
}

.progress-wrapper:hover .progress::after {
  transform: translateY(-50%) scale(1);
}

.progress-hover-time {
  position: absolute;
  top: -25px;
  transform: translateX(-50%);
  background: var(--card-bg);
  color: var(--text-color);
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 12px;
  pointer-events: none;
  white-space: nowrap;
}

.progress-hover-time::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 50%;
  transform: translateX(-50%);
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-top: 4px solid var(--card-bg);
}

.current-time,
.total-time {
  font-size: 0.8rem;
  color: var(--text-color-secondary, #666);
}

.control-button {
  width: 45px;
  height: 45px;
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.control-button.primary {
  width: 55px;
  height: 55px;
  font-size: 1.2rem;
  background: var(--primary-color);
}

.control-button.primary:hover {
  background: var(--primary-color-dark);
}

.control-button.secondary {
  background: var(--card-bg);
  color: var(--text-color);
}

.volume-button {
  width: 35px;
  height: 35px;
  border: none;
  border-radius: 50%;
  background: transparent;
  color: var(--text-color, #333);
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.volume-button:hover {
  background: rgba(255, 255, 255, 0.1);
}

.volume-slider-container {
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  background: var(--card-bg);
  backdrop-filter: blur(10px);
  padding: 1rem 0.5rem;
  border-radius: 10px;
  margin-bottom: 10px;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1001;
}

.volume-slider-container::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-top: 8px solid rgba(255, 255, 255, 0.1);
}

.volume-slider-container input[type="range"] {
  -webkit-appearance: none;
  width: 4px;
  height: 100px;
  background: var(--primary-color, #007bff);
  border-radius: 2px;
  outline: none;
  writing-mode: bt-lr; /* IE */
  -webkit-appearance: slider-vertical; /* Webkit */
}

.volume-slider-container input[type="range"]::-webkit-slider-thumb {
  -webkit-appearance: none;
  width: 12px;
  height: 12px;
  background: white;
  border-radius: 50%;
  cursor: pointer;
}

.volume-slider-container input[type="range"]::-moz-range-thumb {
  width: 12px;
  height: 12px;
  background: white;
  border-radius: 50%;
  cursor: pointer;
  border: none;
}

/* 深色模式适配 */
.dark .volume-button {
  color: var(--text-color, #fff);
}

.dark .volume-slider-container {
  background: var(--card-bg);
}

.dark .volume-slider-container::after {
  border-top-color: var(--card-bg);
}

.playlist-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.playlist-controls {
  display: flex;
  gap: 0.5rem;
}

.playlist-button {
  width: 35px;
  height: 35px;
  border: none;
  border-radius: 50%;
  background: var(--card-bg);
  color: var(--text-color);
  cursor: pointer;
  transition: all 0.3s ease;
}

.playlist-button.active {
  background: var(--primary-color);
  color: white;
  transform: scale(1.1);
}

.playlist-button:hover {
  background: var(--hover-color);
}

.playlist-button.active:hover {
  background: var(--primary-color-dark);
}

/* 深色模式适配 */
.dark .playlist-button {
  color: var(--text-color);
}

.dark .playlist-button.active {
  background: var(--primary-color);
}

.playlist {
  list-style: none;
  padding: 0;
  margin: 0;
}

.playlist li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 1rem;
  margin: 0.5rem 0;
  border-radius: 10px;
  background: var(--card-bg);
  transition: all 0.3s ease;
}

.playlist li:hover {
  background: var(--hover-color);
  transform: translateX(4px);
}

.playlist li.active {
  background: var(--primary-color);
}

.playlist li.active .track-title,
.playlist li.active .track-artist,
.playlist li.active .track-album,
.playlist li.active .track-duration {
  color: white;
}

.track-info-container {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex: 1;
}

.mini-cover {
  width: 40px;
  height: 40px;
  border-radius: 5px;
  object-fit: cover;
}

.track-details {
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0; /* 防止文本溢出 */
}

.track-title {
  font-size: 0.9rem;
  color: var(--text-color);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.track-artist, .track-album {
  font-size: 0.8rem;
  color: var(--text-color-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.track-info-text {
  display: flex;
  align-items: center;
  gap: 4px;
  min-width: 0;
  color: var(--text-color-secondary);
}

.dark .control-button.secondary {
  background: var(--card-bg);
  color: var(--text-color);
}

.dark .playlist li {
  background: var(--card-bg);
}

.dark .playlist-button {
  color: var(--text-color);
}

.dark .playlist-button.active {
  background: var(--primary-color);
}

/* 添加一些动画效果 */
@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

.control-button:active {
  animation: pulse 0.3s ease;
}

.dark {
  background-color: var(--bg-color);
  color: var(--text-color);
}

/* 滚动条样式 */
::-webkit-scrollbar {
  width: 6px;
}

::-webkit-scrollbar-track {
  background: var(--card-bg);
}

::-webkit-scrollbar-thumb {
  background: var(--primary-color);
  border-radius: 3px;
}

@media (max-width: 1024px) {
  .main-content {
    flex-direction: column;
    padding: 1rem;
    gap: 1rem;
    height: 100vh;
    padding-bottom: calc(var(--control-bar-height) + 1rem);
  }

  .main-content.collapsed {
    padding-bottom: calc(var(--collapsed-control-bar-height) + 1rem);
  }

  .playlist-section {
    width: 100%;
    min-width: 100%;
    height: auto;
    max-height: calc(30vh - var(--control-bar-height));
  }

  .playlist-section.collapsed {
    max-height: calc(30vh - var(--collapsed-control-bar-height));
  }

  .player-section {
    width: 100%;
    height: auto;
    flex: 1;
  }
}

@media (max-width: 768px) {
  .control-panel {
    grid-template-columns: 1fr auto; /* 保持两列布局 */
    padding: 0 10px;
  }

  .volume-control {
    margin-left: 10px;
  }

  .controls {
    padding: 10px;
  }

  .progress-bar {
    padding: 0;
  }

  .track-title {
    font-size: 0.85rem;
  }
  
  .track-artist,
  .track-album {
    font-size: 0.75rem;
  }
}
</style>