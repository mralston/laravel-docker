FROM nginx:latest

# Get rid of default website
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy config files
COPY docker/nginx/nginx.conf /etc/nginx/
COPY docker/nginx/conf.d/* /etc/nginx/conf.d/
