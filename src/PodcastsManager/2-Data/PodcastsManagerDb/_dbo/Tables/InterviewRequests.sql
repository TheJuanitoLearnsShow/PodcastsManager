CREATE TABLE [dbo].[InterviewRequests]
(
	[InterviewRequestId] INT identity NOT NULL PRIMARY KEY,
	[LastName] [LastName],
	[FirstName] [FirstName],
	[EmailAddress] [EmailAddress],
	[RequestedOn] Datetimeoffset NOT NULL DEFAULT SYSDATETIMEOFFSET(),
)
