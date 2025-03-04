using System.Data;
using System.Text;
using Microsoft.Data.SqlClient;
using Xunit.Abstractions;

namespace DatabaseTestRunner;

public static class DbTestManager {
    public static TheoryData<string> GetTestStoredProcedures()
    {
        var connectionString = "your_connection_string_here";
        var query = @"
                SELECT SPECIFIC_NAME 
                FROM INFORMATION_SCHEMA.ROUTINES 
                WHERE ROUTINE_TYPE = 'PROCEDURE' 
                AND ROUTINE_SCHEMA = 'tests'
                and SPECIFIC_NAME like '%.test_%'";

        var theoryData = new TheoryData<string>();

        using var connection = new SqlConnection(connectionString);
        var command = new SqlCommand(query, connection);
        connection.Open();
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            theoryData.Add(reader.GetString(0));
        }

        return theoryData;
    }

    public static DbTestResult? GetTestResult(SqlDataReader reader)
    {
        if (reader.HasColumn("TestResult"))
        {
            var testResult = reader["TestResult"].GetDisplayString();
            var testDescription = reader.GetDisplayString("TestDescription") ;
            var testOutcomeExplanation = reader.GetDisplayString("TestOutcomeExplanation";

            // Process the retrieved values as needed
            return new DbTestResult(testResult, testDescription, testOutcomeExplanation);
        }

        return null;
    }

    private static bool HasColumn(this SqlDataReader reader, string columnName)
    {
        for (int i = 0; i < reader.FieldCount; i++)
        {
            if (reader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }
        }
        return false;
    }

    private static string GetDisplayString(this SqlDataReader reader, string columnName)
    {
        return reader.HasColumn(columnName) ? reader[columnName].GetDisplayString() : string.Empty;
    }

    private static string GetDisplayString(this object o)
    {
        return o.ToString() ?? string.Empty;
    }

    public static void MapToDelimited(string[] headers, string[][] values)
    {
        var sb = new StringBuilder();
        var columnWidths = new int[headers.Length];

        // Determine the width of each column
        for (int i = 0; i < headers.Length; i++)
        {
            columnWidths[i] = headers[i].Length;
        }

        foreach (var row in values)
        {
            for (int i = 0; i < row.Length; i++)
            {
                if (row[i].Length > columnWidths[i])
                {
                    columnWidths[i] = row[i].Length;
                }
            }
        }

        // Create the header row
        for (int i = 0; i < headers.Length; i++)
        {
            sb.Append("| ").Append(headers[i].PadRight(columnWidths[i])).Append(" ");
        }
        sb.AppendLine("|");

        // Create the separator row
        for (int i = 0; i < headers.Length; i++)
        {
            sb.Append("|-").Append(new string('-', columnWidths[i])).Append("-");
        }
        sb.AppendLine("|");

        // Create the data rows
        foreach (var row in values)
        {
            for (int i = 0; i < row.Length; i++)
            {
                sb.Append("| ").Append(row[i].PadRight(columnWidths[i])).Append(" ");
            }
            sb.AppendLine("|");
        }
    }
    public static async Task ExecuteTestStoredProc(string connectionString, string spName, 
        ITestOutputHelper testOutputHelper)
    {
        await using var connection = new SqlConnection(connectionString);
        var command = new SqlCommand(spName, connection);
        command.CommandType = CommandType.StoredProcedure;
        connection.Open();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            var testResult = GetTestResult(reader);
            if (testResult != null)
            {
                if (!testResult.TestResult.Equals("PASS", StringComparison.OrdinalIgnoreCase))
                {
                    var msg =
                        $"{spName}: Test {testResult.TestDescription} failed: {testResult.TestOutcomeExplanation}";
                    Assert.Fail(msg);
                }
            }
        }
    }
}

public record DbTestResult(string TestResult, string TestDescription, string TestOutcomeExplanation);