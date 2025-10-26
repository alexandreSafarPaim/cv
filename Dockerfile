# Use Nginx Alpine para uma imagem leve
FROM nginx:alpine

# Copiar arquivos HTML para o diretório padrão do Nginx
COPY index-pt.html /usr/share/nginx/html/
COPY index-en.html /usr/share/nginx/html/

# Copiar configuração customizada do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expor porta 80
EXPOSE 80

# Comando padrão do Nginx
CMD ["nginx", "-g", "daemon off;"]
