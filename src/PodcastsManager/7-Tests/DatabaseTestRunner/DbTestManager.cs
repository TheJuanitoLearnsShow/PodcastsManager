using System.Data;
using System.Text;
using Microsoft.Data.SqlClient;
using Xunit.Abstractions;

namespace DatabaseTestRunner;

public static class DbTestManager {
    private const string CONNECTION_NAME = "PodcastsManager";
    private const string PASS_VALUE = "PASS";

    public static TheoryData<string> GetTestStoredProcedures()
    {
        var connectionString = GetConnectionString();
        var query = @"
                SELECT ROUTINE_SCHEMA + '.' + SPECIFIC_NAME 
                FROM INFORMATION_SCHEMA.ROUTINES 
                WHERE ROUTINE_TYPE = 'PROCEDURE' 
                AND ROUTINE_SCHEMA = 'tests'
                and SPECIFIC_NAME like '%spTest_%'
";

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

    private static string GetConnectionString()
    {
        return Environment.GetEnvironmentVariable(CONNECTION_NAME) ?? 
            $"Data Source=.\\sqlExpress;Database=AutomatedTESTS_{CONNECTION_NAME};Integrated Security=True;TrustServerCertificate=True;";
    }

    public static DbTestResult? GetTestResult(SqlDataReader reader)
    {
        if (reader.HasColumn("TestResult"))
        {
            var testResult = reader["TestResult"].GetDisplayString();
            var testDescription = reader.GetDisplayString("TestDescription") ;
            var testOutcomeExplanation = reader.GetDisplayString("TestOutcomeExplanation");

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

    private static string[] MapHeaderToStringArray(this SqlDataReader reader)
    {
        var values = new string[reader.FieldCount];
        for (int i = 0; i < reader.FieldCount; i++)
        {
            values[i] = reader.GetName(i);
        }
        return values;
    }

    private static string[] MapToStringArray(this SqlDataReader reader)
    {
        var values = new string[reader.FieldCount];
        for (int i = 0; i < reader.FieldCount; i++)
        {
            values[i] = reader[i].GetDisplayString();
        }
        return values;
    }

    private static string GetDisplayString(this SqlDataReader reader, string columnName)
    {
        return reader.HasColumn(columnName) ? reader[columnName].GetDisplayString() : string.Empty;
    }

    private static string GetDisplayString(this object o)
    {
        return o.ToString() ?? string.Empty;
    }

    public static string MapToDelimited(string[] headers, string[][] values)
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

        DoSeparatorRow(headers, sb, columnWidths);
        // Create the header row
        for (int i = 0; i < headers.Length; i++)
        {
            sb.Append("| ").Append(headers[i].PadRight(columnWidths[i])).Append(" ");
        }
        sb.AppendLine("|");
        DoSeparatorRow(headers, sb, columnWidths);

        // Create the data rows
        foreach (var row in values)
        {
            for (int i = 0; i < row.Length; i++)
            {
                sb.Append("| ").Append(row[i].PadRight(columnWidths[i])).Append(" ");
            }
            sb.AppendLine("|");
            DoSeparatorRow(headers, sb, columnWidths);
        }
        return sb.ToString();

        static void DoSeparatorRow(string[] headers, StringBuilder sb, int[] columnWidths)
        {
            // Create the separator row
            for (int i = 0; i < headers.Length; i++)
            {
                sb.Append("|-").Append(new string('-', columnWidths[i])).Append("-");
            }
            sb.AppendLine("|");
        }
    }
    public static async Task ExecuteTestStoredProc(
        string spName, 
        ITestOutputHelper testOutputHelper,
        CancellationToken cancellationToken)
    {
        var connectionString = GetConnectionString();
        await using var connection = new SqlConnection(connectionString);
        var command = new SqlCommand(spName, connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        await connection.OpenAsync(cancellationToken);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        var failures = new List<string>();
        do
        {
            string[]? headers = null;
            var values = new List<string[]>();
            while (await reader.ReadAsync(cancellationToken))
            {
                headers ??= reader.MapHeaderToStringArray();
                values.Add( reader.MapToStringArray() );

                var testResult = GetTestResult(reader);

                if (testResult != null)
                {
                    if (!testResult.TestResult.Equals(PASS_VALUE, StringComparison.OrdinalIgnoreCase))
                    {
                        var msg =
                            $"{spName}: Test {testResult.TestDescription} failed: {testResult.TestOutcomeExplanation}";
                        failures.Add(msg);
                    }
                }
            }
            var output = MapToDelimited(headers ?? [], [.. values]);
            testOutputHelper.WriteLine(output);

        } while (await reader.NextResultAsync(cancellationToken));

        if (failures.Count > 0)
        {
            var assertions = failures.Select(BuildFailAssertion).ToArray();
            Assert.Multiple(assertions);
        }
    }

    private static Action BuildFailAssertion(string msg)
    {
        return () => Assert.Fail(msg);
    }
}

public record DbTestResult(string TestResult, string TestDescription, string TestOutcomeExplanation);