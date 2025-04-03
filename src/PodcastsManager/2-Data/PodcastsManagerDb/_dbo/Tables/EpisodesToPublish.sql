-- "outbox" pattern table to hold those episodes that need to be queued for publishing by external .net process
CREATE TABLE [dbo].[EpisodesToPublish]
(
	[EpisodeId] int not null PRIMARY KEY identity,
	[Title] [EpisodeTitle],
	[Description] [EpisodeDescription],
	[AudioFilePath] [FilePath]
)
