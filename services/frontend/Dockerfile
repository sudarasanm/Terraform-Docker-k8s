FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN chown -R appuser:appgroup /var/cache/nginx /var/log/nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && chown -R appuser:appgroup /var/run/nginx.pid

USER appuser

EXPOSE 8080