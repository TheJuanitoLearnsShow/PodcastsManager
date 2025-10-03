CREATE VIEW [api].[vEpisodesAndGuests]
AS
SELECT [EpisodeId]
	,[Title]
	,[Description]
	,[PublishedOn]
	,[Url]
	,[DurationInMinutes]
	,[AudioFileSize]
	,g.[GuestId]
	,g.[GuestName]
	,g.[ChefRating]
	
FROM dbo.EpisodesPublished e
INNER JOIN dbo.PodcastGuests g ON e.GuestId = g.GuestId
