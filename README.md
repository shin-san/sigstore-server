# Remote Signature Server

## Overview

This page is to give context of the file structures and its uses for the remote signature server.

The container image being used as a sigstore server is a Red Hat version of httpd and has been modified to allow file and directory upload specifically for storing detached signatures generated through the pipeline.

## Directory Structure

```
    sigstore/
    ├── conf
    │   └── sigstore.conf
    ├── htpasswd
    │   └── user.passwd
    ├── images
    │   └── context
    │       ├── image@sha256
    │       │   └── signature-1
    ├── logs
    │   ├── modsec_audit.log
    │   ├── modsec_debug.log
    │   ├── sigstore-access.log
    │   └── sigstore-error.log
    ├── modules
    │   └── 00-dav.conf
    ├── pipeline
    │   └── image-push-and-sign
    │       ├── image-sign-and-push-pipeline.yaml
    │       ├── kustomization.yaml
    │       ├── pipelinerun-image-sign-and-push-v3.yaml
    │       ├── pvc
    │       │   └── pvc-sigstore-pipeline-storage copy.yaml
    │       └── task
    │           ├── task-cleanup.yaml
    │           ├── task-image-sign-and-push.yaml
    │           └── task-upload-signature.yaml
    ├── podman-run.sh
    └── README.md
```

* `/conf` contains the configuration of `VirtualHost` to instruct httpd of what features it can provide when accessing certain context paths
* `/htpasswd` contains the user details for authenticating certain API methods
* `/images` is the directory that contains all the detached signature for validation
* `logs` contains all the logs of both httpd access and audit logs
* `/modules` is used specifically to enable certain plugins
* `/pipeline` contains a working tekton pipeline resources that will pull, sign, and upload the detached signature to the remote sigstore server
* `podman-run.sh` is a script on how to run the container including the relevant volume mounts to guarantee that the sigstore is operational

Sigstore uses a specific plugin called WebDAV to allow file and directory creation through HTTP protocol

`PUT`, `DELETE`, and `MKCOL` methods have been restricted to authorised users. This is to protect the signatures from accidental removal and manipulation.

## API Operations

### Create Directory

Creating a directory can be done through the use of `MKCOL` method:

```
curl -k -v -X MKCOL -u $USER:$PASSWORD \
    https://localhost:8443/images/test-directory/
```

### PUT File

Upload a file:

```
curl -k -v -T test.txt -u $USER:$PASSWORD \
    https://localhost:8443/images/test-directory/test.txt
```

### Delete File

If there is a need to delete a file:

```
curl -k -v -X DELETE -u $USER:$PASSWORD \
    https://localhost:8443/images/test-directory/test.txt
```

### Delete Directory

Or a directory:

```
curl -k -v -X DELETE -u $USER:$PASSWORD \
    https://localhost:8443/images/test-directory/
```