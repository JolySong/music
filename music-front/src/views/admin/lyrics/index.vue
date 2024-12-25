<template>
  <div class="lyrics-management">
    <div class="song-info">
      <div class="cover">
        <img :src="currentTrack.coverUrl || defaultCover" :alt="currentTrack.title" @error="handleImageError">
      </div>
      <div class="details">
        <h2>{{ currentTrack.title || '未知歌曲' }}</h2>
        <p>{{ currentTrack.artist || '未知歌手' }} · {{ currentTrack.album || '未知专辑' }}</p>
      </div>
    </div>

    <div class="lyrics-editor">
      <div class="toolbar">
        <button class="btn btn-primary" @click="saveLyrics" :disabled="saving">
          <i class="fas fa-save"></i>
          {{ saving ? '保存中...' : '保存' }}
        </button>
        <button class="btn btn-text" @click="addTimestamp">
          <i class="fas fa-clock"></i>
          插入时间戳
        </button>
        <button class="btn btn-text" @click="formatLyrics">
          <i class="fas fa-magic"></i>
          格式化
        </button>
      </div>

      <div class="editor-container">
        <textarea
          v-model="lyricsText"
          placeholder="输入歌词，每行一句
格式：[mm:ss.xx]歌词内容
例如：
[00:00.00]歌曲名
[00:01.00]歌手名
[00:15.32]第一句歌词
[00:20.15]第二句歌词"
          @input="handleLyricsChange"
        ></textarea>

        <div class="preview">
          <h3>预览</h3>
          <div class="lyrics-list">
            <div v-for="(line, index) in parsedLyrics" :key="index" class="lyric-line">
              <span class="timestamp">{{ formatTimestamp(line.timestamp) }}</span>
              <span class="content">{{ line.text }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useSongStore } from '@/stores/song';
import { useLyricStore } from '@/stores/lyric';
import { getSongDetail } from '@/api/music';

