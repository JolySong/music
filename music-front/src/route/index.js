import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Player',
    component: () => import('@/views/player/index.vue')
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('@/views/admin/index.vue'),
    children: [
      {
        path: 'songs',
        name: 'SongManagement',
        component: () => import('@/views/admin/songs/index.vue')
      },
      {
        path: 'lyrics/:id',
        name: 'LyricManagement',
        component: () => import('@/views/admin/lyrics/index.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router 