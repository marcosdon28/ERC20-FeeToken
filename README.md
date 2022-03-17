# ERC20-FeeToken
This project is a ERC20 token that includes Ownable functions and burnable functions, this have a transaction fees implementes with exclude address and deflationary economy.

How this token works ?
ProjectFee,PFEE is a normal erc20 token but when you transfer the function repart a percent of tokens into to a diferents wallets.
Owner,marketing and burn is easy to explain. The function transfer balance and substract this part for the num of tokens that recipient will receive.
with the holders rewards is different. I created a tokenPool with increments her value in base to Tokens fees from holders i also change the function balanceOf()
to display the balance of owner + the amount of tokens that they have in the pool.

Implementations:
transfer() WITH FEES that goes to: OwnerAddress, marketingAddress, TokenHolders, burned.
excludeAddress() to exclude an address from pay transaction fees.
changeFees()this contract have diferents functions to change OwnerReward, marketingReward, burnedAmount, HodersReward.
changeMarketingWallet() this function allows the owner to change the marketingAddress 
And anotherfunctions to view ownerAddress,marketingAddres, if an address is excluded from pay fees, etc.

this token also contains the basic functions of ERC20 TOKEN and OwnableToken.
You can see them here
ERC20 : https://github.com/marcosdon28/ERC20-FeeToken/blob/79ac19bab66f45c7c70bf36f449f211ab162831c/IERC20.sol
OWNABLE : https://github.com/marcosdon28/ERC20-FeeToken/blob/79ac19bab66f45c7c70bf36f449f211ab162831c/Ownable.sol


pending functions:
nativeChainTokenFee take a fee of the ERC20 token and convert it into native chain token



