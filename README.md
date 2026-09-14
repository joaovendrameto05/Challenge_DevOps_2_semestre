# GuardianPet

API REST desenvolvida em ASP.NET Core 8 para gestão completa de clínica veterinária, cobrindo o fluxo de atendimento de tutores, pets, veterinários e consultas com segurança, monitoramento e infraestrutura em nuvem.

Desenvolvido para o **Challenge FIAP 2026** — CLYVO VET.

---

## Integrantes

| Nome | RM | Turma |
|---|---|---|
| Yuri Fuzinatto Garzoli Barreto | 561450 | 2TDSPX |
| Nicolas de Oliveira Jacob | 564205 | 2TDSPX |
| Gabriel Ambrósio Saraiva | 566552 | 2TDSPV |
| Vinicius Romaguera Cardozo | 562308 | 2TDSPX |
| João Victor Vendrameto | 563665 | 2TDSPV |

Repositório: https://github.com/Yurifgb06/GuardianPetV2

---

## Sobre o projeto

O GuardianPet centraliza e otimiza a jornada de cuidado do pet em uma única API RESTful. A fragmentação de dados clínicos e operacionais é eliminada por meio de um banco de dados unificado em nuvem, regras de negócio consistentes e controle de acessos estruturado — resultando em agilidade no atendimento, precisão no acompanhamento médico e melhor experiência tanto para o corpo clínico quanto para os tutores.

A API cobre operações de cadastro, consulta, atualização e exclusão das principais entidades:

- Usuários
- Pets
- Veterinários
- Consultas

Entre as funcionalidades implementadas estão:

- CRUD completo de todas as entidades com relacionamentos consistentes
- Busca de usuários por nome e e-mail
- Busca de pets por espécie e porte
- Busca de veterinários por nome e especialidade
- Autenticação via JWT com hash seguro de senhas
- Documentação interativa com Swagger/OpenAPI
- Health Checks de liveness e readiness
- Logs estruturados com Serilog
- Correlation ID por requisição
- Tracing distribuído com OpenTelemetry
- Métricas de latência e erros
- Testes unitários e de integração (80 testes, 0 falhas)
- Pipeline CI/CD automatizado no Azure DevOps
- Deploy containerizado via Azure Container Registry e Azure Container Instances

---

## Stack tecnológica

| Componente | Tecnologia |
|---|---|
| Linguagem / Framework | C# / ASP.NET Core (.NET 8) |
| Banco de Dados Relacional | Oracle Database Free (Entity Framework Core 8) |
| Banco de Dados NoSQL | MongoDB (manipulação de documentos) |
| Autenticação | JWT Bearer / PasswordHasher |
| Testes Automatizados | xUnit, Moq, WebApplicationFactory (padrão AAA) |
| Documentação | Swagger / OpenAPI com XML |
| Observabilidade | Serilog, OpenTelemetry, Correlation ID |
| Infraestrutura | Azure Container Registry (ACR) / Azure Container Instances (ACI) |
| CI/CD | Azure DevOps Pipelines |
| Containerização | Docker / Docker Compose |

---

## Arquitetura

O projeto segue os princípios de Clean Architecture com separação em camadas, SOLID e Injeção de Dependências.

```
HTTP Request
     |
     v
Controller        <- Recebe requisições, trabalha com DTOs, retorna respostas
     |
     v
Service           <- Concentra regras de negócio e validações
     |
     v
Repository        <- Acessa os dados via AppDbContext
     |
     v
Entity Framework Core
     |
     v
Oracle Database
```

### Responsabilidade das camadas

**Controllers** — Recebem as requisições HTTP, trabalham com os DTOs e retornam as respostas.

**Services** — Concentram as regras de negócio e validações da aplicação.

**Repositories** — Realizam o acesso aos dados através do `AppDbContext`.

**DTOs** — Separam os dados recebidos e retornados pela API das entidades persistidas no banco.

**Middlewares** — Tratamento global de erros, Correlation ID e coleta de métricas.

**Observability** — Centraliza os componentes do OpenTelemetry para tracing e métricas.

