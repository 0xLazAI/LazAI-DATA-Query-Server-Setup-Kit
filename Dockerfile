FROM python:3.12.5-slim

RUN pip install -U pip setuptools

# Install build dependencies for llama-cpp-python
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./

RUN pip install -r requirements.txt

ENV CMAKE_ARGS="-DGGML_NATIVE=OFF -DGGML_CPU_HBM=OFF -DGGML_AVX=OFF -DGGML_AVX2=OFF -DGGML_FMA=OFF"
ENV FORCE_CMAKE=1

# Alternative: Use pre-built wheel if available
RUN pip install --verbose llama-cpp-python || \
    pip install --verbose --no-cache-dir llama-cpp-python

RUN pip install pymilvus "pymilvus[model]"  

COPY main.py ./

EXPOSE 8000

# Use 0.0.0.0 to allow external connections
CMD ["python", "main.py", "--host", "0.0.0.0", "--port", "8000"]