<template>
  <router-view />
</template>

<style scoped>
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  overflow: hidden; /* 确保没有滚动条 */
  background-color: var(--bg-color);
  color: var(--text-color);
}

#app {
  height: 100%;
  width: 100%; /* 确保占满宽度 */
  overflow: auto; /* 允许滚动 */
  background-color: var(--bg-color);
  color: var(--text-color);
}

/* 重置一些基础样式 */
* {
  margin: 0;
  padding: 0;
}

/* 滚动条样式优化 */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-thumb {
  background: var(--text-color-secondary);
  border-radius: 3px;
}

::-webkit-scrollbar-track {
  background: var(--hover-color);
}

</style>