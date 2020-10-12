[
  {
    "name": "my-app",
    "image": "${docker_image_url_connop}",
    "essential": true,
    "cpu": 0,
    "memory": 128,
    "links": [],
    "portMappings": [
      {
        "containerPort": 4000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "command": [],
    "environment": []
    
    
  }
]