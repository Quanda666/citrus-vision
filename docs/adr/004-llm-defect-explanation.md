# ADR-004：引入多模态大模型增强缺陷解释能力

- **状态（Status）**：已接受（Accepted）
- **日期**：2026-06-23
- **决策者**：第 12 组（技术负责人 陈绍杰、算法负责人 黄权达）

## 背景（Context）

当前系统输出检测结果（等级 / 缺陷类型 / 置信度 / 量化指标），但存在以下用户体验问题：

- **可理解性不足**：新手质检员看到"病斑 0.82"不知道严重程度、成因、是否影响销售
- **教育价值缺失**：系统只做判断不做解释，用户学不到品质知识
- **决策支持弱**：仅给等级和数字，缺少"为什么是二级""如何处理"的指导

用户实际需求："这个橘子为什么是二级？那个黑点严不严重？能放多久？"——典型的**多模态理解 + 领域知识生成**任务，正是大模型擅长的。

## 决策（Decision）

在检测结果详情页增加**"智能解释"功能**，调用多模态大模型（Qwen-VL / GPT-4V / Claude 3.5 Sonnet）生成通俗易懂的文字说明：

### 技术方案

- **接口标准**：采用 **OpenAI 兼容接口**（`/v1/chat/completions`），一套代码适配所有兼容厂商
- **推荐模型**：
  - **云端**：阿里通义千问 **Qwen-VL-Max**（中文强、多模态、有免费额度、兼容接口）
  - **本地兜底**：Ollama + **qwen2.5-vl:7b** 或 **llava:13b**（离线可演示，零成本）
- **输入**：标注图（base64）+ 检测结果 JSON（等级 / 缺陷列表 / 量化指标）
- **输出**：200~300 字的中文解释，包含缺陷成因、严重程度、分级依据、储存建议

### 实现架构

```python
# 后端新增 LLMClient（OpenAI 兼容）
class LLMClient:
    def __init__(self, base_url, api_key, model):
        self.client = OpenAI(base_url=base_url, api_key=api_key)
        self.model = model
    
    def explain_defects(self, image_b64: str, result: DetectionResult) -> str:
        prompt = f"""你是柑橘品质专家。根据图片和检测结果，用通俗语言解释：
1. 各缺陷的类型、严重程度与可能成因
2. 为什么被判定为该等级
3. 储存与销售建议

检测结果：
- 等级：{result.grade}
- 果径：{result.diameter_mm}mm
- 着色率：{result.color_ratio}%
- 缺陷占比：{result.defect_ratio}%
- 缺陷列表：{[{d.type: d.confidence} for d in result.defects]}

限200-300字，面向果农和质检员。"""
        
        resp = self.client.chat.completions.create(
            model=self.model,
            messages=[{
                "role": "user",
                "content": [
                    {"type": "text", "text": prompt},
                    {"type": "image_url", 
                     "image_url": {"url": f"data:image/jpeg;base64,{image_b64}"}}
                ]
            }],
            timeout=15
        )
        return resp.choices[0].message.content

# 新增接口
@router.get("/results/{id}/explain")
async def explain_result(id: int, llm: LLMClient = Depends(get_llm_client)):
    result = get_result(id)
    image_b64 = load_annotated_image_as_b64(result.annotated_path)
    explanation = await asyncio.to_thread(llm.explain_defects, image_b64, result)
    return {"explanation": explanation}
```

### 配置（.env）

```bash
# LLM 增强功能（可选，默认禁用）
LLM_ENABLED=true
LLM_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1  # 云端
# LLM_BASE_URL=http://localhost:11434/v1                         # 本地 Ollama
LLM_API_KEY=sk-xxx
LLM_MODEL=qwen-vl-max              # 云端：qwen-vl-max，本地：qwen2.5-vl
LLM_TIMEOUT=15
LLM_FALLBACK_MESSAGE="智能解释服务暂时不可用"
```

### 用户体验

- 结果详情页增加"智能解释"按钮（异步加载，不阻塞主结果显示）
- 云端响应约 3~8 秒，本地 Ollama 约 5~15 秒，显示加载动画
- 失败时回退到默认文本："系统已完成检测，详细指标见上方数据卡"

## 后果（Consequences）

**正面**：
- **可理解性大幅提升**：用户从"看数字"变为"读解释"，尤其对新手友好
- **教育价值**：每次检测都是一次学习，长期使用后用户能理解品质标准
- **技术亮点**：课设答辩时可展示"AI 大模型增强"，区别于纯 CV 项目
- **厂商中立**：OpenAI 兼容接口让切换模型零成本（Qwen / GPT / Claude / Ollama）
- **演示保险**：本地 Ollama 兜底，答辩现场网络断了也能演示

**负面 / 代价**：
- **成本**：云端 API 按 token 计费（Qwen-VL-Max 约 ¥0.01/次），演示 50 次约 ¥0.5，可接受；本地 Ollama 需额外下载 4~7GB 模型
- **响应延迟**：3~15 秒，需异步处理 + 加载动画
- **依赖外部服务**：云端模式需联网，可能限流或超时
- **复杂度略增**：新增 `LLMClient` 模块与配置项

**风险与应对**：
- LLM 输出不可控（偶尔胡言）→ Prompt 工程约束输出格式 + 后验校验长度
- 云端限流或欠费 → 优雅降级到预设文本，不影响核心检测
- 答辩现场网络差 → 提前切换到本地 Ollama 模式

**关联**：与 [ADR-001] 双引擎方案呼应——传统 CV 保底 + YOLOv8 检测 + LLM 解释，三层增强。

---

**实施优先级**：P1（加分项），在 MVP 闭环（检测 + 结果展示）完成后实现，约需 1~2 天（后端接口 + 前端按钮 + Prompt 调优）。
