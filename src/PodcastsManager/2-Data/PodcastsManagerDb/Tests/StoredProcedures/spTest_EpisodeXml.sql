CREATE PROCEDURE [tests].[spTest_EpisodeXml]
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		--Arrange 
		DECLARE @EpisodeXml VARCHAR(MAX);

		--- clear data and add one episode
		DELETE dbo.EpisodesPublished;

		INSERT dbo.EpisodesPublished (
			[EpisodeId]
			,[Title]
			,[Description]
			,[PublishedOn]
			,[Url]
			,[Duration]
			,[AudioFileSize]
			)
		SELECT 1
			,'Test Title'
			,'Test Description'
			,'2025-01-01'
			,'http://url'
			,30
			,56789;

		-- Act
		SELECT @EpisodeXml = CONVERT(VARCHAR(MAX), x.EpisodeXml)
		FROM dbo.[fnGetEpisodesRssXml](0, 99999) x;

		-- Assert
		SELECT *
		FROM dbo.EpisodesPublished;

		SELECT @EpisodeXml XmlProduced;

		DECLARE @dateWrongMsg VARCHAR(512) = CASE 
				WHEN @EpisodeXml LIKE '%Wed%'
					THEN NULL
				ELSE 'Date is not properly formated: ' + @EpisodeXml
				END;

		SELECT 'Is Date Formated Correctly' [TestDescription]
			,CASE 
				WHEN @dateWrongMsg IS NULL
					THEN 'PASS'
				ELSE 'FAIL'
				END [TestResult]
			,@dateWrongMsg [TestOutcomeExplanation]

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
