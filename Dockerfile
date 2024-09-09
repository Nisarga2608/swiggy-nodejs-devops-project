# Step 1: Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Step 2: Set the working directory inside the container
WORKDIR /usr/src/app

# Step 3: Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Step 4: Install app dependencies
RUN npm install --production

# Step 5: Copy the rest of the application code to the container
COPY . .

# Step 6: Expose the port the app runs on (change this if your app runs on a different port)
EXPOSE 3000

# Step 7: Command to run the app (adjust this if your start script is different)
CMD ["npm", "start"]
