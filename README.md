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

#### 3. Configuração de Porta (⚠️ CRÍTICO!)

**IMPORTANTE**: O container será desligado automaticamente se a porta não for configurada!

Você verá nos logs algo como:
```
[notice] 1#1: signal 3 (SIGQUIT) received, shutting down
```

Para corrigir, siga estes passos **EXATAMENTE**:

1. Após criar o serviço no EasyPanel, **NÃO clique em Deploy ainda**
2. No **painel do serviço**, procure no menu lateral esquerdo por:
   - **"Implantações"** ou **"Deployments"** ou
   - **"Settings"** → **"Ports"** ou
   - Aba **"Ports"** diretamente
3. Adicione uma nova porta clicando em **"Add Port"** ou **"+ Port"**
4. Configure:
   - **Container Port**: `80` (obrigatório)
   - **Protocol**: `HTTP` ou `TCP`
   - **Published Port**: Deixe vazio ou automático
5. Clique em **"Save"** ou **"Salvar"**
6. **Agora sim**, faça o deploy ou redeploy

**Verificação**: Após o deploy, verifique os logs. O Nginx deve continuar rodando sem receber SIGQUIT.

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

**Causa**: O EasyPanel não sabe em qual porta o container está escutando.

**Solução passo-a-passo**:

1. **Acesse o painel do serviço no EasyPanel**
2. **Localize a configuração de portas**:
   - Procure no menu lateral esquerdo
   - Pode estar em: "Implantações", "Deployments", "Settings", ou "Ports"
3. **Adicione a porta**:
   - Clique em "Add Port" ou "+ Port" ou "Adicionar Porta"
   - **Container Port**: `80`
   - **Protocol**: Selecione `HTTP` (preferível) ou `TCP`
   - **Published Port**: Deixe vazio/automático ou `80`
4. **Salve a configuração**
5. **Faça o redeploy**:
   - Vá em "Deployments" ou "Implantações"
   - Clique em "Redeploy" ou "Deploy novamente"
6. **Verifique os logs**:
   - Os logs devem mostrar o Nginx rodando continuamente
   - NÃO deve aparecer mensagem de SIGQUIT

**Como verificar se a porta está configurada**:
- No painel do serviço, procure por "Ports" ou "Portas"
- Deve haver uma entrada com "Container Port: 80"
- Se não houver, adicione conforme passos acima

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
