resource "null_resource" "deploy" {
  provisioner "local-exec" {
    # command = "aws eks update-kubeconfig --region eu-west-1 --name ${aws_eks_cluster.cluster.name} && kubectl apply -f ."
    command = "aws eks update-kubeconfig --region eu-west-1 --name ${aws_eks_cluster.cluster.name}"
    working_dir = "../kubernetes-ms"
  }

  depends_on = [ aws_eks_cluster.cluster, aws_eks_node_group.nodes ]
}