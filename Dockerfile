# Please execute the following command to build
# docker build -t nginx_v1.16.0 this_file_path
# docker-compose build

# Please execute the following command to start it
# docker run -itd --name nginx_v1.16.0 -p 80:80 nginx_v1.16.0
# docker-compose up -d

# Please execute the following command to attach
# docker exec -it nginx_v1.16.0 /bin/bash

# ベースイメージを指定
FROM hazuki3417/ubuntu:latest
# 制作者情報を指定
LABEL maintainer="hazuki3417 <hazuki3417@gmail.com>"

# メイン処理
RUN : "必要なコマンド類をインストール" && \
	apt-get install -y \
	git \
	# gnupg \ 
	# dpkg-dev \
	# dh-make \
	# build-essential \
	libpcre3-dev \
	libssl-dev \
	zlib1g-dev \
	libgd-dev \
	libxml2-dev \
	libxslt1-dev \
	# geoip-bin
	&& echo "complate!"

ARG workspace=/workspace
RUN : '作業用ディレクトリ作成' && \
	mkdir -m 777 ${workspace}
# 作業用ディレクトリへ移動
WORKDIR ${workspace}

RUN : "apt-keyを追加" && \
	curl -O "http://nginx.org/keys/nginx_signing.key" && \
	apt-key add ./nginx_signing.key && \
	rm ./nginx_signing.key

RUN : "リポジトリを追加" && { \
	echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx"; \
	echo "deb-src http://nginx.org/packages/ubuntu `lsb_release -cs` nginx"; \
	} | tee /etc/apt/sources.list.d/nginx.list

ARG nginx_version=1.16.0
ARG nginx_install_path=/etc/nginx
ARG conf_path=/etc/nginx/nginx.conf
ARG cache_path=/var/cache/nginx
ARG modules_path=/usr/lib/nginx/modules

RUN : "Nginxインストール用のディレクトリを作成" && \
	mkdir -p ${modules_path} && \
	mkdir -p ${cache_path}

RUN : 'Nginxをソースからインストール' && \
	apt-get update && \
	apt-get source nginx=${nginx_version}

