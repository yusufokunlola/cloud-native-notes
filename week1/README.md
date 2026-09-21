# ***Are You Ready?***

Get your environment ready! As an engineer, you have to figure out some things on the go by yourself by reading and searching. We learn by doing to become better engineers.

In the bootcamp, **Tasks** are provided for you to complete. Read through and understand them. You are to solve the problems presented in the tasks. Learning to search for information and actually implementing it yourself is a skill you will learn. 

The **Extra Challenge** contains tasks that help you dive deeper and explore. Some are requirements to complete future tasks.

The **To Think About** section helps you understand why and how.

**Solution Guide** contains: 
1. helpful codes or documentation that would guide you to the solution, 
2. actual solution to some task or
3. nothing about the solution so that you can think deep and make thing work. 

So, rather than mindlessly copying answers from AI chatbots, try to understand the rationale behind the answers given by AI. 

**Things would break. You have to fix them.** ***Think and act like an engineer!***

## Week 1 - Tasks

Install the following:
1. Docker
2. kubectl
3. Kind
4. Git
5. Python 3
6. VS Code 
7. Helm


## Extra Challenge
1. Create 3 nodes on Kind 
    - one control plane and 
    - two worker nodes

2. Create a cluster in Kind and export the kubeconfig 

## To Think About
- What is the use of each program installed?


## Solution Guide
- [Install Docker](https://docs.docker.com/engine/install/ "Docker")

- [Install *kubectl*](https://kubernetes.io/docs/tasks/tools/ "Kubectl")
    

    or simply run on the terminal
    ```
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    ```

- [Install Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation "Kind")

- [Install Git](https://git-scm.com/install/ "Git")

- [Install Python](https://www.python.org/downloads/ "Python 3")

     Note that some Operating Systems have a Python installed by default.

- [Download VS Code](https://code.visualstudio.com/download "VS Code")

- [Install Helm](https://helm.sh/docs/intro/install/ "Helm") 

    or simply run `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash`


## Verify your installation 

Run the verification script `./verify-week1.sh`

If your verification score is 100%, you are good to go!

If not, read the report and rectify the error(s).

If you are stucked after several trials, ask for help in the group.

### Welcome to the Handson Academy Bootcamp!


