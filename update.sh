docker exec -i $1 sh -c 'cat > /etc/uwsgi/uwsgi.ini' < ./uwsgi/uwsgi.ini
docker exec -i $1 sh -c 'cat > /app/uwsgi.ini' < ./app/uwsgi.ini
docker exec -i $1 sh -c 'cat > /app/main.py' < ./app/main.py
docker exec -i $1 sh -c 'cat > /app/static/index.html' < ./app/static/index.html
docker exec -i $1 sh -c 'cat > /etc/nginx/nginx.conf' < ./nginx/nginx.conf
docker exec -i $1 sh -c 'cat > /etc/supervisor/conf.d/supervisord.conf' < ./supervisor/supervisord.conf
docker exec -i $1 sh -c 'chown -R nginx:nginx /app'
