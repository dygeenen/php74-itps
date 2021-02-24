FROM registry.access.redhat.com/ubi8/php-74

USER 0

RUN INSTALL_PREREQUIS="gcc-c++ gcc php-devel php-pear yum-utils" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PREREQUIS --nogpgcheck && \
    rpm -V $INSTALL_PREREQUIS && \
    yum -y clean all --enablerepo='*'

RUN pecl install mongodb && \
    echo extension=mongodb.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-mongodb.ini

USER 1001
