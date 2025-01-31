# Build Stage
FROM node:18-alpine as build-stage

# Install Python and make for build compatibility
RUN apk add --no-cache python3 make g++

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Build the Vue.js app
RUN npm run build

# Production Stage
FROM nginx:stable-alpine as production-stage

# Set working directory in Nginx container
WORKDIR /usr/share/nginx/html

# Copy built files from the build stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Add runtime configuration script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 80
EXPOSE 80

# Start the app
CMD ["/entrypoint.sh"]
