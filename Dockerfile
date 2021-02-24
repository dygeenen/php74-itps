FROM registry.access.redhat.com/ubi8/php-74

USER 0

RUN INSTALL_PREREQUIS="gcc-c++ gcc php-devel php-pear yum-utils" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PREREQUIS --nogpgcheck && \
    rpm -V $INSTALL_PREREQUIS && \
    yum -y clean all --enablerepo='*'

RUN pecl install mongodb && \
    echo extension=mongodb.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-mongodb.ini
    
# MSSQL
RUN INSTALL_PREREQUIS_MSSQL="php-pdo php-xml php-pear php-devel re2c gcc-c++ gcc" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PREREQUIS_MSSQL --nogpgcheck && \
    rpm -V $INSTALL_PREREQUIS_MSSQL && \
    yum -y clean all --enablerepo='*'
   
RUN curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/mssql-release.repo && \
    yum -y remove unixODBC-utf16 unixODBC-utf16-devel && \
    yum -y install unixODBC-devel && \
    ACCEPT_EULA=Y yum -y install msodbcsql17 && \
    ACCEPT_EULA=Y yum -y install mssql-tools && \
    rpm -V msodbcsql17 mssql-tools unixODBC-devel && \
    
RUN pecl install sqlsrv && \
    echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini
RUN pecl install sqlsrv && \
    echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
    
USER 1001
