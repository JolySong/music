import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './route/index.js'
import '@fortawesome/fontawesome-free/css/all.css';
import { createPinia } from 'pinia';

const app = createApp(App);
const pinia = createPinia();

app.use(router).use(pinia).mount('#app')
