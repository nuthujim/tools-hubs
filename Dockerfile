# Stage 1: Build the frontend
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app/frontend

# Copy package.json and package-lock.json (or yarn.lock if using yarn)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the frontend application
# This command depends on your frontend framework (e.g., 'npm run build', 'ng build --prod')
# Ensure your package.json has a 'build' script.
RUN npm run build

# Stage 2: Serve the static assets
# Using a lightweight Nginx server to serve the built static files
FROM nginx:alpine

# Copy the built static files from the builder stage
COPY --from=builder /app/frontend/dist /usr/share/nginx/html # Adjust '/dist' if your build output directory is different (e.g., 'build')

# Expose the port Nginx runs on
EXPOSE 8080 # Cloud Run expects services to listen on port 8080

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
