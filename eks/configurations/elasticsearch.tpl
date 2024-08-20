apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
 annotations:
   eck.k8s.elastic.co/downward-node-labels: "topology.kubernetes.io/zone"
 name: ${cluster_name}
 namespace: ${cluster_name}
spec:
 version: ${es_version}
 http:
   service:
     spec:
       type: NodePort
       ports:
       - name: http
         port: 9200
         targetPort: 9200
   tls:
     selfSignedCertificate:
       disabled: true
 nodeSets:
   - name: masters
     count: ${master_count}
     config:
       node.attr.zone: ${ZONE}
       cluster.routing.allocation.awareness.attributes: k8s_node_name,zone
       bootstrap.memory_lock: true
       node.roles: ["master"]
       xpack.ml.enabled: true
     podTemplate:
       spec:
         containers:
           - name: elasticsearch
             env:
               - name: ZONE
                 valueFrom:
                   fieldRef:
                     fieldPath: metadata.annotations['topology.kubernetes.io/zone']
             resources:
               requests:
                 memory: ${master_memory_request}
                 cpu: ${master_cpu_request}
               limits:
                 memory: ${master_memory_limit}
                 cpu: ${master_cpu_limit}
     volumeClaimTemplates:
       - metadata:
           name: elasticsearch-data
         spec:
           accessModes:
             - ReadWriteOnce
           resources:
             requests:
               storage: ${master_disk_size}
           storageClassName: ${storage_class}
   - name: data
     count: ${data_count}
     config:
       node.attr.zone: ${ZONE}
       cluster.routing.allocation.awareness.attributes: k8s_node_name,zone
       bootstrap.memory_lock: true
       node.roles: ["data", "data_content", "data_hot", "data_warm", "data_cold", "data_frozen", "ingest"]
     podTemplate:
       spec:
         containers:
           - name: elasticsearch
             env:
               - name: ZONE
                 valueFrom:
                   fieldRef:
                     fieldPath: metadata.annotations['topology.kubernetes.io/zone']
             resources:
               requests:
                 memory: ${data_memory_request}
                 cpu: ${data_cpu_request}
               limits:
                 memory: ${data_memory_limit}
                 cpu: ${data_cpu_limit}
     volumeClaimTemplates:
       - metadata:
           name: elasticsearch-data
         spec:
           accessModes:
             - ReadWriteOnce
           resources:
             requests:
               storage: ${data_disk_size}
           storageClassName: ${storage_class}
   - name: client
     count: ${client_count}
     config:
       node.attr.zone: ${ZONE}
       cluster.routing.allocation.awareness.attributes: k8s_node_name,zone
       bootstrap.memory_lock: true
       node.roles: []
     podTemplate:
       spec:
         containers:
           - name: elasticsearch
             env:
               - name: ZONE
                 valueFrom:
                   fieldRef:
                     fieldPath: metadata.annotations['topology.kubernetes.io/zone']
             resources:
               requests:
                 memory: ${client_memory_request}
                 cpu: ${client_cpu_request}
               limits:
                 memory: ${client_memory_limit}
                 cpu: ${client_cpu_limit}
     volumeClaimTemplates:
       - metadata:
           name: elasticsearch-data
         spec:
           accessModes:
             - ReadWriteOnce
           resources:
             requests:
               storage: ${client_disk_size}
           storageClassName: ${storage_class}
    