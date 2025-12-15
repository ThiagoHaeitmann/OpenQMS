# ===== Build stage =====
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia tudo e publica
COPY . .
RUN dotnet restore ./OpenQMS.csproj
RUN dotnet publish ./OpenQMS.csproj -c Release -o /app/publish --no-restore

# ===== Runtime stage =====
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Porta padrão do teu app
EXPOSE 80
ENV ASPNETCORE_URLS=http://0.0.0.0:80

# Copia o publish
COPY --from=build /app/publish .

# DataProtection keys (IMPORTANTE pra parar erro de antiforgery depois de restart)
# A app por padrão guarda chaves em /root/.aspnet/DataProtection-Keys
# (você vai montar um volume nesse path no Nomad depois)
ENTRYPOINT ["dotnet", "OpenQMS.dll"]
