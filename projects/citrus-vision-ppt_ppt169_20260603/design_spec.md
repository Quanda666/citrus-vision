# CitrusVision - Design Spec

> 软件工程课程设计 · 第12组 · 题目10 · 课堂方案讲解 PPT。本文件为人类可读的设计叙事;机器可读执行契约见 `spec_lock.md`(每页生成前必读,冲突以 spec_lock.md 为准)。

## I. Project Information

| Item | Value |
| ---- | ----- |
| **Project Name** | CitrusVision · 基于机器视觉的肇庆柑橘品质分级与缺陷检测系统 |
| **Canvas Format** | PPT 16:9 (1280×720) |
| **Page Count** | 18 |
| **Design Style** | B) 通用咨询(数据/图表清晰优先)+ 清爽学术科技风 |
| **Target Audience** | 任课老师 + 同班同学 |
| **Use Case** | 软件工程课程设计课堂 · 小组代表上台讲解项目方案 |
| **Created Date** | 2026-06-03 |

---

## II. Canvas Specification

| Property | Value |
| -------- | ----- |
| **Format** | PPT 16:9 |
| **Dimensions** | 1280×720 |
| **viewBox** | `0 0 1280 720` |
| **Margins** | 左右 60px,上下 50px |
| **Content Area** | 1160×620(安全区);标题区 1160×96,正文区 1160×480,页脚区 1160×36 |

---

## III. Visual Theme

### Theme Style

- **Style**: 清爽学术科技风 — 柑橘农业主题 × 机器视觉科技底色
- **Theme**: Light theme(浅色)
- **Tone**: 专业、稳重、可信、有主题辨识度;让架构/数据/流程"图表说话"

### Color Scheme

| Role | HEX | Purpose |
| ---- | --- | ------- |
| **Background** | `#FFFFFF` | 页面背景 |
| **Secondary bg** | `#F4F7F6` | 卡片背景、分区背景 |
| **Primary** | `#0E7C66` 深青绿 | 标题装饰、关键分区、图标、架构主色(科技+农业稳重) |
| **Primary dark** | `#0A5A49` | 渐变深端、强调底块 |
| **Accent** | `#F2811D` 柑橘橙 | 数据高亮、缺陷框联想、关键信息(主题辨识) |
| **Body text** | `#1F2A33` | 正文 |
| **Secondary text** | `#5B6B73` | 注释、副信息 |
| **Border/divider** | `#E2E8E9` | 卡片边框、分隔线 |
| **Success** | `#2E9E5B` | 达标/正向(一级品、通过) |
| **Warning** | `#E0544A` | 风险标记、缺陷、等外品 |

> 60-30-10:浅底(白/浅灰)≈60% + 深青绿 ≈30% + 柑橘橙 ≈10%。每页配色不超过 4 个主要颜色。文字对比度 ≥ 4.5:1。

### Gradient Scheme (SVG syntax)

```xml
<!-- 标题/主视觉渐变:青绿 → 深青绿 -->
<linearGradient id="titleGradient" x1="0%" y1="0%" x2="100%" y2="100%">
  <stop offset="0%" stop-color="#0E7C66"/>
  <stop offset="100%" stop-color="#0A5A49"/>
</linearGradient>

<!-- 强调渐变:柑橘橙(用于 KPI 数字、缺陷框、亮点) -->
<linearGradient id="accentGradient" x1="0%" y1="0%" x2="100%" y2="0%">
  <stop offset="0%" stop-color="#F2811D"/>
  <stop offset="100%" stop-color="#E0544A"/>
</linearGradient>

<!-- 背景装饰径向(注意:禁止 rgba,使用 stop-opacity) -->
<radialGradient id="bgDecor" cx="85%" cy="15%" r="55%">
  <stop offset="0%" stop-color="#0E7C66" stop-opacity="0.10"/>
  <stop offset="100%" stop-color="#0E7C66" stop-opacity="0"/>
</radialGradient>
```

---

## IV. Typography System

### Font Plan

**Typography direction**: 现代中文黑体,同族字重对比(标题粗、正文常规),全程 PPT 安全字体。

