using System.Threading.Tasks;
using Nethereum.Contracts;
using Nethereum.Web3;

public class ListenEvents
{
    // 你的合约地址和ABI
    private static string contractAddress = "your_contract_address";
    private static string abi = "Your ABI";

    public static async Task Main(string[] args)
    {
        // 创建Web3实例
        Web3 web3 = new Web3("https://mainnet.infura.io");

        // 创建合约实例
        Contract contract = web3.Eth.GetContract(abi, contractAddress);

        // 创建过滤器
        var filterAll = await contract.Event("ListingForSale").CreateFilterAsync();

        // 循环查询新的事件
        while (true)
        {
            var log = await contract.Event("ListingForSale").GetFilterChanges<ListingForSaleEventDTO>(filterAll);
            foreach (var e in log)
            {
                // 在这里，你可以把事件的信息存储到你的数据库
                System.Console.WriteLine($"Block: {e.Log.BlockNumber.Value}, Seller: {e.Event.Seller}, Token ID: {e.Event.TokenId}, Price: {e.Event.Price}");
            }

            // 等待一段时间后再查询新的事件
            await Task.Delay(10000);
        }
    }
}
