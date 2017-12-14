nginx:
  ng:
    lookup:
      package: nginx
      service: nginx
      webuser: nginx
      conf_file: /etc/nginx/nginx.conf
      server_available: /etc/nginx/sites-available
      server_enabled: /etc/nginx/sites-enabled
      server_use_symlink: True
      rh_os_releasever: '7'
      gpg_check: True
      pid_file: /run/nginx.pid
    service:
      enable: True
    server:
      config:
        worker_processes: 4
        pid: /var/run/nginx.pid
        events:
          worker_connections: 128
        http:
          sendfile: 'on'
          include:
            - /etc/nginx/mime.types
            - /etc/nginx/conf.d/*.conf
            - /etc/nginx/sites-enabled/*
    servers:
      managed:
        php:
          enabled: True
          overwrite: True
          config:
            - server:
              - server_name: localhost
              - listen:
                - 80
                - default_server
              - root: /usr/share/nginx/html
              - error_page:
                - 404
                - /404.html
              - error_page:
                - 500
                - 502
                - 503
                - 504
                - /50x.html
              - location = /50x.html:
                - root: /usr/share/nginx/html
              - index:
                - index.php
                - index.html
                - index.htm
              - location /:
                - try_files:
                  - $uri
                  - $uri/ =404
              - location ~ \.php$:
                - try_files:
                  - $uri =404
                - fastcgi_pass: unix:/var/run/php-fpm-www.sock
                - fastcgi_index: index.php
                - fastcgi_param:
                  - SCRIPT_FILENAME 
                  - $document_root$fastcgi_script_name
                - include: fastcgi_params
php:
  ng:
    lookup:
      fpm:
        conf: /etc/opt/remi/php70/php-fpm.conf
        ini: /etc/opt/remi/php70/php.ini
        pools: /etc/opt/remi/php70/php-fpm.d
        service: php70-php-fpm
        defaults:
          include: /etc/opt/remi/php70/php-fpm.d/*.conf
      pkgs:
        fpm:
          - php70-php-mysqlnd
          - php70-php-common
          - php70-php-pdo
          - php70-php-fpm
          - curl
    fpm:
      service:
        enabled: True
        opts:
          reload: True
      config:
        # options to manage the php.ini file used by php-fpm
        ini:
          opts:
            recurse: True
          settings:
            PHP:
              engine: 'On'
              extension_dir: '/opt/remi/php70/root/usr/lib64/php/modules'
              extension: [pdo_mysql.so, iconv.so, openssl.so]
        conf:
          settings:
            global:
              error_log: /var/log/php-fpm-error.log
      pools:
        defaults:
          user: nginx
          group: nginx
        'www.conf':
          enabled: True
          opts:
            replace: True
          settings:
            www:
              listen: /var/run/php-fpm-www.sock
              listen.owner: nginx
              listen.group: nginx
              pm: dynamic
              pm.max_children: 5
              pm.start_servers: 2
              pm.min_spare_servers: 1
              pm.max_spare_servers: 3
