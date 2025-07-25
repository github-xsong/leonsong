#!/bin/bash

# 部署配置
DOCKER_IMAGE="ghcr.io/github-xsong/leonsong"
CONTAINER_NAME="blog-website"
HOST_PORT="80"
CONTAINER_PORT="80"
BACKUP_CONTAINER="${CONTAINER_NAME}-backup"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 检查 Docker 是否运行
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        error "Docker 未运行或无权限访问"
        exit 1
    fi
}

# 登录到 GitHub Container Registry
login_ghcr() {
    log "登录到 GitHub Container Registry..."
    if [ -z "$GITHUB_TOKEN" ]; then
        error "GITHUB_TOKEN 环境变量未设置"
        exit 1
    fi
    
    echo $GITHUB_TOKEN | docker login ghcr.io -u github-xsong --password-stdin
    if [ $? -eq 0 ]; then
        success "登录成功"
    else
        error "登录失败"
        exit 1
    fi
}

# 拉取最新镜像
pull_image() {
    log "拉取最新镜像..."
    docker pull ${DOCKER_IMAGE}:latest
    if [ $? -eq 0 ]; then
        success "镜像拉取成功"
    else
        error "镜像拉取失败"
        exit 1
    fi
}

# 备份当前容器
backup_current() {
    if docker ps -q -f name=${CONTAINER_NAME} >/dev/null; then
        log "备份当前运行的容器..."
        docker stop ${BACKUP_CONTAINER} 2>/dev/null || true
        docker rm ${BACKUP_CONTAINER} 2>/dev/null || true
        docker rename ${CONTAINER_NAME} ${BACKUP_CONTAINER} 2>/dev/null || true
        success "当前容器已备份为 ${BACKUP_CONTAINER}"
    fi
}

# 启动新容器
start_new_container() {
    log "启动新容器..."
    docker run -d \
        --name ${CONTAINER_NAME} \
        -p ${HOST_PORT}:${CONTAINER_PORT} \
        --restart unless-stopped \
        ${DOCKER_IMAGE}:latest
    
    if [ $? -eq 0 ]; then
        success "新容器启动成功"
    else
        error "新容器启动失败"
        rollback
        exit 1
    fi
}

# 健康检查
health_check() {
    log "执行健康检查..."
    sleep 10
    
    for i in {1..6}; do
        if curl -f -s http://localhost:${HOST_PORT}/health >/dev/null; then
            success "健康检查通过"
            return 0
        else
            warning "健康检查失败，重试中... ($i/6)"
            sleep 10
        fi
    done
    
    error "健康检查失败，执行回滚"
    rollback
    exit 1
}

# 回滚函数
rollback() {
    log "执行回滚操作..."
    docker stop ${CONTAINER_NAME} 2>/dev/null || true
    docker rm ${CONTAINER_NAME} 2>/dev/null || true
    
    if docker ps -a -q -f name=${BACKUP_CONTAINER} >/dev/null; then
        docker rename ${BACKUP_CONTAINER} ${CONTAINER_NAME}
        docker start ${CONTAINER_NAME}
        success "回滚完成"
    else
        error "没有备份容器可以回滚"
    fi
}

# 清理函数
cleanup() {
    log "清理旧备份和无用镜像..."
    docker stop ${BACKUP_CONTAINER} 2>/dev/null || true
    docker rm ${BACKUP_CONTAINER} 2>/dev/null || true
    docker image prune -f
    success "清理完成"
}

# 主函数
main() {
    log "开始部署流程..."
    
    check_docker
    login_ghcr
    pull_image
    backup_current
    start_new_container
    health_check
    cleanup
    
    success "🎉 部署完成！网站已更新到最新版本"
    log "访问地址: http://$(curl -s ifconfig.me)"
}

# 如果直接运行脚本
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 