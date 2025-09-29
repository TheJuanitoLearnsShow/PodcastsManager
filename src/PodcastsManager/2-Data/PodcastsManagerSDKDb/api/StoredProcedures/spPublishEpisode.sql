CREATE PROCEDURE [api].[spPublishEpisode]
	@Title [EpisodeTitle],
	@Description [EpisodeDescription],
	@AudioFilePath [FilePath]
AS
	insert into [dbo].[EpisodesToPublish]([Title],
	[Description],
	[AudioFilePath])
	select @Title, @Description, @AudioFilePath
RETURN 0
