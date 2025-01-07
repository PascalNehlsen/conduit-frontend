# Use Node:20 image
FROM node:20 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ${WORKDIR}

# Install dependencies using npm with faster options
RUN npm install --legacy-peer-deps --prefer-offline --no-audit

# Copy the project files
COPY . ${WORKDIR}

# Build the Angular application for production
RUN npm run build --prod

# Deploy the application with Nginx
FROM nginx:alpine

# Copy the app from the build stage to the Nginx directory
COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html

# Expose port 80 for accessing the frontend
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]