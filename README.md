# MultiTierARM
Create a domain with 2 DC's, Mid Tier Servers and Member Servers

* Each machine has it's own Public IP address that you can connect

* Review the alternate project for using a LoadBalancer and single Public IP address

    __https://github.com/brwilkinson/MultiTierARMLoadBalance__

## Steps to get up and running
    1. Download the zip file or clone the repo
    2. Right click and open the solution MTLoadBalance.sln
    3. In solution explorer, Right click on the solution and click Build Solution

 You should now be ready deploy:

* Ensure you setup the KeyVault for your credentials during deployment, in the same region that you want to deploy

* View the DeploymentFeatures.md file
