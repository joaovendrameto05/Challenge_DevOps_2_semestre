az login
az group create --name RG-Challenge-DevOps --location eastus
az acr create --resource-group RG-Challenge-DevOps --name acrchallengedevops2026 --sku Basic --admin-enabled true
az container create --resource-group RG-Challenge-DevOps --name db-container --image postgres:15-alpine --os-type Linux --cpu 1 --memory 1.5 --environment-variables POSTGRES_USER=admin POSTGRES_PASSWORD=admin POSTGRES_DB=clyvodata --dns-name-label db-clyvo-devops --ports 5432
az container create --resource-group RG-Challenge-DevOps --name api-container --image acrchallengedevops2026.azurecr.io/api-clyvo:latest --os-type Linux --cpu 1 --memory 1.5 --registry-login-server acrchallengedevops2026.azurecr.io --registry-username acrchallengedevops2026 --registry-password <SENHA_DO_ACR> --dns-name-label api-clyvo-devops --ports 8080 --environment-variables ConnectionStrings__DefaultConnection="Host=db-clyvo-devops.eastus.azurecontainer.io;Database=clyvodata;Username=admin;Password=admin;"
