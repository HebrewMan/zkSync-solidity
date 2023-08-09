using System.Threading.Tasks;
using Nethereum.Contracts;
using Nethereum.Web3;

public class ScanBlocks
{
    // 你的合约地址和ABI
    private static string contractAddress = "your_contract_address";
    private static string abi = "Your ABI";

    // 设置开始和结束区块的高度
    private static ulong startBlock = 0;
    private static ulong endBlock = ulong.MaxValue;  // 你也可以设置一个具体的区块高度

    public static async Task Main(string[] args)
    {
        // 创建Web3实例
        Web3 web3 = new Web3("https://mainnet.infura.io");

        // 创建合约实例
        Contract contract = web3.Eth.GetContract(abi, contractAddress);

        // 扫描区块
        for (ulong i = startBlock; i <= endBlock; i++)
        {
            var filterInput = contract.Event("ListingForSale").CreateFilterInput(new BlockParameter(i), new BlockParameter(i));
            var events = await web3.Eth.Filters.GetFilterChangesForEvent<ListingForSaleEventDTO>(filterInput);
            foreach (var e in events)
            {
                // 在这里，你可以把事件的信息存储到你的数据库
                System.Console.WriteLine($"Block: {e.Log.BlockNumber.Value}, Seller: {e.Event.Seller}, Token ID: {e.Event.TokenId}, Price: {e.Event.Price}");
            }
        }
    }
}
