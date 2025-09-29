CREATE ROLE [PodcastAppServiceRole]
go

GRANT Execute ON SCHEMA::api TO [PodcastAppServiceRole]
GO
GRANT select ON SCHEMA::api TO [PodcastAppServiceRole]
GO