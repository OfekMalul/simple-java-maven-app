# Welcome to My Latest Devops Project

This project provides a CI/CD pipeline utilizing GitHub Actions platform, in the goal to provide a streamlined and automated integration and deployment of Java Application. Incorporates the latest build, containerized and cloud technologies, Maven, Docker and AWS.

## Requirements

### AWS

- EC2: Ubuntu with t2 micro _minimum_
- Install Docker on the EC2 (Docker installation in Docker website for guidance)

### DockerHub

- Create a repository to contain your docker images

### GitHub Actions - Secrets

- DockerHub username and password.
- Github username and email
- EC2 host ip address and username (if you created EC2 running with ubuntu the user name is ubuntu)

### Github Actions - Environment Variables

- Set your public and private repository as DOCKER_REPO_NAME_PUB and DOCKER_REPO_NAME_COMPANY.
