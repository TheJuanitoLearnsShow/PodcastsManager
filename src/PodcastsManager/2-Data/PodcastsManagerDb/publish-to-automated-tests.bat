@REM this line does not need to run multiple times. It is only used to ensure the sqlpackage tool is installed and up-to-date
@REM dotnet tool install -g microsoft.sqlpackage

msbuild "PodcastsManagerDb.sqlproj" /p:Configuration=Release

SqlPackage /Action:Publish /SourceFile:".\bin\release\PodcastsManagerDb.dacpac" /TargetConnectionString:"Data Source=.\sqlExpress;Database=AutomatedTESTS_PodcastsManager;Integrated Security=True;TrustServerCertificate=True;" /p:ScriptDatabaseCompatibility=True /p:BlockOnPossibleDataLoss=False
