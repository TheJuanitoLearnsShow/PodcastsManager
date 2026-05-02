CREATE TABLE [dbo].[Payments]
(
	[PaymentId] INT NOT NULL PRIMARY KEY identity,
	[Amount] DECIMAL(18, 2) NOT NULL,
	[PaymentDate] DATETIME NOT NULL
)
