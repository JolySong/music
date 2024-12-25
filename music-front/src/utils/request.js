import axios from 'axios';

// 创建请求实例
const instance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api', // 从环境变量获取基础URL
  timeout: 6000, // 请求超时时间
  headers: {
    'Content-Type': 'application/json',
  },
});

// 请求拦截器
instance.interceptors.request.use(
  (config) => {
    // 在发送请求之前做些什么
    const token = localStorage.getItem('token');
    if (token) {
      config.headers = {
        ...config.headers,
        Authorization: `Bearer ${token}`,
      };
    }
    return config;
  },
  (error) => {
    // 对请求错误做些什么
    console.error('Request error:', error);
    return Promise.reject(error);
  }
);

// 响应拦截器
instance.interceptors.response.use(
  (response) => {
    const { data } = response;
    
    // 这里可以根据后端的响应结构进行定制
    if (data.code === 200) {
      return data;
    }
    
    // 处理业务错误
    console.error('Request failed:', data.message || '请求失败');
    return Promise.reject(new Error(data.message || '请求失败'));
  },
  (error) => {
    // 处理HTTP错误
    if (error.response) {
      const { status } = error.response;
      let errorMessage = '';
      switch (status) {
        case 401:
          errorMessage = '未授权，请重新登录';
          // 可以在这里处理登出逻辑
          break;
        case 403:
          errorMessage = '拒绝访问';
          break;
        case 404:
          errorMessage = '请求的资源不存在';
          break;
        case 500:
          errorMessage = '服务器错误';
          break;
        default:
          errorMessage = `请求失败: ${error.message}`;
      }
      console.error(errorMessage);
    } else if (error.request) {
      console.error('网络错误，请检查您的网络连接');
    } else {
      console.error(`请求错误: ${error.message}`);
    }
    return Promise.reject(error);
  }
);

// 封装请求方法
const request = {
  get(url, config) {
    return instance.get(url, config);
  },

  post(url, data, config) {
    return instance.post(url, data, config);
  },

  put(url, data, config) {
    return instance.put(url, data, config);
  },

  delete(url, config) {
    return instance.delete(url, config);
  },

  // 上传文件的方法
  upload(url, config, params) {
    const formData = new FormData();
    params.forEach(param => {
      formData.append(param.key, param.value);
    });
    return instance.post(url, formData, {
      ...config,
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
  },
};

export default request; 