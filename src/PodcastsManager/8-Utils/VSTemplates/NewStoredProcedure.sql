CREATE PROCEDURE $SchemaQualifiedObjectName$
    @param1 int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        IF XACT_STATE() <> 0 
            ROLLBACK TRANSACTION;
        
        SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );
    END CATCH
END