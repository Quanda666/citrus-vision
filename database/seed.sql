-- CitrusVision 数据库初始数据脚本
-- 用于插入默认管理员、分级标准、价格参考等初始数据

USE citrus_vision;

-- ========================================
-- 1. 插入默认管理员用户
-- ========================================
-- 默认管理员账号：admin / admin123
-- 默认普通用户：user / user123
-- 密码哈希使用 bcrypt，以下为示例（实际部署时由后端生成）

INSERT INTO user (username, password_hash, role, real_name, status) VALUES
('admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5IsUfDvNu8xEG', 'admin', '系统管理员', 1),
('demo_user', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5IsUfDvNu8xEG', 'user', '演示用户', 1);

-- ========================================
-- 2. 插入默认分级标准
-- ========================================
-- 砂糖橘标准（激活）
INSERT INTO grade_standard (name, min_diameter, color_th1, color_th2, defect_th1, defect_th2, description, is_active) VALUES
('砂糖橘分级标准（默认）', 45.00, 85.00, 70.00, 2.00, 5.00,
'一级：果径≥45mm 且 着色率≥85% 且 缺陷占比<2% 且 无裂纹/腐烂；
二级：着色率≥70% 且 缺陷占比<5% 且 无裂纹/严重畸形；
等外品：其他情况', 1);

-- 贡柑标准（备用）
INSERT INTO grade_standard (name, min_diameter, color_th1, color_th2, defect_th1, defect_th2, description, is_active) VALUES
('贡柑分级标准', 50.00, 80.00, 65.00, 2.50, 6.00,
'适用于德庆贡柑，标准略宽松', 0);

-- ========================================
-- 3. 插入市场价格参考
-- ========================================
INSERT INTO price_reference (grade, price, unit, source, update_date, is_active) VALUES
('grade1', 8.50, '斤', '肇庆市场调研', CURDATE(), 1),
('grade2', 5.00, '斤', '肇庆市场调研', CURDATE(), 1),
('out', 2.00, '斤', '肇庆市场调研', CURDATE(), 1);

-- ========================================
-- 4. 插入默认模型信息
-- ========================================
INSERT INTO model_info (version, weight_path, algorithm, map50, precision_val, recall_val, description, is_active, trained_at) VALUES
('v1.0-yolov8n-baseline', 'weights/best.pt', 'YOLOv8n', 0.6200, 0.7100, 0.6500,
'基线模型，使用公开数据集预训练', 1, NOW());

-- ========================================
-- 5. 插入演示样本（可选，用于测试）
-- ========================================
-- 演示时可取消注释以下语句
-- INSERT INTO product_sample (name, image_path, thumb_path, origin, batch_no, uploader_id) VALUES
-- ('砂糖橘-演示样本1', 'uploads/demo/sample1.jpg', 'uploads/demo/thumb_sample1.jpg', '肇庆四会', 'DEMO-001', 1),
-- ('砂糖橘-演示样本2', 'uploads/demo/sample2.jpg', 'uploads/demo/thumb_sample2.jpg', '肇庆德庆', 'DEMO-001', 1);

-- ========================================
-- 初始化完成
-- ========================================

SELECT 'Database seeded successfully!' AS message;
