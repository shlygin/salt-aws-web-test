# Salt provisioner

Provisions new web machine with nginx+php-fpm(7.0)+mariadb(10.1).

/usr/share/nginx/html will be served as document root.

mariadb install has no any security changes or passwords applied.

It can take some time on AWS instances of small shape to be provisioned.

```
# Provision new web server with salt-ssh
$ salt-ssh '<ip_address>' state.highstate
```
