<template>
  <div class="song-management">
    <div class="actions">
      <button class="btn btn-primary" @click="showUploadDialog = true">
        <i class="fas fa-upload"></i>
        上传歌曲
      </button>
    </div>

    <div class="song-list">
      <div class="song-item header">
        <div class="cover">封面</div>
        <div class="title">标题</div>
        <div class="artist">歌手</div>
        <div class="album">专辑</div>
        <div class="duration">时长</div>
        <div class="actions">操作</div>
      </div>
      <div v-for="song in songs" :key="song.id" class="song-item">
        <div class="cover">
          <img :src="song.coverUrl || defaultCover" :alt="song.title" @error="handleImageError">
        </div>
        <div class="title" :title="song.title">{{ song.title || '未知歌曲' }}</div>
        <div class="artist" :title="song.artist">{{ song.artist || '未知歌手' }}</div>
        <div class="album" :title="song.album">{{ song.album || '-' }}</div>
        <div class="duration">{{ formatTime(song.duration) }}</div>
        <div class="actions">
          <button class="btn btn-text" @click="editLyrics(song)">
            <i class="fas fa-pen"></i>
            歌词
          </button>
          <button class="btn btn-text" @click="editSong(song)">
            <i class="fas fa-edit"></i>
            编辑
          </button>
          <button class="btn btn-text btn-danger" @click="confirmDelete(song)">
            <i class="fas fa-trash"></i>
            删除
          </button>
        </div>
      </div>
    </div>

    <!-- 上传对话框 -->
    <div v-if="showUploadDialog" class="dialog-overlay" @click.self="showUploadDialog = false">
      <div class="dialog">
        <h2>上传歌曲</h2>
        <div class="form-group">
          <label>音频文件</label>
          <input type="file" accept="audio/*" @change="handleFileChange">
        </div>
        <div class="form-group">
          <label>歌曲标题</label>
          <input type="text" v-model="uploadForm.title" placeholder="请输入歌曲标题">
        </div>
        <div class="form-group">
          <label>歌手</label>
          <input type="text" v-model="uploadForm.artist" placeholder="请输入歌手名">
        </div>
        <div class="form-group">
          <label>专辑</label>
          <input type="text" v-model="uploadForm.album" placeholder="请输入专辑名">
        </div>
        <div class="form-group">
          <label>封面图片</label>
          <input type="file" accept="image/*" @change="handleCoverChange">
        </div>
        <div class="dialog-footer">
          <button class="btn btn-text" @click="showUploadDialog = false">取消</button>
          <button class="btn btn-primary" @click="handleUploadSong" :disabled="uploading">
            {{ uploading ? '上传中...' : '上传' }}
          </button>
        </div>
      </div>
    </div>

    <!-- 编辑对话框 -->
    <div v-if="showEditDialog" class="dialog-overlay" @click.self="showEditDialog = false">
      <div class="dialog">
        <h2>编辑歌曲</h2>
        <div class="form-group">
          <label>歌曲标题</label>
          <input type="text" v-model="editForm.title" placeholder="请输入歌曲标题">
        </div>
        <div class="form-group">
          <label>歌手</label>
          <input type="text" v-model="editForm.artist" placeholder="请输入歌手名">
        </div>
        <div class="form-group">
          <label>专辑</label>
          <input type="text" v-model="editForm.album" placeholder="请输入专辑名">
        </div>
        <div class="form-group">
          <label>封面图片</label>
          <input type="file" accept="image/*" @change="handleEditCoverChange">
        </div>
        <div class="dialog-footer">
          <button class="btn btn-text" @click="showEditDialog = false">取消</button>
          <button class="btn btn-primary" @click="updateSong" :disabled="updating">
            {{ updating ? '保存中...' : '保存' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useSongStore } from '@/stores/song';
import { uploadSong, updateSong, deleteSong } from '@/api/music';

export default {
  name: 'SongManagement',
  setup() {
    const router = useRouter();
    const songStore = useSongStore();
    const defaultCover = '/images/default-cover.jpg';

    const songs = ref([]);
    const showUploadDialog = ref(false);
    const showEditDialog = ref(false);
    const uploading = ref(false);
    const updating = ref(false);

    const uploadForm = ref({
      title: '',
      artist: '',
      album: '',
      file: null,
      cover: null
    });

    const editForm = ref({
      id: null,
      title: '',
      artist: '',
      album: '',
      cover: null
    });

    const handleFileChange = (event) => {
      uploadForm.value.file = event.target.files[0];
    };

    const handleCoverChange = (event) => {
      uploadForm.value.cover = event.target.files[0];
    };

    const handleEditCoverChange = (event) => {
      editForm.value.cover = event.target.files[0];
    };

    const handleUploadSong = async () => {
      if (!uploadForm.value.file) {
        alert('请选择音频文件');
        return;
      }

      uploading.value = true;
      try {
        const formData = new FormData();
        formData.append('file', uploadForm.value.file);
        formData.append('title', uploadForm.value.title);
        formData.append('artist', uploadForm.value.artist);
        formData.append('album', uploadForm.value.album);
        if (uploadForm.value.cover) {
          formData.append('cover', uploadForm.value.cover);
        }

        await uploadSong(formData);
        await songStore.fetchSongs();
        songs.value = songStore.songs;
        showUploadDialog.value = false;
        uploadForm.value = { title: '', artist: '', album: '', file: null, cover: null };
      } catch (error) {
        console.error('Failed to upload song:', error);
        alert('上传失败');
      } finally {
        uploading.value = false;
      }
    };

    const editSong = (song) => {
      editForm.value = {
        id: song.id,
        title: song.title,
        artist: song.artist,
        album: song.album,
        cover: null
      };
      showEditDialog.value = true;
    };

    const updateSong = async () => {
      updating.value = true;
      try {
        const formData = new FormData();
        formData.append('title', editForm.value.title);
        formData.append('artist', editForm.value.artist);
        formData.append('album', editForm.value.album);
        if (editForm.value.cover) {
          formData.append('cover', editForm.value.cover);
        }

        await updateSong(editForm.value.id, formData);
        await songStore.fetchSongs();
        songs.value = songStore.songs;
        showEditDialog.value = false;
      } catch (error) {
        console.error('Failed to update song:', error);
        alert('更新失败');
      } finally {
        updating.value = false;
      }
    };

    const editLyrics = (song) => {
      router.push(`/admin/lyrics/${song.id}`);
    };

    const confirmDelete = async (song) => {
      if (confirm(`确定要删除歌曲 "${song.title}" 吗？`)) {
        try {
          await deleteSong(song.id);
          await songStore.fetchSongs();
          songs.value = songStore.songs;
        } catch (error) {
          console.error('Failed to delete song:', error);
          alert('删除失败');
        }
      }
    };

    const handleImageError = (event) => {
      event.target.src = defaultCover;
    };

    const formatTime = (seconds) => {
      if (!seconds) return '00:00';
      const mins = Math.floor(seconds / 60);
      const secs = Math.floor(seconds % 60);
      return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    };

    onMounted(async () => {
      await songStore.fetchSongs();
      songs.value = songStore.songs;
    });

    return {
      songs,
      defaultCover,
      showUploadDialog,
      showEditDialog,
      uploadForm,
      editForm,
      uploading,
      updating,
      handleFileChange,
      handleCoverChange,
      handleEditCoverChange,
      uploadSong,
      editSong,
      updateSong,
      editLyrics,
      confirmDelete,
      handleImageError,
      formatTime
    };
  }
};
</script>

<style lang="scss">
.song-management {
  background: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  height: 100%;
  display: flex;
  flex-direction: column;
  
  .actions {
    padding: 1rem;
    border-bottom: 1px solid #eee;
    flex-shrink: 0;
  }

  .song-list {
    flex: 1;
    overflow-y: auto;
    
    .song-item {
      display: grid;
      grid-template-columns: 60px 2fr 1fr 1fr 100px 200px;
      align-items: center;
      padding: 1rem;
      border-bottom: 1px solid #eee;

      &.header {
        font-weight: 500;
        color: #666;
        background: #f9f9f9;
        position: sticky;
        top: 0;
        z-index: 1;
      }

      .cover {
        width: 40px;
        height: 40px;
        border-radius: 4px;
        overflow: hidden;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .title, .artist, .album {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        padding: 0 0.5rem;
      }

      .title {
        font-weight: 500;
        color: #333;
      }

      .artist, .album {
        color: #666;
      }

      .duration {
        color: #666;
        text-align: center;
      }

      .actions {
        display: flex;
        gap: 0.5rem;
        justify-content: flex-end;
        border: none;
        padding: 0;
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

    &.btn-danger:hover {
      color: #dc3545;
      background: #fff5f5;
    }
  }
}

.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;

  .dialog {
    background: white;
    border-radius: 8px;
    padding: 2rem;
    width: 100%;
    max-width: 500px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);

    h2 {
      margin: 0 0 1.5rem;
      font-size: 1.5rem;
      font-weight: 500;
    }

    .form-group {
      margin-bottom: 1rem;

      label {
        display: block;
        margin-bottom: 0.5rem;
        color: #666;
      }

      input[type="text"] {
        width: 100%;
        padding: 0.5rem;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 1rem;

        &:focus {
          outline: none;
          border-color: #1db954;
        }
      }

      input[type="file"] {
        width: 100%;
      }
    }

    .dialog-footer {
      margin-top: 2rem;
      display: flex;
      justify-content: flex-end;
      gap: 1rem;
    }
  }
}
</style> 