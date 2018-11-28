import Web3 from 'web3'
import contracts from './ContractInstances';

new AugTCR();

class AugTCR {
    constructor() {
        //Initializes the Web3 connection instance.
        if(typeof window.web3 != 'undefined'){
            console.log("Using web3 detected from external source like Metamask");
            window.web3 = new Web3(window.web3.currentProvider);
        }
        else {
            window.web3 = new Web3(new 
            Web3.providers.HttpProvider("http://localhost:8545"));
        }
  
        //Sets the account, for it to be recognized by Metamask 
        window.web3.eth.defaultAccount = window.web3.eth.accounts[0]

        //Sets the contract connection for the instance.
        const OrchContract = window.web3.eth.contract(contracts.orchestratorABI);
        let contractInstance = OrchContract.at(contracts.orchestratorAddress);

        alert(contracts.orchestratorAddress);
    }
}