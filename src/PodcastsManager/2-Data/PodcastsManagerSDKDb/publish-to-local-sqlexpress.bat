@REM this line does not need to run multiple times. It is only used to ensure the sqlpackage tool is installed and up-to-date
@REM dotnet tool install -g microsoft.sqlpackage

dotnet build /p:NetCoreBuild=true /p:Configuration=Release

:: The SDK DB build produces PodcastsManagerSDKDb.dacpac; use that filename
SqlPackage /Action:Publish /SourceFile:".\bin\release\PodcastsManagerSDKDb.dacpac" /TargetConnectionString:"Data Source=.\sqlExpress;Database=PodcastsManager;Integrated Security=True;TrustServerCertificate=True;" /p:ScriptDatabaseCompatibility=True /p:BlockOnPossibleDataLoss=False
