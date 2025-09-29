
-- Episodes that have been successfully published to the feed
CREATE TABLE dbo.EpisodesPublished
(
	[EpisodeId] [EpisodeId] PRIMARY KEY,
	[Title] [EpisodeTitle],
	[Description] [EpisodeDescription],
	[PublishedOn] [PublishDate],
	[Url] [Url],
	[Duration] [Duration],
	[AudioFileSize] [AudioFileSize],
	[GuestId] [dbo].[GuestId], 
    CONSTRAINT [FK_EpisodesPublished_PodcastsGuests] FOREIGN KEY ([GuestId]) REFERENCES dbo.[PodcastGuests]([GuestId])
)
