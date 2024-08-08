# Use the official Node.js image.
FROM node:18

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Install production dependencies.
RUN npm install

# Copy the source code into the container image.
COPY . .

# Expose port 3003 to the outside world.
EXPOSE 3003

# Run the web service on container startup.
CMD [ "node", "app.js" ]
