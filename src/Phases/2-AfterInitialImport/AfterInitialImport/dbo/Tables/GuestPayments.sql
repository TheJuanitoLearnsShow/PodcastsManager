CREATE TABLE [dbo].[GuestPayments] (
    [PaymentId] INT   IDENTITY (1, 1) NOT NULL,
    [GuestId]   INT   NOT NULL,
    [Amount]    MONEY NOT NULL,
    [GuestLastName] [LastName],
    PRIMARY KEY CLUSTERED ([PaymentId] ASC)
);

