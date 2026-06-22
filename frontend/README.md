# 前端 Web 应用

基于 Vue 3 + Vite + Element Plus 构建的前端应用，支持 PC Web 和移动端 H5。

## 技术栈

- Vue 3.3+ (Composition API)
- Vite 5.0+ (构建工具)
- TypeScript 5.0+
- Element Plus 2.4+ (UI 组件库)
- Pinia 2.1+ (状态管理)
- Vue Router 4.2+ (路由)
- Axios 1.6+ (HTTP 客户端)
- ECharts 5.4+ (数据可视化)

## 项目结构

```
frontend/
├── package.json
├── vite.config.ts         # Vite 配置
├── tsconfig.json          # TypeScript 配置
├── index.html
├── public/                # 静态资源
│   └── favicon.ico
└── src/
    ├── main.ts            # 入口文件
    ├── App.vue
    ├── api/               # API 接口
    │   ├── index.ts       # Axios 配置
    │   ├── auth.ts        # 认证接口
    │   ├── sample.ts      # 样本接口
    │   ├── task.ts        # 任务接口
    │   ├── result.ts      # 结果接口
    │   └── ...
    ├── router/            # 路由配置
    │   └── index.ts
    ├── store/             # Pinia 状态管理
    │   ├── index.ts
    │   ├── user.ts        # 用户状态
    │   └── app.ts         # 应用状态
    ├── views/             # 页面组件
    │   ├── Login.vue      # 登录页
    │   ├── Dashboard.vue  # 仪表盘
    │   ├── Detect.vue     # 检测页（核心）
    │   ├── Batch.vue      # 批量检测
    │   ├── Result.vue     # 结果详情
    │   ├── TaskList.vue   # 任务列表
    │   ├── Sample.vue     # 样本管理
    │   ├── Trace.vue      # 溯源信息
    │   ├── Report.vue     # 报表导出
    │   └── admin/         # 管理员页面
    │       ├── Standard.vue   # 标准管理
    │       ├── Price.vue      # 价格管理
    │       ├── Model.vue      # 模型管理
    │       └── Log.vue        # 日志查询
    ├── components/        # 公共组件
    │   ├── UploadBox.vue      # 上传组件
    │   ├── DefectCanvas.vue   # 缺陷标注画布
    │   ├── GradeBadge.vue     # 等级徽章
    │   ├── StatCharts.vue     # 统计图表
    │   └── ...
    ├── assets/            # 资源文件
    │   ├── styles/
    │   │   ├── main.css
    │   │   └── variables.css
    │   └── images/
    ├── utils/             # 工具函数
    │   ├── request.ts     # 请求封装
    │   ├── auth.ts        # 认证工具
    │   └── format.ts      # 格式化工具
    └── types/             # TypeScript 类型定义
        ├── api.d.ts
        └── models.d.ts
```

## 快速开始

### 1. 安装依赖

```bash
cd frontend
npm install
# 或
pnpm install
```

### 2. 配置环境变量

创建 `.env.development` 和 `.env.production`：

```env
# .env.development
VITE_API_BASE_URL=http://localhost:8000/api/v1
VITE_UPLOAD_MAX_SIZE=10485760

# .env.production
VITE_API_BASE_URL=/api/v1
VITE_UPLOAD_MAX_SIZE=10485760
```

### 3. 启动开发服务器

```bash
npm run dev
```

访问：http://localhost:5173

### 4. 构建生产版本

```bash
npm run build
```

输出目录：`dist/`

## 核心功能页面

### 1. 登录页 (Login.vue)

- 用户名/密码登录
- JWT Token 保存到 localStorage
- 自动跳转到仪表盘

### 2. 仪表盘 (Dashboard.vue)

- 检测总量、各等级占比饼图
- 缺陷分布柱图
- 最近任务列表
- 快捷入口

### 3. 检测页 (Detect.vue) ⭐核心

**功能流程**：

```
上传图片 → 创建任务 → 轮询任务状态 → 
获取结果 → 渲染标注图 + 等级徽章 + 量化指标 → 
可选：登记溯源/导出报告
```

**UI 布局**：

```
┌─────────────────────────────────────┐
│  [上传框] 拖拽或点击上传             │
│  [参数选择] 分级标准、模型版本       │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│  结果区                              │
│  ┌──────────┐  ┌─────────────────┐  │
│  │ 标注图    │  │ 等级徽章：一级   │  │
│  │ (Canvas) │  │ 果径：52.3mm    │  │
│  │          │  │ 着色率：88.5%   │  │
│  │          │  │ 缺陷占比：1.2%  │  │
│  └──────────┘  └─────────────────┘  │
│  缺陷列表：                          │
│  · 病斑 (0.85) [120,150,30,30]      │
│  · 碰伤 (0.72) [200,180,25,28]      │
│  [登记溯源] [导出报告]              │
└─────────────────────────────────────┘
```

