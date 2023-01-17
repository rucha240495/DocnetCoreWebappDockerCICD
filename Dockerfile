#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

# STAGE01 - Build application and its dependencies
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["DocnetCoreWebappDockerCICD.csproj", ""]
RUN dotnet restore "./DocnetCoreWebappDockerCICD.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DocnetCoreWebappDockerCICD.csproj" -c Release -o /app/build
RUN echo "test"

# STAGE02 - Publish the application
FROM build AS publish
RUN dotnet publish "DocnetCoreWebappDockerCICD.csproj" -c Release -o /app/publish

#In this stage we use the .Net Core Runtime as our base layer and copy the binaries
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DocnetCoreWebappDockerCICD.dll"]
