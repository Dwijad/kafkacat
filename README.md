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

 



<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE3Njk2MTc4MDgsMTQ2NjgyODEyNSwtMz
A3MTkzOTg1XX0=
-->