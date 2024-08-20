# Install ECK operator via helm-charts
resource "helm_release" "elastic" {
  name             = "elasticsearch-operator"
  repository       = "https://helm.elastic.co"
  chart            = "eck-operator"
  create_namespace = true
  namespace        = "elasticsearch"
  version          = "2.14.0"

  depends_on = [module.eks]
}

# Create Elasticsearch manifest
resource "kubectl_manifest" "elastic_quickstart" {
  yaml_body = templatefile("configurations/elasticsearch.tpl",
    {
      cluster_name          = "elasticsearch",
      es_version            = "8.15.0",
      master_count          = 1,
      data_count            = 1,
      client_count          = 1,
      master_memory_request = "2Gi",
      master_memory_limit   = "2Gi",
      master_cpu_request    = 1,
      master_cpu_limit      = 1,
      data_memory_request   = "2Gi",
      data_memory_limit     = "2Gi",
      data_cpu_request      = 1,
      data_cpu_limit        = 1,
      client_memory_request = "2Gi",
      client_memory_limit   = "2Gi",
      client_cpu_request    = 1,
      client_cpu_limit      = 1,
      master_disk_size      = "2Gi",
      data_disk_size        = "2Gi",
      client_disk_size      = "2Gi",
      storage_class         = "gp2",
      ZONE                  = var.region
  })

  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [helm_release.elastic]

}

# Create Kibana manifest
resource "kubectl_manifest" "kibana_quickstart" {
yaml_body = templatefile("configurations/kibana.tpl",
    {
      cluster_name          = "elasticsearch",
      es_version            = "8.15.0",
      kibana_memory_request = "1Gi",
      kibana_memory_limit   = "1Gi",
      kibana_cpu_request    = 1,
      kibana_cpu_limit      = 1
  })


    provisioner "local-exec" {
        command = "sleep 60"
    }
    depends_on = [helm_release.elastic, kubectl_manifest.elastic_quickstart]
}