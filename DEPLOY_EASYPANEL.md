# Guia Completo de Deploy no EasyPanel

Este guia fornece instruções passo-a-passo para fazer o deploy deste projeto no EasyPanel.

## Índice

1. [Pré-requisitos](#pré-requisitos)
2. [Configuração Inicial](#configuração-inicial)
3. [Configuração de Porta (CRÍTICO)](#configuração-de-porta-crítico)
4. [Deploy e Verificação](#deploy-e-verificação)
5. [Solução de Problemas](#solução-de-problemas)

---

## Pré-requisitos

- Acesso ao EasyPanel na sua VPS
- Repositório Git com o código (GitHub, GitLab, etc.)
- Domínio configurado (opcional, mas recomendado)

---

## Configuração Inicial

### Passo 1: Criar Novo Serviço

1. Faça login no seu **EasyPanel**
2. Clique em **"Create Service"** ou **"New App"** ou **"+ Service"**
3. Selecione **"From Git Repository"** ou **"GitHub"**
4. Cole a URL do repositório:
   ```
   https://github.com/alexandreSafarPaim/cv
   ```
5. Selecione o branch:
   ```
   main
   ```
   (ou o branch que você está usando)

### Passo 2: Configurações Básicas

Configure os seguintes campos:

- **Name**: `cv-alexandre` (ou qualquer nome de sua preferência)
- **Build Method**: `Dockerfile` (MUITO IMPORTANTE!)
- **Dockerfile Path**: Deixe vazio ou coloque `./Dockerfile`
- **Domain**: Configure seu domínio ou subdomínio

**NÃO clique em Deploy ainda!** Primeiro precisamos configurar a porta.

---

## Configuração de Domínio e Proxy (CRÍTICO)

### Para Aplicações Web (como este projeto)

**NÃO use a aba "Ports"** - isso é apenas para aplicações não-web.

Para aplicações web HTTP/HTTPS, use o **Proxy** na aba **Domínios**:

### Como Configurar o Proxy

1. **Vá para a aba "Domínios"** no painel do serviço
2. **Adicione um domínio** clicando em "Add Domain" ou "+ Domain"
3. **Configure o proxy**:
   ```
   Domain: cv.alexandresafarpaim.com.br
   Path: /
   Target: http://site_cv:80/
   ```

   Onde:
   - `site_cv` é o nome do seu serviço no EasyPanel
   - `80` é a porta do Nginx dentro do container

4. **Ative HTTPS** (opcional mas recomendado):
   - Marque a opção "Enable HTTPS" ou "SSL/TLS"
   - O EasyPanel gerará automaticamente um certificado Let's Encrypt

5. **Salve as alterações**

### Formato do Target

O target deve seguir o formato:
```
http://<nome-do-servico>:<porta>/
```

Exemplos:
- `http://site_cv:80/` ✅
- `http://cv:80/` ✅
- `http://localhost:80/` ❌ (não use localhost)
- `80` ❌ (formato incorreto)

---

## Deploy e Verificação

### Fazer o Deploy

1. Vá para **"Deployments"** no menu lateral
2. Clique em **"Deploy"** ou **"Trigger Deploy"**
3. Aguarde o build (pode levar 1-3 minutos)

### Verificar os Logs

1. No painel do serviço, vá para **"Logs"**
2. Você deve ver algo assim:

```
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/10/26 05:32:15 [notice] 1#1: using the "epoll" event method
2025/10/26 05:32:15 [notice] 1#1: nginx/1.29.2
2025/10/26 05:32:15 [notice] 1#1: start worker processes
2025/10/26 05:32:15 [notice] 1#1: start worker process 29
2025/10/26 05:32:15 [notice] 1#1: start worker process 30
```

**✅ BOM**: Os logs param aqui e o Nginx continua rodando

**❌ RUIM**: Se aparecer `signal 3 (SIGQUIT) received, shutting down`, volte para [Configuração de Porta](#configuração-de-porta-crítico)

### Acessar o Site

1. Vá para a URL configurada no domínio
2. Você deve ver a versão em **Inglês** (padrão)
3. Acesse `/pt` para ver a versão em **Português**
4. Clique no **botão verde** no canto inferior esquerdo para alternar idiomas

---

## Solução de Problemas

### Container sendo desligado (SIGQUIT)

**Sintoma**: Logs mostram `signal 3 (SIGQUIT) received, shutting down`

**Logs mostram**:
```
2025/10/26 05:32:15 [notice] 1#1: start worker processes
2025/10/26 05:32:18 [notice] 1#1: signal 3 (SIGQUIT) received, shutting down
```

#### Causa 1: Proxy não configurado

**Solução**: Verifique se o proxy está configurado na aba "Domínios":
1. Vá para **Domínios** no painel do serviço
2. Verifique se há um domínio configurado
3. O Target deve ser: `http://<nome-servico>:80/`
4. Exemplo: `http://site_cv:80/`

#### Causa 2: Nome do serviço incorreto no Target

**Problema**: O nome do serviço no Target não corresponde ao nome real do serviço.

**Solução**:
1. Verifique o nome do serviço no EasyPanel (geralmente no topo da página)
2. O Target deve usar EXATAMENTE esse nome
3. Exemplo: Se o serviço se chama `site_cv`, use `http://site_cv:80/`

#### Causa 3: Health check falhando

**Problema**: O EasyPanel pode estar verificando a saúde do container e não recebendo resposta.

**Solução**:
- Este projeto já inclui um endpoint `/health` que retorna 200 OK
- Após o redeploy com a versão mais recente, o health check deve passar

#### Causa 4: Container não está pronto a tempo

**Problema**: O EasyPanel pode estar terminando o container antes dele estar totalmente inicializado.

**Solução**:
1. Aguarde o build completo
2. Verifique os logs para ver se o Nginx iniciou completamente
3. Se o problema persistir, pode ser necessário configurar um health check customizado no EasyPanel

### Build falhou

**Sintoma**: Error durante o build

**Possíveis causas**:
- Branch errado selecionado
- Build Method não está como "Dockerfile"
- Dockerfile não está na raiz do projeto

**Solução**:
1. Verifique se o branch está correto (main)
2. Verifique se "Build Method" está como "Dockerfile"
3. Verifique se "Dockerfile Path" está vazio ou `./Dockerfile`

### Site não carrega (404 ou erro de conexão)

**Possíveis causas**:
1. Porta não configurada
2. Domínio não configurado corretamente
3. DNS não propagado

**Solução**:
1. Verifique a configuração de porta
2. Verifique se o domínio aponta para o IP correto da VPS
3. Aguarde a propagação do DNS (pode levar até 24h)
4. Tente acessar via IP da VPS para descartar problema de DNS

### Página carrega mas botões não funcionam

**Sintoma**: Site abre mas clicar no botão de idioma não funciona

**Causa**: Configuração incorreta do Nginx ou arquivos não foram copiados

**Solução**:
1. Verifique os logs do Nginx
2. Faça um redeploy
3. Verifique se ambos os arquivos `index.html` e `pt.html` existem no container

### Como verificar arquivos no container

Se você tiver acesso SSH ao container:

```bash
# Listar arquivos
docker exec -it <container-name> ls -la /usr/share/nginx/html/

# Deve mostrar:
# index.html
# pt.html
```

---

## Checklist de Deploy

Use este checklist para garantir que tudo está configurado corretamente:

- [ ] Repositório Git configurado no EasyPanel
- [ ] Branch correto selecionado (main ou seu branch)
- [ ] Build Method: Dockerfile
- [ ] **Porta 80 configurada** (Container Port: 80, Protocol: HTTP)
- [ ] Domínio configurado (opcional)
- [ ] Deploy realizado
- [ ] Logs mostram Nginx rodando (sem SIGQUIT)
- [ ] Site acessível via domínio ou IP
- [ ] Versão inglês acessível em `/`
- [ ] Versão português acessível em `/pt`
- [ ] Botão de idioma funciona
- [ ] Botão de impressão funciona

---

## Rotas Disponíveis

Após o deploy bem-sucedido:

- **`/`** → Versão em Inglês (padrão)
- **`/pt`** → Versão em Português

**Navegação**: Use o botão verde no canto inferior esquerdo para alternar entre idiomas.

---

## Contato

Para dúvidas ou problemas:
- Email: alexandresafarpaim@gmail.com
- GitHub: [github.com/alexandreSafarPaim](https://github.com/alexandreSafarPaim)

---

**Última atualização**: 2024-10-26
