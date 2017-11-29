### Development steps thus far

```
cd ~/etherealize-ico
truffle init
```

# Modify the truffle.js config to point to a TestRPC node

```
cat truffle.js
```
```
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*"
    }
  }
};
```

# Prior to writing an ICO contract, this project will need to import zepplin-solidity npm library to import other contract code bases - industry standard

```
~/etherealize-ico$ node --version
v8.8.1

npm init
npm install zepplin-solidity -S
```

# Go to the contracts directory created by truffle and begin coding the solidity contract

```
cat contracts/EtherealizeToken.sol
```
```
pragma solidity ^0.4.4;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';

// Define a contract
contract EtherealizeToken is StandardToken {
    // Set a name for the token
    string public name = "Etherealize";
    // Set a symbol for the token
    string public symbol = "ETR";
    // Specify to what number of decimals the token be divisible to
    uint public decimals = 10;
    // Specify the total token supply upon contract deployment
    uint public INITIAL_SUPPLY = 10000000;
    // Define a constructor
    function EtherealizeToken() {
        // Make totalSupply equal to the INITIAL_SUPPLY
        totalSupply = INITIAL_SUPPLY;
        // Assign the entire initial supply to the individual that interacts with the contract. Eg. msg.sender.
        balances[msg.sender] = INITIAL_SUPPLY;
    }

}
```

# Create a migration file

```
cat migrations/2_deploy_contracts.2.js
```
```
var EtherealizeToken = artifacts.require("./EtherealizeToken.sol");

module.exports = function(deployer) {
    deployer.deploy(EtherealizeToken);
};
```

# Pre-requisite; get ganache-cli (TestRPC) if you don't already have it
```
git clone https://github.com/trufflesuite/ganache-cli.git
cd ganache-cli
docker build -t trufflesuite/ganache-cli .
```

# On the command line bring up theganache-cli docker container to make a TestRPC node available

```
docker run -d -p 8545:8545 trufflesuite/ganache-cli:latest -a 10 --debug
```

# Open the truffle console to expose yourself to the TestRPC web3 libraries and in-line command prompt
```
truffle console
truffle(development)>
```
# To bring your contract up onto the TestRPC blockchain, you must first compile and then migrate
Compile:
```
truffle(development)> compile --reset
Compiling ./contracts/EtherealizeToken.sol...
Compiling ./contracts/Migrations.sol...
Compiling zeppelin-solidity/contracts/math/SafeMath.sol...
Compiling zeppelin-solidity/contracts/token/BasicToken.sol...
Compiling zeppelin-solidity/contracts/token/ERC20.sol...
Compiling zeppelin-solidity/contracts/token/ERC20Basic.sol...
Compiling zeppelin-solidity/contracts/token/StandardToken.sol...

Writing artifacts to ./build/contracts
```
Migrate:
```
truffle(development)> migrate
Using network 'development'.

Running migration: 2_deploy_contracts.2.js
  Deploying EtherealizeToken...
  ... 0xd7d7c902972a6aa49deec276d151d9ccf27e516b2c76525376bcfc503435f769
  EtherealizeToken: 0xf9910dcf665d84a1a5d30fb6e940a1dadb0d5a9a
Saving successful migration to network...
  ... 0xd00eab29956cb6902f00844ccdbd230915927985d95f166c23f6f774d7b9a5c3
Saving artifacts...
```

### Web3 / Truffle commands to interrogate the contract

# Truffle console packs contracts that have been deployed and can be accessed by specifying the contract name followed by .deployed function
```
truffle(development)> EtherealizeToken.deployed().then(function(instance) { app = instance; })
undefined
truffle(development)> app.totalSupply.call()
BigNumber { s: 1, e: 7, c: [ 10000000 ] }
```
# Other
```
> web3.eth.accounts
> var ac1 = web3.eth.accounts[0]
> var ac2 = web3.eth.accounts[1]
> app.totalSupply.call()
> app.functionName(arg1, argn)
> app.functionName.call() 
```
# Using promise

```
> app.totalSupply.call().then(function(result){ console.log(result);})
BigNumber { s: 1, e: 7, c: [ 10000000 ] }
undefined
```

