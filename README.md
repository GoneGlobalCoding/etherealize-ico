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

### Set up ACTUAL testnet chain and miner on Ubuntu local machine
TBA

