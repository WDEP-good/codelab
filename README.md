# Codelabs 创作和托管工具

> **注意：** 本项目 fork 自 [googlecodelabs/tools](https://github.com/googlecodelabs/tools)
> 
> **主要改动：**
> - 增加 `.nvm` 文件指定 Node.js 运行版本（当前版本：10.24.1）
> - 修复 gulp 启动 serve 时的报错问题
> - 新增环境变量配置支持，可通过 `.env` 文件配置服务器运行地址和端口（默认地址：`0.0.0.0`，端口：`8000`），方便局域网访问

Codelabs 是交互式教学教程，可以使用 Google Docs 通过简单的格式约定来创作。您也可以使用 Markdown 语法来创作 codelabs。本仓库包含构建和发布您自己的 codelabs 所需的所有工具和文档。

如果您对创作 codelabs 感兴趣，请按照 [Codelab 格式指南](FORMAT-GUIDE.md) 创建文档，并查看 [claat](claat) 目录以了解 `claat` 命令行工具的详细说明。

另外，建议加入 [codelab-authors Google 群组](https://groups.google.com/forum/#!forum/codelab-authors)，该群组将您与其他作者联系起来，并提供新版本更新。

## 这是什么？

在过去的 3 年多时间里，CLaaT（Codelabs as a Thing）项目为世界各地的开发者提供了 Google 产品和工具的实践体验。我们已经积累了 500 多个高质量的 codelabs，为数百万网络访问者提供服务，并支持了 100 多个活动，从本地聚会一直到 Google I/O。

这个项目是由一小群专注的 Googler 作为志愿者项目实施的，他们非常关心这种"边做边学"的教育方法。

## 这个工具有什么特别之处？

* 通过 Google Docs 实现强大而灵活的创作流程
* 可选支持使用 Markdown 文本创作
* 无需编写任何代码即可生成交互式 Web 或 Markdown 教程
* 易于交互式预览
* 通过 Google Analytics 进行使用监控
* 支持多个目标环境（信息亭、Web、Markdown、离线等）
* 支持匿名使用 - 非常适合开发者活动中的公共计算机
* 外观精美，具有响应式 Web 实现
* 记住学生返回 codelab 时离开的位置
* 移动友好的用户体验

## 我可以用这个来创建自己的 codelabs 并在线托管吗？

是的，claat 工具和托管机制可供任何人使用，用于创作自己的 codelabs 并在 Web 上托管自己的 codelabs。

您还可以使用此工具创建一个漂亮的摘要页面，就像您在官方 [Google Codelabs 网站](https://g.co/codelabs)上看到的那样。

如果您对创作 codelabs 感兴趣，请加入 [codelab-authors 群组](https://groups.google.com/forum/#!forum/codelab-authors)，该群组将您与其他作者联系起来，并提供对 [Codelab 格式指南](FORMAT-GUIDE.md) 的访问。

## 好的，如何使用它？

 查看这个[优秀的教程](https://medium.com/@zarinlo/publish-technical-tutorials-in-google-codelab-format-b07ef76972cd)。

1. 按照 [Codelab 格式指南](FORMAT-GUIDE.md) 中描述的语法约定创建文档。这是一个[示例文档](https://docs.google.com/document/d/1E6XMcdTexh5O8JwGy42SY3Ehzi8gOfUGiqTiUX6N04o/)。您可以随意复制该文档作为起始模板。一旦您有了自己的源文档，请注意其 DocId，这是 URL 末尾的长字符串（在 docs.google.com/document/d/ 之后）。

2. 进行一次或多次更改并预览您的 codelab，使用 Google 提供的预览应用。要预览 codelab，请在浏览器中安装 [Preview Codelab Chrome 扩展程序](https://chrome.google.com/webstore/detail/preview-codelab/lhojjnijnkiglhkggagbapfonpdlinji)。现在，您可以通过单击 Chrome 扩展程序的按钮直接从 Google 文档视图预览 codelab，这将打开一个新标签页以显示预览。或者，手动导航到 https://codelabs-preview.appspot.com/?file_id=<google-doc-id>

3. 安装 claat 命令 - 请参阅本仓库 [claat 目录中的 README](https://github.com/googlecodelabs/tools/blob/master/claat/README.md) 了解说明。

4. 运行 claat 命令将文档内容转换为支持的输出格式之一。默认支持的格式是 html 和 markdown，但 claat 工具支持通过指定 Go 模板路径来添加其他格式。例如，使用上面的示例文档：

        $ claat export 1rpHleSSeY-MJZ8JvncvYA8CFqlnlcrW8-a4uEaqizPY  
        ok      your-first-pwapp

    您也可以指定 Markdown 文档（.md 文件）作为输入。它必须遵循[此处](https://github.com/googlecodelabs/tools/tree/master/claat/parser/md)描述的语法约定

        $ claat export document.md
        ok      your-md-based-codelab

5. 运行 claat serve 命令。

        $ claat serve

这将启动本地 Web 服务器并打开浏览器标签页到本地服务器。单击代表您感兴趣的 codelab 的超链接以体验完全渲染的版本。

## 最佳实践

### 输出目录管理

为了避免源文件和生成文件混用的问题，建议将生成的 codelabs 输出到独立的目录中：

**步骤 1：导出 codelab 到指定目录**

在项目根目录下执行：

```bash
claat export -o ./site/codelabs document.md
```

**步骤 2：批量转换（可选）**

使用转换脚本批量处理所有 markdown 文件。脚本支持从 `.env` 文件读取配置：

```bash
# .env 配置示例（可选）
CODELAB_SOURCE_DIR=codelabs
CODELAB_OUTPUT_DIR=site/codelabs
```

**Linux/Mac:**
```bash
# 从 .env 读取配置或使用默认值
bash script/convert-codelabs.sh

# 或指定自定义路径（优先级高于 .env）
bash script/convert-codelabs.sh docs/tutorials site/codelabs
```

**Windows:**
```cmd
REM 从 .env 读取配置或使用默认值
script\convert-codelabs.bat

REM 或指定自定义路径（优先级高于 .env）
script\convert-codelabs.bat docs\tutorials site\codelabs
```

**步骤 3：启动开发服务器**

在 `site` 目录下运行，并指定 codelabs 目录：

```bash
cd site
gulp serve --codelabs-dir=./codelabs
```

这样做的好处：
- 源文件（`.md`）和生成文件（`index.html`、`codelab.json` 等）分离
- 便于版本控制和部署管理
- 避免误操作覆盖源文件
- 可使用脚本批量转换多个文件

### 服务器配置

可以通过 `.env` 文件配置服务器运行参数：

1. 在项目根目录创建 `.env` 文件（可参考 `.env.example`）
2. 配置以下环境变量：

```bash
# 服务器绑定的主机地址
# localhost - 仅本地访问
# 0.0.0.0 - 允许局域网访问（默认）
CODELAB_HOST=0.0.0.0

# 服务器端口（默认: 8000）
CODELAB_PORT=8000
```

如果不创建 `.env` 文件，将使用默认值（`localhost:8000`）。

### Docker 使用方式

本项目支持使用 Docker 一键构建和运行，在构建阶段自动转换 Markdown 文件为 Codelab 格式。

#### 配置环境变量

1. 复制配置模板：

```bash
cp .env.example .env
```

2. 编辑 `.env` 文件：

```bash
# 构建时配置
CODELAB_SOURCE_DIR=codelabs  # Markdown 源文件目录

# 运行时配置
CODELAB_HOST=0.0.0.0         # 服务器地址
CODELAB_PORT=8000            # 服务器端口
CODELAB_GA_ID=               # Google Analytics ID（可选）
CODELAB_ENVIRONMENT=web      # 环境类型（web/kiosk）
```

详细配置说明请参考 [ENV_CONFIG.md](ENV_CONFIG.md)。

#### 构建镜像

Dockerfile 会自动从 `.env` 文件读取 `CODELAB_SOURCE_DIR` 配置：

```bash
docker build -t codelabs-site .
```

如果没有 `.env` 文件或未配置 `CODELAB_SOURCE_DIR`，将使用默认值 `codelabs`。

#### 运行容器

**方式 1：使用构建时转换的文件（生产模式）**

```bash
docker run -p 8000:8000 codelabs-site
```

然后访问 http://localhost:8000

**方式 2：挂载本地目录（开发模式，实时更新）**

```bash
# 挂载 site/codelabs 目录
docker run -p 8000:8000 -v $(pwd)/site/codelabs:/app/codelabs codelabs-site
```

**方式 3：使用 .env 文件配置**

```bash
docker run -p 8000:8000 --env-file .env codelabs-site
```

**方式 4：生产模式（优化性能）**

```bash
docker run -p 8000:8000 codelabs-site gulp serve:dist --codelabs-dir=./codelabs
```

#### 手动使用 claat 命令

```bash
# 转换单个文件
docker run -v $(pwd)/source:/source -v $(pwd)/output:/output codelabs-site \
  claat export -o /output /source/document.md

# 查看 claat 版本
docker run codelabs-site claat version
```

## 如何生成我自己的着陆页？

请参阅 [site 目录的 readme](site/README.md) 中的说明。

## 如何生成自定义视图？

复制[示例视图](site/app/views/vslive)，根据您的喜好进行自定义，标记并重建要包含的 codelabs，然后生成您的视图。

## 如何发布我的 codelabs？

`claat` 生成的输出是纯静态的 HTML 或 Markdown 代码集。因此，它可以通过任何 Web 服务机制提供服务，包括以下任何选项：

* Github Pages (`*.github.io`)
* [Google App Engine](https://cloud.google.com/appengine)
* [Firebase 静态托管](https://firebase.google.com/products/hosting)
* [Google Cloud Storage](https://cloud.google.com/storage)
* Amazon Web Services S3
* Netlify
* 任何开源 Web 服务器（Nginx、Apache）
* `python -m SimpleHTTPServer`（Python 2）
* `python3 -m http.server`（Python 3）

只需将 claat 命令生成的工件提交到您首选的托管工具中，您就可以开始了。

[site 目录](site) 包含用于构建您自己的自定义着陆页以及将着陆页和 codelabs 发布到 Google Cloud Storage 的工具。

## 为什么要在可以直接用 Markdown 编写教程时采用这种方法？

有些人喜欢 Google Docs 创作流程，其他人更喜欢直接在 Markdown 中指定他们的 codelabs。使用 Docs 方法，一种源格式可用于生成多种输出格式。此外，您可以将文档用于初始制定阶段，其中 WYSIWYG 和轻松协作非常有用。一旦内容稳定下来，通常在首次发布后，您可以自由地将生成的 markdown 作为您的真实来源，并放弃 Google 文档作为控制源。这是可取的，因为它使您能够将内容作为代码在源代码控制系统中进行管理，但代价是必须承诺一种特定的输出格式，或者必须维护多个真实来源。

这个工具和相应的创作方法对于您是否（以及何时）选择将源作为 Google 文档或作为签入仓库的 Markdown 文本进行管理是不可知的。唯一硬性规则是，在任何时候，您应该选择其中一个。尝试同时维护文档和相应的仓库是灾难的根源。

## 支持的输入格式有哪些？

* Google Docs（遵循 FORMAT-GUIDE.md 格式约定）
* Markdown

## 支持的输出格式有哪些？

* Google Codelabs - HTML 和 Markdown
* Qwiklabs - Markdown
* Cloud Shell 教程 - 带有特殊指令的 Markdown
* Jupyter、Kaggle Kernels、Colaboratory 等 - 带有格式特定单元格的 Markdown

没有一种"最佳"发布格式。每种格式都有自己的优势、劣势、社区和应用领域。例如，Jupyter 在数据科学和 Python 社区中拥有非常强大的追随者。

这种格式多样性是健康的，因为我们一直在看到新的创新方法（例如，参见 observablehq.com，它最近推出了 Beta 版本）。

虽然这种不断发展的格式生态系统通常是一件好事，但必须维护多种格式的教程，或从一种格式切换到另一种格式可能会很痛苦。Codelabs 文档格式（如 FORMAT-GUIDE.md 中指定的）可以提供高级规范，用于维护单一真实来源，以编程方式转换为一个或多个教程特定格式。

## 我可以贡献吗？

当然可以。有功能想法？向我们发送拉取请求或提交错误报告。


## 注意事项

这不是官方的 Google 产品。
