
-- Episodes that have been successfully published to the feed
CREATE TABLE dbo.EpisodesPublished
(
	[EpisodeId] [EpisodeId] PRIMARY KEY,
	[Title] [EpisodeTitle],
	[Description] [EpisodeDescription],
	[PublishedOn] [PublishDate],
	[Url] [Url],
	[DurationInMinutes] [Duration],
	[AudioFileSize] [AudioFileSize],
	[GuestId] [GuestId], 
	[EncodingType] varchar(20) default ('mp3') NOT NULL,
    CONSTRAINT [FK_EpisodesPublished_PodcastsGuests] FOREIGN KEY ([GuestId]) REFERENCES dbo.[PodcastGuests]([GuestId])
)
