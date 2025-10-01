CREATE PROCEDURE [tests].[spTest_Dummy]
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		--Arrange 

		-- Act
		SELECT 'Hi!' [Greeting];

		-- Assert
		SELECT 'Dummy Tests' [TestDescription]
			,'FAIL' [TestResult]
			,'Awesome!!!' [TestOutcomeExplanation]

		ROLLBACK TRANSACTION;
	END TRY

	BEGIN CATCH
		-- opportunity to retry the transaction.
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE();

		RAISERROR (
				@ErrorMessage
				,@ErrorSeverity
				,@ErrorState
				);
	END CATCH
END
