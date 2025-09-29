CREATE FUNCTION [dbo].[fnGetEpisodesRssXml]
(
	@StartEpisodeId [EpisodeId],
	@EndEpisodeId [EpisodeId]
)
RETURNS TABLE AS RETURN
( 

    WITH XMLNAMESPACES (
        'http://www.itunes.com/dtds/podcast-1.0.dtd' AS itunes
    )
    SELECT 
        (
            SELECT 
                e.EpisodeId AS 'guid',
                e.[Url] AS 'enclosure/@url',
                'audio/mpeg' AS 'enclosure/@type',
                e.[AudioFileSize] AS 'enclosure/@length',
                '1' AS 'itunes:season',
                e.EpisodeId AS 'itunes:episode',
                FORMAT(e.PublishedOn, 'ddd, dd MMM yyyy HH:mm:ss ''EST''') AS 'pubDate',
                e.[Title] AS 'title',
                e.[Description] AS 'description',
                '00:' + format(e.[DurationInMinutes], '00') + ':00' AS 'itunes:duration',
                'false' AS 'itunes:explicit',
                'full' AS 'itunes:episodeType'
            FROM EpisodesPublished e
            WHERE e.EpisodeId BETWEEN @StartEpisodeId AND @EndEpisodeId
            FOR XML PATH('item'), TYPE
        ) AS EpisodeXml
)
