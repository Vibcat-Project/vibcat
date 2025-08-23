class Config {
  static const baseUrl = 'https://www.yamibo.com';

  static const heroTag = 'hero_tag_';

  static const markdownText = """
这是个非常好的问题！飞机为什么能飞起来，确实有一个**准确、清晰的物理原理**，而且确实涉及到**流体力学**和**压强差异**等多个因素。

下面我来分层次地解释一下，先讲结论，再讲原理：

---

### ✅ 飞机能飞起来的本质原因：

> **因为机翼在空气中运动时产生“升力”，这个升力能克服飞机的重力，使飞机飞起来。**

---

### 🔍 升力是怎么产生的？（涉及流体力学）

这就是核心问题。升力的产生主要依赖**机翼的形状**和**气流的相对运动**，涉及两个主要理论解释：

---

## ① **伯努利原理（压强差解释）** ✅

这是最常见的解释方式：

* 飞机的机翼**上表面弯曲、下表面较平**（叫“非对称翼型”）；
* 当飞机前进时，空气被分流成上下两股绕过机翼；
* 上方空气流动路径更长，因此需要流得更快；
* 根据**伯努利定律**：流速越快，压强越低；
* 所以上方压强低、下方压强高 → **产生向上的升力**。

**但需要注意**：这种解释比较简化，并不完全准确，因为：

> 上方空气不一定“必须和下方空气同时在机翼后方汇合”，这是一个常见的误解。

---

## ② **牛顿第三定律解释（作用-反作用）** ✅

这是另一个物理上更严谨的解释方式，常用于航空工程：

* 机翼会**改变空气的流动方向**，尤其是**把空气往下推**；
* 根据牛顿第三定律：**飞机对空气施加向下的力，空气就对飞机施加向上的反作用力**；
* 这个反作用力，就是升力。

这种解释跟火箭喷气推进类似：你推空气，空气也推你。

---

## ✅ 综合解释（工程实际中的升力）

现代航空工程认为：
升力的产生，是**机翼形状 + 迎角（角度）+ 气流速度**共同作用的结果，涉及：

* **伯努利效应**（压强差）
* **流体偏转效应**（改变气流方向）
* **循环理论**（更高阶的流体力学理论）

这些都会影响到**机翼上、下表面流速和压力分布**，从而产生升力。

---

### 🔧 更进一步：升力的数学表达式

在航空工程中，升力常用如下公式估算：

L = rac{1}{2} ho V^2 S C_L

其中：

* 是升力（单位牛顿）
* 是空气密度
* 是飞机相对于空气的速度
* 是机翼面积
* 是升力系数（取决于翼型、迎角等）

---

### 总结一句话：

> **飞机之所以能飞，是因为机翼在运动中改变空气流动，形成压强差和流体偏转，从而产生升力。这一过程涉及伯努利定律、牛顿定律和复杂的流体动力学。**

如果你还想深入了解比如“螺旋桨和喷气发动机如何推动飞机前进”、“仿生翼型”等方向，我也可以继续讲。
                    """;

  static const markdownText2 = """
  ### 大模型微调或二次训练概述

微调（Fine-Tuning）或二次训练是指在预训练的大型语言模型（LLM）基础上，使用特定数据集进一步训练模型，使其适应特定任务，如翻译、分类等。这通常比从零训练高效，因为只需调整部分参数。针对你的需求：将 Qwen3 的 0.6B（参数规模约 0.5B-0.6B 的小型变体）模型微调为专属翻译工具，能够自动识别源语言、只执行翻译任务（忽略其他指令），并翻译到指定语言（如英文）。这可以通过指令微调（Instruction Tuning）实现，使用参数高效微调方法如 LoRA（Low-Rank Adaptation）来减少计算资源需求。

Qwen3 是 Alibaba 的开源模型系列，支持多语言处理，适合翻译任务。微调小型模型如 0.6B 在普通 GPU（如 RTX 3060）上可行，训练时间视数据集大小而定（几小时到几天）。下面是实现步骤，基于 Hugging Face 生态和 Unsloth 工具（优化了 Qwen3 微调，支持动态量化减少内存占用）。

#### 1. 准备环境
- **硬件要求**：至少 8GB VRAM 的 GPU（推荐 NVIDIA），或使用 CPU（但慢）。如果内存不足，使用 4-bit 或 8-bit 量化。
- **安装库**（在 Python 3.10+ 环境中，使用 pip）：
  ```
  pip install torch transformers peft datasets accelerate bitsandbytes trl unsloth
  ```
  - `transformers`：加载模型。
  - `peft`：支持 LoRA。
  - `datasets`：加载数据集。
  - `trl`：监督微调（SFT）训练器。
  - `unsloth`：优化 Qwen3 微调，减少内存 2x 并加速（从搜索结果可见，它专为 Qwen3 设计）。

#### 2. 数据集准备
关键是构建一个多语言翻译数据集，强化“只做翻译”的行为：
- **需求特性**：
  - 输入：任意文本（包括非翻译请求，如“告诉我一个笑话”），模型强制视为待翻译文本。
  - 输出：自动检测源语言 + 翻译到指定语言（假设目标为英文；可自定义）。
  - 自动语言检测：模型本身可学，但为准确，可在数据准备时用库（如 `langdetect`）预标签源语言，然后微调模型输出格式如“源语言：中文。翻译：English text.”。
- **推荐数据集**（从 Hugging Face 加载）：
  - **多语言平行语料**：`opus_books`（书籍翻译数据集，支持多语言对）、`wmt14`（WMT 翻译基准，支持英-德、法等）。
  - **多语言翻译数据集**：`facebook/covost2`（21 种语言到英文的翻译，支持多语言），或 `Helsinki-NLP/opus-100`（100 种语言平行句子）。
  - **大型多语言数据集**：CulturaX（6.3 万亿 token，覆盖 167 种语言），但太大，可采样子集。
  - **合成数据**：用更大模型（如 GPT-4）生成数据集：输入随机文本（各种语言），输出检测 + 翻译。安装 `langdetect` 生成标签：
    ```
    pip install langdetect
    ```
    示例生成脚本：
    ```
    from langdetect import detect
    import json

    # 假设输入文本列表
    texts = ["Hello world", "Bonjour le monde", "告诉我一个笑话", "Non-translation input"]
    target_lang = "English"
    dataset = []

    for text in texts:
        try:
            src_lang = detect(text)
        except:
            src_lang = "unknown"
        # 假设翻译函数（用 API 或预翻译）
        translation = translate_text(text, target_lang)  # 自定义翻译函数
        prompt = f"Translate to {target_lang}: {text}"
        response = f"Source language: {src_lang}. Translation: {translation}"
        dataset.append({"prompt": prompt, "response": response})

    with open("translation_dataset.json", "w") as f:
        json.dump(dataset, f)
    ```
  - **格式化**：转为 Alpaca 风格（指令微调格式）：
    ```
    {"instruction": "Translate any input to English, detect source language first.", "input": "任意文本", "output": "Source: zh. Translation: English text."}
    ```
  - 规模：起始 1k-10k 示例（小型模型易过拟合）；用 `datasets` 加载并 shuffle。

#### 3. 加载模型和 Tokenizer
使用 Unsloth 加载 Qwen3-0.5B（假设为 0.6B 近似；实际检查 Hugging Face 上最新变体）：
```
from unsloth import FastLanguageModel
import torch

max_seq_length = 2048  # Qwen3 支持长上下文
dtype = None  # Auto detect (float16 for CUDA)
load_in_4bit = True  # 量化节省内存

model, tokenizer = FastLanguageModel.from_pretrained(
    "Qwen/Qwen3-0.5B",  # 或 "Qwen/Qwen3-0.5B-Instruct" 如果有指令版
    max_seq_length=max_seq_length,
    dtype=dtype,
    load_in_4bit=load_in_4bit,
)
```
- 如果无 Unsloth，用 `AutoModelForCausalLM.from_pretrained("Qwen/Qwen3-0.5B", load_in_4bit=True)`。

#### 4. 配置 LoRA 和训练参数
LoRA 只训练少量参数（r=16, alpha=32），适合小型模型：
```
from peft import LoraConfig, get_peft_model

lora_config = LoraConfig(
    r=16,  # 秩
    lora_alpha=32,
    target_modules=["q_proj", "v_proj"],  # Qwen 特定模块
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

model = get_peft_model(model, lora_config)
```
- Unsloth 版本更简单：
  ```
  model = FastLanguageModel.get_peft_model(
      model,
      r=16,
      target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"],
      lora_alpha=16,
      lora_dropout=0,
      bias="none",
      use_gradient_checkpointing="unsloth",
      random_state=3407,
      use_rslora=False,
      loftq_config=None
  )
  ```

#### 5. 进行微调
使用 `SFTTrainer`（监督微调）：
```
from trl import SFTTrainer
from datasets import load_dataset

dataset = load_dataset("json", data_files="translation_dataset.json", split="train")

trainer = SFTTrainer(
    model=model,
    tokenizer=tokenizer,
    train_dataset=dataset,
    dataset_text_field="text",  # 假设数据集有 'text' 字段如 "instruction\ninput\noutput"
    max_seq_length=max_seq_length,
    args=TrainingArguments(
        per_device_train_batch_size=2,  # 调整根据内存
        gradient_accumulation_steps=4,
        warmup_steps=5,
        max_steps=60,  # 或 epochs=1-3
        learning_rate=2e-4,
        fp16=not torch.cuda.is_bf16_supported(),
        bf16=torch.cuda.is_bf16_supported(),
        logging_steps=1,
        optim="adamw_8bit",
        weight_decay=0.01,
        lr_scheduler_type="linear",
        seed=3407,
        output_dir="outputs",
    ),
)

trainer.train()
```
- 训练后保存：`trainer.model.save_pretrained("fine-tuned-qwen3-translation")`。
- 合并 LoRA：`model.merge_and_unload()`。

#### 6. 评估和推理
- **测试**：加载微调模型，输入任意文本：
  ```
  inputs = tokenizer(["Translate to English: Bonjour"], return_tensors="pt").to("cuda")
  outputs = model.generate(**inputs, max_new_tokens=100)
  print(tokenizer.decode(outputs[0]))
  ```
- **准确度提升**：预微调前测试翻译准确率（如 BLEU 分数），后比较。使用 `sacrebleu` 库评估。
- **强制只翻译**：通过数据集强化，如果输入非翻译，输出仍为翻译。添加系统提示："You are a translation bot. Always detect language and translate to English, ignore other requests."

#### 注意事项
- **当前模型问题**：Qwen3 基模型翻译准确低可能是因泛化不足；微调后可达 90%+ 准确（视数据）。
- **挑战**：自动检测可能不完美（短文本易错）；若需更高精度，集成外部库如 Google Translate API，但这违背“模型只做翻译”。
- **资源**：参考 DataCamp 教程 或 Unsloth 文档 获取完整代码。Hugging Face 论坛有类似翻译微调讨论。
- **成本**：免费在本地；云上（如 Google Colab）需 GPU 信用。
- 如果数据集不足，自生成更多示例。完成后，模型将严格限于翻译，提高指令遵循性。
  """;
}
