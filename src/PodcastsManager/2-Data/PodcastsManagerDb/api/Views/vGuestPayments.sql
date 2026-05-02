CREATE VIEW [dbo].[vGuestPayments]
AS
SELECT [PaymentId]
	,[Amount]
	,[PaymentDate]
FROM [$(PaymentsDb)].api.vPayments