| Role | Chinese | English | Fallback tail |
| ---- | ------- | ------- | ------------- |
| **Title** | `"Microsoft YaHei"` | `Arial` | `sans-serif` |
| **Body** | `"Microsoft YaHei"` | `Arial` | `sans-serif` |
| **Emphasis** | `"Microsoft YaHei"` | `Arial` | `sans-serif` |
| **Code** | — | `Consolas, "Courier New"` | `monospace` |

**Per-role font stacks**:

- Title: `"Microsoft YaHei", Arial, sans-serif`(字重 700–800 实现对比)
- Body: `"Microsoft YaHei", Arial, sans-serif`(字重 400)
- Emphasis: same as Body(字重 700 + 柑橘橙着色实现强调)
- Code: `Consolas, "Courier New", monospace`(用于目录树、接口路径、字段名)

### Font Size Hierarchy

**Baseline**: Body = **20px**(课堂投影中等密度,清晰可读)

| Purpose | Ratio | px @ body=20 | Weight |
| ------- | ----- | ------------ | ------ |
| Cover title | 3x | 60 | Heavy |
| Page title | 1.8x | 36 | Bold |
| Hero number(KPI 大数字) | 2x | 40 | Bold |
| Subtitle | 1.3x | 26 | SemiBold |
| **Body** | **1x** | **20** | Regular |
| Annotation / caption | 0.7x | 14 | Regular |
| Page number / footnote | 0.6x | 12 | Regular |

> Formula policy: **text-only** —— 着色率%、缺陷占比%、阈值、mAP 等用普通文本/Unicode,无 LaTeX PNG 渲染。

---

## V. Layout Principles

### Page Structure

- **Header area**: 高 ~96px。左侧色条(青绿)+ 页标题(36px)+ 可选副标题;右上角章节标识。
- **Content area**: 高 ~480px。按页面 rhythm 与图表模板组织。
- **Footer area**: 高 ~36px。左"CitrusVision · 第12组",右页码 "NN / 18";细分隔线。

### Layout Pattern Library(按信息权重组合,勿千篇一律)

- 封面/收尾:单列居中 / 负空间驱动(breathing)
- 路线图/目标/架构/算法:结构强调页(anchor),主视觉占据视觉中心
- 对比/表格/多卡:对称或非对称分栏、卡片网格(dense)
- 流程/管线:横向步骤条 + 箭头
- UML(用例图/E-R):自由画布,实体/参与者 + 连线

### Spacing Specification

| Element | Range | Project |
| ------- | ----- | ------- |
| 画布安全边距 | 40–60px | 60px |
| 内容块间距 | 24–40px | 28px |
| 图标-文字间距 | 8–16px | 12px |
| 卡片间距 | 20–32px | 24px |
| 卡片内边距 | 20–32px | 24px |
| 卡片圆角 | 8–16px | 12px |
| 行高 | 1.4–1.6× | 1.5× |

---

## VI. Icon Usage Specification

### Source

- **Built-in icon library**: `tabler-outline`(线性描边,**stroke-width = 2**,全篇统一,禁止混库)
- **Usage**: `<use data-icon="tabler-outline/icon-name" .../>`;仅可使用下方清单内图标。

### Recommended Icon List

