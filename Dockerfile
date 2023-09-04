FROM alpine

# 添加一个非root用户
RUN addgroup -S testgroup && adduser -S -G testgroup -u 10014 test

# 设置工作目录和复制文件
WORKDIR /workdir
COPY ./content /workdir/

# 安装依赖和设置权限
RUN apk add --no-cache curl runit bash tzdata \
  && chmod +x /workdir/service/*/run \
  && sh /workdir/install.sh \
  && rm /workdir/install.sh \
  && ln -s /workdir/service/* /etc/service/

# 切换到非root用户
USER your_user_name

# 设置环境变量
ENV PORT=3000
ENV TZ=UTC

# 暴露端口
EXPOSE 3000

# 设置入口点
ENTRYPOINT ["runsvdir", "/etc/service"]
