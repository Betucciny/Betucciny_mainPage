# Stage 1: Build the application
FROM node:22 AS builder
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Run the application
FROM node:22-slim AS runtime
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Set environment variables                                 
ENV HOST=0.0.0.0
ENV PORT=4321

# Expose the desired port
EXPOSE 4321

# Command to run the application
CMD ["node", "./dist/server/entry.mjs"]
