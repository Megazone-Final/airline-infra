data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "s3-an2-airline-tfstate-036333380579-ap-northeast-2-an"
    key    = "prod-vpc/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
