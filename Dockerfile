# Use an official lightweight Nginx image as a parent image.
# 'alpine' is a very small distribution, making the final image size smaller.
FROM nginx:alpine

# Remove the default Nginx welcome page.
RUN rm -rf /usr/share/nginx/html/*

# Copy the entire content of your project (HTML, CSS, JS, images)
# into the directory that Nginx serves files from.
COPY . /usr/share/nginx/html

# Expose port 80 to allow traffic to the web server.
EXPOSE 80

# The default Nginx command will start the server automatically when the container runs.
# No CMD instruction is needed.
