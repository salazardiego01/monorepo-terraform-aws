# Módulo Terraform – Estrutura Base (Gerenciamento + escala + Automação)

Este repositório contém a estrutura padrão para criação de módulos Terraform, incluindo:

- Módulos reutilizáveis dentro de `modulos/`
- Templates para geração automática via script `start.sh`
- Backend S3 para armazenamento remoto do estado
- Padrão de ambientes (`dev`, `hml`, `prd`)
- Estrutura limpa e padronizada para projetos AWS

---

##  Dependências

Antes de utilizar este projeto, certifique-se de ter instalado:

- **Terraform ≥ 1.0**
- **AWS CLI** configurado com perfis utilizados pelo projeto  
- **Bash** (Windows usar Git Bash)
- Permissão AWS para acessar:
  - S3 (bucket do tfstate)
  - EC2/VPC (dependendo do módulo)
- Bucket S3 criado previamente para armazenar o `terraform.tfstate`



##  Estrutura do Repositório

```bash
.
├── start.sh
├── modulos/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── versions.tf
│   └── outros-modulos...
├── templates/
│   └── vpc/
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── versions.tf
├── aws-projeto1/
│   ├── dev/
│   ├── hml/
│   └── prd/
└── README.md