---

## Estrutura da solução

```
GuardianPet.sln
│
├── GuardianPet
│   ├── Controllers
│   ├── Data
│   ├── Documentation
│   ├── DTOs
│   ├── Enums
│   ├── Exceptions
│   ├── HealthChecks
│   ├── Middlewares
│   ├── Migrations
│   ├── Models
│   ├── Observability
│   ├── Repositories
│   ├── Security
│   └── Services
│
├── GuardianPet.Tests.Unit
│
└── GuardianPet.Tests.Integration
```

---

## Fluxo CI/CD

```
Push na branch master (GitHub)
     |
     v
Azure DevOps detecta alteração
     |
     v
CI: build + testes automatizados
     |
     v
Build validado -> Imagem Docker construída
     |
     v
Imagem enviada para Azure Container Registry (ACR)
     |
     v
CD: Azure Container Instances (ACI) atualizado automaticamente
```

Variáveis sensíveis são protegidas na Library do Azure DevOps. O deploy ocorre de forma transparente, sem intervenção manual.

---

## Executando o projeto

### Pré-requisitos

Para execução com Docker:

- Docker Desktop
- Docker Compose

Para execução direta pelo .NET:

- SDK .NET 8 ou compatível

---

### Execução com Docker (recomendado)

Na pasta onde está o arquivo `docker-compose.yml`, execute:

```bash
docker compose up -d --build
```

Para verificar os containers:

```bash
docker compose ps
```

São iniciados dois containers:

```
guardianpet-api    -> API disponível na porta 8080
oracle-db          -> Oracle na porta 1521, PDB: FREEPDB1
```

Os dados do Oracle são mantidos pelo volume `oracle-data`.

**Acessos:**

| Recurso | URL |
|---|---|
| Swagger | http://localhost:8080/swagger |
| Health Check | http://localhost:8080/health |
| Readiness | http://localhost:8080/health/ready |

Para visualizar os logs da API:

```bash
docker compose logs --tail=100 guardianpet-api
```

Para parar os containers mantendo os dados:

```bash
docker compose down
```

> A remoção do volume Oracle apaga todos os dados armazenados e não faz parte da execução normal do projeto.

---

### Execução pelo .NET (ambiente de desenvolvimento)

Para subir somente o Oracle no Docker e executar a API localmente:

```bash
docker compose up -d oracle-db
```

Em seguida:

```bash
dotnet restore GuardianPet.sln
dotnet build GuardianPet.sln
dotnet run --project GuardianPet.csproj --launch-profile http
```

A aplicação usará o ambiente `Development`. O Swagger ficará disponível em:

```
http://localhost:5202/swagger
```

---

### Deploy na nuvem (Azure)

A infraestrutura é provisionada via script de automação:

```bash
az login
bash infra/provisionamento.sh
```

O script cria o Resource Group, o Azure Container Registry e o Azure Container Instances. O deploy da aplicação containerizada ocorre de forma automática via trigger na branch `master` pelo Azure DevOps.

---

## Banco de dados

O projeto utiliza Oracle Database com Entity Framework Core 8.

As migrations ficam na pasta `Migrations/` e são aplicadas automaticamente na inicialização da API. Como o Oracle pode levar alguns segundos para subir, a aplicação realiza novas tentativas de conexão antes de desistir.

Entidades principais:

- Users
- Pets
- Veterinarians
- Consultations

---

## Autenticação e autorização

### Cadastro

```http
POST /api/users
```

O cadastro inicial é público. As senhas são armazenadas com hash seguro via `PasswordHasher<User>`.

### Login

```http
POST /api/auth/login
```

Recebe e-mail e senha. Quando válidos, retorna:

- Token JWT
- Data de expiração
- ID do usuário

Nos endpoints protegidos, envie o token no header:

```http
Authorization: Bearer <token>
```

### Permissões

A policy `ManageUsers` exige a claim `permission=users.manage` para operações administrativas. Os administradores são configurados via `Jwt:AdminUserIds`.

Pets, veterinários e consultas exigem autenticação.

