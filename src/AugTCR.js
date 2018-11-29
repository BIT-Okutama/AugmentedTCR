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

    //PLCR Functions

    PLCRRequestVotingRights(_numTokens){
        this.plcrInstance.requestVotingRights(_numTokens,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    PLCRWithdrawVotingRights(_numTokens) {
        this.plcrInstance.withdrawVotingRights(_numTokens,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    PLCRCommitVote(_pollID, _voteOption, _salt, _numTokens){
        this.plcrInstance.commitVote(_pollID, web3.utils.keccak256(_voteOption+ '' +_salt), _numTokens, 0,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    PLCRRevealVote(_pollID, _voteOption, _salt){
        this.plcrInstance.revealVote(_pollID, _voteOption, _salt,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    PLCRAAAexpireCommitDuration(_pollID){
        this.plcrInstance.AAAexpireCommitDuration(_pollID,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    PLCRAAAexpireRevealDuration(_pollID){
        this.plcrInstance.AAAexpireRevealDuration(_pollID,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    //Registry Functions
    registryRegister(_uniqueKey, _amount, _desc, _extra){
        this.registryInstance.register(web3.utils.keccak256(_uniqueKey, _desc), _amount, _desc, _extra,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    registryDeposit(_contenderHash, _amount){
        this.registryInstance.deposit(_contenderHash, _amount,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    registryWithdraw(_contenderHash, _amount){
        this.registryInstance.withdraw(_contenderHash, _amount,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    registryChallenge(_contenderHash, _evidence){
        this.registryInstance.challenge(_contenderHash, _evidence,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    //Array of Bytes32
    registryBatchUpdateStatuses(_contenderHashes){
        this.registryInstance.batchUpdateStatuses(_contenderHashes,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    //Array of Integer
    registryBatchClaimIncentives(_challengeIDs){
        this.registryInstance.batchClaimIncentives(_challengeIDs,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    registryViewVoterIncentive(_voter, _challengeID){
        this.registryInstance.viewVoterIncentive(_voter, _challengeID,
            (err, result) => {
                return result;
            }
        );
    }

    registryIncentiveClaimStatus(_challengeID, _voter){
        this.registryInstance.incentiveClaimStatus(_challengeID, _voter,
            (err, result) => {
                return result;
            }
        );
    }

    registryIsChampion(_contenderHash){
        this.registryInstance.incentiveClaimStatus(_contenderHash,
            (err, result) => {
                return result;
            }
        );    
    }

    registryAAAexpireApplication(_contenderHash){
        this.registryInstance.AAAexpireApplication(_contenderHash,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }
    
    registryGetChampionNonce(){
        this.registryInstance.getChampionNonce(
            (err, result) => {
                return result;
            }
        );   
    }
    
    registryGetChampion(_contenderHash) {
        this.registryInstance.getChampion(_contenderHash,
            (err, result) => {
                return result;
            }
        );   
    }

    //Parameterizer Functions

    paramProposeAdjustment(_paramName, _paramVal){
        this.parameterizerInstance.proposeAdjustment(_paramName, _paramVal,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }
    
    paramChallengeProposal(_proposalID){
        this.parameterizerInstance.challengeProposal(_proposalID,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    paramProcessProposalResult(_proposalID){
        this.parameterizerInstance.processProposalResult(_proposalID,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    paramBatchClaimIncentives(_challengeIDs){
        this.parameterizerInstance.batchClaimIncentives(_challengeIDs,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    paramViewVoterIncentive(_voter, _challengeID){
        this.parameterizerInstance.viewVoterIncentive(_voter, _challengeID,
            (err, result) => {
                return result;
            }
        ); 
    }

    paramIncentiveClaimStatus(_challengeID, _voter){
        this.parameterizerInstance.incentiveClaimStatus(_challengeID, _voter,
            (err, result) => {
                return result;
            }
        ); 
    }

    paramSet(_name, _value){
        this.parameterizerInstance.set(_name, _value,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

    paramGet(_name){
        this.parameterizerInstance.get(_name,
            (err, result) => {
                return result;
            }
        ); 
    }

    paramAAAexpireProposal(_proposalID){
        this.parameterizerInstance.AAAexpireProposal(_proposalID,
            {gas: 300000, from: window.web3.eth.accounts[0]},
            (err, result) => {
                alert("Transaction Successful!");
            }
        );
    }

}