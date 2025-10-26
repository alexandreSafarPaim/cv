# CV - Alexandre Paim

Currículo profissional disponível em português e inglês.

## Tecnologias

- HTML5
- CSS3
- Nginx (para servir arquivos estáticos)
- Docker

## Acesso Local

Para visualizar localmente, basta abrir os arquivos HTML no navegador:
- `pt.html` - Versão em Português
- `index.html` - Versão em Inglês (padrão)

## Deploy no EasyPanel

📖 **[Guia Completo de Deploy no EasyPanel](./DEPLOY_EASYPANEL.md)** - Instruções detalhadas passo-a-passo

### Resumo Rápido

**IMPORTANTE**: Configure a porta ANTES do primeiro deploy para evitar que o container seja desligado!

### Pré-requisitos

- Acesso ao EasyPanel na sua VPS
- Repositório Git configurado

### Passo a Passo

#### 1. No EasyPanel

1. Faça login no seu EasyPanel
2. Clique em **"Create Service"** ou **"New App"**
3. Selecione **"From GitHub"** ou **"From Git Repository"**
4. Cole a URL do seu repositório Git
5. Configure o branch (geralmente `main` ou `master`)

#### 2. Configurações do Projeto

- **Build Method**: Dockerfile
- **Dockerfile Path**: `./Dockerfile` (ou deixe vazio se o Dockerfile estiver na raiz)
- **Domain**: Configure seu domínio ou subdomínio

#### 3. Configuração de Domínio (⚠️ CRÍTICO!)

**IMPORTANTE**: Para aplicações web, use a aba **"Domínios"**, NÃO a aba "Portas".

**A aba "Portas" é apenas para aplicações não-web.**

Para configurar o proxy HTTP/HTTPS:

1. No painel do serviço, vá para a aba **"Domínios"**
2. Clique em **"Add Domain"** ou **"+ Domínio"**
3. Configure:
   - **Domain**: `seu-dominio.com.br`
   - **Path**: `/`
   - **Target**: `http://<nome-do-servico>:80/`
     - Exemplo: `http://site_cv:80/`
     - Use o nome EXATO do seu serviço no EasyPanel
4. Ative **HTTPS/SSL** (opcional mas recomendado)
5. Salve e faça o deploy

**Verificação**: O formato do Target deve ser `http://nome-servico:80/` onde `nome-servico` é o nome do seu serviço no EasyPanel.

#### 4. Variáveis de Ambiente

Não são necessárias variáveis de ambiente para este projeto.

#### 5. Deploy

1. Clique em **"Deploy"** ou **"Create"**
2. Aguarde o build e deploy do container
3. Verifique se a porta foi configurada corretamente (passo 3)
4. Acesse seu domínio configurado

### Rotas Disponíveis

Após o deploy, você terá acesso às seguintes rotas:

- `/` - Versão em Inglês (padrão)
- `/pt` - Versão em Português

**Navegação entre idiomas**: Cada página possui um botão flutuante verde no canto inferior esquerdo para alternar entre os idiomas.

## Desenvolvimento Local com Docker

Para testar localmente com Docker:

```bash
# Build da imagem
docker build -t cv-alexandre .

# Executar container
docker run -d -p 8080:80 cv-alexandre

# Acessar no navegador
# http://localhost:8080 (Inglês - padrão)
# http://localhost:8080/pt (Português)
```

## Estrutura do Projeto

```
cv/
├── pt.html                # CV em Português
├── index.html             # CV em Inglês (padrão)
├── Dockerfile             # Configuração Docker
├── nginx.conf             # Configuração do Nginx
├── .dockerignore          # Arquivos ignorados no build
└── README.md              # Este arquivo
```

## Atualizações

Para atualizar o CV:

1. Edite os arquivos `pt.html` e/ou `index.html`
2. Commit e push para o repositório
3. No EasyPanel, clique em **"Redeploy"** ou configure deploy automático

## Troubleshooting

### Container sendo desligado (SIGQUIT)

**Problema**: O container é iniciado mas após 2-3 segundos é desligado.

**Logs mostram**:
```
2025/10/26 05:32:15 [notice] 1#1: start worker processes
2025/10/26 05:32:18 [notice] 1#1: signal 3 (SIGQUIT) received, shutting down
```

**Possíveis Causas e Soluções**:

#### 1. Proxy não configurado na aba Domínios

**Verificar**:
1. Vá para aba **"Domínios"** no painel do serviço
2. Deve haver um domínio configurado com:
   - **Target**: `http://<nome-servico>:80/`
   - Exemplo: `http://site_cv:80/`

**Solução**: Se não estiver configurado, siga a [seção de Configuração de Domínio](#3-configuração-de-domínio-️-crítico)

#### 2. Nome do serviço incorreto no Target

**Verificar**: O nome no Target (`site_cv` em `http://site_cv:80/`) corresponde ao nome do serviço?

**Solução**: Use o nome EXATO do serviço. Verifique no topo da página do painel.

#### 3. Health check falhando

**Solução**: Faça um redeploy com a versão mais recente do código (que inclui endpoint `/health`)

Para mais detalhes, consulte o [Guia Completo de Deploy](./DEPLOY_EASYPANEL.md).

### Warning de MIME type duplicado

**Problema**: Logs mostram warning sobre `text/html` duplicado.

**Solução**: Este problema já foi corrigido no `nginx.conf`. O tipo `text/html` foi removido da configuração `gzip_types` pois já é incluído por padrão pelo Nginx.

### Site não carrega após deploy

**Verificações**:
1. Verifique se a porta 80 está configurada corretamente
2. Verifique se o domínio está apontando para o servidor correto
3. Verifique os logs do container no EasyPanel
4. Teste acessar via IP da VPS para descartar problemas de DNS

## Suporte

Para dúvidas ou problemas:
- Email: alexandresafarpaim@gmail.com
- LinkedIn: [linkedin.com/in/alexandresafarpaim](https://linkedin.com/in/alexandresafarpaim)
- GitHub: [github.com/alexandreSafarPaim](https://github.com/alexandreSafarPaim)

---

**© 2024 Alexandre Paim - Todos os direitos reservados**
