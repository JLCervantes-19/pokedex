# Etapa 1: Build de la app Angular
FROM node:16 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build -- --configuration production --base-href=/

# Etapa 2: Servir la app con Nginx
FROM nginx:alpine
COPY --from=build /app/dist/pokedex-angular /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]