export default {
  name: 'LyricsManagement',
  setup() {
    const route = useRoute();
    const router = useRouter();
    const songStore = useSongStore();
    const lyricStore = useLyricStore();
    const defaultCover = '/images/default-cover.jpg';

    const currentTrack = ref({});
    const lyricsText = ref('');
    const saving = ref(false);

    const parsedLyrics = computed(() => {
      return lyricsText.value
        .split('\n')
        .map(line => {
          const match = line.match(/\[(\d{2}):(\d{2})\.(\d{2})\](.*)/);
          if (match) {
            const [, minutes, seconds, milliseconds, text] = match;
            const timestamp = (parseInt(minutes) * 60 + parseInt(seconds)) * 1000 + parseInt(milliseconds) * 10;
            return { timestamp, text: text.trim() };
          }
          return null;
        })
        .filter(line => line !== null)
        .sort((a, b) => a.timestamp - b.timestamp);
    });

    const loadSongDetails = async () => {
      try {
        const response = await getSongDetail(route.params.id);
        if (response.code === 200 && response.data) {
          currentTrack.value = response.data;
        }
      } catch (error) {
        console.error('Failed to load song details:', error);
        alert('加载歌曲信息失败');
      }
    };

    const loadLyrics = async () => {
      await lyricStore.fetchLyrics(route.params.id);
      if (lyricStore.lyrics.length > 0) {
        lyricsText.value = lyricStore.lyrics
          .map(line => `[${formatTimestamp(line.timestamp)}]${line.text}`)
          .join('\n');
      }
    };

    const saveLyrics = async () => {
      saving.value = true;
      try {
        // 将解析后的歌词发送到服务器
        const lyrics = parsedLyrics.value.map(line => ({
          timePoint: line.timestamp,
          content: line.text
        }));

        // TODO: 实现保存歌词的 API
        await lyricStore.saveLyrics(route.params.id, lyrics);
        alert('保存成功');
      } catch (error) {
        console.error('Failed to save lyrics:', error);
        alert('保存失败');
      } finally {
        saving.value = false;
      }
    };

    const addTimestamp = () => {
      const textarea = document.querySelector('.lyrics-editor textarea');
      const cursorPosition = textarea.selectionStart;
      const textBeforeCursor = lyricsText.value.substring(0, cursorPosition);
      const textAfterCursor = lyricsText.value.substring(cursorPosition);
      
      lyricsText.value = `${textBeforeCursor}[00:00.00]${textAfterCursor}`;
      
      // 将光标移动到时间戳中间
      textarea.focus();
      textarea.selectionStart = cursorPosition + 1;
      textarea.selectionEnd = cursorPosition + 7;
    };

    const formatLyrics = () => {
      lyricsText.value = parsedLyrics.value
        .map(line => `[${formatTimestamp(line.timestamp)}]${line.text}`)
        .join('\n');
    };

    const formatTimestamp = (ms) => {
      const totalSeconds = Math.floor(ms / 1000);
      const minutes = Math.floor(totalSeconds / 60);
      const seconds = totalSeconds % 60;
      const milliseconds = Math.floor((ms % 1000) / 10);
      return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${milliseconds.toString().padStart(2, '0')}`;
    };

    const handleLyricsChange = () => {
      // 可以在这里添加实时验证逻辑
    };

    const handleImageError = (event) => {
      event.target.src = defaultCover;
    };

    onMounted(async () => {
      await loadSongDetails();
      await loadLyrics();
    });

    return {
      currentTrack,
      defaultCover,
      lyricsText,
      parsedLyrics,
      saving,
      saveLyrics,
      addTimestamp,
      formatLyrics,
      formatTimestamp,
      handleLyricsChange,
      handleImageError
    };
  }
};
</script>

<style lang="scss">
.lyrics-management {
  background: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  padding: 2rem;
  height: 100%;
  display: flex;
  flex-direction: column;

  .song-info {
    display: flex;
    align-items: center;
    gap: 1.5rem;
    margin-bottom: 2rem;
    padding-bottom: 1.5rem;
    border-bottom: 1px solid #eee;
    flex-shrink: 0;

    .cover {
      width: 120px;
      height: 120px;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }

    .details {
      h2 {
        margin: 0 0 0.5rem;
        font-size: 1.5rem;
        font-weight: 600;
      }

      p {
        margin: 0;
        color: #666;
      }
    }
  }

  .lyrics-editor {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-height: 0;

    .toolbar {
      display: flex;
      gap: 1rem;
      margin-bottom: 1rem;
      flex-shrink: 0;
    }

    .editor-container {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      flex: 1;
      min-height: 0;

      textarea {
        padding: 1rem;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-family: monospace;
        font-size: 0.9rem;
        line-height: 1.5;
        resize: none;
        height: 100%;

        &:focus {
          outline: none;
          border-color: #1db954;
        }
      }

      .preview {
        display: flex;
        flex-direction: column;
        min-height: 0;

        h3 {
          margin: 0 0 1rem;
          font-size: 1.1rem;
          color: #666;
          flex-shrink: 0;
        }

        .lyrics-list {
          flex: 1;
          overflow-y: auto;
          padding: 1rem;
          background: #f9f9f9;
          border-radius: 8px;

          .lyric-line {
            display: flex;
            gap: 1rem;
            margin-bottom: 0.5rem;
            font-family: monospace;
            font-size: 0.9rem;

            .timestamp {
              color: #666;
              flex-shrink: 0;
            }

            .content {
              color: #333;
            }
          }
        }
      }
    }
  }
}

.btn {
  padding: 0.5rem 1rem;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  font-size: 0.9rem;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;

  &.btn-primary {
    background: #1db954;
    color: white;

    &:hover {
      background: #1ed760;
    }

    &:disabled {
      background: #ccc;
      cursor: not-allowed;
    }
  }

  &.btn-text {
    background: transparent;
    color: #666;

    &:hover {
      color: #333;
      background: #f5f5f5;
    }
  }
}
</style> 