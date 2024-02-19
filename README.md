# kcat in Docker
![kcat_small](https://github.com/Dwijad/kafkacat/assets/12824049/2070ad85-5e41-456d-8360-f83a2ff42501)

Kcat is a netcat for Apache Kafka mainly used for debugging state of kafka cluster, its metadata, topics/partitions.

The docker image for Kcat is available [here](https://hub.docker.com/r/solsson/kafka/tags).

### Run Kcat in Docker

    $ docker run -it edenhill/kcat:1.7.1 -b YOUR_BROKER -L

### Run Kcat in Kubernetes

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      creationTimestamp: null
      labels:
        run: kafkacat
      name: kafkacat
    spec:
      replicas: 1
      selector:
        matchLabels:
          run: kafkacat
      strategy: {}
      template:
        metadata:
          creationTimestamp: null
          labels:
            run: kafkacat
        spec:
          containers:
          - image: solsson/kafkacat
            name: kafkacat
            resources: {}
            command:
              - sh
              - -c
              - "exec tail -f /dev/null"
    status: {}

### Build custom Kcat image
 
Build you custom Kcat docker image from the Dockerfile

    $ DOCKER_BUILDKIT=1 docker buildx build -t localhost:5000/kcat:latest  --no-cache --progress=plain .

### SSL/SASL support

To connect Kafka cluster with SASL_SSL support, convert brokers certificate and key in PEM format.

    $ keytool -exportcert -alias broker-0 -keystore kafka-broker-0.keystore.jks -rfc -file certificate.pem
    $ keytool -v -importkeystore -srckeystore kafka-broker-0.keystore.jks -srcalias broker-0 -destkeystore cert_and_key.p12 -deststoretype PKCS12
    $ openssl pkcs12 -in cert_and_key.p12 -nocerts -nodes -out key.pem
    $ keytool -exportcert -alias ca -keystore kafka-broker-0.keystore.jks -rfc -file CARoot.pem

#### List kafka cluster metadata

    $ kafkacat -b test-kafka.default.svc.cluster.local:9092 -L -X security.protocol=SASL_SSL -X api.version.request=true -X sasl.mechanisms=PLAIN -X sasl.username=user1 -X sasl.password=password -X ssl.key.location=key.pem -X ssl.key.password=password -X ssl.certificate.location=certificate.pem -X ssl.ca.location=CARoot.pem  -X  api.version.request=true

#### Examine the topic _connect-offsets

    $ kafkacat -b test-kafka.default.svc.cluster.local:9092 -L -X security.protocol=SASL_SSL -X api.version.request=true -X sasl.mechanisms=PLAIN -X sasl.username=user1 -X sasl.password=password -X ssl.key.location=key.pem -X ssl.key.password=password -X ssl.certificate.location=certificate.pem -X ssl.ca.location=CARoot.pem  -t __consumer_offsets -C -f '\nKey (%K bytes): %k Value (%S bytes): %s Timestamp: %T Partition: %p Offset: %o\n'

More examples of running Kcat are [here](https://github.com/edenhill/kcat/tree/master#examples).

References:

<!--stackedit_data:
eyJoaXN0b3J5IjpbMjMyNDc2Nzg0LC0xNjAxNzYwNDEsMTQ2Nj
gyODEyNSwtMzA3MTkzOTg1XX0=
-->