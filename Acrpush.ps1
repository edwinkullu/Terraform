
az login --service-principal -u "39c95471-bcfc-4bdc-b53d-eef346ab1a89" -p "YLx8Q~uJzzU4LUrX2G0hQsHZRVUv~f4lG.5.NcEt" --tenant "4ec9e9d4-1dad-427f-adf9-e774dca413d1"
az acr login -n azureregistery02

$copydockerapifilepath="System.DefaultWorkingDirectory/_testweb-CI/drop/Webapp"
#git init
#git config --global user.name "edwin kullu"
#git config --global user.email "edwinkullu94@gmail.com"

git clone --depth 1 https://github.com/edwinkullu/Webapp.git "$copydockerapifilepath"

$tag =" "
$tag = "__WebAppImageTag__"
$registrybaseurl = "azureregistery02.azurecr.io"

$imagename = "$registrybaseurl/webapp:$tag"
#Copy-Item -Path "$copydockerapifilepath/Webapp/Webapp/Webapp/Dockerfile" -Destination $copydockerapifilepath/Webapp/Webapp
Set-Location "$copydockerapifilepath/Webapp/"

Write-Output "--------------------- BUILDING IMAGE ---------------------"
docker build --rm ./ -t $imagename


#Remove-Item -Path "$copydockerapifilepath/Terraform/Dockerfile"
Write-Output "--------------------- PUSHING   IMAGE ---------------------"
docker push $imagename

Write-Output "=====================REMOVE IMAGE============================="
docker rmi $imagename



