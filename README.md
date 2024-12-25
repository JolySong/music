# Vue3 音乐播放器

一个基于 Vue3 + Vite + Pinia 构建的现代化音乐播放器，具有优雅的界面设计和丰富的功能。

## 功能特点

### 播放器功能
- 🎵 音乐播放、暂停、上一首、下一首
- 🔄 播放模式：顺序播放、随机播放、单曲循环
- 🎚️ 音量控制（带垂直滑块）
- ⏩ 进度条拖拽控制
- 📝 实时歌词显示（带动画效果）
- 🌓 深色/浅色主题切换
- 📱 响应式设计，支持移动端

### 播放列表
- 📋 歌曲列表展示
- 🎵 歌曲切换
- 🔍 当前播放歌曲高亮
- 📊 播放列表最小化

### 后台管理
- 🎵 歌曲管理（上传、编辑、删除）
- 📝 歌词管理（LRC 格式支持）
- 🖼️ 封面图片管理
- 📊 数据统计（开发中）

## 技术栈

- 🚀 Vue 3 - 渐进式 JavaScript 框架
- 📦 Vite - 下一代前端构建工具
- 🗃️ Pinia - Vue 状态管理库
- 🎨 SCSS - CSS 预处理器
- 🛠️ Vue Router - 官方路由管理器
- 🔌 Axios - HTTP 客户端
- 🎯 ESLint - 代码检查工具
- 💅 Prettier - 代码格式化工具

## 项目结构

```
src/
├── api/          # API 接口
├── assets/       # 静态资源
├── components/   # 公共组件
├── router/       # 路由配置
├── stores/       # Pinia 状态管理
├── styles/       # 全局样式
├── utils/        # 工具函数
└── views/        # 页面组件
    ├── player/   # 播放器页面
    └── admin/    # 后台管理页面
```

## 开发环境设置

1. 克隆项目
```bash
git clone [项目地址]
cd [项目目录]
```

2. 安装依赖
```bash
npm install
```

3. 启动开发服务器
```bash
npm run dev
```

4. 构建生产版本
```bash
npm run build
```

## API 接口

### 音乐接口
- GET `/api/songs` - 获取歌曲列表
- GET `/api/songs/:id` - 获取歌曲详情
- POST `/api/songs/upload` - 上传歌曲
- PUT `/api/songs/:id` - 更新歌曲信息
- DELETE `/api/songs/:id` - 删除歌曲

### 歌词接口
- GET `/api/lyrics/:id` - 获取歌词
- PUT `/api/lyrics/:id` - 更新歌词

## 特色功能实现

### 实时歌词滚动
- 使用 CSS transitions 实现平滑滚动
- 当前播放行高亮显示
- 支持点击歌词跳转播放

### 主题切换
- 支持浅色/深色主题
- 响应系统主题设置
- 平滑过渡动画

### 音量控制
- 垂直滑块设计
- 悬停显示
- 记忆上次音量设置

### 进度控制
- 拖拽进度条
- 显示缓冲进度
- 实时更新时间

## 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

[MIT License](LICENSE)

## 联系方式

- 作者：[您的名字]
- 邮箱：[您的邮箱]
- 项目链接：[项目地址]

## 致谢

感谢所有为这个项目做出贡献的开发者！