| Status | Significado |
|---|---|
| 401 | Não autenticado, token inválido ou credenciais incorretas |
| 403 | Autenticado, mas sem permissão necessária |

---

## Endpoints principais

| Recurso | Método | Endpoint |
|---|---|---|
| Autenticação | POST | `/api/auth/login` |
| Usuários | POST / GET | `/api/users` |
| Usuários | GET / PUT / DELETE | `/api/users/{id}` |
| Usuários | GET | `/api/users/search?name=...` |
| Usuários | GET | `/api/users/email?email=...` |
| Pets | POST / GET | `/api/pets` |
| Pets | GET / PUT / DELETE | `/api/pets/{id}` |
| Pets | GET | `/api/pets/search?species=...&petSize=...` |
| Veterinários | POST / GET | `/api/veterinarians` |
| Veterinários | GET / PUT / DELETE | `/api/veterinarians/{id}` |
| Veterinários | GET | `/api/veterinarians/search/name?name=...` |
| Veterinários | GET | `/api/veterinarians/search/specialty?specialty=...` |
| Consultas | POST / GET | `/api/consultations` |
| Consultas | GET / PUT / DELETE | `/api/consultations/{id}` |
| Health | GET | `/health` |
| Readiness | GET | `/health/ready` |

Schemas completos, campos obrigatórios e valores de enums disponíveis no Swagger.

---

## Swagger

Com Docker:

```
http://localhost:8080/swagger
```

Os endpoints possuem documentação XML com descrição da operação, parâmetros, corpo da requisição, retornos, códigos HTTP e requisitos de autenticação.

Para testar endpoints protegidos:

1. Realize o login
2. Copie o token retornado
3. Clique em **Authorize** no Swagger
4. Informe o token no esquema Bearer
5. Execute o endpoint desejado

Login, cadastro e Health Checks permanecem públicos.

---

## Monitoramento e observabilidade

### Health Checks

**Liveness** — Verifica se a aplicação está funcionando. Não depende da conexão com o Oracle.

```http
GET /health
-> 200 Healthy
```

**Readiness** — Verifica se a aplicação está pronta para receber requisições e se consegue acessar o Oracle via `AppDbContext`.

```http
GET /health/ready
-> 200 Healthy
-> 503 Unhealthy
```

---

### Logs

O projeto utiliza Serilog para geração de logs estruturados, enviados para:

- Console
- Arquivo diário em `logs/guardianpet-.log` (retenção de 14 arquivos)

Níveis utilizados: `Information`, `Warning`, `Error`.

Informações sensíveis como senhas, tokens JWT e o header Authorization não são registradas.

---

### Correlation ID

Cada requisição pode enviar o header:

```http
X-Correlation-ID
```

O identificador é incluído nos logs e devolvido na resposta. Quando nenhum valor válido é enviado, a aplicação gera automaticamente um GUID. Isso facilita rastrear todos os registros relacionados à mesma requisição.

---

### OpenTelemetry e tracing

Instrumentação automática para ASP.NET Core e HttpClient. O fluxo de demonstração de tracing é:

```
HTTP Request -> Controller -> PetService -> PetRepository -> Oracle
```

Todos os spans compartilham o mesmo `TraceId`, permitindo acompanhar a requisição entre as camadas. Também são utilizados `SpanId` e `CorrelationId`. O Console Exporter está habilitado no ambiente `Development`.

---

### Métricas

| Métrica | Tipo | Descrição |
|---|---|---|
| `guardianpet.http.request.duration` | Histograma | Duração das requisições HTTP em milissegundos |
| `guardianpet.http.errors` | Contador | Respostas HTTP entre 400 e 599 |

As métricas utilizam tags de método HTTP, status HTTP e padrão de rota. As rotas são normalizadas para evitar cardinalidade alta — `/api/pets/{id}` em vez de `/api/pets/1`, `/api/pets/2`.

Em `Development`, as métricas são exportadas para o console periodicamente.

---

## Testes automatizados

A solução possui dois projetos separados de testes.

### Testes unitários

Utilizam xUnit, Moq e o padrão AAA (Arrange, Act, Assert).

