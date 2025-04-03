CREATE PROCEDURE [dbo].[spIssuePayment]
	@GuestId int
AS
	declare @tonsOfMoney$$$ money = 400000000
	declare @amountToPay money = 
	(
		select 
			case when g.GuestName like '%tarquino%' then @tonsOfMoney$$$
			else g.ChefRating * 100.01
		end
		from PodcastGuests g 
		where GuestId = @GuestId
	);
	insert into [dbo].GuestPayments(
	GuestId,
	Amount)
	select @GuestId, @amountToPay

	select * from [dbo].GuestPayments where PaymentId = SCOPE_IDENTITY()