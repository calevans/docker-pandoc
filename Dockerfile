FROM haskell:latest
MAINTAINER Cal Evans <cal@calevans.com>

# Set to Non-Interactive
ENV DEBIAN_FRONTEND noninteractive

# Install EVERYTHING
RUN apt-get update && \
    apt-get install --yes --no-install-recommends apt-utils && \
    apt-get install --yes --no-install-recommends apt-transport-https \
            biber \
            ca-certificates \
            dos2unix \
            fontconfig \
            git \
            latex-xcolor \
            libfreetype6 \
            libxrender1 \           
            libxext6 \
            libx11-6 \
            locales \
            lmodern \
            lsb-release \
            make \
            texlive-bibtex-extra \
            texlive-fonts-recommended \
            texlive-generic-recommended \
            texlive-lang-english \
            texlive-lang-german \
            texlive-latex-base \
            texlive-latex-extra \
            texlive-math-extra \
            texlive-xetex \
            wget \
            xz-utils && \
    wget -q -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
            php7.1 \
            php7.1-curl \
            php7.1-zip \
            php-yaml \
            php7.1-xml && \
    apt-get --yes autoclean && \
    apt-get --purge --yes autoremove && \
    git clone https://github.com/jgm/pandoc /opt/pandoc && \
    cd /opt/pandoc && \
    stack setup && \
    stack install --test && \
    wget -q -O /tmp/kindlegen.tar.gz https://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz && \
    cd /tmp && \
    tar -zxvf kindlegen.tar.gz && \
    mv /tmp/kindlegen /usr/local/bin && \
    cd /tmp && \
    wget -q https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -O /tmp/wkhtmltox.tar.xz && \
    xz -d wkhtmltox.tar.xz  && \
    tar -xf wkhtmltox.tar  && \
    mv wkhtmltox/bin/* /usr/local/bin/  && \
    cd /tmp  && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
# Move BuildBook into place.
#
COPY ./buildbook.sh /usr/local/bin

# Export the output data
WORKDIR /data
VOLUME ["/data"]

#
# Set the Entry Point
#
ENTRYPOINT ["buildbook.sh"]
