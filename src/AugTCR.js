import Web3 from 'web3'
import contracts from './ContractInstances';

let sample = new AugTCR();


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
        this.contractInstance = OrchContract.at(contracts.orchestratorAddress);

        alert(contracts.orchestratorAddress);
    }

    //Environment Builder
    initEnvironmentWithToken(_token, _registryName, _parameters){
        this.contractInstance.buildEnv(_token, _registryName, _parameters,
            {gas: 300000, from: window.web3.eth.accounts[0]},(err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    initEnvironmentAndToken(_supply, _tokenName, _decimals, _symbol, _parameters, _registryName){
        this.contractInstance.buildEnvAndToken(_supply, _tokenName, _decimals, _symbol, _parameters, _registryName,
            {gas: 300000, from: window.web3.eth.accounts[0]},(err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    //There should be a looper to navigate instances.
    retrieveEnvironmentInstance(_id, _creator){
        this.contractInstance.getEnvInstances(_id, _creator,
            (err, result) => {
                this.plcr = result[0];
                this.parameterizer = result[1];
                this.registry = result[2];
            }
        );
    }

    //Instance Setter
    setEnvironmentInstance(){
        if(this.plcr === 'undefined' || this.parameterizer === 'undefined' === this.registry == 'undefined'){
            console.log("Get your instance first");
        }
        else {
            const PLCRContract = window.web3.eth.contract(contracts.plcrABI);
            this.plcrInstance = PLCRContract.at(contracts.plcrAddress);

            const ParameterizerContract = window.web3.eth.contract(contracts.parameterizerABI);
            this.parameterizerInstance = ParameterizerContract.at(contracts.parameterizerAddress);

            const RegistryContract = window.web3.eth.contract(contracts.registryABI);
            this.registryInstance = RegistryContract.at(contracts.registryAddress);
        }
    }

    

    



    
}