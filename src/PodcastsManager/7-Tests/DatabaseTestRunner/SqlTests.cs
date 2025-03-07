using System.Threading.Tasks;
using Xunit.Abstractions;

namespace DatabaseTestRunner;

public class SqlTests
{
    private readonly ITestOutputHelper _testOutputHelper;

    public SqlTests(ITestOutputHelper testOutputHelper)
    {
       _testOutputHelper = testOutputHelper;
    }

    [Theory]
    [MemberData(nameof(DbTestManager.GetTestStoredProcedures), MemberType = typeof(DbTestManager))]
    public async Task TestStoredProcedures(string spName)
    {
        await DbTestManager.ExecuteTestStoredProc(
            spName,
            _testOutputHelper,
            default);
    }

}