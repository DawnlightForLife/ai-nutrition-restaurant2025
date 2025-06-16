FROM python:3.13.2-slim

# 安装基础构建工具和依赖
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    libffi-dev \
 && rm -rf /var/lib/apt/lists/*

# 安装 Rust 工具链
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
# 更新并设置默认为稳定版本
RUN rustup update stable && rustup default stable

WORKDIR /app

COPY requirements.txt .

# 升级 pip 并安装依赖（尝试使用预编译轮子优先）
RUN pip install --upgrade pip && \
    pip install --prefer-binary --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8001
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
