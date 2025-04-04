CREATE TABLE [dbo].[PodcastGuests] (
    [GuestId]    [GuestId]          ,
    [GuestName]  [GuestName],
    [ChefRating] [Rating],
    PRIMARY KEY CLUSTERED ([GuestId] ASC), 
    CONSTRAINT [CK_PodcastGuests_Rating] CHECK ([ChefRating] between 0 and 5)
);

