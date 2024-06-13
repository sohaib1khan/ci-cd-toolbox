This document guides you through deploying Jenkins using Docker Compose. This configuration offers a persistent Jenkins environment with access to Docker within the container.

**Prerequisites**

- Docker installed and running on your system. You can find installation instructions on the Docker website: https://www.docker.com/products/docker-desktop/
- Docker Compose installed. You can find installation instructions on the Docker Compose website: https://docs.docker.com/compose/install/

**Configuration**

This project uses a `docker-compose.yml` file to define the Jenkins service and its configuration. The provided configuration is included below:

```
version: '3.7'
services:
  jenkins:
    image: jenkins/jenkins:lts
    restart: always
    privileged: true
    user: root
    ports:
      - 8022:8080
      - 50000:50000
    container_name: jenkins
    volumes:
      - /PEASE/ENTER/PATH/FOR/DATA:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker
```

**Explanation of Configuration Options:**

- **version:** Specifies the Docker Compose file format version (here, version 3.7).
- **services:** Defines the services to be deployed in this configuration.
    - **jenkins:** Defines the Jenkins service.
        - **image:** Specifies the Docker image to use (jenkins/jenkins:lts - LTS stands for Long-Term Support).
        - **restart:** Sets the restart policy for the container (`always` ensures Jenkins restarts automatically on container failure).
        - **privileged:** Grants the container privileged access to the host system (**caution:** use this with awareness of security implications).
        - **user:** Specifies the user to run the Jenkins process within the container (here, `root`).
        - **ports:** Defines port mappings between the container and the host machine:
            - `8022:8080` maps port 8022 on the host to port 8080 within the container (the Jenkins web UI).
            - `50000:50000` maps port 50000 on the host to port 50000 within the container (Jenkins agent communication).
        - **container_name:** Sets a friendly name for the container (`jenkins`).
        - **volumes:** Defines persistent storage for the container:
            - `/PEASE/ENTER/PATH/FOR/DATA:/var/jenkins_home`: Mounts a host directory (replace with your desired path) to `/var/jenkins_home` within the container. This persists Jenkins configuration and data across container restarts.
            - `/var/run/docker.sock:/var/run/docker.sock`: Allows the Jenkins container to access the Docker socket on the host machine (enables Docker commands within Jenkins).
            - `/usr/local/bin/docker:/usr/local/bin/docker`: Makes the `docker` command available within the Jenkins container.

**Deployment Steps:**

1.  **Save the configuration:** Create a file named `docker-compose.yml` and paste the provided configuration. Replace `/PEASE/ENTER/PATH/FOR/DATA` with the desired path on your host system to store Jenkins data persistently.
2.  **Navigate to the directory containing the `docker-compose.yml` file.**
3.  **Run `docker-compose up -d`:** This command starts the Jenkins service in detached mode (background).

**Accessing Jenkins:**

Once the deployment is complete, you can access the Jenkins web UI by opening http://localhost:8022 in your web browser.

**Initial Setup:**

Upon first access, you'll need to complete the Jenkins initial setup process. This typically involves unlocking the Jenkins web UI and installing plugins. Refer to the official Jenkins documentation for detailed instructions: https://www.jenkins.io/doc/

**Additional Notes:**

- Consider security implications when using the `privileged` flag in production environments. Explore alternative approaches if possible.
- Adjust volume paths and port mappings as needed for your specific environment.

This guide provides a basic setup for deploying Jenkins with Docker Compose. You can further customize the configuration based on your specific requirements and plugins.