#!/bin/bash
set -euo pipefail

# =============================
#   1. Selecionar Módulo
# =============================
echo " Buscando módulos na pasta 'modulos/'..."
modules=($(ls -d modulos/*/ 2>/dev/null | sed 's|modulos/||;s|/||'))

if [ ${#modules[@]} -eq 0 ]; then
    echo " Nenhum módulo encontrado em ./modulos/"
    exit 1
fi

echo "Selecione o módulo:"
for i in "${!modules[@]}"; do
    echo "$((i+1))) ${modules[$i]}"
done

read -p "Digite o número do módulo: " module_option
module_index=$((module_option-1))
selected_module="${modules[$module_index]}"

echo " Módulo selecionado: $selected_module"
echo ""

# =============================
#   2. Selecionar pasta AWS
# =============================
echo " Buscando pastas que começam com 'aws-'..."
aws_folders=($(ls -d aws-* 2>/dev/null || true))

if [ ${#aws_folders[@]} -eq 0 ]; then
    echo " Nenhuma pasta 'aws-*' encontrada."
    exit 1
fi

echo "Selecione uma pasta AWS:"
for i in "${!aws_folders[@]}"; do
    echo "$((i+1))) ${aws_folders[$i]}"
done

read -p "Digite o número da pasta AWS: " aws_option
aws_index=$((aws_option-1))
selected_aws_folder="${aws_folders[$aws_index]}"

echo " Pasta AWS selecionada: $selected_aws_folder"
echo ""

# =============================
#   3. Selecionar ambiente (dev/hml/prd)
# =============================
echo " Listando ambientes dentro de $selected_aws_folder..."
env_folders=($(ls -d "$selected_aws_folder"/*/ 2>/dev/null | sed "s|$selected_aws_folder/||;s|/||"))

if [ ${#env_folders[@]} -eq 0 ]; then
    echo " Nenhuma pasta de ambiente encontrada."
    exit 1
fi

echo "Selecione o ambiente:"
for i in "${!env_folders[@]}"; do
    echo "$((i+1))) ${env_folders[$i]}"
done

read -p "Digite o número do ambiente: " env_option
env_index=$((env_option-1))
selected_env="${env_folders[$env_index]}"

echo " Ambiente selecionado: $selected_env"
echo ""

# =============================
# 4. Copiar arquivos do template para o destino
# =============================
template_path="templates/${selected_module}"
destination_path="${selected_aws_folder}/${selected_env}"

echo " Copiando arquivos do template:"
echo "De: $template_path"
echo "Para: $destination_path"

if [ ! -d "$template_path" ]; then
    echo " Template não encontrado: $template_path"
    exit 1
fi

mkdir -p "$destination_path"
cp -r "$template_path/"* "$destination_path/"

echo " Arquivos copiados com sucesso!"
echo ""

# =============================
# 5. Atualizar key no versions.tf (inserir ambiente antes de terraform.tfstate)
# =============================
versions_file="${destination_path}/versions.tf"

if [ -f "$versions_file" ]; then
    echo "🔧 Ajustando backend S3 no versions.tf..."

    # Substituição segura:
    # - captura o início: key = "
    # - captura um prefixo opcional que termina em /
    # - captura terraform.tfstate"
    # Substitui por: <prefixo opcional><selected_env>/terraform.tfstate
    #
    # Exemplo:
    #   key = "terraform.tfstate"         -> key = "dev/terraform.tfstate"
    #   key = "vpc/terraform.tfstate"     -> key = "vpc/dev/terraform.tfstate"
    #   key = "some/path/terraform.tfstate" -> some/path/dev/terraform.tfstate

    tmpfile="$(mktemp)"
    sed -E "s|(key[[:space:]]*=[[:space:]]*\")([^\"]*/)?(terraform\.tfstate\")|\1\2${selected_env}/\3|g" "$versions_file" > "$tmpfile" && mv "$tmpfile" "$versions_file"

    echo " 'key' atualizado para incluir o ambiente: ${selected_env}"
else
    echo " Aviso: versions.tf não encontrado em $destination_path — pulando ajuste do backend"
fi

echo ""

# =============================
# 6. Montar profile AWS
# =============================
aws_profile="${selected_aws_folder}-${selected_env}"

echo " Profile AWS que será utilizado: $aws_profile"
echo ""

# =============================
# 7. Rodar Terraform Init
# =============================
echo " Executando Terraform Init..."

cd "$destination_path" || exit 1

AWS_PROFILE="$aws_profile" terraform init

echo ""
echo "=============================================="
echo "Terraform inicializado com sucesso!"
echo "=============================================="
echo ""
echo " Para rodar o PLAN:"
echo "     cd ${selected_aws_folder}/${selected_env}"
echo "     export AWS_PROFILE=$aws_profile"
echo "     terraform plan -var-file=variables.tfvars -out=tfplan"
echo ""
echo " Para aplicar:"
echo "     terraform apply tfplan"
echo ""
