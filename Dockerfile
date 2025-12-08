# 使用官方 Node.js 运行时作为基础镜像
FROM node:20-alpine

LABEL maintainer="AIClient2API Team"
LABEL description="Docker image for AIClient2API server"

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install --production

# 复制源代码
COPY . .

# 创建日志目录
RUN mkdir -p /app/logs

# 暴露端口（可选，Render 会自动处理）
EXPOSE 3000

# 添加健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js || exit 1

# 设置启动命令
# 使用 Render 自动注入的环境变量 PORT
# 并绑定 0.0.0.0
CMD ["sh", "-c", "node src/api-server.js --port ${PORT:-3000}"]
