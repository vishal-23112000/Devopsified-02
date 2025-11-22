FROM node:18-alpine AS build

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm install --production

# Correct way to copy files
COPY index.js ./
COPY public ./public

# -----------------------------
FROM node:18-alpine

WORKDIR /usr/src/app

COPY --from=build /usr/src/app /usr/src/app

EXPOSE 3000
CMD ["node", "index.js"]