| Purpose | Icon Path | Page |
| ------- | --------- | ---- |
| 柑橘/农业 | `tabler-outline/leaf` | P01,P03,P04 |
| 视觉检测/识别 | `tabler-outline/eye-check` / `tabler-outline/scan` | P01,P03,P12 |
| 拍照上传 | `tabler-outline/camera` / `tabler-outline/upload` / `tabler-outline/device-mobile` | P06,P09 |
| 路线/导览 | `tabler-outline/route` / `tabler-outline/map-pin` | P02,P03 |
| 目标/达标 | `tabler-outline/target` / `tabler-outline/circle-check` | P04,P05,P16 |
| 时间/计时 | `tabler-outline/clock` / `tabler-outline/calendar-event` / `tabler-outline/flag` | P05,P14 |
| 数据/图表 | `tabler-outline/chart-bar` / `tabler-outline/chart-pie` / `tabler-outline/chart-dots` | P05,P16 |
| 用户/角色 | `tabler-outline/users` / `tabler-outline/user-circle` / `tabler-outline/settings` | P06,P15 |
| 溯源二维码 | `tabler-outline/qrcode` | P06,P17 |
| 需求/清单 | `tabler-outline/list-check` / `tabler-outline/clipboard-check` | P07,P16,P18 |
| 非功能/安全 | `tabler-outline/shield-check` | P07,P16 |
| 模块/分层 | `tabler-outline/stack` / `tabler-outline/layout-grid` / `tabler-outline/box` | P08,P10,P11 |
| 算法/推理 | `tabler-outline/cpu` / `tabler-outline/filter-cog` / `tabler-outline/ruler` / `tabler-outline/palette` | P10,P12 |
| 服务/存储 | `tabler-outline/server` / `tabler-outline/database` / `tabler-outline/cloud` / `tabler-outline/folder` / `tabler-outline/photo` | P10,P11,P13 |
| 代码/接口 | `tabler-outline/code` / `tabler-outline/table` / `tabler-outline/key` / `tabler-outline/link-plus` | P10,P13 |
| 协作/分支 | `tabler-outline/git-branch` / `tabler-outline/adjustments-horizontal` / `tabler-outline/arrows-split` | P09,P15 |
| 测试/缺陷 | `tabler-outline/bug` / `tabler-outline/flask-2` | P16 |
| 创新/亮点 | `tabler-outline/bulb` / `tabler-outline/star` / `tabler-outline/sparkles` | P17 |
| 风险 | `tabler-outline/alert-triangle` | P17 |
| 交付物 | `tabler-outline/package` / `tabler-outline/file-text` / `tabler-outline/video` | P18 |

---

## VII. Visualization Reference List

Catalog read: 71 templates

