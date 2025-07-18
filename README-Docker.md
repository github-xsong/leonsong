# Docker 使用指南

本项目支持使用 Docker 进行容器化部署和管理。

## 📋 前置要求

- Docker Desktop 或 Docker Engine
- Docker Compose

## 🚀 快速开始

### 开发环境

```bash
# 启动开发环境（支持热重载）
docker-compose --profile dev up

# 或者使用简写
docker-compose -f docker-compose.yml -f docker-compose.override.yml up
```

访问 http://localhost:4321 查看开发环境。

### 生产环境

```bash
# 构建并启动生产环境
docker-compose --profile prod up -d

# 查看日志
docker-compose --profile prod logs -f
```

访问 http://localhost 查看生产环境。

### 预览环境

```bash
# 构建后预览
docker-compose --profile preview up
```

## 🛠 常用命令

### 构建镜像

```bash
# 构建开发镜像
docker build -f Dockerfile.dev -t leonsong-blog:dev .

# 构建生产镜像
docker build -t leonsong-blog:prod .
```

### 运行容器

```bash
# 运行开发容器
docker run -p 4321:4321 -v $(pwd):/app leonsong-blog:dev

# 运行生产容器
docker run -p 80:80 leonsong-blog:prod
```

### 管理容器

```bash
# 查看运行中的容器
docker ps

# 停止所有容器
docker-compose down

# 清理镜像和容器
docker system prune -a
```

## 📁 文件说明

- `Dockerfile` - 生产环境多阶段构建
- `Dockerfile.dev` - 开发环境构建
- `docker-compose.yml` - 容器编排配置
- `docker-compose.override.yml` - 本地开发覆盖配置
- `nginx.conf` - Nginx 服务器配置
- `.dockerignore` - Docker 构建忽略文件

## 🔧 配置说明

### 环境变量

- `NODE_ENV` - 环境模式 (development/production)
- `ASTRO_TELEMETRY_DISABLED` - 禁用 Astro 遥测

### 端口映射

- 开发环境: `4321:4321`
- 生产环境: `80:80`

### 数据卷

- 源代码挂载: `.:/app`
- Node 模块缓存: `/app/node_modules`
- Astro 缓存: `/app/.astro`

## 🚀 部署到服务器

### 1. 构建生产镜像

```bash
docker build -t leonsong-blog:latest .
```

### 2. 推送到镜像仓库

```bash
# 标记镜像
docker tag leonsong-blog:latest your-registry/leonsong-blog:latest

# 推送镜像
docker push your-registry/leonsong-blog:latest
```

### 3. 在服务器上运行

```bash
# 拉取镜像
docker pull your-registry/leonsong-blog:latest

# 运行容器
docker run -d -p 80:80 --name leonsong-blog your-registry/leonsong-blog:latest
```

## 🔍 故障排除

### 常见问题

1. **端口被占用**
   ```bash
   # 查看端口占用
   lsof -i :4321
   
   # 修改端口映射
   docker-compose up -p 4322:4321
   ```

2. **权限问题**
   ```bash
   # 修复文件权限
   sudo chown -R $USER:$USER .
   ```

3. **构建失败**
   ```bash
   # 清理缓存重新构建
   docker-compose build --no-cache
   ```

### 查看日志

```bash
# 查看容器日志
docker-compose logs -f blog-dev

# 查看构建日志
docker-compose build --progress=plain
```

## 📝 注意事项

1. 开发环境支持热重载，修改代码会自动刷新
2. 生产环境使用 Nginx 提供静态文件服务
3. 确保 `.dockerignore` 文件正确配置以优化构建速度
4. 生产环境建议使用反向代理（如 Nginx）处理 HTTPS 