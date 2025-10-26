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

## Configuração de Porta (CRÍTICO)

### Por que isso é importante?

Se você não configurar a porta, o container será iniciado mas será **desligado automaticamente** após 2-3 segundos com a mensagem:

```
[notice] 1#1: signal 3 (SIGQUIT) received, shutting down
```

### Como Configurar a Porta

#### Opção 1: Antes do Primeiro Deploy (Recomendado)

1. **Após criar o serviço**, você estará no painel do serviço
2. **Procure no menu lateral esquerdo** uma das seguintes opções:
   - "Ports" ou "Portas"
   - "Deployments" → seção "Ports"
   - "Settings" → aba "Ports"
   - "Implantações" → seção "Portas"

3. **Clique em "Add Port"** ou **"+ Port"** ou **"Adicionar Porta"**

4. **Preencha os campos**:
   ```
   Container Port: 80
   Protocol: HTTP
   Published Port: (deixe vazio ou automático)
   ```

5. **Clique em "Save"** ou **"Salvar"**

6. **Agora sim, vá para Deployments e clique em "Deploy"**

#### Opção 2: Após o Deploy (Se já deployou sem configurar)

Se você já fez o deploy e o container está sendo desligado:

1. **Vá para o painel do serviço**
2. **Localize "Ports"** no menu lateral
3. **Adicione a porta** conforme descrito acima:
   - Container Port: `80`
   - Protocol: `HTTP`
4. **Salve as alterações**
5. **Vá para "Deployments"** ou **"Implantações"**
6. **Clique em "Redeploy"** ou **"Deploy novamente"**

### Variações do EasyPanel

Dependendo da versão do EasyPanel, a localização pode variar:

**Versão 1**:
- Menu lateral → "Settings" → aba "Ports"

**Versão 2**:
- Menu lateral → "Deployments" → seção "Ports" (role a página)

**Versão 3**:
- Menu lateral → "Ports" (direto)

**Se não encontrar**:
- Procure por um ícone de engrenagem (⚙️) para Settings
- Procure por qualquer menu relacionado a "Network", "Networking" ou "Rede"

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

**Causa**: Porta não configurada

**Solução**: Siga a seção [Configuração de Porta](#configuração-de-porta-crítico) acima

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
