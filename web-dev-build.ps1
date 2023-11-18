$ErrorActionPreference = "Stop";

New-Item -ItemType Directory -Force -Path ./build/core-idenity
New-Item -ItemType Directory -Force -Path ./zip
Remove-Item ./build/core-idenity -Recurse -Force
Remove-Item ./zip/* -Recurse -Force

dotnet restore ./src/Presentation/TemplateCore.Presentation.Api/TemplateCore.Presentation.Api.csproj
dotnet publish ./src/Presentation/TemplateCore.Presentation.Api/TemplateCore.Presentation.Api.csproj -c Release --os linux --no-restore -o ./build/core-idenity

Compress-Archive ./build/core-idenity/*  ./zip/core-idenity.zip

ssh root@{{ip-remote}} docker stop {{docker-name}}
ssh root@{{ip-remote}} rm -rf /app/{{folder}}/*

scp ./zip/core-idenity.zip root@{{ip-remote}}:/app/{{folder}}

ssh root@{{ip-remote}} unzip /app/{{folder}}/core-idenity.zip  -d /app/{{folder}}

ssh root@{{ip-remote}} docker start {{docker-name}}