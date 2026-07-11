FROM ubuntu:20.04

WORKDIR /workspace

# prevent interactive prompts during installation (golang??? tf)
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    build-essential \
    golang \
    zstd \
    && apt-get clean


RUN curl -fsSL https://ollama.ai/install.sh | sh
RUN ollama serve & \
    (while ! curl -s http://localhost:11434/api/status > /dev/null; do sleep 1; done) && \
    ollama pull llama3.2


EXPOSE 8080
EXPOSE 11434

COPY . .

RUN go build -o chatbot main.go

CMD ["sh", "-c", "./chatbot"]
