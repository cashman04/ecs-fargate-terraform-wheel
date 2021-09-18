output "Next_Steps" {
  value = <<-EOT
  
  Next Steps to deploy example docker container to ECS:

    Docker Build(from app directory):  
        docker build . -t ${var.name}
        

    Login to ECR:  
        aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.main.repository_url}


    Tag Docker image with ECR:  
        docker tag ${var.name} ${aws_ecr_repository.main.repository_url}


    Push Docker image to ECR: 
        docker push ${aws_ecr_repository.main.repository_url}


    Force new ECS service deployment: 
        aws ecs update-service --cluster ${aws_ecs_cluster.main.name} --service ${aws_ecs_service.main.name} --force-new-deployment


    Wait a short time and then visit your URL!  
        ${aws_route53_record.main.name}

  EOT
}