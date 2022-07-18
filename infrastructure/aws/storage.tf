resource "aws_s3_bucket" "cluster_state_store" {
   bucket = var.state_store_bucket
}