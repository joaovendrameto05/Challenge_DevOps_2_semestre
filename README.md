# Challenge_DevOps_2_semestre

## Descricao da Solucao
Esta aplicacao e uma API RESTful desenvolvida em .NET 8 para o gerenciamento de clinicas veterinarias. O sistema gerencia as entidades centrais do dominio, como Tutores e Pets, integrando-se a um banco de dados relacional em nuvem. A infraestrutura e totalmente conteinerizada, utilizando Azure Container Registry (ACR) para armazenamento de imagens e Azure Container Instances (ACI) para execucao dos servicos.

## Beneficios para o Negocio
A solucao resolve o problema de fragmentacao no acompanhamento da saude dos animais. Ao centralizar os dados de tutores e pets em uma plataforma em nuvem de alta disponibilidade, a clinica reduz o esquecimento de tratamentos, melhora a integracao entre sistemas internos e aumenta a fidelizacao dos clientes. A arquitetura Serverless de containers reduz custos operacionais de infraestrutura e permite escalabilidade sob demanda.

## Instrucoes de Deploy e Teste (How To)

### Pre-requisitos
Azure CLI instalado
Acesso a uma subscricao ativa da Microsoft Azure
Ferramenta para requisicoes HTTP

### Deploy da Infraestrutura
1. Abra o terminal e autentique-se na Azure:
az login
2. Navegue ate a pasta infra e execute o script de provisionamento:
bash infra/provisionamento.sh
3. Aguarde a criacao do Resource Group, ACR e dos containeres do Banco de Dados e da API.

### Teste da Solucao
1. Obtenha o FQDN gerado para o container da API no portal do Azure.
2. Acesse a rota de documentacao no navegador:
http://<FQDN_DA_API>:8080/swagger
3. Utilize os endpoints GET, POST, PUT e DELETE nas rotas /api/tutores e /api/pets.
4. Para validar a persistencia, conecte-se ao banco de dados utilizando as credenciais configuradas e execute um SELECT nas tabelas correspondentes.