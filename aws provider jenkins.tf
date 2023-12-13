provider "aws" {
  region     = "ap-southeast-1"
  access_key = "AKIAUODATVGMMRNGSKX2"
  secret_key = "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"
}
resource "aws_vpc" "vpcjenkins" {
  cidr_block = "10.0.0.0/24"
}
resource "aws_subnet" "subjenkins" {
  cidr_block        = "10.0.0.0/25"
  vpc_id            = aws_vpc.vpcjenkins.id
  availability_zone = "ap-southeast-1a"
}
resource "aws_ebs_volume" "v1jenkins" {
  size              = 9
  availability_zone = "ap-southeast-1a"
  type              = "gp2"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpcjenkins.id
}
resource "aws_route_table" "rtjenkins" {
  vpc_id = aws_vpc.vpcjenkins.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "sn1rtjenkins" {
  subnet_id      = aws_subnet.subjenkins.id
  route_table_id = aws_route_table.rtjenkins.id
}
resource "aws_instance" "i1" {
  ami           = "ami-02453f5468b897e31"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subjenkins.id
  provisioner "local-exec" {
    command = "echo '${aws_instance.i1.private_ip}' > output.txt"
 }
}
output "private_ip" {
  value = aws_instance.i1.private_ip
}