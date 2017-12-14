#!/bin/bash
set -x

echo "Installing repos..."
    yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum -y install epel-release
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    cat <<EOF > /etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
    yum -y clean all
    yum -y update

echo "Adding ssh keys..."
    cat <<EOF >> /home/$1/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxgzzUeJAgnuacI1m+vb1+0BLwZRNyoz0PalDv6pUVr1CVFLq1ld+iNDquq6OSCbmzwHTlzNV27ieK9AFK9ss68tjEaLTSFaXJ1h4Ose4C5EH6dCtHYT3YVrvolXW2bjLrqhzN0Bmh7FCnwd6AYE8sLDJbn7q4WkhXNFUcnsjCTaoV67KAf40GltUG2DN9fW++h7PuNMUd/3f1mJuOYcT2BEHQrIw0jWTtzwazdLK1JELJiE4RG5exjsSyIzoGsbuMZonELm3RVll+Ikwd761E5vf7gdAouFsQCrCuRiXrHG0hh9V+zIWT4QJnqoPnFnK88pne5LaDJIcJNk/p9UCv simtech_key
EOF
