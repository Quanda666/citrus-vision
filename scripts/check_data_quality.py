#!/usr/bin/env python3
"""
数据质量检查脚本
检查标注文件的完整性、格式正确性、类别分布
"""
import argparse
from pathlib import Path
from collections import Counter, defaultdict

def check_dataset_quality(data_dir):
    """
    检查数据集质量

    Args:
        data_dir: 数据目录（可以是原始标注目录，或划分后的 train/val/test）
    """
    data_dir = Path(data_dir)

    print(f"{'='*60}")
    print(f"数据质量检查报告")
    print(f"{'='*60}")
    print(f"检查目录：{data_dir.absolute()}\n")

    # 检测目录结构
    if (data_dir / "images").exists():
        # 单个子集（train/val/test 之一）
        subsets = [data_dir]
    elif (data_dir / "train" / "images").exists():
        # 已划分的数据集
        subsets = [data_dir / "train", data_dir / "val", data_dir / "test"]
    else:
        # 原始标注目录（图片和标注在同一目录）
        subsets = [data_dir]

    total_stats = {
        "total_images": 0,
        "total_labels": 0,
        "missing_labels": [],
        "empty_labels": [],
        "invalid_labels": [],
        "class_counts": Counter(),
        "bbox_counts": []
    }

    for subset_dir in subsets:
        subset_name = subset_dir.name if len(subsets) > 1 else "dataset"

        # 查找图片目录
        if (subset_dir / "images").exists():
            image_dir = subset_dir / "images"
            label_dir = subset_dir / "labels"
        else:
            image_dir = subset_dir
            label_dir = subset_dir

        print(f"\n[{subset_name}]")
        print(f"  图片目录：{image_dir}")
        print(f"  标注目录：{label_dir}")

        # 1. 统计图片和标注文件
        images = list(image_dir.glob("*.jpg")) + list(image_dir.glob("*.png"))
        print(f"  图片数量：{len(images)}")

        labeled_count = 0
        missing_labels = []
        empty_labels = []
        invalid_labels = []
        class_counts = Counter()
        bbox_counts = []

        for img in images:
            label_file = label_dir / f"{img.stem}.txt"

            if not label_file.exists():
                missing_labels.append(img.name)
                continue

            labeled_count += 1

            # 2. 检查标注文件内容
            try:
                content = label_file.read_text(encoding="utf-8").strip()

                if not content:
                    empty_labels.append(img.name)
                    continue

                lines = content.split("\n")
                bbox_counts.append(len(lines))

                # 3. 检查格式与类别
                for line_no, line in enumerate(lines, start=1):
                    parts = line.strip().split()

                    if len(parts) != 5:
                        invalid_labels.append(f"{img.name}:{line_no} (字段数={len(parts)})")
                        continue

                    try:
                        class_id = int(parts[0])
                        x, y, w, h = map(float, parts[1:])

                        # 检查类别范围
                        if class_id < 0 or class_id > 3:
                            invalid_labels.append(f"{img.name}:{line_no} (类别={class_id})")

                        # 检查坐标范围
                        if not (0 <= x <= 1 and 0 <= y <= 1 and 0 <= w <= 1 and 0 <= h <= 1):
                            invalid_labels.append(f"{img.name}:{line_no} (坐标越界)")

                        class_counts[class_id] += 1

                    except ValueError:
                        invalid_labels.append(f"{img.name}:{line_no} (格式错误)")

            except Exception as e:
                invalid_labels.append(f"{img.name} (读取失败: {e})")

        # 4. 输出统计
        print(f"  已标注数量：{labeled_count}")
        print(f"  缺失标注：{len(missing_labels)} 张")
        print(f"  空标注文件：{len(empty_labels)} 张")
        print(f"  格式错误：{len(invalid_labels)} 处")

        if bbox_counts:
            avg_bbox = sum(bbox_counts) / len(bbox_counts)
            print(f"  平均缺陷数：{avg_bbox:.2f} 个/张")
            print(f"  最多缺陷：{max(bbox_counts)} 个")

        # 5. 类别分布
        print(f"\n  类别分布：")
        class_names = {0: "病斑(black_spot)", 1: "裂纹(crack)", 2: "碰伤(bruise)", 3: "畸形(deformity)"}
        for class_id in range(4):
            count = class_counts[class_id]
            print(f"    {class_names[class_id]}: {count} 个")

        # 累计到总统计
        total_stats["total_images"] += len(images)
        total_stats["total_labels"] += labeled_count
        total_stats["missing_labels"].extend(missing_labels)
        total_stats["empty_labels"].extend(empty_labels)
        total_stats["invalid_labels"].extend(invalid_labels)
        total_stats["class_counts"].update(class_counts)
        total_stats["bbox_counts"].extend(bbox_counts)

    # 6. 总体报告
    print(f"\n{'='*60}")
    print(f"总体统计")
    print(f"{'='*60}")
    print(f"  总图片数：{total_stats['total_images']}")
    print(f"  已标注数：{total_stats['total_labels']}")
    print(f"  标注率：{total_stats['total_labels'] / total_stats['total_images'] * 100:.1f}%")

    # 7. 问题汇总
    issues = []
    if total_stats["missing_labels"]:
        issues.append(f"缺失标注：{len(total_stats['missing_labels'])} 张")
    if total_stats["empty_labels"]:
        issues.append(f"空标注：{len(total_stats['empty_labels'])} 张")
    if total_stats["invalid_labels"]:
        issues.append(f"格式错误：{len(total_stats['invalid_labels'])} 处")

    # 检查类别均衡性
    class_counts = total_stats["class_counts"]
    if class_counts:
        min_count = min(class_counts.values())
        max_count = max(class_counts.values())
        if min_count < 50:
            issues.append(f"某类样本不足50个（最少={min_count}）")
        if max_count > min_count * 3:
            issues.append(f"类别不均衡（最多/最少={max_count}/{min_count}）")

    print(f"\n{'='*60}")
    if issues:
        print(f"⚠️  发现 {len(issues)} 个问题：")
        for issue in issues:
            print(f"  - {issue}")

        # 详细列出前几个问题样本
        if total_stats["missing_labels"]:
            print(f"\n缺失标注样本（前5个）：")
            for name in total_stats["missing_labels"][:5]:
                print(f"  - {name}")

        if total_stats["invalid_labels"]:
            print(f"\n格式错误样本（前5个）：")
            for name in total_stats["invalid_labels"][:5]:
                print(f"  - {name}")
    else:
        print(f"✅ 数据质量良好，无明显问题")
    print(f"{'='*60}\n")

    return total_stats

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="检查数据集标注质量")
    parser.add_argument("data_dir", help="数据目录（原始标注目录或划分后的根目录）")

    args = parser.parse_args()
    check_dataset_quality(args.data_dir)