### 4. 批量检测页 (Batch.vue)

- 批量上传（最多 20 张）
- 进度条显示
- 结果瀑布流展示
- 批量统计图表
- 批量导出

### 5. 结果详情页 (Result.vue)

- 大图标注展示
- 缺陷逐条详情
- 量化指标卡片
- 参考价格
- 溯源二维码
- 人工复核入口（管理员）

## 关键组件

### UploadBox.vue

```vue
<template>
  <el-upload
    drag
    :action="uploadUrl"
    :before-upload="beforeUpload"
    :on-success="handleSuccess"
    accept="image/jpeg,image/png"
  >
    <el-icon class="el-icon--upload"><upload-filled /></el-icon>
    <div class="el-upload__text">
      拖拽图片到此处或 <em>点击上传</em>
    </div>
    <template #tip>
      <div class="el-upload__tip">
        支持 JPG/PNG，单张不超过 10MB
      </div>
    </template>
  </el-upload>
</template>
```

### DefectCanvas.vue

在 Canvas 上绘制缺陷框：

```typescript
// 绘制矩形框 + 类别标签 + 置信度
defects.forEach(defect => {
  ctx.strokeStyle = '#FF4444';
  ctx.lineWidth = 3;
  ctx.strokeRect(defect.bbox_x, defect.bbox_y, defect.bbox_w, defect.bbox_h);
  
  // 绘制标签
  const label = `${defect.type} ${(defect.confidence * 100).toFixed(0)}%`;
  ctx.fillStyle = '#FF4444';
  ctx.fillRect(defect.bbox_x, defect.bbox_y - 25, 120, 25);
  ctx.fillStyle = '#FFF';
  ctx.fillText(label, defect.bbox_x + 5, defect.bbox_y - 8);
});
```

### GradeBadge.vue

等级徽章组件：

```vue
<template>
  <div :class="['grade-badge', `grade-${grade}`]">
    <span class="grade-icon">{{ gradeIcon }}</span>
    <span class="grade-text">{{ gradeText }}</span>
  </div>
</template>

<style scoped>
.grade-badge.grade-grade1 {
  background: linear-gradient(135deg, #FFD700, #FFA500);
  color: #8B4513;
}
.grade-badge.grade-grade2 {
  background: linear-gradient(135deg, #C0C0C0, #A9A9A9);
  color: #4A4A4A;
}
.grade-badge.grade-out {
  background: linear-gradient(135deg, #CD853F, #8B7355);
  color: #FFF;
}
</style>
```

## 移动端适配

使用响应式设计 + 媒体查询：

```css
/* PC 端 */
@media (min-width: 768px) {
  .detect-container {
    display: flex;
    gap: 20px;
  }
}

/* 移动端 */
@media (max-width: 767px) {
  .detect-container {
    display: block;
  }
  .result-card {
    margin-top: 20px;
  }
}
```

H5 拍照上传：

```vue
<input
  type="file"
  accept="image/*"
  capture="environment"
  @change="handleCapture"
/>
```

## 状态管理

### User Store (store/user.ts)

```typescript
export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('token') || '',
    userInfo: null as UserInfo | null,
    role: 'user' as 'admin' | 'user'
  }),
  actions: {
    async login(username: string, password: string) {
      const res = await loginApi(username, password);
      this.token = res.data.token;
      this.userInfo = res.data.userInfo;
      this.role = res.data.role;
      localStorage.setItem('token', this.token);
    },
    logout() {
      this.token = '';
      this.userInfo = null;
      localStorage.removeItem('token');
      router.push('/login');
    }
  }
});
```

## 路由守卫

```typescript
router.beforeEach((to, from, next) => {
  const userStore = useUserStore();
  
  if (to.meta.requiresAuth && !userStore.token) {
    next('/login');
  } else if (to.meta.requiresAdmin && userStore.role !== 'admin') {
    ElMessage.error('无权限访问');
    next('/dashboard');
  } else {
    next();
  }
});
```

## 开发规范

- 组件命名：PascalCase
- 文件命名：PascalCase (组件) / camelCase (工具)
- CSS：使用 scoped + BEM 命名
- TypeScript：严格模式，类型完整
- 注释：关键逻辑必须注释

## 负责人

- 主负责人：[成员C]
- 协作：全组成员

---

**最后更新**：2026-06-22
