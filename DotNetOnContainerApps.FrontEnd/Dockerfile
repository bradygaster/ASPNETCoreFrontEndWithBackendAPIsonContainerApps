#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DotNetOnContainerApps.FrontEnd/FrontEnd.csproj", "DotNetOnContainerApps.FrontEnd/"]
RUN dotnet restore "DotNetOnContainerApps.FrontEnd/FrontEnd.csproj"
COPY . .
WORKDIR "/src/DotNetOnContainerApps.FrontEnd"
RUN dotnet build "FrontEnd.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FrontEnd.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FrontEnd.dll"]