apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
 name: kibana
spec:
 version: ${es_version}
 http:
   service:
     spec:
       type: NodePort
       ports:
       - name: http
         port: 80
         targetPort: 3000
   tls:
     selfSignedCertificate:
       disabled: true
 count: 1
 elasticsearchRef:
   name: ${cluster_name}
 podTemplate:
   spec:
     containers:
     - name: kibana
       resources:
         requests:
           memory: ${kibana_memory_request}
           cpu: ${kibana_cpu_request}
         limits:
           memory: ${kibana_memory_limit}
           cpu: ${kibana_cpu_limit}
       volumeMounts:
       - name: elasticsearch-templates
         mountPath: /etc/elasticsearch-templates
         readOnly: true
     volumes:
       - name: elasticsearch-templates
         configMap:
           name: ilm-and-index-templates