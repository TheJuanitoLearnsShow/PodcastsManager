CREATE VIEW [dbo].[vEpisodesAndGuests]
AS
SELECT [EpisodeId]
	,[Title]
	,[Description]
	,[PublishedOn]
	,[Url]
	,[Duration]
	,[AudioFileSize]
	,g.[GuestId]
	,g.[GuestName]
	,g.[ChefRating]
FROM dbo.EpisodesPublished e
inner join dbo.PodcastGuests g
on e.GuestId = g.GuestId
