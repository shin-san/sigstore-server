podman run --name sigstore -p 8080:8080 -p 8443:8443 \
    -v $HOME_DIR/sigstore/htpasswd:/opt/app-root/src/htpasswd \
    -v $HOME_DIR/sigstore/modules/00-dav.conf:/etc/httpd/conf.modules.d/00-dav.conf \
    -v $HOME_DIR/sigstore/conf/sigstore.conf:/etc/httpd/conf.d/sigstore.conf \
    -v $HOME_DIR/sigstore/images:/var/www/html/images \
    -v $HOME_DIR/sigstore/logs:/var/log/httpd \
    registry.redhat.io/rhel8/httpd-24:latest