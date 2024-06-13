### Step-by-Step Guide to Create the Freestyle Job

1.  **Open Jenkins Dashboard:**
    
    - Access Jenkins by navigating to `http://localhost:8022` in your web browser.
2.  **Create a New Freestyle Project:**
    
    - Click on "New Item" in the left-hand menu.
    - Enter an item name, for example, `FirstFreestyleJob`.
    - Select "Freestyle project" and click "OK".
3.  **Configure the Job:**
    
    - In the configuration page, scroll down to the "Build" section.
    - Click on "Add build step" and select "Execute shell".
4.  **Add the Bash Script:**
    
    - In the "Command" text box, enter the following bash script:

```
#!/bin/bash

echo "Starting Jenkins Freestyle Job"
echo "
 _____              _             _ 
|_   _|            (_)           | |
  | |  _ ____   ___ _ _ __   __ _| |
  | | | '_ \ \ / / | | '_ \ / _\` | |
 _| |_| | | \ V /| | | | | | (_| |_|
|_____|_| |_|\_/ |_|_|_| |_|\__, (_)
                              __/ |  
                             |___/   
"
echo "Job Completed Successfully!"
```

1.  **Save the Configuration:**
    
    - Click "Save" at the bottom of the configuration page.
2.  **Run the Job:**
    
    - After saving the configuration, you will be taken to the project page for your new job.
    - Click "Build Now" in the left-hand menu to run the job.
3.  **View the Build Output:**
    
    - Click on the build number under the "Build History" on the left.
    - Click on "Console Output" to see the output of your job, which will include the ASCII art of Jenkins.
