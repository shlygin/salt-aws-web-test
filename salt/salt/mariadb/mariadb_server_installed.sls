
include:
    - mariadb.default_mysql_uninstalled

mariadb_server_installed:
    pkg.installed:
        - pkgs:
            - MariaDB-client
            - MariaDB-server
        - require:
            - pkg: default_mysql_uninstalled
