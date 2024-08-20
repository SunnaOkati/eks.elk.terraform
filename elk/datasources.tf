data "aws_caller_identity" "current" {}

data "kubectl_file_documents" "elastic_quickstart_manifest" {
    content = file("/configuration/elasticsearch.yaml")
}

data "kubectl_file_documents" "kibana_quickstart_manifest" {
    content = file("/configuration/kibana.yaml")
}
