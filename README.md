# Alith LazAI Privacy Data Query Node

[![](https://cloud.phala.network/deploy-button.svg)](https://cloud.phala.network/templates/python-starter)

## What is this?

This is a **privacy-preserving data query service** built on [FastAPI](https://fastapi.tiangolo.com/) that enables secure, confidential data retrieval using **Trusted Execution Environment (TEE)** technology. The application integrates with [Alith LazAI](https://github.com/0xLazAI) to provide encrypted data querying capabilities while maintaining data privacy.

## Why Privacy-Preserving Data Query?

In today's data-driven world, organizations often need to query sensitive data while maintaining confidentiality. Traditional approaches either:
- Require full data decryption (security risk)
- Use complex encryption schemes (performance overhead)
- Rely on trusted third parties (privacy concerns)

This application solves these challenges by:
- **🔒 Encrypted Processing**: Data remains encrypted during query processing
- **🛡️ TEE Security**: Uses Trusted Execution Environment for hardware-level security
- **⚡ High Performance**: Optimized for real-time query responses
- **🔐 Zero Trust**: No need to trust the service provider with your data

## Key Features

- **RAG (Retrieval-Augmented Generation)**: Query encrypted documents using natural language
- **Vector Search**: Semantic search across encrypted data using embeddings
- **File Management**: Secure file upload, storage, and retrieval
- **Permission Control**: Fine-grained access control for data files
- **Milvus Integration**: High-performance vector database for similarity search

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client App    │    │  FastAPI Node   │    │   TEE Runtime   │
│                 │───▶│                 │───▶│                 │
│ - File Upload   │    │ - Query API     │    │ - Decryption    │
│ - Query Request │    │ - Auth Middleware│   │ - Processing    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   Milvus Store  │
                       │                 │
                       │ - Vector Search │
                       │ - Embeddings    │
                       └─────────────────┘
```

## Prerequisites

Before you begin, ensure you have:
- Python 3.12+ installed
- Docker and Docker Compose (for containerized deployment)
- Access to Alith LazAI services
- DStack TEE simulator (for local development)

## Local Development Setup

### 1. Clone and Initialize

```bash
# Clone the repository
git clone <your-repo-url>
cd phala-cloud-python-starter

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
python -m pip install -r requirements.txt

# Set up environment variables
cp env.example .env
# Edit .env with your actual API keys and configuration
```

### 2. Configure Environment Variables

Edit the `.env` file with your actual credentials:

```bash
# DStack configuration
DSTACK_SIMULATOR_ENDPOINT=/tmp/tappd.sock

# OpenAI configuration (for embeddings)
OPENAI_API_KEY=your_openai_api_key_here

# Alith LazAI configuration
PRIVATE_KEY=your_private_key_here
RSA_PRIVATE_KEY_BASE64=your_rsa_private_key_base64_here
LLM_API_KEY=your_llm_api_key_here
LLM_BASE_URL=your_llm_base_url_here
DSTACK_API_KEY=your_dstack_api_key_here
```

### 3. Start TEE Simulator

The application requires a Trusted Execution Environment simulator for local development:

**For macOS:**
```bash
wget https://github.com/Leechael/tappd-simulator/releases/download/v0.1.4/tappd-simulator-0.1.4-aarch64-apple-darwin.tgz
tar -xvf tappd-simulator-0.1.4-aarch64-apple-darwin.tgz
cd tappd-simulator-0.1.4-aarch64-apple-darwin
./tappd-simulator -l unix:/tmp/tappd.sock
```

**For Linux:**
```bash
wget https://github.com/Leechael/tappd-simulator/releases/download/v0.1.4/tappd-simulator-0.1.4-x86_64-linux-musl.tgz
tar -xvf tappd-simulator-0.1.4-x86_64-linux-musl.tgz
cd tappd-simulator-0.1.4-x86_64-linux-musl
./tappd-simulator -l unix:/tmp/tappd.sock
```

### 4. Start the Application

In a new terminal (with your virtual environment activated):

```bash
# Start the FastAPI development server
python main.py
```

The server will be available at `http://127.0.0.1:8000`

## Docker Deployment

### Building the Image

```bash
# Build for your local architecture
docker build -t thirumurugan7/my-tee-app:v2.0.1 .

# Build for multi-platform deployment (recommended for production)
docker buildx build --platform linux/amd64 -t thirumurugan7/my-tee-app:v2.0.1 --push .
```

### Running with Docker Compose

```bash
# Start the application with docker-compose
docker-compose up -d
```

The application will be available at `http://localhost:8000`

## API Endpoints

### Health Check
- `GET /health` - Check if the service is running

### Root
- `GET /` - Service information

### Data Query
- `POST /query/rag` - Perform RAG (Retrieval-Augmented Generation) queries on encrypted data

### Example Query Request

```json
{
  "file_id": "your_file_id",
  "query": "What are the main topics discussed in this document?",
  "limit": 5
}
```

## Production Deployment

This template is designed for deployment on:
- **[Phala Cloud](https://cloud.phala.network/)** - Managed TEE infrastructure
- **[DStack](https://github.com/dstack-TEE/dstack/)** - Self-hosted TEE platform

### Phala Cloud Deployment

1. Fork this repository
2. Configure your environment variables in the Phala Cloud dashboard
3. Deploy using the one-click button above

### DStack Deployment

1. Set up a DStack cluster with TEE support
2. Configure the required environment variables
3. Deploy using the provided Docker image

## Security Considerations

- **Private Keys**: Never commit private keys to version control
- **Environment Variables**: Use secure environment variable management
- **Network Security**: Ensure proper firewall configuration
- **TEE Validation**: Verify TEE attestation in production environments

## Troubleshooting

### Common Issues

1. **TEE Simulator Connection Error**
   - Ensure the simulator is running: `./tappd-simulator -l unix:/tmp/tappd.sock`
   - Check socket permissions

2. **API Key Errors**
   - Verify all environment variables are set correctly
   - Check API key permissions and quotas

3. **Vector Database Issues**
   - Ensure Milvus is properly configured
   - Check collection creation permissions

### Logs

Check application logs for detailed error information:
```bash
# Local development
python main.py --host 0.0.0.0 --port 8000

# Docker
docker-compose logs -f app
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- **Documentation**: [Alith LazAI Docs](https://docs.alith.ai/)
- **Issues**: [GitHub Issues](https://github.com/0xLazAI)
- **Community**: [Discord](https://discord.gg/nAtAEQbJpe)