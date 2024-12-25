<template>
  <div class="admin-container">
    <aside class="sidebar">
      <div class="logo">
        Music Admin
      </div>
      <nav class="nav-menu">
        <router-link to="/admin/songs" class="nav-item">
          <i class="fas fa-music"></i>
          歌曲管理
        </router-link>
      </nav>
    </aside>
    <main class="main-content">
      <header class="header">
        <div class="breadcrumb">
          {{ currentPage }}
        </div>
      </header>
      <div class="content">
        <router-view></router-view>
      </div>
    </main>
  </div>
</template>

<script>
import { computed } from 'vue';
import { useRoute } from 'vue-router';

export default {
  name: 'AdminLayout',
  setup() {
    const route = useRoute();
    
    const currentPage = computed(() => {
      switch(route.name) {
        case 'SongManagement':
          return '歌曲管理';
        case 'LyricManagement':
          return '歌词管理';
        default:
          return '后台管理';
      }
    });

    return {
      currentPage
    };
  }
};
</script>

<style lang="scss">
.admin-container {
  display: flex;
  min-height: 100vh;
  height: 100vh;
  background-color: #f5f5f5;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;

  .sidebar {
    width: 250px;
    background-color: #1e1e2d;
    color: #ffffff;
    padding: 1rem;
    height: 100vh;
    overflow-y: auto;

    .logo {
      font-size: 1.5rem;
      font-weight: bold;
      padding: 1rem;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      margin-bottom: 1rem;
    }

    .nav-menu {
      display: flex;
      flex-direction: column;
      gap: 0.5rem;

      .nav-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.75rem 1rem;
        color: #a5a5b5;
        text-decoration: none;
        border-radius: 6px;
        transition: all 0.3s ease;

        &:hover, &.router-link-active {
          background-color: rgba(255, 255, 255, 0.1);
          color: #ffffff;
        }

        i {
          width: 20px;
        }
      }
    }
  }

  .main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    height: 100vh;
    overflow: hidden;
    
    .header {
      background-color: #ffffff;
      padding: 1rem 2rem;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
      z-index: 10;

      .breadcrumb {
        font-size: 1.25rem;
        font-weight: 500;
        color: #333;
      }
    }

    .content {
      flex: 1;
      padding: 2rem;
      overflow-y: auto;
      height: calc(100vh - 64px); // 减去header的高度
    }
  }
}

/* 隐藏滚动条但保持功能 */
* {
  scrollbar-width: none;
  -ms-overflow-style: none;
  &::-webkit-scrollbar {
    display: none;
  }
}
</style> 