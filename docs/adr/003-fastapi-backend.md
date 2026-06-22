# ADR-003：使用 FastAPI 作为后端框架

- **状态（Status）**：已接受（Accepted）
- **日期**：2026-06-22
- **决策者**：第 12 组（组长 陈绍杰）

## 背景（Context）

后端 API 层与算法服务层均需 Web 框架。备选：

- **Flask**：轻量、生态成熟，但需手动集成数据校验与 API 文档。
- **Django**：功能全，但偏重，学习与配置成本高，对本项目过重。
- **FastAPI**：异步、自带数据校验（Pydantic）与交互式 API 文档（Swagger/OpenAPI）。

项目约束：周期短（约 4 周）、需快速产出接口文档（课设要求接口设计交付）、前后端并行需契约先行、团队 Python 基础较好。

## 决策（Decision）

后端 API 与算法服务统一采用 **FastAPI + Uvicorn**：

- 后端：FastAPI + SQLAlchemy（ORM）+ Pydantic（校验）+ python-jose（JWT）+ passlib（bcrypt）。
- 算法服务：FastAPI 提供 `POST /infer`，与后端同框架降低学习成本。

## 后果（Consequences）

**正面**：
- **自带 Swagger**：`/docs` 自动生成交互式 API 文档，直接服务接口设计交付物。
- **Pydantic 校验**：请求 / 响应模型即文档即校验，减少手写校验代码。
- **异步性能**：满足演示级并发（≥5）。
- 前后端契约清晰，可并行开发。
- 两层同框架，团队只需掌握一套。

**负面 / 代价**：
- 相比 Django 缺少内置 Admin / ORM，需自行组装 SQLAlchemy、迁移工具（Alembic）。
- 异步编程对新手有一定门槛（本项目多数接口可同步实现，门槛可控）。

**关联**：分层结构见源代码文档 §3；接口契约见详细设计 §4；架构决策见 [ADR-002]。
