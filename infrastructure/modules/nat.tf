##############################################################
# NAT GATEWAY
# reserve Elastic IP to be used in our NAT gateway
##############################################################

resource "aws_eip" "nat_gw_elastic_ip" {
  vpc = true

  tags = {
    Name        = "${local.cluster_name}-nat-eip"
    Terraform   = "true"
    Environment = "test"
  }
}