WORKDIR /workspace/nginx-${nginx_version}
RUN : "Nginxインストール環境のチェック" && \
	./configure \
	--prefix=${nginx_install_path} \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=${conf_path} \
	--http-log-path=/var/log/nginx/access.log \
	--error-log-path=/var/log/nginx/error.log \
	--lock-path=/var/lock/nginx.lock \
	--pid-path=/run/nginx.pid \
	--user=root \
	--group=root \
	# --build=NAME \
	# --builddir=DIR \
	--modules-path=${modules_path} \
	# --add-dynamic-module=PATH \
	# --add-module=PATH \
	--http-client-body-temp-path=${cache_path}/client_temp \
	--http-proxy-temp-path=${cache_path}/proxy_temp \
	--http-fastcgi-temp-path=${cache_path}/fastcgi_temp \
	--http-uwsgi-temp-path=${cache_path}/uwsgi_temp \
	--http-scgi-temp-path=${cache_path}/scgi_temp \
	--with-file-aio \
	# --with-cc-opt=OPTIONS \
	# --with-cc=PATH \
	# --with-compat \
	# --with-cpp_test_module \
	# --with-cpp=PATH \
	--with-debug \
	# --with-google_perftools_module \
	--with-http_addition_module \
	--with-http_auth_request_module \
	# --with-http_dav_module \
	# --with-http_degradation_module \
	--with-http_flv_module \
	# --with-http_geoip_module \
	# --with-http_geoip_module=dynamic \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_image_filter_module \
	--with-http_mp4_module \
	# --with-http_perl_module \
	# --with-http_perl_module=dynamic \
	--with-http_random_index_module \
	--with-http_realip_module \
	--with-http_secure_link_module \
	--with-http_slice_module \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-http_sub_module \
	--with-http_v2_module \
	--with-http_xslt_module \
	# --with-http_xslt_module=dynamic \
	# --with-ld-opt=OPTIONS \
	# --with-libatomic \
	# --with-libatomic=DIR \
	# --with-mail \
	--with-mail_ssl_module \
	--with-mail=dynamic \
	# --with-openssl-opt=OPTIONS \
	# --with-openssl=DIR \
	# --with-pcre \
	# --with-pcre-jit \
	# --with-pcre-opt=OPTIONS \
	# --with-pcre=DIR \
	# --with-perl_modules_path=PATH \
	# --with-perl=PATH \
	# --with-stream \
	# --with-stream_geoip_module \
	# --with-stream_geoip_module=dynamic \
	# --with-stream_realip_module \
	--with-stream_ssl_module \
	# --with-stream_ssl_preread_module \
	--with-stream=dynamic \
	--with-threads \
	# --with-zlib-asm=CPU \
	# --with-zlib-opt=OPTIONS \
	# --with-zlib=DIR \
	# --without-pcre \
	# --without-http \
	# --without-http_access_module \
	# --without-http_auth_basic_module \
	# --without-http_autoindex_module \
	# --without-http_browser_module \
	# --without-http_charset_module \
	# --without-http_charset_module \
	# --without-http_empty_gif_module \
	# --without-http_empty_gif_module \
	# --without-http_fastcgi_module \
	# --without-http_geo_module \
	# --without-http_gzip_module \
	# --without-http_limit_conn_module \
	# --without-http_limit_req_module \
	# --without-http_map_module \
	# --without-http_memcached_module \
	# --without-http_proxy_module \
	# --without-http_referer_module \
	# --without-http_rewrite_module \
	# --without-http_scgi_module \
	# --without-http_split_clients_module \
	# --without-http_ssi_module \
	# --without-http_upstream_hash_module \
	# --without-http_upstream_ip_hash_module \
	# --without-http_upstream_keepalive_module \
	# --without-http_upstream_least_conn_module \
	# --without-http_upstream_zone_module \
	# --without-http_userid_module \
	# --without-http_uwsgi_module \
	# --without-http-cache \
	# --without-mail_imap_module \
	# --without-mail_pop3_module \
	# --without-mail_smtp_module \
	# --without-stream_access_module \
	# --without-stream_geo_module \
	# --without-stream_limit_conn_module \
	# --without-stream_map_module \
	# --without-stream_return_module \
	# --without-stream_split_clients_module \
	# --without-stream_upstream_hash_module \
	# --without-stream_upstream_least_conn_module \
	# --without-stream_upstream_zone_module \
	&& echo 'check complate!'
RUN : "Nginxをビルド・インストール" && \
	make && make install && \
	echo "Nginx install complate!"

RUN : "Nginxの設定" && \
	echo "nginx setting start..." && \
	mkdir ${nginx_install_path}/modules-available && \
	mkdir ${nginx_install_path}/modules-enabled && \
	mkdir ${nginx_install_path}/sites-available && \
	mkdir ${nginx_install_path}/sites-enabled
COPY config/nginx/nginx.conf /etc/nginx/
COPY config/nginx/sites/default_http.conf /etc/nginx/sites-available/
COPY config/nginx/sites/default_https.conf /etc/nginx/sites-available/
COPY config/nginx/sites/default_virtualhost.conf /etc/nginx/sites-available/

WORKDIR /etc/nginx/sites-enabled
RUN : "サイトの設定ファイルを読み込む" && \
	ln -s ../sites-available/default_http.conf ./defautl_http.conf

RUN : "不要なファイルを削除" && \
	rm -rfv ${workspace}

# サービス起動用のシェルスクリプト作成
RUN : "コンテナ起動時に起動するサービスを設定する" && { \
	echo '#!/bin/bash'; \
	echo 'nginx -c '${conf_path}; \
	echo '/bin/bash'; \
	} | tee /startup.sh
RUN chmod 744 /startup.sh

WORKDIR /
CMD [ "/startup.sh" ]

# 指定したポートを開放
EXPOSE 80
