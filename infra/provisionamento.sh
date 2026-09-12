az login

az group create --name RG-Challenge-DevOps --location eastus

az acr create --resource-group RG-Challenge-DevOps --name acrchallengedevops2026 --sku Basic --admin-enabled true

az container create --resource-group RG-Challenge-DevOps --name db-container --image gvenzl/oracle-free:slim-faststart --os-type Linux --cpu 1 --memory 2.0 --environment-variables ORACLE_PASSWORD="ClyvoOracle2026!" APP_USER="admin" APP_USER_PASSWORD="ClyvoOracle2026!" --dns-name-label db-clyvo-devops --ports 1521

az container create --resource-group RG-Challenge-DevOps --name api-container --image acrchallengedevops2026.azurecr.io/api-clyvo:latest --os-type Linux --cpu 1 --memory 1.5 --registry-login-server acrchallengedevops2026.azurecr.io --registry-username acrchallengedevops2026 --registry-password <COLE_A_SENHA_DO_ACR_AQUI> --dns-name-label api-clyvo-devops --ports 8080 --environment-variables ConnectionStrings__DefaultConnection="Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=db-clyvo-devops.eastus.azurecontainer.io)(PORT=1521)))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=FREEPDB1)));User Id=admin;Password=ClyvoOracle2026!;"