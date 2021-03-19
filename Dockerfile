FROM --platform=${BUILDPLATFORM} \
    mcr.microsoft.com/dotnet/sdk:5.0.201 AS build-env
WORKDIR /app

# Git is a requirement.
RUN apt-get update; apt-get install git

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet build -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:5.0.4-alpine3.13
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "Fortebass.dll"]