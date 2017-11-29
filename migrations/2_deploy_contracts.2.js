var EtherealizeToken = artifacts.require("./EtherealizeToken.sol");

module.exports = function(deployer) {
    deployer.deploy(EtherealizeToken);
};