CREATE TABLE [dbo].[PodcastGuests] (
    [GuestId]    INT           IDENTITY (1, 1) NOT NULL,
    [GuestName]  VARCHAR (120) NOT NULL,
    [ChefRating] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([GuestId] ASC)
);

