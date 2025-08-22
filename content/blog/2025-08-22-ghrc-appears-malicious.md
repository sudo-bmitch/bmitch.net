---
date: '2025-08-22'
draft: false
title: 'ghrc.io Appears to be Malicious'
showToc: false
TocOpen: false
categories: ["blog"]
tags: ["security", "OCI"]
---

A simple typo of ghcr.io to ghrc.io would normally be a small goof.
You'd typically get a 404 or similar error, finally work out the issue, fix it, and move along.
But in this case, that typo appears to be doing something very malicious, stealing your credentials.

## What's ghcr.io?

First, a quick bit of background.
`ghcr.io` is an OCI conformant registry for container images and OCI artifacts used by a lot of projects.
When tools are configured to access it, they often do so with credentials to access private content or to push content.
And that happens using the OCI APIs and the [token auth workflow][distribution-token-auth] currently defined by the distribution project.

When querying `ghcr.io` you can see the start of this with the `www-authenticate` header:

```shell
$ curl -i https://ghcr.io/v2/
HTTP/2 401
content-type: application/json
docker-distribution-api-version: registry/2.0
strict-transport-security: max-age=63072000; includeSubDomains; preload
www-authenticate: Bearer realm="https://ghcr.io/token",service="ghcr.io",scope="repository:user/image:pull"
date: Fri, 22 Aug 2025 17:51:36 GMT
content-length: 73
x-github-request-id: DA46:5B047:5EDB5D:66E5C2:68A8AE28

{"errors":[{"code":"UNAUTHORIZED","message":"authentication required"}]}
```

## But It's Just A Typo, Right?

Now when running the same call to `ghrc.io`, we see something very concerning:

```shell
$ curl -i https://ghrc.io/v2/
HTTP/2 401
server: nginx
date: Fri, 22 Aug 2025 17:56:36 GMT
content-type: application/json
content-length: 72
www-authenticate: Bearer realm="https://ghrc.io/token"

{"errors":[{"code":"UNAUTHORIZED","message":"authentication required"}]}
```

First, the server is a simple nginx install, not a container registry, none of these fields are from someone actually running a registry server.
Second, it's only the OCI `/v2/` endpoint that is returning this, the rest look like a default nginx setup with the default home page and 404s on the other URLs:

```shell
$ curl -i https://ghrc.io/
HTTP/2 200
server: nginx
date: Fri, 22 Aug 2025 17:58:01 GMT
content-type: text/html
content-length: 615
last-modified: Tue, 23 Apr 2024 14:04:32 GMT
etag: "6627bff0-267"
strict-transport-security: max-age=31536000; includeSubDomains
accept-ranges: bytes

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

```shell
$ curl -i https://ghrc.io/404/
HTTP/2 404
server: nginx
date: Fri, 22 Aug 2025 17:58:04 GMT
content-type: text/html
content-length: 146
strict-transport-security: max-age=31536000; includeSubDomains

<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

```shell
$ curl -i https://ghrc.io/v3/
HTTP/2 404
server: nginx
date: Fri, 22 Aug 2025 17:58:35 GMT
content-type: text/html
content-length: 146
strict-transport-security: max-age=31536000; includeSubDomains

<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

But the `/v2/` API's return just enough of the normal OCI response:

```shell
$ curl -i https://ghrc.io/v2/library/alpine/tags/list
HTTP/2 401
server: nginx
date: Fri, 22 Aug 2025 17:58:21 GMT
content-type: application/json
content-length: 72
www-authenticate: Bearer realm="https://ghrc.io/token"

{"errors":[{"code":"UNAUTHORIZED","message":"authentication required"}]}
```

Both the error message body, and the `www-authenticate` header, show this is a targeted attack to OCI clients to trigger them to send their credentials to the token API.

## What's the Risk?

If you have ever run `docker login ghrc.io` or configured any automation like GitHub actions to login to `ghrc.io` instead of `ghcr.io`, you have leaked your credentials.
Just trying to pull an image won't leak your credentials, because credentials are tied to the hostname, and container runtimes will try to perform an anonymous image pull and fail.
If you've ever accidentally performed the login to the wrong server, you should change your password, and/or revoke any PATs you used.

[distribution-token-auth]: https://distribution.github.io/distribution/spec/auth/token/
