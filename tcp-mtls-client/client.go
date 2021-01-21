package main

import (
	"crypto/tls"
	"crypto/x509"
	"io/ioutil"
	"log"
)

func main() {
	cert, err := tls.LoadX509KeyPair("certs/client.crt", "certs/client.key")
	if err != nil {
		log.Println(err)
		return
	}
	certBytes, err := ioutil.ReadFile("certs/ca.crt")
	if err != nil {
		panic("Unable to read cert.pem")
	}
	roots := x509.NewCertPool()
	ok := roots.AppendCertsFromPEM(certBytes)
	if !ok {
		panic("failed to parse root certificate")
	}
	conf := &tls.Config{
		RootCAs:            roots,
		Certificates:       []tls.Certificate{cert},
		InsecureSkipVerify: false,
		ServerName:         "localhost",
		// ServerName:         "127.0.0.1",
		// ServerName:         "172.26.128.144",
		// ServerName:         "server.example.com",
	}
	conn, err := tls.Dial("tcp", "localhost:8443", conf)
	if err != nil {
		log.Println(err)
		return
	}
	defer conn.Close()
	n, err := conn.Write([]byte("hello\n"))
	if err != nil {
		log.Println(n, err)
		return
	}
	buf := make([]byte, 100)
	n, err = conn.Read(buf)
	if err != nil {
		log.Println(n, err)
		return
	}
	println(string(buf[:n]))
}
