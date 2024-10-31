# How to Run Jobs on a Remote Server from Jenkins

In this guide, we will walk through the process of executing scripts on a remote server using Jenkins. This tutorial assumes that you have already set up and configured a Jenkins server.

## Prerequisites

- **Jenkins Server Setup**: If you want to deploy Jenkins on Kubernetes, you can refer to my [GitHub repository](https://github.com/sohaib1khan/kubernetes_craft/tree/main/Skaffold_Deployments/jenkins).
- **Remote Server**: You need a separate virtual machine (VM) or container with SSH access enabled. This server will be the target for Jenkins to connect to and execute scripts.

## Installing Plugins

To enable remote execution, you need to install the necessary Jenkins plugins. Follow these steps:

1. **Access Jenkins Web UI**: Ensure that Jenkins is properly set up and accessible through your browser.
2. **Manage Jenkins**: From the Jenkins homepage, click on **Manage Jenkins** on the left-hand side under the Jenkins logo.
3. **Plugin Manager**: On the Manage Jenkins page, locate the **System Configuration** section and click **Manage Plugins**.
4. **Update Existing Plugins**: It is recommended to update existing plugins to their latest versions before installing new ones. Keeping your plugins up to date ensures compatibility with newer versions of Jenkins and enhances stability.
5. **Install Plugins**: Click on the **Available Plugins** tab, then search for the required plugin, such as `SSH2 Easy`. **Note**: If you cannot find `SSH2 Easy`, it may have been installed during the initial Jenkins setup.

The SSH2 Easy plugin helps Jenkins securely connect to remote servers via SSH, allowing for script automation and system management without compromising on security.

## Configuring the Remote Server in Jenkins

After verifying that the **SSH2 Easy** plugin is installed, you need to configure the remote server:

1. **Navigate to Manage Jenkins**: On the main Jenkins page, click on **Manage Jenkins**.
2. **System Configuration**: Click on **System** to access the configuration page.
3. **Server Groups Center**: Scroll down or use **CTRL + F** to search for **Server Groups Center**.
   - **Group Name**: Provide a name for your group, such as `Test`. Grouping servers helps keep track of multiple target machines easily.
   - **SSH Port**: Enter the SSH port, usually `22` unless your server uses a different port.
   - **Username**: Enter the SSH username for the remote server, e.g., `devk3s`.
   - **Password**: Enter the SSH password for the user.
4. **Add Server to Group**:
   - In the **Server List** section, assign a server to the group you created.
   - Enter the **Server IP Address**.
5. **Save Configuration**: Click on **Save** and **Apply** to store your settings.

This configuration is essential because it allows Jenkins to know which remote servers to communicate with, providing a centralized way to manage all your remote build targets. When you have multiple remote servers to work with, grouping and organizing them effectively will make the management of builds much easier and more efficient.

## Adding SSH Credentials to Jenkins

Next, you need to add the credentials for the remote server to facilitate secure communication between Jenkins and the server:

1. **Manage Jenkins**: On the Jenkins dashboard, click **Manage Jenkins** and navigate to the **Security** section.
2. **Credentials**: Click **Credentials**, then select **System** under **Stores scoped to Jenkins**.
3. **Global Credentials**: Click on **Global credentials (unrestricted)**. This is where you store credentials that are shared across different nodes and jobs.
4. **Add Credentials**:
   - **Kind**: Select **Username with password**.
   - **Scope**: Keep the default, which is **Global**.
   - **Username**: Enter the SSH username, e.g., `devk3s`.
   - **Password**: Provide the SSH password for the user.
   - **Click Create**: Finally, click **Create** to save the credentials.

By storing credentials here, you enable Jenkins jobs to authenticate with the remote server without manually entering usernames and passwords each time, which greatly enhances security and convenience. Secure storage of credentials also prevents potential leaks that could occur if passwords were hardcoded into build scripts.

## Running a Test Job

To verify that the configuration is correct, create a simple Jenkins job that executes a test script on the remote server:

1. **Create a New Job**:
   - On the Jenkins dashboard, click **New Item**.
   - Provide a name for the job, e.g., `demo_project`.
   - Select **Freestyle Project** and click **OK**.

Creating a freestyle project allows for flexibility in the type of tasks that can be executed, which is ideal for testing different configurations. Freestyle projects are perfect for running different types of build steps and experimenting with remote shell commands.

2. **Configure the Job**:
   - Scroll down to the **Build Steps** section.
   - Click **Add build step** and select **Remote Shell**. This allows Jenkins to run a shell command on the remote server.
   - In the **Target Server** drop-down menu, select the server you configured.
   - **Shell Command**: Enter the script you want to run. For this example:
      ```bash
      #!/bin/bash
      # Create a test directory if it doesn't already exist
      mkdir -p ~/jenkins_test
      # Create or overwrite a test output file
      output_file=~/jenkins_test/jenkins_output.txt
      echo "Current Date and Time:" > "$output_file"
      date >> "$output_file"
      echo "System Uptime:" >> "$output_file"
      uptime >> "$output_file"
      echo "Disk Usage:" >> "$output_file"
      df -h >> "$output_file"
      echo "Environment Variables:" >> "$output_file"
      env >> "$output_file"
      echo "Script executed successfully. Check the output in ~/jenkins_test/jenkins_output.txt"
      exit $?
      ```
   - **Save the Job**: Click **Save** and **Apply**.

The script above creates a directory, writes system information to a file, and prints environment variables. This is useful for verifying connectivity, server status, and basic system metrics. Having a record of system information in a text file can be useful for auditing and troubleshooting purposes, especially when diagnosing connectivity issues.

3. **Run the Job**:
   - On the job page, click **Build Now**. This triggers Jenkins to start executing the configured build steps.
   - To view the progress, go to **Build History** and click on the build number, then select **Console Output**. The console output is a detailed log of the job execution, providing information about each step.
   - The console output should display something like this:
     ```
     Started by user sirjenkins
     Running as SYSTEM
     Building in workspace /var/jenkins_home/workspace/demo_project
     Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)
     Script executed successfully. Check the output in ~/jenkins_test/jenkins_output.txt
     ##########################################################################
     Finished: SUCCESS
     ```

This output log verifies that Jenkins was able to connect to the remote server and successfully execute the script, confirming that the entire setup works as expected.

## Verifying the Remote Server Output

To confirm that the script executed successfully, SSH into the remote server and verify the output file:

```bash
ssh devk3s@192.168.1.28
ls ~/jenkins_test/jenkins_output.txt
cat ~/jenkins_test/jenkins_output.txt
```

If the setup is correct, you should see the `jenkins_output.txt` file containing the system information, such as date, uptime, disk usage, and environment variables. The file will provide a snapshot of the system state at the time of execution, ensuring that Jenkins was able to interact effectively with the remote server.

The content of this file serves as a record of the job's successful execution and can be used for further diagnostics or as part of a larger automation pipeline. You can also use this to validate that commands were executed correctly, which is a key part of automating server tasks reliably.

## Summary

In this guide, you successfully:

- Installed the necessary Jenkins plugins for remote execution.
- Configured a remote server to connect to Jenkins via SSH.
- Created and tested a job to validate the SSH connection and execute a script on the remote server.

These steps will help you automate tasks such as deployments, remote server maintenance, or any other kind of automated management directly through Jenkins. Once you are comfortable with this setup, you can expand it to manage more sophisticated deployments, such as Kubernetes manifests or multi-server orchestration. Jenkins can be integrated with other tools like Git or Docker, allowing for a comprehensive CI/CD solution that is capable of handling complex workflows.

Jenkins offers a powerful way to streamline and automate routine tasks, making it easier for developers and administrators to focus on high-level decision-making and development. With Jenkins, you can schedule jobs, monitor builds, and ensure consistency across environments. Automation helps prevent human error, increase efficiency, and ultimately boost productivity for your development and operational workflows.

## Resources

### Jenkins Remote Script Example

The following script is an example of a simple shell script you can use for testing remote execution in Jenkins. This script gathers various system metrics and writes them to a file on the remote server:

```bash
#!/bin/bash

# Create a test directory if it doesn't already exist
mkdir -p ~/jenkins_test

# Create or overwrite a test output file
output_file=~/jenkins_test/jenkins_output.txt

# Write the current date and time
echo "Current Date and Time:" > "$output_file"
date >> "$output_file"
echo "" >> "$output_file"

# Write system uptime information
echo "System Uptime:" >> "$output_file"
uptime >> "$output_file"
echo "" >> "$output_file"

# Write disk usage information
echo "Disk Usage:" >> "$output_file"
df -h >> "$output_file"
echo "" >> "$output_file"

# Write some environment information
echo "Environment Variables:" >> "$output_file"
env >> "$output_file"
echo "" >> "$output_file"

# End of script
echo "Script executed successfully. Check the output in ~/jenkins_test/jenkins_output.txt"
```

Use these instructions as a reference whenever you need to run scripts on remote servers using Jenkins. This setup will allow you to leverage Jenkins for more powerful CI/CD workflows, increasing automation and efficiency in your infrastructure management.

The example script provided here can be modified as needed to perform other tasks, such as updating packages, monitoring resources, or deploying applications. Jenkins's flexibility with scripting and its plugin ecosystem make it an invaluable tool for managing environments at scale.

By automating these tasks through Jenkins, you not only save time but also minimize errors caused by manual intervention, ensuring that your deployments are repeatable and reliable. Utilizing Jenkins for remote jobs helps centralize your automation efforts, keeping your operations organized and robust.



