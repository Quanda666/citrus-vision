-- CitrusVision 数据库初始化脚本
-- 数据库：MySQL 8.0+
-- 字符集：utf8mb4
-- 维护人：[组长]（组长）
-- 最后更新：2026-06-22

-- 创建数据库
CREATE DATABASE IF NOT EXISTS citrus_vision
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE citrus_vision;

-- ========================================
-- 表1：用户表（user）
-- ========================================
CREATE TABLE IF NOT EXISTS user (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
  username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希（bcrypt）',
  role ENUM('admin', 'user') NOT NULL DEFAULT 'user' COMMENT '角色：管理员/普通用户',
  real_name VARCHAR(50) COMMENT '真实姓名',
  phone VARCHAR(20) COMMENT '联系电话',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-禁用',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_username (username),
  INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ========================================
-- 表2：农产品样本表（product_sample）
-- ========================================
CREATE TABLE IF NOT EXISTS product_sample (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '样本ID',
  name VARCHAR(100) COMMENT '品种名称（砂糖橘/贡柑等）',
  image_path VARCHAR(255) NOT NULL COMMENT '原图存储路径',
  thumb_path VARCHAR(255) COMMENT '缩略图路径',
  origin VARCHAR(100) COMMENT '产地',
  batch_no VARCHAR(50) COMMENT '批次号',
  uploader_id BIGINT COMMENT '上传人ID',
  file_size INT COMMENT '文件大小（字节）',
  width INT COMMENT '图像宽度',
  height INT COMMENT '图像高度',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_uploader (uploader_id),
  INDEX idx_batch (batch_no),
  INDEX idx_created (created_at),
  FOREIGN KEY (uploader_id) REFERENCES user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='农产品样本表';

-- ========================================
-- 表3：检测任务表（detection_task）
-- ========================================
CREATE TABLE IF NOT EXISTS detection_task (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '任务ID',
  task_no VARCHAR(40) NOT NULL UNIQUE COMMENT '任务编号（唯一）',
  user_id BIGINT NOT NULL COMMENT '发起人ID',
  model_id BIGINT COMMENT '使用的模型ID',
  type ENUM('single', 'batch') NOT NULL DEFAULT 'single' COMMENT '任务类型：单张/批量',
  status ENUM('pending', 'processing', 'done', 'failed') NOT NULL DEFAULT 'pending' COMMENT '任务状态',
  total_count INT NOT NULL DEFAULT 0 COMMENT '图片总数',
  done_count INT NOT NULL DEFAULT 0 COMMENT '已完成数',
  error_msg TEXT COMMENT '错误信息（失败时）',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_task_no (task_no),
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_created (created_at),
  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
  FOREIGN KEY (model_id) REFERENCES model_info(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检测任务表';

-- ========================================
-- 表4：检测结果表（detection_result）
-- ========================================
CREATE TABLE IF NOT EXISTS detection_result (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '结果ID',
  task_id BIGINT NOT NULL COMMENT '所属任务ID',
  sample_id BIGINT NOT NULL COMMENT '样本ID',
  grade ENUM('grade1', 'grade2', 'out') NOT NULL COMMENT '评定等级：一级/二级/等外品',
  diameter_mm DECIMAL(6, 2) COMMENT '果径估计（毫米）',
  color_ratio DECIMAL(5, 2) COMMENT '着色率（%）',
  defect_ratio DECIMAL(5, 2) COMMENT '缺陷面积占比（%）',
  defect_count INT NOT NULL DEFAULT 0 COMMENT '缺陷数量',
  annotated_path VARCHAR(255) COMMENT '标注图路径',
  confidence DECIMAL(4, 3) COMMENT '综合置信度',
  ref_price DECIMAL(8, 2) COMMENT '参考价格（元/斤）',
  is_reviewed TINYINT NOT NULL DEFAULT 0 COMMENT '是否已人工复核',
  reviewed_grade ENUM('grade1', 'grade2', 'out') COMMENT '复核后等级',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_task (task_id),
  INDEX idx_sample (sample_id),
  INDEX idx_grade (grade),
  INDEX idx_created (created_at),
  FOREIGN KEY (task_id) REFERENCES detection_task(id) ON DELETE CASCADE,
  FOREIGN KEY (sample_id) REFERENCES product_sample(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='检测结果表';

-- ========================================
-- 表5：缺陷标签表（defect_label）
-- ========================================
CREATE TABLE IF NOT EXISTS defect_label (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '标签ID',
  result_id BIGINT NOT NULL COMMENT '所属结果ID',
  defect_type ENUM('black_spot', 'crack', 'bruise', 'deformity') NOT NULL COMMENT '缺陷类型',
  bbox_x INT NOT NULL COMMENT '边界框 x 坐标',
  bbox_y INT NOT NULL COMMENT '边界框 y 坐标',
  bbox_w INT NOT NULL COMMENT '边界框宽度',
  bbox_h INT NOT NULL COMMENT '边界框高度',
  confidence DECIMAL(4, 3) NOT NULL COMMENT '置信度',
  area_px INT COMMENT '缺陷像素面积',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  INDEX idx_result (result_id),
  INDEX idx_type (defect_type),
  FOREIGN KEY (result_id) REFERENCES detection_result(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='缺陷标签表';

-- ========================================
-- 表6：分级标准表（grade_standard）
-- ========================================
CREATE TABLE IF NOT EXISTS grade_standard (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '标准ID',
  name VARCHAR(100) NOT NULL COMMENT '标准名称',
  min_diameter DECIMAL(5, 2) COMMENT '最小果径（mm）',
  color_th1 DECIMAL(5, 2) NOT NULL COMMENT '着色率阈值1（一级）',
  color_th2 DECIMAL(5, 2) NOT NULL COMMENT '着色率阈值2（二级）',
  defect_th1 DECIMAL(5, 2) NOT NULL COMMENT '缺陷占比阈值1（一级）',
  defect_th2 DECIMAL(5, 2) NOT NULL COMMENT '缺陷占比阈值2（二级）',
  description TEXT COMMENT '标准描述',
  is_active TINYINT NOT NULL DEFAULT 0 COMMENT '是否当前激活',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分级标准表';

-- ========================================
-- 表7：市场价格参考表（price_reference）
-- ========================================
CREATE TABLE IF NOT EXISTS price_reference (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '价格ID',
  grade ENUM('grade1', 'grade2', 'out') NOT NULL COMMENT '等级',
  price DECIMAL(8, 2) NOT NULL COMMENT '参考价格（元）',
  unit VARCHAR(20) NOT NULL DEFAULT '斤' COMMENT '单位',
  source VARCHAR(100) COMMENT '价格来源',
  update_date DATE NOT NULL COMMENT '更新日期',
  is_active TINYINT NOT NULL DEFAULT 1 COMMENT '是否有效',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_grade (grade),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='市场价格参考表';

-- ========================================
-- 表8：溯源信息表（traceability）
-- ========================================
CREATE TABLE IF NOT EXISTS traceability (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '溯源ID',
  sample_id BIGINT NOT NULL UNIQUE COMMENT '样本ID（一对一）',
  origin VARCHAR(100) COMMENT '产地',
  variety VARCHAR(50) COMMENT '品种',
  producer VARCHAR(100) COMMENT '生产者',
  batch_no VARCHAR(50) COMMENT '批次号',
  detect_time DATETIME COMMENT '检测时间',
  inspector VARCHAR(50) COMMENT '检测人',
  qr_code_path VARCHAR(255) COMMENT '二维码图片路径',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (sample_id) REFERENCES product_sample(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='溯源信息表';

-- ========================================
-- 表9：模型信息表（model_info）
-- ========================================
CREATE TABLE IF NOT EXISTS model_info (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '模型ID',
  version VARCHAR(50) NOT NULL UNIQUE COMMENT '版本号',
  weight_path VARCHAR(255) NOT NULL COMMENT '权重文件路径',
  algorithm VARCHAR(100) COMMENT '算法名称（YOLOv8n/YOLOv8s等）',
  map50 DECIMAL(5, 4) COMMENT 'mAP@0.5 指标',
  precision_val DECIMAL(5, 4) COMMENT 'Precision',
  recall_val DECIMAL(5, 4) COMMENT 'Recall',
  description TEXT COMMENT '模型描述',
  is_active TINYINT NOT NULL DEFAULT 0 COMMENT '是否当前激活',
  trained_at DATETIME COMMENT '训练时间',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  INDEX idx_version (version),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型信息表';

-- ========================================
-- 表10：操作日志表（operation_log）
-- ========================================
CREATE TABLE IF NOT EXISTS operation_log (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
  user_id BIGINT COMMENT '操作人ID',
  action VARCHAR(50) NOT NULL COMMENT '操作类型（login/upload/detect/export等）',
  target VARCHAR(100) COMMENT '操作对象',
  detail TEXT COMMENT '详细信息（JSON）',
  ip VARCHAR(50) COMMENT 'IP 地址',
  user_agent VARCHAR(255) COMMENT 'User-Agent',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  INDEX idx_user (user_id),
  INDEX idx_action (action),
  INDEX idx_created (created_at),
  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- ========================================
-- 初始化完成
-- ========================================
