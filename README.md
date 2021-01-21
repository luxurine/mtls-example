# mtls example

## prepare certs

```bash
sh makecert.sh
```

## http mtls

server:
```bash
go run http-mtls-server/server.go
```

client:
```bash
go run http-mtls-client/client.go
```

参考链接：
- https://venilnoronha.io/a-step-by-step-guide-to-mtls-in-go

## tcp mtls

server:
```bash
go run tcp-mtls-server/server.go
```

client:
```bash
go run tcp-mtls-client/client.go
```
