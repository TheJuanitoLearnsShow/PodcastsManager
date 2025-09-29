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

CREATE TYPE [dbo].[Url]
	FROM varchar(250) NOT NULL
GO

CREATE TYPE [dbo].[Duration]
	FROM smallint NOT NULL
GO

CREATE TYPE [dbo].[AudioFileSize]
	FROM int NOT NULL
GO

CREATE TYPE [dbo].[LastName]
	FROM varchar(160) NOT NULL
GO

CREATE TYPE [dbo].[FirstName]
	FROM varchar(100) NOT NULL
GO

CREATE TYPE [dbo].[EmailAddress]
	FROM varchar(150) NOT NULL
GO

CREATE TYPE [dbo].[GuestName]
	FROM varchar(120) NOT NULL
GO

CREATE TYPE [dbo].[GuestId]
	FROM int NOT NULL
GO

CREATE TYPE [dbo].[Rating]
	FROM int NOT NULL
GO
