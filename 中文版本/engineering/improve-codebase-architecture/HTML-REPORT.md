# HTML 报告格式

架构评审会渲染为操作系统临时目录中的一个自包含 HTML 文件。Tailwind 和 Mermaid 都来自 CDN。Mermaid 能可靠地处理图状图表；手工绘制的 div 和内联 SVG 则用于更具编辑风格的视觉效果：体量图（面积对比图）、剖面图。两者混用：不要把所有东西都交给 Mermaid，否则会显得千篇一律。

## 脚手架

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>{{repo name}} 的架构评审</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* 一个小型的自定义层，用于 Tailwind 无法干净覆盖的内容：
         虚线接缝、略带手绘感的箭头头部等 */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## 页眉

仓库名称、日期，以及一个紧凑的图例：实线框 = 模块，虚线 = 接缝，红色箭头 = 泄漏，深色粗框 = 深层模块。不需要引言段落。直接进入候选项。

## 候选项卡片

图表承担主要分量。文字稀少、朴素，并且直接使用（来自 `/codebase-design` skill 的）术语表词汇，不加修饰。

每个候选项是一个 `<article>`：

- **标题**：简短，点明深化内容（例如"合并 Order 接收流水线"）。
- **徽章行**：推荐强度（`Strong` = 翡翠绿，`Worth exploring` = 琥珀色，`Speculative` = 石板灰），外加依赖类别的标签（`in-process`、`local-substitutable`、`ports & adapters`、`mock`）。
- **文件**：等宽字体列表，`font-mono text-sm`。
- **前后对比图**：核心部分。两列，并排。参见下面的模式。
- **问题**：一句话。什么地方在痛。
- **方案**：一句话。什么会改变。
- **收益**：要点，每条不超过 6 个词。例如"测试只命中一个接口"、"定价逻辑不再泄漏"、"删掉 4 个浅层包装器"。
- **ADR 提示框**（如适用）：琥珀色底的一行提示框。

没有大段的解释。如果图表需要一段文字才能理解，就重画图表。

## 图表模式

选择与候选项相匹配的模式。混合使用。不要让每张图都长得一样。多样性本身就是重点。

### Mermaid 图（依赖关系 / 调用流的主力）

当重点是"X 调用 Y，Y 调用 Z，看看这团乱麻"时，使用 Mermaid 的 `flowchart` 或 `graph`。把它包进一个 Tailwind 样式的卡片中，使它不显得突兀。用 classDef 为泄漏的边着红色，把深层模块涂成深色。时序图适合表达"之前：6 次往返；之后：1 次"。

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### 手工绘制的方框与箭头（当 Mermaid 的布局与你作对时）

模块是带边框和标签的 `<div>`。箭头是绝对定位在相对定位容器之上的内联 SVG `<line>` 或 `<path>` 元素。当你希望"之后"的图看起来像一个粗边框的深层模块、内部元素灰掉时使用这种方式，因为 Mermaid 无法以正确的粗细渲染它。

### 剖面图（适合表现分层的浅层性）

堆叠水平色带（`h-12 border-l-4`），展示一次调用经过的各层。之前：6 个薄层，每层什么也不做。之后：1 个粗色带，标注合并后的职责。

### 体量图（面积对比图）：适合表现"接口与实现一样宽"

每个模块两个矩形：一个代表接口表面积，一个代表实现。之前：接口矩形几乎与实现矩形一样高（浅层）。之后：接口矩形很矮，实现矩形很高（深层）。

### 调用图折叠

之前：以嵌套方框呈现的函数调用树。之后：同一棵树折叠为一个方框，现已变为内部的调用以淡化的形式显示在其中。

## 风格指南

- 偏编辑风格，而非企业仪表盘。留白充足。标题可选用衬线体（`font-serif` 与 stone/slate 搭配很好）。
- 色彩节制：一种强调色（翡翠绿或靛蓝），加上表示泄漏的红色和表示警告的琥珀色。
- 图表高度约 320px，使前后对比可以并排舒适地放置，无需滚动。
- 图表内的模块标签使用 `text-xs uppercase tracking-wider`，使其读起来像示意图，而不是界面 UI。
- 唯一的脚本是 Tailwind CDN 和 Mermaid 的 ESM 导入。报告其余部分是静态的：没有应用代码，除了 Mermaid 自身的渲染之外没有交互。

## 首要推荐部分

一张更大的卡片。候选项名称，一句话说明原因，以及指向其卡片的锚点链接。仅此而已。

## 语气

平实的英语（此处为中文），简洁，但架构名词和动词直接取自 `/codebase-design` skill。简洁不是漂移的借口。

**必须准确使用：** module（模块）、interface（接口）、implementation（实现）、depth（深度）、deep（深）、shallow（浅）、seam（接缝）、adapter（适配器）、leverage（杠杆）、locality（局部性）。

**绝不替换：** component、service、unit（用于代替 module）· API、signature（用于代替 interface）· boundary（用于代替 seam）· layer、wrapper（用于代替 module，当你指的就是 module 时）。

**符合风格的措辞：**

- "订单接收模块很浅：接口几乎与实现一样复杂。"
- "定价逻辑泄漏过了接缝。"
- "深化：一个接口，一个测试的地方。"
- "两个适配器证明了这个接缝的必要性：生产环境用 HTTP，测试中用内存实现。"

**收益要点**用术语表中的词来说明收益："局部性：bug 集中在一个模块中"、"杠杆：一个接口，N 个调用点"、"接口缩小；实现吸收了包装器"。不要写"更容易维护"或"代码更干净"，因为这些词不在术语表中，也不值得占一席之地。

不要含糊其辞，不要清嗓子式的铺垫，不要"值得注意的是……"。如果一句话可以写成要点，就写成要点。如果一个要点可以删掉，就删掉。如果一个术语不在 `/codebase-design` 术语表中，在发明新词之前，先找一个已有的词。
