# BTCPriceFeed

BTCPriceFeed is a smart contract that acts as a trusted source for the BTC-USD price. It makes use of [TLS-N](https://tls-n.org) proofs for the API of (https://index.bitcoin.com/).

The usage is as follows:
1. A user wants to securely use the BTC-USD price at time **T** (e.g. 1483228800, i.e. Jan 1st 2017).
2. The user generates a TLS-N proof for time **T** using URL https://index.bitcoin.com/api/v0/lookup?time=T . This can for example be done through the TLS-N website: (https://tls-n.org/#cta).
3. The user sends the proof to BTCPriceFeed in an Ethereum transaction.
4. BTCPriceFeed verifies that the proof is valid and the data source is correct. Afterwards the price is stored.
5. Using the `getPrice()` function of BTCPriceFeed the user now has secure access to the BTC-USD price at time **T**.

## Ropsten Deployment

BTCPriceFeed is deployed on Ropsten (the Ethereum test network) at the address [0x8b09153430106169626df6e533590bc7062078cb](https://ropsten.io/address/0x8b09153430106169626df6e533590bc7062078cb). Multiple bitcoin prices, such as the prices for August 1st 2017 (timestamp = 1501545600) are already inserted ([Example Transaction](https://ropsten.io/tx/0xec0662cd26ce2a31dcfeee62a54fd59cd7a4849bc4e71ed525e6565e2a094cbb)) and can be queried. More prices can be inserted as described above.

### Notes
- Note, that due to the functionality of the bitcoin.com API, **T** has to refer to the beginning or end of a day.
- Note, that as bitcoin.com currently does not support TLS-N, the contract checks for the use of the TLS-N.org proxy.
- This is a prototype, with no correctness guarantees.
