# 项目参考资源

本文件汇总项目开发过程中的参考资源和链接。

## 官方文档

### 技术栈文档

- [Vue 3 官方文档](https://cn.vuejs.org/)
- [Element Plus 组件库](https://element-plus.org/zh-CN/)
- [FastAPI 文档](https://fastapi.tiangolo.com/zh/)
- [SQLAlchemy 文档](https://docs.sqlalchemy.org/)
- [PyTorch 文档](https://pytorch.org/docs/)
- [Ultralytics YOLOv8](https://docs.ultralytics.com/)
- [OpenCV Python 教程](https://docs.opencv.org/4.x/d6/d00/tutorial_py_root.html)

### 工具文档

- [Git 中文教程](https://git-scm.com/book/zh/v2)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [Vite 构建工具](https://cn.vitejs.dev/)
- [Pinia 状态管理](https://pinia.vuejs.org/zh/)

## 数据集资源

### 公开数据集

- [Kaggle - Fruit Quality Detection](https://www.kaggle.com/datasets/fruit-quality)
- [百度 AI Studio - 水果检测数据集](https://aistudio.baidu.com/datasetoverview)
- [Roboflow - Citrus Dataset](https://universe.roboflow.com/)
- [天池 - 农产品质检数据集](https://tianchi.aliyun.com/)

### 标注工具

- [LabelImg](https://github.com/HumanSignal/labelImg) - YOLO 格式标注工具
- [Roboflow](https://roboflow.com/) - 在线标注 + 增强 + 导出
- [CVAT](https://www.cvat.ai/) - 计算机视觉标注工具

## 学习资源

### YOLOv8 训练教程

- [YOLOv8 官方教程](https://docs.ultralytics.com/modes/train/)
- [YOLOv8 自定义数据集训练](https://blog.roboflow.com/how-to-train-yolov8-on-a-custom-dataset/)
- [Google Colab 免费 GPU](https://colab.research.google.com/)

### OpenCV 图像处理

- [OpenCV 颜色空间转换](https://docs.opencv.org/4.x/df/d9d/tutorial_py_colorspaces.html)
- [形态学操作](https://docs.opencv.org/4.x/d9/d61/tutorial_py_morphological_ops.html)
- [轮廓检测](https://docs.opencv.org/4.x/d4/d73/tutorial_py_contours_begin.html)

### FastAPI 开发

- [FastAPI 快速入门](https://fastapi.tiangolo.com/zh/tutorial/)
- [SQLAlchemy ORM 教程](https://docs.sqlalchemy.org/en/20/tutorial/)
- [JWT 认证实现](https://fastapi.tiangolo.com/tutorial/security/)

### Vue 3 开发

- [Vue 3 Composition API](https://cn.vuejs.org/guide/extras/composition-api-faq.html)
- [Pinia 快速入门](https://pinia.vuejs.org/zh/getting-started.html)
- [Element Plus 表单验证](https://element-plus.org/zh-CN/component/form.html)

## 项目参考

### 类似项目

- [Fruit Quality Detection System](https://github.com/example/fruit-detection)
- [Agricultural Product Grading](https://github.com/example/ag-grading)
- [YOLOv8 Defect Detection](https://github.com/example/yolov8-defect)

### UML 绘图

- [ProcessOn 在线作图](https://www.processon.com/)
- [draw.io](https://app.diagrams.net/)
- [PlantUML](https://plantuml.com/zh/) - 代码生成 UML

### 报表生成

- [ReportLab 用户手册](https://www.reportlab.com/docs/reportlab-userguide.pdf)
- [openpyxl 文档](https://openpyxl.readthedocs.io/)

## 肇庆柑橘产业资料

### 产业背景

- [四会柑橘产业概况](https://www.zhaoqing.gov.cn/)
- [德庆贡柑介绍](https://baike.baidu.com/item/德庆贡柑)
- [广东柑橘产业统计](https://www.gdagri.gov.cn/)

### 分级标准参考

- [NY/T 585-2020 柑橘等级规格](http://www.moa.gov.cn/) - 国家标准
- [柑橘品质分级参考](https://www.cnki.net/)

## 开发工具

### 在线工具

- [JSON 格式化](https://jsonformatter.org/)
- [图片压缩](https://tinypng.com/)
- [视频压缩](https://www.freeconvert.com/video-compressor)
- [正则表达式测试](https://regex101.com/)
- [Base64 编解码](https://www.base64encode.org/)

### IDE 插件

- **VS Code**:
  - Volar (Vue 3)
  - Pylance (Python)
  - REST Client (API 测试)
  - GitLens (Git 增强)
  
- **PyCharm**:
  - .ignore
  - Database Navigator

## 答辩资源

### PPT 模板

- [学术答辩模板](https://www.pptsupermarket.com/)
- [课设答辩模板](https://www.1ppt.com/)

### 图标资源

- [iconfont 阿里图标库](https://www.iconfont.cn/)
- [Iconify](https://iconify.design/)
- [Font Awesome](https://fontawesome.com/)

### 配色方案

- [Coolors 配色生成器](https://coolors.co/)
- [中国传统色](http://zhongguose.com/)

## 常见问题

### Q1: YOLOv8 训练显存不足？

**A**: 使用 YOLOv8n（最小版本）+ 减小 batch size（8 → 4）+ 使用 Colab 免费 GPU

### Q2: MySQL 连接报错？

**A**: 检查防火墙 3306 端口、MySQL 用户权限、pymysql 驱动安装

### Q3: 前端跨域问题？

**A**: 后端添加 CORS 中间件：
```python
from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(CORSMiddleware, allow_origins=["*"])
```

### Q4: Docker 启动慢？

**A**: 使用国内镜像源：
```bash
# /etc/docker/daemon.json
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
```

### Q5: 视频超过 50M？

**A**: 使用 ffmpeg 压缩：
```bash
ffmpeg -i input.mp4 -vcodec h264 -crf 28 -preset slow -acodec aac -b:a 96k output.mp4
```

## 联系方式

### 组内沟通

- 微信群：第12组-CitrusVision
- 代码仓库：[Gitee/GitHub 地址]
- 文档协作：腾讯文档/石墨文档

### 外部求助

- Stack Overflow: [https://stackoverflow.com/](https://stackoverflow.com/)
- GitHub Issues: 各技术栈官方仓库 Issues
- CSDN/掘金: 搜索相关技术博客

---

**维护说明**：发现有用的资源及时补充到本文件

**最后更新**：2026-06-22