# When calling functions, we can specify the account to send from. By default it will use web3.eth.accounts[0].
```
> var acc = web3.eth.accounts[0]
> app.totalSupply(argn, {from: acc}) << Throws an error at the moment>>
```
# ----------
# Set up contract on actual testnet. eg. ropsten
#### Use a third party node that is already synced with the blockchain to speed up the deployment process
1. Go to https://infura.io/register.html
1. Sign up and obtain the access token 
1. Use one of the below urls in the truffle.js config described further down
Handy blog link: https://blog.infura.io/getting-started-with-infura-28e41844cc89
```
To get started, use the following provider URLs in your code (in place of localhost):

Main Ethereum Network
https://mainnet.infura.io/ 

Test Ethereum Network (Ropsten)
https://ropsten.infura.io/ 

Test Ethereum Network (Rinkeby)
https://rinkeby.infura.io/ 

Test Ethereum Network (Kovan)
https://kovan.infura.io/ 

Test Ethereum Network (INFURAnet)
https://infuranet.infura.io/ 

IPFS Gateway
https://ipfs.infura.io 

IPFS RPC
https://ipfs.infura.io:5001 
```

# Install the needed libraries
```
npm install truffle-hdwallet-provider --save
```
# Get chrome metamask
1. google: https://chrome.google.com/webstore/detail/metamask/
1. add to chrome

# Once installed, click the fox icon top right of chrome. 
1. Accept conditions
1. Create a new wallet - enter in password. Write down and remember.
1. Save the mneomic pass phrase used to recover the wallet. Mneomic is used in cnofig below
1. Obtain the public address of the wallet by copying clipboard.

# Obtain some ether for your test wallet from a metamask Ropsten faucet
1. Select Ropsten Network on metamask plugin on to left
1. Click buy on metamask wallet account
1. Click Ropsten faucet
1. When redirected, click on "request 1 ether from faucet"
1. Ether will be transfered from the faucet towards your (user) wallet. Check back in ~ 1 minute to see your eth received. The transaction id should be seen in the transactions box visible in the browser.
1. Click the transaction if you wish to see the confirmations on the testnet chain.

### Eth is in your testnet wallet and you are now capable of deploying the contract

# Configue truffle to deploy to Ropsten
We are configuring the infura ropsten node as entry point by providing the mnemonic phrase (Metamask / SEttings / Reveal / Seed words)

```
cat truffle.js
```
```
var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "XXXXXX";
var mnemonic = "twelve words you can find in metamask/settings/reveal seed words blabla";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*"
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey),
      network_id: 3,
      gas: 4712388
    }
  }
}
```
# Deploy to Ropsten 
```
rm -rf build
truffle migrate --network ropsten
Spanning multiple lines.

Writing artifacts to ./build/contracts

Using network 'ropsten'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0x331ea345f345cd2b86e7f2f56618fb69b8ea5c8ad825702da84ea2849e5cf994
  Migrations: 0xfa24e7f1287a220c192a3cff8f34c267314fce81
Saving successful migration to network...
  ... 0x256be64c311ae19a14ed2cb1b39946c09b53710ce716f115e6be2e586fbdf766
Saving artifacts...
Running migration: 2_deploy_contracts.2.js
  Deploying EtherealizeToken...
  ... 0x6bd64f056672146c0dbad149fbba49c3a8f7399ef6b996d02e7651bd1549ab2e
  EtherealizeToken: 0x55df04e4f13a7b54aa1e5f108975395d455c088d
Saving successful migration to network...
  ... 0xba1fd70ffc83af4841e7f445041c9dfdbcb68e644ca548bddd5b9415dc533c01
Saving artifacts...
```

# Search your contract address from output above eg. EtherealizeToken: <contract address>
1. https://ropsten.etherscan.io/address/0x55df04e4f13a7b54aa1e5f108975395d455c088d#code

# Verify your contract and put it up at the address by going to
1. https://ropsten.etherscan.io/verifyContract2
1. Verify what version of Solidity compiler you used on your machine 
```
truffle console
truffle(development)> var version = soljson.cwrap('version', 'string', []);
Truffle v4.0.1 (core: 4.0.1)
Solidity v0.4.18 (solc-js) 
```
1. Prepare to flatten your source code because if you used truffle, you have import statements and need to modify them, so go to new directory and do the following OR collate all your imported .sol files into a single block of code. Ensure that all imported .sol files are defined above their first usage within the calling contracts.
```
sudo ap install python-pip3
pip3 install solidity-flattener
# code and issues at https://github.com/BlockCatIO/solidity-flattener
```
```
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
```
cd contracts/
solidity_flattener --output EtherealizeTokenFlattened.sol EtherealizeToken.sol
```
1. Copy your contract source code into the form field
1. Verify and Submit
1. Your contract should be submitted


# Handy JSON RPC Link 
https://github.com/ethereum/wiki/wiki/JSON-RPC

