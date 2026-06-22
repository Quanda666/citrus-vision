# 模型权重文件

本目录存放 YOLOv8 训练的模型权重文件。

## 文件说明

- `best.pt` - 最佳模型权重（训练过程中验证集表现最好）
- `last.pt` - 最后一个 epoch 的模型权重
- `*.onnx` - 导出的 ONNX 格式（可选，用于加速推理）

## 获取模型

### 方式1：使用预训练模型（首次运行）

首次运行时，YOLOv8 会自动下载预训练的 `yolov8n.pt`，无需手动操作。

### 方式2：使用自己训练的模型

1. 在 Google Colab 训练模型（参考 `../train/README.md`）
2. 下载训练生成的 `runs/detect/train/weights/best.pt`
3. 复制到本目录：

```bash
cp /path/to/your/best.pt ./best.pt
```

## 模型版本管理

建议在数据库 `model_info` 表中登记模型版本：

| 版本 | 文件名 | 算法 | mAP@0.5 | 训练日期 | 说明 |
|---|---|---|---|---|---|
| v1.0 | best.pt | YOLOv8n | 0.620 | 2026-06-10 | 基线模型 |
| v1.1 | best_v1.1.pt | YOLOv8s | 0.685 | 2026-06-15 | 增强数据集 |

## 注意事项

⚠️ **大文件警告**：
- 模型文件通常 5-20 MB，已在 `.gitignore` 中排除
- 不要提交到 Git 仓库
- 通过网盘/对象存储共享

⚠️ **推理性能**：
- YOLOv8n: CPU 约 2-3 秒/张
- YOLOv8s: CPU 约 4-5 秒/张，精度更高
- GPU 推理快 5-10 倍

## 模型训练指南

详细训练流程请参阅：[../train/README.md](../train/README.md)

---

**最后更新**：2026-06-22
