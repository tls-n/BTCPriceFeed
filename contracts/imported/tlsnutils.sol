pragma solidity ^0.4.11;
import "./bytesutils.sol";

library tlsnutils{
    
    using bytesutils for *;

    /*
     * @dev Returns the complete response (all generator records).
     * @param proof The proof.
     * @return The response as a bytestring. Empty string on error.
    */
    function getConversationPart(bytes memory proof, bytes1 conversation_part) private returns(bytes){
        bytes memory response = "";
        uint16 readPos = 96;
        // Skipping the certificate chain
        readPos += uint16(proof[26])+256*uint16(proof[27]);
        bytes1 generator_originated;
        // Parse one record after another ( i < num_proof_nodes )
        for(uint16 i = 0; i < uint16(proof[6])+256*uint16(proof[7]); i++){

            // Assume the request is in the first record
            bytes2 len_record; // Length of the record
            assembly { len_record := mload(add(proof,add(readPos,33))) }
            
            uint16 tmplen = uint16(len_record[0])+256*uint16(len_record[1]);

            generator_originated = proof[readPos+3];

            // Skip node, type, content len and generator info
            readPos += 4;

            if(generator_originated == conversation_part){
                var chunk = proof.toSlice(readPos).truncate(tmplen); 
                response = response.toSlice().concat(chunk);
            }
            readPos += tmplen + 16;              
        } 
        return response;
    }



    /*
     * @dev Returns the complete request (all requester records).
     * @param proof The proof.
     * @return The request as a bytestring.
    */
    function getRequest(bytes memory proof) internal returns(bytes){
        return getConversationPart(proof, 0);
    }


    /*
     * @dev Returns the complete response (all generator records).
     * @param proof The proof.
     * @return The response as a bytestring.
    */
    function getResponse(bytes memory proof) internal returns(bytes){
        return getConversationPart(proof, 1);
    }



    /*
     * @dev Returns the HTTP body.
     * @param proof The proof.
     * @return The HTTP body in case the request was valid. (200 OK) 
    */
    function getHTTPBody(bytes memory proof) internal returns(bytes){
        bytes memory response = getResponse(proof);
        bytesutils.slice memory code = response.toSlice().truncate(15);
        require(code.equals("HTTP/1.1 200 OK".toSlice()));
        bytesutils.slice memory body = response.toSlice().find("\r\n\r\n".toSlice());
        body.addOffset(4);
        return body.toBytes();  
    }

    
    /*
     * @dev Returns HTTP Host inside the request
     * @param proof The proof.
     * @return The Host as a bytestring.
    */
    function getHost(bytes memory proof) internal returns(bytes){
        bytesutils.slice memory request = getRequest(proof).toSlice();
        // Search in Headers
        request = request.split("\r\n\r\n".toSlice());
        // Find host header
        request.find("Host:".toSlice());
        request.addOffset(5);
        // Until newline
        request = request.split("\r\n".toSlice());
        while(request.startsWith(" ".toSlice())){
            request.addOffset(1);
        }
        return request.toBytes();
    }

    /*
     * @dev Returns the requested URL for HTTP
     * @param proof The proof.
     * @return The request as a bytestring. Empty string on error.
    */
    function getHTTPRequestURL(bytes memory proof) internal returns(bytes){
        bytes memory request = getRequest(proof);
        bytesutils.slice memory slice = request.toSlice();
        bytesutils.slice memory delim = " ".toSlice();
        // Check the method is GET
        bytesutils.slice memory method = slice.split(delim);
        require(method.equals("GET".toSlice()));
        // Return the URL
        return slice.split(delim).toBytes();
    }

}
