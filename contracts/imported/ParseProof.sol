pragma solidity ^0.4.1;

// For 64-byte ECC proofs with SHA256
library ParseProof {

  // Parses the provided proof and returns the signature parts and the evidence hash 
  function parseProof(bytes memory proof) returns(uint256 sig_r, uint256 sig_s, bytes32 hashchain) {

      uint16 readPos = 0; // Initialize index in proof bytes array
      bytes16 times; // Contains Timestamps for signature validation
	  bytes2 len_record; // Length of the record
	  bytes1 generator_originated; // Boolean whether originated by generator
	  bytes memory chunk; // One chunk for hashing
	  bytes16 saltsecret; // Salt secret from proof

      // Parse times
      assembly {
        times := mload(add(proof, 40))
      }
      readPos += 32; //update readPos, skip parameters

    assembly {
        sig_r := mload(add(proof,64))
        sig_s := mload(add(proof,96))
	    readPos := add(readPos, 64)
    }

      // Skipping the certificate chain
      readPos += uint16(proof[26])+256*uint16(proof[27]);

      // Parse one record after another ( i < num_proof_nodes )
	  for(uint16 i = 0; i < uint16(proof[6])+256*uint16(proof[7]); i++){
			// Get the Record length as a byte array
			assembly { len_record := mload(add(proof,add(readPos,33))) }
			// Convert the record length into a number
			uint16 tmplen = uint16(len_record[0])+256*uint16(len_record[1]);
			// Parse generator information
			generator_originated = proof[readPos+3];
			// Update readPos
			readPos += 4; 
			// Set chunk pointer
			assembly { chunk := add(proof,readPos) }
			// Set length of chunks 
			assembly { mstore(chunk, tmplen) }
			// Load saltsecret
			assembly { saltsecret := mload(add(proof,add(readPos,add(tmplen,32)))) }
			// Root hash
			bytes32 hash = sha256(saltsecret,chunk,uint8(0),len_record,generator_originated);
			// Hash chain
			if(i == 0){
				hashchain = sha256(uint8(1),hash);
			}else{
				hashchain = sha256(uint8(1),hashchain,hash);
			}
			// Jump over record and salt secret
			readPos += tmplen + 16; 
		}
		// Compute Evidence Hash
		// Load chunk size and salt size 
		bytes4 test; // Temporarily contains salt size and chunk size 
		assembly { test := mload(add(proof,34)) } 
		// Compute final hash chain
		hashchain = sha256(hashchain, times, test, 0x04000000);
    }
}
