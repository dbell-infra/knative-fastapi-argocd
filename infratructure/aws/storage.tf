resource "aws_s3_bucket" "cluster_state_store" {
   bucket = "dm-bell-test-k8s-kops-state-store"
   acl    = "private"
}