| Page | Template | Path | Summary-quote (verbatim from `charts_index.json`) | Usage |
| ---- | -------- | ---- | ------------------------------------------------- | ----- |
| P02 | agenda_list | `templates/charts/agenda_list.svg` | "Pick for table of contents, meeting agendas, or presentation roadmap — numbered items + brief description + duration / owner per row. Skip for substantive content lists (use vertical_list) or single-page section dividers (use a cover layout)." | 六步汇报路线图(为什么做→…→预期结果) |
| P04 | harvey_balls_table | `templates/charts/harvey_balls_table.svg` | "Pick for qualitative scoring grid using 0-100% Harvey balls (vendor/skill assessment). Skip for binary checkmarks (use feature_matrix_table) or numeric values (use basic_table)." | 五候选×五维度星级评分(柑橘为首选) |
| P05 | kpi_cards | `templates/charts/kpi_cards.svg` | "Pick for 4-8 standalone numeric metrics shown as overview cards (2x2 or 1x4) — exec summary opener, dashboard headline, quarterly recap, results-at-a-glance. Skip if metrics have target baselines (use bullet_chart) or single hero number (use gauge_chart)." | 可量化核心目标卡(≤3s / mAP≥0.6 / ≥80% / ≥10张) |
| P06 | labeled_card | `templates/charts/labeled_card.svg` | "Pick for 3-4 parallel aspects of one subject with per-aspect titles + short body (self-introduction, four-pillar overview, capability quadrant). Skip for plain feature lists (use icon_grid), sequential steps (use numbered_steps), or strategic quadrants (use quadrant_text_bullets / matrix_2x2)." | 三类用户角色卡 + 底部使用旅程条 |
| P08 | concentric_circles | `templates/charts/concentric_circles.svg` | "Pick for 3-5 priority rings from core to periphery — bullseye/onion model, sphere of influence, stakeholder rings, core-to-ecosystem priority layers, target-vs-extended audience. Skip for non-prioritized layers (use pyramid_chart)." | 功能模块 P0/P1/P2 优先级同心圈(MVP 在内核) |
| P09 | process_flow | `templates/charts/process_flow.svg` | "Pick for 3-8 sequential steps connected by simple arrows — approval workflows, customer onboarding, request handling, lifecycle stages. Skip if cyclical (use circular_stages) or stages produce named outputs (use pipeline_with_stages)." | 端到端业务主流程(登录→上传→检测→展示) |
| P10 | vertical_pillars | `templates/charts/vertical_pillars.svg` | "Pick for 1×3 / 1×4 / 1×5 vertical column layout where each pillar = one independent category with title + bullets — PEST (Political/Economic/Social/Technological), four-pillar strategy overview, side-by-side independent categories. Skip for 2×2 quadrant (use quadrant_text_bullets), pricing tiers (use comparison_columns), or 2×2 parallel aspects (use labeled_card)." | 技术栈分层选型(前端/后端/算法/数据/训练)+ 理由 |
| P11 | layered_architecture | `templates/charts/layered_architecture.svg` | "Pick for 3-4 horizontal architecture layers (presentation/service/data), 2-4 module cards per layer, each card = title + 1-line description (description required, even if source brief). Skip if no per-module descriptions (use icon_grid) or no horizontal layering (use module_composition)." | 四层 B/S 系统架构(前端/后端/算法/数据) |
| P12 | pipeline_with_stages | `templates/charts/pipeline_with_stages.svg` | "Pick for 3-5 horizontal pipeline stages, each = title + 1-line description + output artifact, connected by arrows (data pipelines, ETL, build pipelines). Skip if any stage lacks an artifact (use process_flow or numbered_steps)." | 算法五步管线(预处理→分割→检测→特征→分级) |
| P14 | gantt_chart | `templates/charts/gantt_chart.svg` | "Pick for project schedule with 6-12 tasks, durations, and dependencies. Skip for simple milestones without duration (use timeline) or vertical roadmap (use roadmap_vertical)." | 4 周开发计划甘特图 + 里程碑 M1–M4 |
| P15 | team_roster | `templates/charts/team_roster.svg` | "Pick for 3-12 leadership/team profile cards (photo + name + title + short bio). Skip for reporting hierarchy (use top_down_tree)." | 4 人团队分工卡(角色+职责+承担评分模块) |
| P16 | basic_table | `templates/charts/basic_table.svg` | "Pick for plain tabular text/number grid, 3-8 columns. Skip if cells need visual bars (use consulting_table) or qualitative scores (use harvey_balls_table)." | 测试类型矩阵(类型/工具/重点)+ 验收清单 |
| P17 | icon_grid | `templates/charts/icon_grid.svg` | "Pick for 4-9 parallel features/capabilities/services as icon cards — feature grid, service lineup, benefits matrix, brand values, product highlights. Skip for sequential ordering (use numbered_steps) or hierarchical layers (use pyramid_chart)." | 4 个创新亮点卡 + 风险应对区 |
| P18 | vertical_list | `templates/charts/vertical_list.svg` | "Pick for 3-6 numbered key points each with a short description — design principles, core tenets, action items, key takeaways, recommendations, executive summary points. Skip for icon-style cards (use icon_grid) or sequential steps (use numbered_steps)." | 交付物清单 + 核心策略 + 致谢答疑 |

**Runners-up considered**:

- `pipeline_with_stages` | rejected for P09: 主业务流程(登录→上传→检测→展示)不强调每步"命名产出物",用 process_flow 的简单箭头更贴切;pipeline_with_stages 留给 P12 算法管线(每阶段有明确产出)。
- `project_schedule_table` | rejected for P14: 4 周计划含阶段依赖与时间跨度(关键路径),需横向条带表达 duration;project_schedule_table 仅适合"任务/负责人/状态"无跨度清单。
- `bullet_chart` | rejected for P05: 核心目标是阈值型概览数字(≤3s、mAP≥0.6、≥80%),作为概览卡更直观;bullet_chart 需"目标 vs 实际"双值,本阶段尚无实际值。
- `pyramid_chart` | rejected for P08: P0/P1/P2 是"核心→外围、由外向内可砍"的优先级圈层,concentric_circles 的同心环比金字塔分层更贴切。
- `client_server_flow` | rejected for P11: 系统架构是四层纵向分层(含文件/模型存储),layered_architecture 的横向分层卡更完整;client_server_flow 偏纯请求/响应二端视图。

