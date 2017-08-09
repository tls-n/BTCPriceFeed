# BTCPriceFeed

BTCPriceFeed is a smart contract that acts as a trusted source for the BTC-USD price. It makes use of [TLS-N](https://tls-n.org) proofs for the API of (https://index.bitcoin.com/).

The usage is as follows:
1. A user wants to securely use the BTC-USD price at time **T** (e.g. 1483228800, i.e. Jan 1st 2017).
2. The user generates a TLS-N proof for time **T** using URL https://index.bitcoin.com/api/v0/lookup?time=T . This can for example be done through the TLS-N website: (https://tls-n.org/#cta).
3. The user sends the proof to BTCPriceFeed in an Ethereum transaction.
4. BTCPriceFeed verifies that the proof is valid and the data source is correct. Afterwards the price is stored.
5. Using the `getPrice()` function of BTCPriceFeed the user now has secure access to the BTC-USD price at time **T**.
