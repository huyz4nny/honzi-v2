# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY ["HonZi.Web/HonZi.Web.csproj", "HonZi.Web/"]
RUN dotnet restore "HonZi.Web/HonZi.Web.csproj"

# Copy everything else and build Release
COPY . .
WORKDIR "/src/HonZi.Web"
RUN dotnet publish "HonZi.Web.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_HTTP_PORTS=8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "HonZi.Web.dll"]
