#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DemoCoreWebAPI2/DemoCoreWebAPI2.csproj", "DemoCoreWebAPI2/"]
RUN dotnet restore "DemoCoreWebAPI2/DemoCoreWebAPI2.csproj"
COPY . .
WORKDIR "/src/DemoCoreWebAPI2"
RUN dotnet build "DemoCoreWebAPI2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DemoCoreWebAPI2.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DemoCoreWebAPI2.dll"]