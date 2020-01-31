#встановлення nginx
yum install -y epel-release
yum install -y nginx vim

#виключення selinux - шось типу брандмауера віндовс
setsebool httpd_can_network_connect 1 -P

# створення папки для сертифікатів
mkdir /etc/ssl/certs/my

#копіювання сертифікатів - їх ліпше згенерувати знов,бо зараз там мої данні
cp /vagrant/distro/ssl/ssl_certificate.crt /etc/ssl/certs/my
cp /vagrant/distro/ssl/ssl_certificate_key.key /etc/ssl/certs/my
cp /vagrant/distro/ssl/ssl_dhparam.pem /etc/ssl/certs/my

#зміна прав на сертифікат і ключ
chmod 600 /etc/ssl/certs/my/ssl_certificate_key.key
chmod 644 /etc/ssl/certs/my/ssl_certificate.crt

#запис налагтувань nginx до файла
echo "user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   650;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

# Settings for a TLS enabled server.
    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        ssl_certificate \"/etc/ssl/certs/my/ssl_certificate.crt\";
        ssl_certificate_key \"/etc/ssl/certs/my/ssl_certificate_key.key\";
        ssl_dhparam \"/etc/ssl/certs/my/ssl_dhparam.pem\";
        ssl_prefer_server_ciphers on;
        ssl_session_timeout  40m;
        ssl_ciphers HIGH:!aNULL:!MD5;

        location / {
        proxy_pass http://192.168.10.31:26112;
    }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

}" > /etc/nginx/nginx.conf

echo "<html>
    <head>
        <title>PROXY</title>
    </head>
    <body>
        <h1 style="font-size: 64">Welcome to the club buddy!</h1>
    </body>
</html>" > /usr/share/nginx/html/index.html

#запуск nginx
systemctl start nginx
systemctl enable nginx
systemctl status nginx

