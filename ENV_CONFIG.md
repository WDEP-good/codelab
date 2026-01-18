# 环境变量配置说明

## 快速开始

### 1. 创建 .env 文件

在项目根目录下创建 `.env` 文件：

```bash
# Linux/Mac
cp .env.example .env

# Windows
copy .env.example .env
```

### 2. 编辑配置

根据需要修改 `.env` 文件中的配置项。

## 配置示例

```bash
# ============================================
# Codelab 配置文件
# ============================================

# ============================================
# 构建时配置
# ============================================

# 源文件目录（Markdown 文件所在路径，相对于项目根目录）
# 默认: codelabs
# 示例: codelabs, docs/tutorials, my-codelabs
CODELAB_SOURCE_DIR=codelabs

# 输出目录（编译后的 codelab 文件，相对于项目根目录）
# 默认: site/codelabs
CODELAB_OUTPUT_DIR=site/codelabs

# ============================================
# 运行时配置
# ============================================

# 服务器绑定地址
# 默认: 0.0.0.0 (允许所有网络接口访问)
# 可选: localhost (仅本地访问), 192.168.1.100 (指定IP)
CODELAB_HOST=0.0.0.0

# 服务器端口
# 默认: 8000
CODELAB_PORT=8000

# Google Analytics ID（可选）
# 用于追踪 codelab 访问统计
# 留空则不启用统计
CODELAB_GA_ID=

# Codelab 环境类型
# 可选值: web (默认), kiosk
CODELAB_ENVIRONMENT=web
```

## 使用方式

### 1. 构建镜像

Dockerfile 会自动读取 `.env` 文件中的配置：

```bash
docker build -t codelabs-site .
```

如果 `.env` 中配置了 `CODELAB_SOURCE_DIR`，将使用该配置；否则使用默认的 `codelabs` 目录。

### 2. 运行容器

**使用 .env 文件配置：**
```bash
docker run -p 8000:8000 --env-file .env codelabs-site
```

**直接指定环境变量：**
```bash
docker run -p 8000:8000 \
  -e CODELAB_HOST=localhost \
  -e CODELAB_PORT=3000 \
  codelabs-site
```

## 配置优先级

### 构建时（CODELAB_SOURCE_DIR）：
1. `.env` 文件中的配置
2. 默认值（`codelabs`）

### 运行时（其他环境变量）：
1. 命令行直接指定的环境变量（`-e`）
2. `.env` 文件中的配置（`--env-file`）
3. Dockerfile 中的默认值（`ENV`）

## 注意事项

- `.env` 文件不应该提交到 Git 仓库（已在 `.gitignore` 和 `.dockerignore` 中排除）
- 每次修改 `CODELAB_SOURCE_DIR` 后需要重新构建镜像
- 修改运行时配置（HOST/PORT 等）只需重启容器即可
