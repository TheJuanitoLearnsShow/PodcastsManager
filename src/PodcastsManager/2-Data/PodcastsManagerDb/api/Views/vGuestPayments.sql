CREATE VIEW [dbo].[vGuestPayments]
AS
SELECT [PaymentId]
	,[Amount]
	,[PaymentDate]
FROM [$(PaymentsDb)].api.vPayments
left join dbo.Reviews
on 1=1
