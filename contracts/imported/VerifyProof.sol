pragma solidity ^0.4.8;

import "./ECMath.sol";
import "./ParseProof.sol";

library VerifyProof {


  function verifyProof(bytes memory proof) returns(bool) {
    uint256 qx = 0xd1a5bb464bdcedfaed55610d4bc6d0683ecb87a9bb57c1849a84810c4877a658; //public key x-coordinate signer
    uint256 qy = 0xb646431a722873a1626bddbb19d111a19045d4909a9da45d7d55de77a5e98f03; //public key y-coordinate signer
    return verifyProof(proof, qx, qy);
  }

  function verifyProof(bytes memory proof, uint256 qx, uint256 qy) returns(bool) {
    bytes32 m; // Evidence Hash in bytes32
    uint256 e; // Evidence Hash in uint256
    uint256 sig_r; //signature parameter
    uint256 sig_s; //signature parameter

	// Returns ECC signature parts and the evidence hash
    (sig_r, sig_s, m) = ParseProof.parseProof(proof);

    // Convert evidence hash to uint
	e = uint256(m);

    // Verify signature
    return ECMath.ecdsaverify(qx, qy, e, sig_r, sig_s);

  }

}
