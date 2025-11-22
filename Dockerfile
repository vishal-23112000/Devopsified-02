# -----------------------------
# Stage 1: Build Stage
# -----------------------------
FROM node:18-alpine AS build

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first
COPY package.json package-lock.json ./

# Install production dependencies only
RUN npm install --production

# Copy app source
COPY index.js public ./ 

# -----------------------------
# Stage 2: Final Image
# -----------------------------
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy node_modules and app from build stage
COPY --from=build /usr/src/app ./

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
