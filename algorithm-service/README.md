# 算法服务

独立的算法推理服务，负责图像预处理、缺陷检测、特征计算、品质分级。

## 技术栈

- Python 3.10+
- FastAPI (推理 API)
- OpenCV 4.8+ (传统 CV)
- PyTorch 2.1+ (深度学习框架)
- Ultralytics YOLOv8 (缺陷检测)
- NumPy, scikit-learn

## 项目结构

```
algorithm-service/
├── requirements.txt        # 依赖列表
├── .env.example           # 环境变量示例
├── server.py              # FastAPI 服务入口
├── pipeline/              # 检测流水线
│   ├── __init__.py
│   ├── preprocess.py      # 预处理（去噪/白平衡/归一化）
│   ├── segment.py         # 果实分割/ROI 提取
│   ├── detect.py          # YOLOv8 缺陷检测
│   ├── features.py        # 特征计算（果径/着色率/缺陷占比）
│   └── grade.py           # 规则引擎分级
├── train/                 # 训练脚本（在 Colab 运行）
│   ├── train_yolo.py      # YOLOv8 训练
│   ├── data.yaml          # 数据配置
│   ├── evaluate.py        # 模型评估
│   └── README.md          # 训练说明
├── weights/               # 模型权重文件
│   ├── best.pt            # 最佳模型（.gitignore）
│   └── README.md          # 模型说明
└── utils/
    ├── __init__.py
    ├── image_utils.py     # 图像工具
    └── visualize.py       # 结果可视化
```

## 算法流程

```
输入图片 
  ↓
① 预处理（resize/去噪/白平衡/CLAHE）
  ↓
② 果实分割（HSV 阈值 + 形态学 → ROI + 掩膜）
  ↓
③ 缺陷检测（YOLOv8 → 框/类别/置信度）
  ↓
④ 特征计算
   - 果径：外接圆直径（像素 → mm）
   - 着色率：橙色像素占比（HSV 范围）
   - 缺陷占比：缺陷面积 / 果面面积
  ↓
⑤ 规则引擎分级（根据阈值 → 等级）
  ↓
输出：{grade, diameter, color_ratio, defect_ratio, defects[], annotated_path}
```

## 快速开始

### 1. 安装依赖

```bash
cd algorithm-service
pip install -r requirements.txt
```

### 2. 下载/训练模型

```bash
# 方式1：使用预训练模型（首次运行自动下载 YOLOv8n）
# 无需额外操作

# 方式2：使用自己训练的模型
# 将训练好的 best.pt 放到 weights/ 目录
cp /path/to/your/best.pt weights/best.pt
```

### 3. 配置环境变量

```bash
cp .env.example .env
```

编辑 `.env`：

```env
# 模型配置
MODEL_PATH=weights/best.pt
MODEL_TYPE=yolov8n
DEVICE=cpu  # cpu 或 cuda

# 推理配置
CONF_THRESHOLD=0.25
IOU_THRESHOLD=0.45

# 分级标准（对应数据库 grade_standard 激活标准）
MIN_DIAMETER=45.0
COLOR_TH1=85.0
COLOR_TH2=70.0
DEFECT_TH1=2.0
DEFECT_TH2=5.0

# 服务配置
HOST=0.0.0.0
PORT=8001
```

### 4. 启动服务

```bash
# 开发模式
uvicorn server:app --reload --host 0.0.0.0 --port 8001

# 生产模式
uvicorn server:app --host 0.0.0.0 --port 8001 --workers 2
```

### 5. 测试接口

```bash
curl -X POST "http://localhost:8001/infer" \
  -H "Content-Type: application/json" \
  -d '{"image_path": "/path/to/image.jpg", "standard_id": 1}'
```

返回示例：

```json
{
  "grade": "grade1",
  "diameter_mm": 52.3,
  "color_ratio": 88.5,
  "defect_ratio": 1.2,
  "defect_count": 2,
  "defects": [
    {
      "type": "black_spot",
      "bbox": [120, 150, 30, 30],
      "confidence": 0.85,
      "area_px": 650
    }
  ],
  "annotated_path": "/path/to/annotated.jpg",
  "confidence": 0.82
}
```

## 核心模块说明

### 1. 预处理 (preprocess.py)

- 尺寸归一化：resize 到 640×640
- 高斯去噪：cv2.GaussianBlur
- 白平衡：灰度世界算法
- 对比度增强：CLAHE（可选）

### 2. 果实分割 (segment.py)

- HSV 颜色空间阈值分割（橙色范围）
- 形态学开闭运算去除噪点
- 查找最大连通域作为果实区域
- 输出：掩膜 + 外接圆（用于果径）

### 3. 缺陷检测 (detect.py)

- 加载 YOLOv8 模型
- 推理输入图像
- 解析输出：框、类别、置信度
- 过滤低置信度检测

### 4. 特征计算 (features.py)

```python
def calculate_features(image, mask, defects):
    """
    计算品质特征
    
    Returns:
        - diameter_mm: 果径（基于外接圆 + 参照物换算）
        - color_ratio: 着色率（橙色像素 / 总像素）
        - defect_ratio: 缺陷占比（缺陷面积 / 果面面积）
    """
```

### 5. 规则分级 (grade.py)

```python
def classify_grade(diameter, color_ratio, defect_ratio, defects, standard):
    """
    基于规则引擎分级
    
    判定逻辑：
    - 一级：果径达标 且 着色率≥85% 且 缺陷占比<2% 且 无裂纹
    - 二级：着色率≥70% 且 缺陷占比<5% 且 无严重缺陷
    - 等外品：其他情况
    """
```

## 模型训练

详细训练流程请参阅 [train/README.md](train/README.md)

**简要步骤**：

1. 准备数据集（YOLO 格式）
2. 在 Google Colab 打开 `train/train_yolo.py`
3. 配置 `data.yaml`
4. 运行训练：`yolo detect train data=data.yaml model=yolov8n.pt epochs=100`
5. 下载 `runs/detect/train/weights/best.pt` 到本地 `weights/`

## 性能优化

- **CPU 推理**：YOLOv8n 单张约 2-3 秒
- **GPU 推理**：YOLOv8n 单张约 0.5-1 秒
- **批量推理**：batch_size=4 可提升 30% 吞吐
- **模型量化**：导出 ONNX 格式可加速 20-30%

## 传统 CV 兜底方案

如果 YOLOv8 效果不佳，可切换到纯传统 CV：

- 缺陷检测：颜色/纹理异常区域检测（cv2.threshold）
- 分级：仅基于果径、着色率分级
- 优点：确定性高、无需训练、可解释
- 缺点：精度不如深度学习

## 负责人

- 主负责人：[成员A]（算法负责人）
- 协作：[成员B]（传统 CV + 数据）

---

**最后更新**：2026-06-22
