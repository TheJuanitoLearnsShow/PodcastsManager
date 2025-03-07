
-- Episodes that have been successfully published to the feed
CREATE TABLE dbo.EpisodesPublished
(
	[EpisodeId] [EpisodeId] PRIMARY KEY,
	[Title] [EpisodeTitle],
	[Description] [EpisodeDescription],
	[PublishedOn] [PublishDate]
)
