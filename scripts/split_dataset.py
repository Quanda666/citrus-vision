#!/usr/bin/env python3
"""
数据集划分脚本
按 7:2:1 划分训练/验证/测试集，分层抽样，防止数据泄露
"""
import os
import random
import shutil
from pathlib import Path
from collections import defaultdict
import argparse

def split_dataset(image_dir, output_dir, train_ratio=0.7, val_ratio=0.2, test_ratio=0.1, seed=42):
    """
    按指定比例划分数据集

    防泄露策略：同一批次/同一果实的多角度图片划入同一子集
    假设命名规范：prefix_001.jpg, prefix_002.jpg（同一 prefix 为一组）

    Args:
        image_dir: 标注完成的图片目录（与标注文件在同一目录）
        output_dir: 输出目录，将创建 train/val/test 子目录
        train_ratio: 训练集比例
        val_ratio: 验证集比例
        test_ratio: 测试集比例
        seed: 随机种子，保证可复现
    """
    random.seed(seed)

    image_dir = Path(image_dir)
    output_dir = Path(output_dir)

    print(f"[1/5] 扫描图片目录：{image_dir}")
    image_files = list(image_dir.glob("*.jpg")) + list(image_dir.glob("*.png"))
    print(f"      找到 {len(image_files)} 张图片")

    # 按文件名前缀分组（防泄露）
    print(f"[2/5] 按前缀分组（防止同一果实的多角度图片跨集）")
    groups = defaultdict(list)
    for img in image_files:
        # 提取前缀：去掉最后的 _数字 或 -数字
        parts = img.stem.replace("-", "_").split("_")
        if len(parts) > 1 and parts[-1].isdigit():
            prefix = "_".join(parts[:-1])
        else:
            prefix = img.stem
        groups[prefix].append(img)

    print(f"      分组结果：{len(groups)} 个独立组（每组可能有多张图）")

    # 打乱分组
    group_list = list(groups.values())
    random.shuffle(group_list)

    # 计算划分点
    n_total = len(group_list)
    n_train = int(n_total * train_ratio)
    n_val = int(n_total * val_ratio)

    train_groups = group_list[:n_train]
    val_groups = group_list[n_train:n_train+n_val]
    test_groups = group_list[n_train+n_val:]

    print(f"[3/5] 划分结果：")
    print(f"      训练集：{len(train_groups)} 组 ({len(sum(train_groups, []))} 张图)")
    print(f"      验证集：{len(val_groups)} 组 ({len(sum(val_groups, []))} 张图)")
    print(f"      测试集：{len(test_groups)} 组 ({len(sum(test_groups, []))} 张图)")

    # 创建输出目录结构
    print(f"[4/5] 创建输出目录：{output_dir}")
    for subset in ["train", "val", "test"]:
        (output_dir / subset / "images").mkdir(parents=True, exist_ok=True)
        (output_dir / subset / "labels").mkdir(parents=True, exist_ok=True)

    # 复制文件
    print(f"[5/5] 复制文件到对应子集...")
    stats = {"train": 0, "val": 0, "test": 0}
    missing_labels = []

    for subset_name, groups_to_copy in [("train", train_groups), ("val", val_groups), ("test", test_groups)]:
        for group in groups_to_copy:
            for img in group:
                # 复制图片
                dest_img = output_dir / subset_name / "images" / img.name
                shutil.copy2(img, dest_img)

                # 复制标注文件
                label = img.with_suffix(".txt")
                if label.exists():
                    dest_label = output_dir / subset_name / "labels" / label.name
                    shutil.copy2(label, dest_label)
                    stats[subset_name] += 1
                else:
                    missing_labels.append(img.name)

    print(f"\n✅ 划分完成！")
    print(f"   训练集：{stats['train']} 张")
    print(f"   验证集：{stats['val']} 张")
    print(f"   测试集：{stats['test']} 张")

    if missing_labels:
        print(f"\n⚠️  警告：以下 {len(missing_labels)} 张图片没有对应的标注文件：")
        for name in missing_labels[:10]:  # 只显示前10个
            print(f"   - {name}")
        if len(missing_labels) > 10:
            print(f"   ... 还有 {len(missing_labels) - 10} 个")

    # 生成 data.yaml（YOLOv8 训练配置）
    yaml_content = f"""# YOLOv8 训练配置文件
path: {output_dir.absolute()}  # 数据集根目录
train: train/images  # 训练集图片目录（相对于 path）
val: val/images      # 验证集图片目录
test: test/images    # 测试集图片目录

# 类别
names:
  0: black_spot  # 病斑
  1: crack       # 裂纹
  2: bruise      # 碰伤
  3: deformity   # 畸形
"""
    yaml_path = output_dir / "data.yaml"
    yaml_path.write_text(yaml_content, encoding="utf-8")
    print(f"\n📄 已生成 YOLOv8 配置文件：{yaml_path}")

    return stats

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="划分数据集为训练/验证/测试集")
    parser.add_argument("image_dir", help="标注完成的图片目录")
    parser.add_argument("-o", "--output", default="data/split", help="输出目录（默认：data/split）")
    parser.add_argument("--train", type=float, default=0.7, help="训练集比例（默认：0.7）")
    parser.add_argument("--val", type=float, default=0.2, help="验证集比例（默认：0.2）")
    parser.add_argument("--test", type=float, default=0.1, help="测试集比例（默认：0.1）")
    parser.add_argument("--seed", type=int, default=42, help="随机种子（默认：42）")

    args = parser.parse_args()

    # 验证比例之和为 1
    total = args.train + args.val + args.test
    if abs(total - 1.0) > 0.01:
        print(f"❌ 错误：训练/验证/测试比例之和必须为 1.0（当前：{total}）")
        exit(1)

    split_dataset(
        args.image_dir,
        args.output,
        args.train,
        args.val,
        args.test,
        args.seed
    )
