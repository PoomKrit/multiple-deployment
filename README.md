# Deployment script for lambda deployment
 This is making your life easier for deploying Lambda module for api gateway

### Prerequisite
- git
### How to use
1. Change variable in **config.sh** for *branch_source*, *branch_merge* and *branch_target*
- **branch_source** is for source branches that you'd like to merge to (eg. dev, qa)
- **branch_merge** is for preparing to merge into target branch
- **branch_target** is for target branch
2. Copy all Gitlab repo URL we'd like to deploy to **url.txt**
3. Run command `chmod +x merge.sh` to give execute permission
4. Run command `./merge.sh` to start
5. Sit down and chill ~ :coffee: