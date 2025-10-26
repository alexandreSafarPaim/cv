# CV - Alexandre Paim

Currículo profissional disponível em português e inglês.

## Tecnologias

- HTML5
- CSS3
- Nginx (para servir arquivos estáticos)
- Docker

## Acesso Local

Para visualizar localmente, basta abrir os arquivos HTML no navegador:
- `index-pt.html` - Versão em Português
- `index-en.html` - Versão em Inglês

## Deploy no EasyPanel

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
- **Port**: 80
- **Domain**: Configure seu domínio ou subdomínio

#### 3. Variáveis de Ambiente

Não são necessárias variáveis de ambiente para este projeto.

#### 4. Deploy

1. Clique em **"Deploy"** ou **"Create"**
2. Aguarde o build e deploy do container
3. Acesse seu domínio configurado

### Rotas Disponíveis

Após o deploy, você terá acesso às seguintes rotas:

- `/` ou `/pt` - Versão em Português (padrão)
- `/en` - Versão em Inglês

## Desenvolvimento Local com Docker

Para testar localmente com Docker:

```bash
# Build da imagem
docker build -t cv-alexandre .

# Executar container
docker run -d -p 8080:80 cv-alexandre

# Acessar no navegador
# http://localhost:8080 (Português)
# http://localhost:8080/en (Inglês)
```

## Estrutura do Projeto

```
cv/
├── index-pt.html          # CV em Português
├── index-en.html          # CV em Inglês
├── Dockerfile             # Configuração Docker
├── nginx.conf             # Configuração do Nginx
├── .dockerignore          # Arquivos ignorados no build
└── README.md              # Este arquivo
```

## Atualizações

Para atualizar o CV:

1. Edite os arquivos `index-pt.html` e/ou `index-en.html`
2. Commit e push para o repositório
3. No EasyPanel, clique em **"Redeploy"** ou configure deploy automático

## Suporte

Para dúvidas ou problemas:
- Email: alexandresafarpaim@gmail.com
- LinkedIn: [linkedin.com/in/alexandresafarpaim](https://linkedin.com/in/alexandresafarpaim)
- GitHub: [github.com/alexandreSafarPaim](https://github.com/alexandreSafarPaim)

---

**© 2024 Alexandre Paim - Todos os direitos reservados**
