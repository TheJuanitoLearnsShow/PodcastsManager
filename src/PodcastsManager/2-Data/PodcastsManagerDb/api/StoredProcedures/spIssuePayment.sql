CREATE PROCEDURE [api].[spIssuePayment] @GuestId INT
AS
DECLARE @tonsOfMoney$$$ MONEY = 400000000
DECLARE @amountToPay MONEY = (
		SELECT CASE 
				WHEN g.GuestName LIKE '%tarquino%'
					THEN @tonsOfMoney$$$
				ELSE g.ChefRating * 100.01
				END
		FROM PodcastGuests g
		WHERE GuestId = @GuestId
		);

INSERT INTO [dbo].GuestPayments (
	GuestId
	,Amount
	)
SELECT @GuestId
	,@amountToPay

SELECT [PaymentId], [GuestId], [Amount]
FROM [dbo].GuestPayments
WHERE PaymentId = SCOPE_IDENTITY()
