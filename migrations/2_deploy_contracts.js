var ECMath = artifacts.require("./imported/ECMath.sol");
var JsmnSolLib = artifacts.require("./imported/JsmnSolLib.sol");
var tlsnutils = artifacts.require("./imported/tlsnutils.sol");
var bytesutils = artifacts.require("./imported/bytesutils.sol");
var BTCPriceFeed = artifacts.require("./imported/BTCPriceFeed.sol");

module.exports = function(deployer) {
  deployer.deploy(JsmnSolLib);
  deployer.deploy(ECMath);
  deployer.deploy(bytesutils);
  deployer.link(ECMath, tlsnutils);
  deployer.deploy(tlsnutils);
  deployer.link(JsmnSolLib, BTCPriceFeed);
  deployer.link(tlsnutils, BTCPriceFeed);
  deployer.deploy(BTCPriceFeed);
};
