--demonstration of how to include mutliple sql objects in one file

CREATE TYPE [dbo].[EpisodeDescription]
	FROM varchar(250) NOT NULL
GO -- GO is needed to separate our definitions

CREATE TYPE [dbo].[EpisodeId]
	FROM int NOT NULL
GO

CREATE TYPE [dbo].[FilePath]
	FROM varchar(255) NOT NULL
GO

CREATE TYPE [dbo].[PublishDate]
	FROM datetimeoffset NOT NULL
GO