output "cluster_name" {
    value = var.cluster_name
}

output "cluster_state_store" {
    value = aws_s3_bucket.cluster_state_store.id
}

output "cluster_dns" {
    value = aws_route53_zone.k8s.name
}

output "app_dns" {
    value = aws_route53_zone.apps.name
}

output "app_dns_id" {
    value = aws_route53_zone.apps.zone_id
}