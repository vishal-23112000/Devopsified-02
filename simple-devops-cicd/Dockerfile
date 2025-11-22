# Use official Node.js LTS image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY package.json package-lock.json* ./
RUN npm install --production

# Bundle app source
COPY . .

# Expose port and run
EXPOSE 3000
CMD ["node", "index.js"]
