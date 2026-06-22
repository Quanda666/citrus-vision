# 后端 API 服务

基于 FastAPI 构建的后端 API 服务，负责鉴权、业务逻辑编排、数据库操作。

## 技术栈

- Python 3.10+
- FastAPI 0.104+
- SQLAlchemy 2.0+ (ORM)
- Pydantic 2.0+ (数据校验)
- PyJWT (JWT 认证)
- Uvicorn (ASGI 服务器)
- MySQL 8.0+ (数据库)

## 项目结构

```
backend/
├── requirements.txt        # 依赖列表
├── .env.example           # 环境变量示例
├── main.py                # 应用入口
└── app/
    ├── __init__.py
    ├── core/              # 核心配置
    │   ├── config.py      # 配置管理
    │   ├── security.py    # JWT/密码加密
    │   └── deps.py        # 依赖注入
    ├── api/               # API 路由
    │   └── v1/
    │       ├── __init__.py
    │       ├── auth.py    # 认证接口
    │       ├── users.py   # 用户管理
    │       ├── samples.py # 样本上传
    │       ├── tasks.py   # 检测任务
    │       ├── results.py # 检测结果
    │       ├── trace.py   # 溯源信息
    │       ├── reports.py # 报表导出
    │       ├── models.py  # 模型管理
    │       ├── logs.py    # 日志查询
    │       └── stats.py   # 统计看板
    ├── models/            # ORM 模型
    │   ├── __init__.py
    │   ├── user.py
    │   ├── sample.py
    │   ├── task.py
    │   ├── result.py
    │   └── ...
    ├── schemas/           # Pydantic 模型
    │   ├── __init__.py
    │   ├── user.py
    │   ├── sample.py
    │   ├── task.py
    │   └── ...
    ├── services/          # 业务逻辑
    │   ├── __init__.py
    │   ├── auth_service.py
    │   ├── task_service.py
    │   ├── algo_client.py  # 算法服务客户端
    │   └── ...
    ├── crud/              # 数据库操作
    │   ├── __init__.py
    │   ├── user.py
    │   ├── sample.py
    │   └── ...
    ├── db/                # 数据库连接
    │   ├── __init__.py
    │   ├── session.py     # 会话管理
    │   └── init_db.py     # 初始化
    └── utils/             # 工具函数
        ├── __init__.py
        ├── file_utils.py  # 文件处理
        ├── qr_utils.py    # 二维码生成
        └── report_utils.py # 报表生成
```

## 快速开始

### 1. 创建虚拟环境

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

### 3. 配置环境变量

复制 `.env.example` 为 `.env` 并修改配置：

```bash
cp .env.example .env
```

编辑 `.env` 文件：

```env
# 数据库配置
DATABASE_URL=mysql+pymysql://root:password@localhost:3306/citrus_vision

# JWT 配置
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# 算法服务地址
ALGORITHM_SERVICE_URL=http://localhost:8001

# 文件存储
UPLOAD_DIR=../uploads
MAX_UPLOAD_SIZE=10485760

# 服务配置
HOST=0.0.0.0
PORT=8000
```

### 4. 初始化数据库

```bash
# 执行建表脚本
mysql -u root -p < ../database/schema.sql

# 执行初始数据脚本
mysql -u root -p < ../database/seed.sql
```

### 5. 启动服务

```bash
# 开发模式（热重载）
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# 生产模式
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
```

### 6. 访问 API 文档

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API 接口概览

### 认证接口 `/api/v1/auth`

- `POST /register` - 用户注册
- `POST /login` - 用户登录
- `POST /logout` - 用户登出

### 样本接口 `/api/v1/samples`

- `POST /` - 上传图片（单张/批量）
- `GET /` - 样本列表
- `GET /{id}` - 样本详情
- `DELETE /{id}` - 删除样本

### 任务接口 `/api/v1/tasks`

- `POST /` - 创建检测任务
- `GET /` - 任务列表
- `GET /{id}` - 任务详情

### 结果接口 `/api/v1/results`

- `GET /{taskId}` - 查询任务结果
- `GET /{id}` - 结果详情
- `PUT /{id}/correct` - 人工复核

### 其他接口

- `/api/v1/trace` - 溯源信息
- `/api/v1/reports` - 报表导出
- `/api/v1/models` - 模型管理（管理员）
- `/api/v1/stats` - 统计看板
- `/api/v1/logs` - 操作日志

## 开发规范

### 统一返回格式

```json
{
  "code": 0,
  "msg": "success",
  "data": { ... }
}
```

错误码：
- 0 - 成功
- 400 - 请求参数错误
- 401 - 未认证
- 403 - 无权限
- 404 - 资源不存在
- 500 - 服务器错误

### 命名规范

- 文件名：snake_case
- 类名：PascalCase
- 函数/变量：snake_case
- 常量：UPPER_CASE

### 注释规范

```python
def create_detection_task(
    sample_ids: List[int],
    user_id: int,
    db: Session
) -> DetectionTask:
    """
    创建检测任务
    
    Args:
        sample_ids: 样本ID列表
        user_id: 用户ID
        db: 数据库会话
        
    Returns:
        DetectionTask: 创建的任务对象
        
    Raises:
        ValueError: 样本不存在时抛出
    """
    pass
```

## 测试

```bash
# 安装测试依赖
pip install pytest pytest-asyncio httpx

# 运行测试
pytest tests/

# 测试覆盖率
pytest --cov=app tests/
```

## 负责人

- 主负责人：[组长]（组长）
- 协作：[成员A]、[成员B]

---

**最后更新**：2026-06-22