Services testados:

- UserService
- PetService
- VeterinarianService
- ConsultationService
- AuthService

Cenários cobertos: operações válidas, recursos inexistentes, duplicidade de e-mail, duplicidade de CPF, duplicidade de CRMV, relacionamentos inválidos, hash de senha, autenticação e geração de JWT.

Nomenclatura dos testes:

```
MetodoTestado_Cenario_ResultadoEsperado
```

---

### Testes de integração

Utilizam xUnit, `WebApplicationFactory`, `CustomWebApplicationFactory`, Fixtures e Collection Fixture contra Oracle real.

Coberturas de resposta: `200`, `201`, `204`, `400`, `401`, `403`, `404`, `500`.

Cenários cobertos: login válido, login inválido, autenticação, autorização, CRUD de Pets, Correlation ID, Health Checks e Swagger.

O cenário `500 Internal Server Error` é provocado por substituição do `IPetRepository` no ambiente de teste, sem criar endpoint artificial.

**Isolamento do banco:** cada execução cria um schema Oracle temporário `GPTEST_*`, aplica as migrations e o remove ao término. Os testes não dependem de dados usados manualmente na aplicação.

---

### Resultado da validação

| Suíte | Total | Aprovados | Falhas | Ignorados |
|---|---:|---:|---:|---:|
| Unitários | 48 | 48 | 0 | 0 |
| Integração | 32 | 32 | 0 | 0 |
| **Total** | **80** | **80** | **0** | **0** |

```
Build final: 0 erros, 0 warnings
```

---

### Executando os testes

Os testes de integração requerem Docker com Oracle ativo.

```bash
docker compose up -d oracle-db

dotnet restore GuardianPet.sln
dotnet build GuardianPet.sln
dotnet test GuardianPet.sln
```

---

## Configuração por ambiente

O arquivo `.env.example` contém exemplos de todas as variáveis necessárias. Para configuração local, copie para `.env` (não deve ser enviado ao repositório).

| Variável | Finalidade |
|---|---|
| `ASPNETCORE_ENVIRONMENT` | Ambiente da aplicação |
| `ORACLE_PASSWORD` | Senha administrativa do Oracle na inicialização |
| `APP_USER` | Usuário Oracle da aplicação |
| `APP_USER_PASSWORD` | Senha do usuário Oracle |
| `ConnectionStrings__OracleConnection` | Connection string da API |
| `Jwt__Key` | Chave privada do JWT |
| `Jwt__Issuer` | Emissor do token |
| `Jwt__Audience` | Destinatário do token |
| `Jwt__ExpirationMinutes` | Tempo de validade do token |
| `Jwt__AdminUserIds__0` | Usuário com permissão administrativa |

Fora do ambiente de desenvolvimento, a chave JWT de exemplo é recusada pela aplicação. Senhas, tokens e credenciais privadas não devem ser adicionados ao repositório.

---

## Códigos HTTP

| Código | Situação |
|---:|---|
| 200 | Consulta ou atualização realizada com sucesso |
| 201 | Recurso criado |
| 204 | Recurso excluído |
| 400 | Dados inválidos |
| 401 | Não autenticado ou token inválido |
| 403 | Autenticado, mas sem permissão |
| 404 | Recurso não encontrado |
| 500 | Erro interno inesperado |
| 503 | Banco indisponível no readiness |

Em erros inesperados, a API retorna `Erro interno do servidor.` — detalhes técnicos permanecem somente nos logs.

---

## Observações

- O primeiro início do Oracle pode levar alguns segundos até estar disponível.
- As migrations são aplicadas automaticamente na inicialização da API.
- Os testes de integração requerem o Oracle ativo via Docker.
- Não há refresh token ou revogação de JWT nesta versão.
- Usuários com senha armazenada em texto puro (versões anteriores) precisam redefinir a senha.
- Arquivos de build, logs, resultados de testes e configurações locais estão ignorados pelo Git.

---

Projeto desenvolvido para fins educacionais como parte das atividades do curso de Análise e Desenvolvimento de Sistemas — FIAP.