# Codelab 转换脚本说明

## convert-codelabs.sh / convert-codelabs.bat

这是一个通用的 Codelab Markdown 批量转换脚本，支持本地和 Docker 两种使用方式。

- `convert-codelabs.sh` - Linux/Mac 版本
- `convert-codelabs.bat` - Windows 版本

### 功能特性

- ✅ 递归查找所有 `.md` 文件（支持嵌套文件夹）
- ✅ 批量转换为 Codelab HTML 格式
- ✅ 彩色输出，显示转换进度和结果
- ✅ 支持本地直接调用和 Docker 构建时调用
- ✅ 自动创建输出目录

### 使用方式

#### 方式 1：本地使用（推荐）

**Linux/Mac:**

```bash
# 方式 1: 从 site/.env 读取配置（推荐）
bash script/convert-codelabs.sh

# 方式 2: 指定源目录（输出使用 .env 或默认）
bash script/convert-codelabs.sh codelabs

# 方式 3: 完全自定义路径
bash script/convert-codelabs.sh <源目录> <输出目录>
bash script/convert-codelabs.sh docs/tutorials site/codelabs
```

**Windows:**

```cmd
REM 方式 1: 从 site\.env 读取配置（推荐）
script\convert-codelabs.bat

REM 方式 2: 指定源目录（输出使用 .env 或默认）
script\convert-codelabs.bat codelabs

REM 方式 3: 完全自定义路径
script\convert-codelabs.bat docs\tutorials site\codelabs
```

#### 方式 2：Docker 构建时自动调用

在 Docker 构建过程中会自动调用此脚本，无需手动执行：

```bash
docker build -t codelabs-site .
```

### 参数说明

| 参数 | 说明 | 优先级 | 默认值 |
|------|------|--------|--------|
| 参数1 | 源目录（Markdown 文件所在目录） | 1. 命令行参数<br>2. `.env` 配置<br>3. `codelabs` | `codelabs` |
| 参数2 | 输出目录（转换后的文件存放位置） | 1. 命令行参数<br>2. `.env` 配置<br>3. `site/codelabs` | `site/codelabs` |

**配置方式：**

1. **`.env` 配置文件（推荐）：**
   ```bash
   # .env
   CODELAB_SOURCE_DIR=docs/tutorials
   CODELAB_OUTPUT_DIR=site/codelabs
   ```

2. **命令行参数（临时覆盖）：**
   ```bash
   bash script/convert-codelabs.sh custom/path output/path
   ```

3. **默认值：**
   - 源目录: `codelabs`
   - 输出目录: `site/codelabs`

### 输出示例

```
=== Codelab Conversion ===
Source: codelabs
Output: site/codelabs

Found 3 markdown file(s)

Converting: first_codelab.md
  ✓ Success
Converting: android_tutorial.md
  ✓ Success
Converting: web_basics.md
  ✓ Success

Conversion completed
  Total:   3
  Success: 3
  Failed:  0

Output directory contents:
drwxr-xr-x 2 user user 4.0K Jan 17 19:00 first_codelab
drwxr-xr-x 2 user user 4.0K Jan 17 19:00 android_tutorial
drwxr-xr-x 2 user user 4.0K Jan 17 19:00 web_basics

Done!
```

### 常见使用场景

#### 场景 1：开发时快速转换单个文件

```bash
# 单独转换一个文件
claat export -o site/codelabs codelabs/my_new_codelab.md

# 或使用批量脚本
bash script/convert-codelabs.sh codelabs site/codelabs
```

#### 场景 2：使用 .env 配置统一管理

**创建配置文件：**
```bash
# .env
CODELAB_SOURCE_DIR=codelabs
CODELAB_OUTPUT_DIR=site/codelabs
```

**批量转换：**
```bash
# 脚本会自动从 .env 读取配置
bash script/convert-codelabs.sh

# 启动开发服务器查看效果
cd site
gulp serve --codelabs-dir=./codelabs
```

#### 场景 3：转换嵌套文件夹中的文件

```
codelabs/
├── android/
│   ├── basic.md
│   └── advanced.md
├── web/
│   └── intro.md
└── general.md
```

脚本会递归查找并转换所有 `.md` 文件：

```bash
bash script/convert-codelabs.sh codelabs site/codelabs
```

输出到 `site/codelabs/` 目录：

```
site/codelabs/
├── basic/
├── advanced/
├── intro/
└── general/
```

#### 场景 4：Docker 构建时自动转换

```bash
# 使用默认 codelabs 目录
docker build -t codelabs-site .

# 或指定自定义源目录
docker build --build-arg CODELAB_SOURCE_DIR=docs/tutorials -t codelabs-site .
```

### 错误处理

#### 错误：Source directory not found

```
ERROR: Source directory not found: codelabs
```

**解决方法：**
- 检查源目录路径是否正确
- 确保目录存在
- 使用相对路径或绝对路径

#### 警告：No markdown files found

```
WARNING: No markdown files found in codelabs
```

**解决方法：**
- 检查源目录中是否有 `.md` 文件
- 确认文件扩展名是 `.md`（不是 `.markdown`）
- 检查文件权限

#### 转换失败

```
Converting: example.md
  ✗ Failed
```

**可能原因：**
- Markdown 文件格式不符合 Codelab 规范
- 缺少必需的元数据（summary, id 等）
- claat 工具未正确安装

**解决方法：**
- 检查 Markdown 文件格式，参考 [FORMAT-GUIDE.md](../FORMAT-GUIDE.md)
- 确保文件包含必需的元数据
- 运行 `claat version` 检查工具是否可用

### 环境要求

- **本地使用：**
  - Bash shell
  - claat 工具已安装
  - 对源目录和输出目录有读写权限

- **Docker 使用：**
  - Docker 环境
  - 无需额外依赖（已包含在镜像中）

### 技术细节

1. **递归查找：** 使用 `find` 命令递归查找所有 `.md` 文件
2. **批量处理：** 使用 `while read` 循环逐个转换
3. **错误处理：** 使用 `set -e` 确保出错时退出
4. **环境检测：** 自动检测 Docker/本地环境并使用不同的默认路径
5. **彩色输出：** 使用 ANSI 转义码提供彩色输出（本地环境）

### 脚本维护

- 脚本位置：
  - Linux/Mac: `script/convert-codelabs.sh`
  - Windows: `script/convert-codelabs.bat`
- Dockerfile 引用：第 58-64 行
- 权限要求：
  - Linux/Mac: 可执行权限（`chmod +x script/convert-codelabs.sh`）
  - Windows: 无需额外权限

### 相关文档

- [Codelab 格式指南](../FORMAT-GUIDE.md)
- [Docker 使用说明](../README.md#docker-使用方式)
- [环境变量配置](../ENV_CONFIG.md)