> **无对应模板(自由手绘 UML)**:P07 需求用例图(actor + 用例椭圆 + 关系)、P13 数据库 E-R 图(实体矩形 + 1—N 连线 + 基数)。charts 目录无 UML use-case / ER 专用模板,Executor 自由绘制,不进入 `page_charts`。

---

## VIII. Image Resource List

**No images — 全 SVG 矢量绘制(图像策略 h = A)。**

本汇报核心可视化(架构图/流程图/甘特图/E-R 图/模块图/用例图/数据表)全部由 SVG 原生矢量 + 内置图标绘制,无位图依赖:矢量更清晰、可无限缩放、与配色完全统一、无版权风险,且当前 `IMAGE_BACKEND` 未配置。封面与氛围页用矢量几何构图(渐变 + 图标 + 色块)实现,不需要照片素材。故无图片资源列表,亦无 image-as-canvas(#38–#46)覆盖要求(整本无图片承载页)。

---

## IX. Content Outline

### Part 1 · 为什么做(Why)

#### Slide 01 - 封面
- **Layout**: 单列居中 + 矢量主视觉(breathing);青绿渐变 + 柑橘橙点缀 + leaf/eye-check 图标构成的"机器视觉检测柑橘"几何意象
- **Title**: 基于机器视觉的农产品品质分级与缺陷检测系统
- **Subtitle**: CitrusVision · 面向肇庆本地柑橘的品质分级与缺陷检测 Web 系统
- **Info**: 《软件工程课程设计》项目方案汇报 · 题目10 · [计科某班] · 第12组([组长]/[成员A]/[成员B]/[成员C])· 2026-06

#### Slide 02 - 汇报路线图
- **Layout**: 横向六段式路线(anchor)
- **Title**: 汇报路线图 · 六步讲清方案
- **Visualization**: agenda_list
- **Content**: 为什么做(背景+选题)/ 做什么(定位/用户/需求/功能)/ 怎么做(技术/架构/算法/流程/数据库)/ 怎么推进(计划/分工)/ 如何验证(测试/验收)/ 预期结果(创新/风险/交付)

#### Slide 03 - 项目背景与问题痛点
- **Layout**: 左右对比(dense)— 左"传统人工目检"痛点,右"机器视觉"对比
- **Title**: 项目背景与问题痛点
- **Content**: 肇庆(四会/德庆)柑橘重要产区;人工目检主观性强/标准不一/效率低;缺陷易漏检/溯源缺失;机会:客观、量化、可追溯;问题定义=一张照片秒级得到"等级+缺陷+量化依据"

### Part 2 · 做什么(What)

#### Slide 04 - 选题意义与"为什么是柑橘"
- **Layout**: 评分矩阵(dense)
- **Title**: 选题意义与"为什么是柑橘"
- **Visualization**: harvey_balls_table
- **Content**: 五候选(柑橘/苹果/香蕉/番茄/叶菜)×五维度(地方特色/缺陷维度/形态分割/分级直观/数据可得)星级;柑橘综合最优✅;紧扣题目示例第一位+肇庆地方特色

#### Slide 05 - 项目定位与核心目标
- **Layout**: 定位条 + KPI 卡网格(anchor)
- **Title**: 项目定位与核心目标
- **Visualization**: kpi_cards
- **Content**: 定位=教学演示+产地初分的工程完整 B/S 四层 Web 系统;目标 ≤3s 返回 / 缺陷 mAP@0.5≥0.60 / 分级一致率≥80% / 批量≥10张 / 含二维码报告 / UML 文档齐备

#### Slide 06 - 目标用户与使用场景
- **Layout**: 三角色卡 + 底部使用旅程(dense)
- **Title**: 目标用户与使用场景
- **Visualization**: labeled_card
- **Content**: 普通用户(分拣员/质检员)/ 管理员(维护标准价格模型)/ 间接(答辩评委);主场景=微信扫码 H5 拍照;旅程:登录→拍照/上传→看等级与缺陷→登记溯源→导出报告

#### Slide 07 - 需求分析(功能 + 非功能)
- **Layout**: 左用例图(自由 UML)+ 右需求分组(dense)
- **Title**: 需求分析:功能性 + 非功能性
- **Content**: 用例图(参与者:普通用户/管理员;用例:上传/检测/分级/溯源/导出/管理);14 项 FR 分组;性能(≤3s/批量≤30s/≥5并发);可用性;课设交付需求(UML+注释+视频≤50M)

#### Slide 08 - 功能模块设计与优先级
- **Layout**: 优先级同心圈(anchor)
- **Title**: 功能模块设计与优先级(MVP 先行)
- **Visualization**: concentric_circles
- **Content**: 内核 P0(登录/上传/预处理/缺陷检测/分级/可视化/入库/统计)/ 中圈 P1(溯源二维码/价格/导出/样本日志)/ 外圈 P2(模型切换/复核/多品类/热力图);取舍=先保闭环再加分

### Part 3 · 怎么做(How)

#### Slide 09 - 核心业务流程
- **Layout**: 横向流程 + 角色泳道提示(dense)
- **Title**: 核心业务流程:上传 → 检测结果输出
- **Visualization**: process_flow
- **Content**: 登录→上传→后端校验存图建任务→调算法服务 /infer→(预处理→分割→YOLOv8检测→特征→规则分级)→回写结果+关联价格溯源→前端渲染→导出;后端只编排不推理(解耦);辅助流程=管理员维护+操作日志

#### Slide 10 - 技术栈选型及理由
- **Layout**: 纵向分层柱(dense)
- **Title**: 技术栈选型及理由
- **Visualization**: vertical_pillars
- **Content**: 前端 Vue3+ECharts(出活快/图表好/一套响应式);后端 FastAPI(同语言集成/自带 Swagger 接口文档);算法服务 OpenCV+YOLOv8(独立服务/CPU可推理);数据库 MySQL8/SQLite(便于 E-R);训练 Colab/AI Studio 免费 GPU(规避无 GPU)

#### Slide 11 - 系统总体架构
- **Layout**: 四层横向架构(anchor)
- **Title**: 系统总体架构:四层 B/S 分离
- **Visualization**: layered_architecture
- **Content**: 前端层(Vue3 PC+H5)/ 后端 API 层(FastAPI 鉴权JWT/业务编排)/ 算法服务层(独立进程 /infer)/ 数据层(MySQL+文件+weights);HTTP/JSON 与内部 /infer 调用;分层依据=职责单一+4人并行+对应包图

#### Slide 12 - 核心算法方案(双引擎)
- **Layout**: 五步管线 + 量化指标 + 兜底分支(anchor)
- **Title**: 核心算法方案:双引擎 · 可解释 · 可兜底
- **Visualization**: pipeline_with_stages
- **Content**: 传统 CV(分级)+ YOLOv8(缺陷检测)双引擎;管线 预处理→果实分割→缺陷检测→特征计算→规则分级;三量化指标(果径/着色率/缺陷占比);规则评一/二/等外;DL 欠佳传统 CV 兜底

#### Slide 13 - 数据库与核心数据设计
- **Layout**: E-R 图(自由 UML)+ 核心表字段(dense)
- **Title**: 数据库与核心数据设计
- **Content**: MySQL8 共 10 表;核心实体 user/product_sample/detection_task/detection_result/defect_label;配置类 grade_standard/price_reference/traceability/model_info/operation_log;关系 task1-N result、result1-N defect、sample1-1 trace

### Part 4 · 怎么推进(Process)

#### Slide 14 - 项目实施计划与里程碑
- **Layout**: 甘特图 + 里程碑(dense)
- **Title**: 项目实施计划与里程碑(假设 4 周)
- **Visualization**: gantt_chart
- **Content**: W1 立项需求(M1)/ W2 设计原型(M2)/ W3 编码实现(M3 MVP)/ W4 联调测试交付(M4);关键路径=数据采集(W1启动)→训练(W3)→联调(W4);可压缩 3 周版

#### Slide 15 - 团队分工与协作机制
- **Layout**: 4 人分工卡 + 协作机制条(dense)
- **Title**: 团队分工与协作机制
- **Visualization**: team_roster
- **Content**: [组长](组长/PM+后端+架构)/ [成员A](算法负责人 YOLOv8)/ [成员B](算法副+数据工程+传统CV)/ [成员C](前端+测试+文档);机制=接口契约先行→Git分支并行→组长合并;算法配双人,组长担核心(协作30分)

### Part 5 · 如何验证(Verify)

#### Slide 16 - 测试方案与验收标准
- **Layout**: 左测试矩阵表 + 右验收清单(dense)
- **Title**: 测试方案与验收标准
- **Visualization**: basic_table
- **Content**: 测试矩阵(功能/接口Postman+pytest/算法mAP/系统联调/兼容);典型用例;验收=系统可运行+MVP闭环无致命bug+mAP≥0.6+一致率≥80%+加分功能可演示+文档齐全规范+按规范打包按时提交

### Part 6 · 预期结果(Result)

#### Slide 17 - 创新亮点与风险应对
- **Layout**: 上创新点卡网格 + 下风险应对(dense)
- **Title**: 创新亮点与风险应对
- **Visualization**: icon_grid
- **Content**: 创新①双引擎可解释分级 ②分级标准可配置+模板化 ③溯源二维码+价格联动 ④多品类可扩展;风险:数据不足(公开集打底)/模型不稳(传统CV兜底)/无GPU(免费云GPU)/现场故障(预录视频双保险)

#### Slide 18 - 预期成果 · 总结 · 答疑
- **Layout**: 交付清单 + 核心策略条 + 致谢(breathing)
- **Title**: 预期成果 · 总结 · 答疑
- **Visualization**: vertical_list
- **Content**: 交付物(报告含任务书+视频≤50M+源码含注释+源代码文档+数据库脚本+测试材料);文档与系统成果;核心策略=分析24+设计24吃满、算法能演示有兜底;命名 第12组-《题目名》;谢谢聆听·欢迎提问

---

## X. Speaker Notes Requirements

- **Filename**: 与 SVG 同名(`01_cover.svg` → `notes/01_cover.md`);主文档 `notes/total.md` 用 `#` 标题分页
- **Total duration**: 约 10–12 分钟(18 页,平均每页 30–45 秒;P11/P12 架构与算法可适当多讲)
- **Notes style**: 正式但自然口语(formal-conversational),适合学生上台照讲
- **Purpose**: 汇报 + 说服(report + persuade)—— 体现"我们组已思考过且具备落地方案"

---

## XI. Technical Constraints Reminder

### SVG Generation Must Follow:
1. viewBox: `0 0 1280 720`
2. 背景用 `<rect>` 元素
3. 文本换行用 `<tspan>`(禁止 `<foreignObject>`)
4. 透明度用 `fill-opacity` / `stroke-opacity`;禁止 `rgba()`
5. 禁止:`mask`、`<style>`、`class`、`foreignObject`、`textPath`、`animate*`、`script`、`@font-face`
6. 文本符号用原生 Unicode(`—`、`→`、`≤`、`≥`、`%`);禁止 HTML 实体(`&nbsp;`/`&mdash;`);XML 保留字转义 `&amp; &lt; &gt;`(如 `R&amp;D`、`占比 &lt; 2%`)
7. `marker-end` 箭头:`<marker>` 须在 `<defs>`,`orient="auto"`,形状为三角/菱形/圆
8. `clipPath` 仅可用于 `<image>`(本项目无图片,基本不用)

### PPT Compatibility Rules:
- 禁止 `<g opacity="...">`(组透明度);在每个子元素单独设置
- 仅内联样式;禁止外部 CSS 与 `@font-face`
- 图标用 `<use data-icon="tabler-outline/...">` 占位,stroke-width=2
