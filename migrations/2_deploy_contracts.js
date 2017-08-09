var VerifyProof = artifacts.require("./imported/VerifyProof.sol");
var ECMath = artifacts.require("./imported/ECMath.sol");
var ParseProof = artifacts.require("./imported/ParseProof.sol");
var JsmnSolLib = artifacts.require("./imported/JsmnSolLib.sol");
var tlsnutils = artifacts.require("./imported/tlsnutils.sol");
var bytesutils = artifacts.require("./imported/bytesutils.sol");
var BTCPriceFeed = artifacts.require("./imported/BTCPriceFeed.sol");

module.exports = function(deployer) {
  deployer.deploy(JsmnSolLib);
  deployer.deploy(ECMath);
  deployer.deploy(ParseProof);
  deployer.link(ECMath, VerifyProof);
  deployer.link(ParseProof, VerifyProof);
  deployer.deploy(VerifyProof);
  deployer.deploy(bytesutils);
  deployer.deploy(tlsnutils);
  deployer.link(JsmnSolLib, BTCPriceFeed);
  deployer.link(VerifyProof, BTCPriceFeed);
  deployer.link(tlsnutils, BTCPriceFeed);
  deployer.deploy(BTCPriceFeed);
};
