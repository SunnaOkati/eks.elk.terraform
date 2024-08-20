# Install ECK operator via helm-charts
resource "helm_release" "elastic" {
 name             = "elasticsearch-operator"
 repository       = "https://helm.elastic.co"
 chart            = "eck-operator"
 create_namespace = true
 namespace        = "elastic-system"
 version          = var.eck_operator_version

  depends_on = [aws_eks_node_group.node_group]

}

# Delay of 30s to wait until ECK operator is up and running
resource "time_sleep" "wait_30_seconds" {
  depends_on = [helm_release.elastic]

  create_duration = "30s"
}

# Create Elasticsearch manifest
resource "kubectl_manifest" "elastic_quickstart" {
    for_each  = data.kubectl_file_documents.elastic_quickstart_manifest.manifests
    yaml_body = each.value

    provisioner "local-exec" {
        command = "sleep 60"
    }
    depends_on = [helm_release.elastic, time_sleep.wait_30_seconds]
}

# Create Kibana manifest
resource "kubectl_manifest" "kibana_quickstart" {
    for_each  = data.kubectl_file_documents.kibana_quickstart_manifest.manifests
    yaml_body = each.value


    provisioner "local-exec" {
        command = "sleep 60"
    }
    depends_on = [helm_release.elastic, kubectl_manifest.elastic_quickstart]
}