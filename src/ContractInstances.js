var contract = {
    ownerAddress: "0xDA1f876435f34756ACDA6492B1e061c31D1aE52D",
    orchestratorAddress: "0x1dc867bdabc61d1bcb17c4388ee7b68bb3b064e7",
    registryAddress:"0xc00a70fe2125612677356b1d32f1c2f9308fd047",
    parameterizerAddress: "0x74c94f517c6f4d3536ca448d2ba0465b5d11dd9a",
    plcrAddress: "0x41b5af59a230c387c8dc999a9596b85d97221252",
    registryABI: [
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                },
                {
                    "name": "_amount",
                    "type": "uint256"
                }
            ],
            "name": "withdraw",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "name",
            "outputs": [
                {
                    "name": "",
                    "type": "string"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_challengeID",
                    "type": "uint256"
                }
            ],
            "name": "getChallenge",
            "outputs": [
                {
                    "name": "_isConcluded",
                    "type": "bool"
                },
                {
                    "name": "_incentivePool",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                },
                {
                    "name": "_amount",
                    "type": "uint256"
                }
            ],
            "name": "deposit",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "getContender",
            "outputs": [
                {
                    "name": "_desc",
                    "type": "string"
                },
                {
                    "name": "_challengeID",
                    "type": "uint256"
                },
                {
                    "name": "_appExpiry",
                    "type": "uint256"
                },
                {
                    "name": "_isChampion",
                    "type": "bool"
                },
                {
                    "name": "_issuer",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_token",
                    "type": "address"
                },
                {
                    "name": "_name",
                    "type": "string"
                },
                {
                    "name": "_parameterizer",
                    "type": "address"
                },
                {
                    "name": "_voting",
                    "type": "address"
                }
            ],
            "name": "init",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getContenderNonce",
            "outputs": [
                {
                    "name": "",
                    "type": "bytes32[]"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_contenderHashes",
                    "type": "bytes32[]"
                }
            ],
            "name": "batchUpdateStatuses",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "AAAexpireApplication",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                },
                {
                    "name": "_evidence",
                    "type": "string"
                }
            ],
            "name": "challenge",
            "outputs": [
                {
                    "name": "challengeID",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_challengeID",
                    "type": "uint256"
                },
                {
                    "name": "_voter",
                    "type": "address"
                }
            ],
            "name": "incentiveClaimStatus",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_challengeID",
                    "type": "uint256"
                }
            ],
            "name": "claimIncentive",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_challengeIDs",
                    "type": "uint256[]"
                }
            ],
            "name": "batchClaimIncentives",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "updateStatus",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "name": "challenges",
            "outputs": [
                {
                    "name": "challenger",
                    "type": "address"
                },
                {
                    "name": "incentivePool",
                    "type": "uint256"
                },
                {
                    "name": "isConcluded",
                    "type": "bool"
                },
                {
                    "name": "stake",
                    "type": "uint256"
                },
                {
                    "name": "wonTokens",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                },
                {
                    "name": "_amount",
                    "type": "uint256"
                },
                {
                    "name": "_desc",
                    "type": "string"
                },
                {
                    "name": "_extra",
                    "type": "string"
                }
            ],
            "name": "register",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_challengeID",
                    "type": "uint256"
                }
            ],
            "name": "viewVoterIncentive",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "existingContender",
            "outputs": [
                {
                    "name": "exists",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "isChampion",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getChallengeNonce",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256[]"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "bytes32"
                }
            ],
            "name": "contenders",
            "outputs": [
                {
                    "name": "issuer",
                    "type": "address"
                },
                {
                    "name": "description",
                    "type": "string"
                },
                {
                    "name": "isChampion",
                    "type": "bool"
                },
                {
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "name": "deposit",
                    "type": "uint256"
                },
                {
                    "name": "applicationExpiry",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "parameterizer",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "canBecomeChampion",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "challengeCanBeConcluded",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "token",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "voting",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "issuer",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "stake",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "applicationExpiry",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "extra",
                    "type": "string"
                }
            ],
            "name": "NewContender",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "issuer",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "depositAmount",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "total",
                    "type": "uint256"
                }
            ],
            "name": "Deposit",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "issuer",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "withdrawAmount",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "total",
                    "type": "uint256"
                }
            ],
            "name": "Withdrawal",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "ChampionRemoved",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "ContenderRemoved",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "challenger",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "evidence",
                    "type": "string"
                },
                {
                    "indexed": false,
                    "name": "commitEnd",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "revealEnd",
                    "type": "uint256"
                }
            ],
            "name": "NewChallenge",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "NewChampion",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "incentivePoo",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "wonTokens",
                    "type": "uint256"
                }
            ],
            "name": "ChallengerLost",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "incentivePoo",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "wonTokens",
                    "type": "uint256"
                }
            ],
            "name": "ChallengerWon",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "voter",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "reward",
                    "type": "uint256"
                }
            ],
            "name": "IncentiveClaimed",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "contenderHash",
                    "type": "bytes32"
                }
            ],
            "name": "TouchedAndRemoved",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "success",
                    "type": "bool"
                }
            ],
            "name": "OperationSuccess",
            "type": "event"
        }
    ],
    parameterizerABI: [
        {
            "constant": true,
            "inputs": [],
            "name": "PROCESSBY",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getProposalNonce",
            "outputs": [
                {
                    "name": "",
                    "type": "bytes32[]"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_challengeID",
                    "type": "uint256"
                }
            ],
            "name": "getChallenge",
            "outputs": [
                {
                    "name": "_isConcluded",
                    "type": "bool"
                },
                {
                    "name": "_incentivePool",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_propID",
                    "type": "bytes32"
                }
            ],
            "name": "exisitingProposal",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_challengeID",
                    "type": "uint256"
                }
            ],
            "name": "calculateIncentive",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "bytes32"
                }
            ],
            "name": "proposals",
            "outputs": [
                {
                    "name": "pIssuer",
                    "type": "address"
                },
                {
                    "name": "pChallengeID",
                    "type": "uint256"
                },
                {
                    "name": "proposalExpiry",
                    "type": "uint256"
                },
                {
                    "name": "paramName",
                    "type": "string"
                },
                {
                    "name": "paramVal",
                    "type": "uint256"
                },
                {
                    "name": "pDeposit",
                    "type": "uint256"
                },
                {
                    "name": "processBy",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_proposalID",
                    "type": "bytes32"
                }
            ],
            "name": "proposalPassed",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_proposalID",
                    "type": "bytes32"
                }
            ],
            "name": "getProposal",
            "outputs": [
                {
                    "name": "_paramName",
                    "type": "string"
                },
                {
                    "name": "_paramVal",
                    "type": "uint256"
                },
                {
                    "name": "_challengeID",
                    "type": "uint256"
                },
                {
                    "name": "_proposalExpiry",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_token",
                    "type": "address"
                },
                {
                    "name": "_plcr",
                    "type": "address"
                },
                {
                    "name": "_parameters",
                    "type": "uint256[]"
                }
            ],
            "name": "init",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_challengeID",
                    "type": "uint256"
                },
                {
                    "name": "_voter",
                    "type": "address"
                }
            ],
            "name": "incentiveClaimStatus",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_proposalID",
                    "type": "bytes32"
                }
            ],
            "name": "AAAexpireProposal",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_name",
                    "type": "string"
                }
            ],
            "name": "get",
            "outputs": [
                {
                    "name": "value",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_challengeID",
                    "type": "uint256"
                }
            ],
            "name": "claimIncentive",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_proposalID",
                    "type": "bytes32"
                }
            ],
            "name": "processProposalResult",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_challengeIDs",
                    "type": "uint256[]"
                }
            ],
            "name": "batchClaimIncentives",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_proposalID",
                    "type": "bytes32"
                }
            ],
            "name": "challengeProposal",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_name",
                    "type": "string"
                },
                {
                    "name": "_value",
                    "type": "uint256"
                }
            ],
            "name": "set",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "name": "challenges",
            "outputs": [
                {
                    "name": "pChallenger",
                    "type": "address"
                },
                {
                    "name": "pIncentivePool",
                    "type": "uint256"
                },
                {
                    "name": "pIsConcluded",
                    "type": "bool"
                },
                {
                    "name": "pStake",
                    "type": "uint256"
                },
                {
                    "name": "pWonTokens",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_challengeID",
                    "type": "uint256"
                }
            ],
            "name": "viewVoterIncentive",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_paramName",
                    "type": "string"
                },
                {
                    "name": "_paramVal",
                    "type": "uint256"
                }
            ],
            "name": "proposeAdjustment",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getChallengeNonce",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256[]"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "bytes32"
                }
            ],
            "name": "params",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_proposalID",
                    "type": "bytes32"
                }
            ],
            "name": "challengeCanBeConcluded",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "token",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "voting",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "issuer",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "proposalID",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "name",
                    "type": "string"
                },
                {
                    "indexed": false,
                    "name": "value",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "deposit",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "appEndDate",
                    "type": "uint256"
                }
            ],
            "name": "NewProposal",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "challenger",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "proposalID",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "commitEndDate",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "revealEndDate",
                    "type": "uint256"
                }
            ],
            "name": "NewProposalChallenge",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "proposalID",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "incentivePool",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "wonTokens",
                    "type": "uint256"
                }
            ],
            "name": "PChallengerWon",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "proposalID",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "incentivePool",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "wonTokens",
                    "type": "uint256"
                }
            ],
            "name": "PChallengerLost",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "proposalID",
                    "type": "bytes32"
                },
                {
                    "indexed": false,
                    "name": "name",
                    "type": "string"
                },
                {
                    "indexed": false,
                    "name": "value",
                    "type": "uint256"
                }
            ],
            "name": "ProposalPassed",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "proposalID",
                    "type": "bytes32"
                }
            ],
            "name": "ProposalExpired",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "voter",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "challengeID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "incentive",
                    "type": "uint256"
                }
            ],
            "name": "IncentiveClaimed",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "success",
                    "type": "bool"
                }
            ],
            "name": "OperationSuccess",
            "type": "event"
        }
    ],
    plcrABI: [
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "getTotalNumberOfTokensForWinningOption",
            "outputs": [
                {
                    "name": "numTokens",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "getNumPassingTokens",
            "outputs": [
                {
                    "name": "correctVotes",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "AAAexpireRevealDuration",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getPollNonce",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_token",
                    "type": "address"
                }
            ],
            "name": "init",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "getPoll",
            "outputs": [
                {
                    "name": "_commitEndDate",
                    "type": "uint256"
                },
                {
                    "name": "_revealEndDate",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "INITIAL_POLL_NONCE",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_numTokens",
                    "type": "uint256"
                },
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "getInsertPointForNumTokens",
            "outputs": [
                {
                    "name": "prevNode",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_voteQuorum",
                    "type": "uint256"
                },
                {
                    "name": "_commitDuration",
                    "type": "uint256"
                },
                {
                    "name": "_revealDuration",
                    "type": "uint256"
                }
            ],
            "name": "startPoll",
            "outputs": [
                {
                    "name": "pollID",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "name": "voteTokenBalance",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollIDs",
                    "type": "uint256[]"
                },
                {
                    "name": "_secretHashes",
                    "type": "bytes32[]"
                },
                {
                    "name": "_numsTokens",
                    "type": "uint256[]"
                },
                {
                    "name": "_prevPollIDs",
                    "type": "uint256[]"
                }
            ],
            "name": "commitVotes",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                }
            ],
            "name": "getLastNode",
            "outputs": [
                {
                    "name": "pollID",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "revealPeriodActive",
            "outputs": [
                {
                    "name": "active",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "isPassed",
            "outputs": [
                {
                    "name": "passed",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "name": "pollMap",
            "outputs": [
                {
                    "name": "commitEndDate",
                    "type": "uint256"
                },
                {
                    "name": "revealEndDate",
                    "type": "uint256"
                },
                {
                    "name": "voteQuorum",
                    "type": "uint256"
                },
                {
                    "name": "votesFor",
                    "type": "uint256"
                },
                {
                    "name": "votesAgainst",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getVotingBalance",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                }
            ],
            "name": "getLockedTokens",
            "outputs": [
                {
                    "name": "numTokens",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                },
                {
                    "name": "_secretHash",
                    "type": "bytes32"
                },
                {
                    "name": "_numTokens",
                    "type": "uint256"
                },
                {
                    "name": "_prevPollID",
                    "type": "uint256"
                }
            ],
            "name": "commitVote",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_numTokens",
                    "type": "uint256"
                }
            ],
            "name": "tokenFaucet",
            "outputs": [],
            "payable": true,
            "stateMutability": "payable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "didCommit",
            "outputs": [
                {
                    "name": "committed",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollIDs",
                    "type": "uint256[]"
                },
                {
                    "name": "_voteOptions",
                    "type": "uint256[]"
                },
                {
                    "name": "_salts",
                    "type": "uint256[]"
                }
            ],
            "name": "revealVotes",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_prevID",
                    "type": "uint256"
                },
                {
                    "name": "_nextID",
                    "type": "uint256"
                },
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_numTokens",
                    "type": "uint256"
                }
            ],
            "name": "validPosition",
            "outputs": [
                {
                    "name": "valid",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "pollExists",
            "outputs": [
                {
                    "name": "exists",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "pollNonce",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "rescueTokens",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_user",
                    "type": "address"
                },
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "attrUUID",
            "outputs": [
                {
                    "name": "UUID",
                    "type": "bytes32"
                }
            ],
            "payable": false,
            "stateMutability": "pure",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_numTokens",
                    "type": "uint256"
                }
            ],
            "name": "requestVotingRights",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "commitPeriodActive",
            "outputs": [
                {
                    "name": "active",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "didReveal",
            "outputs": [
                {
                    "name": "revealed",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                },
                {
                    "name": "_voteOption",
                    "type": "uint256"
                },
                {
                    "name": "_salt",
                    "type": "uint256"
                }
            ],
            "name": "revealVote",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollIDs",
                    "type": "uint256[]"
                }
            ],
            "name": "rescueTokensInMultiplePolls",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "AAAexpireCommitDuration",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "getNumTokens",
            "outputs": [
                {
                    "name": "numTokens",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_voter",
                    "type": "address"
                },
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "getCommitHash",
            "outputs": [
                {
                    "name": "commitHash",
                    "type": "bytes32"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_terminationDate",
                    "type": "uint256"
                }
            ],
            "name": "isExpired",
            "outputs": [
                {
                    "name": "expired",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_numTokens",
                    "type": "uint256"
                }
            ],
            "name": "withdrawVotingRights",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_pollID",
                    "type": "uint256"
                }
            ],
            "name": "pollEnded",
            "outputs": [
                {
                    "name": "ended",
                    "type": "bool"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "token",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "pollID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "numTokens",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "voter",
                    "type": "address"
                }
            ],
            "name": "_VoteCommitted",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "pollID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "numTokens",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "votesFor",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "votesAgainst",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "choice",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "voter",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "salt",
                    "type": "uint256"
                }
            ],
            "name": "_VoteRevealed",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "voteQuorum",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "commitEndDate",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "revealEndDate",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "pollID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "creator",
                    "type": "address"
                }
            ],
            "name": "_PollCreated",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "numTokens",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "voter",
                    "type": "address"
                }
            ],
            "name": "_VotingRightsGranted",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "numTokens",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "voter",
                    "type": "address"
                }
            ],
            "name": "_VotingRightsWithdrawn",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "pollID",
                    "type": "uint256"
                },
                {
                    "indexed": false,
                    "name": "voter",
                    "type": "address"
                }
            ],
            "name": "_TokensRescued",
            "type": "event"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "success",
                    "type": "bool"
                }
            ],
            "name": "OperationSuccess",
            "type": "event"
        }
    ],
    orchestratorABI: [
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_supply",
                    "type": "uint256"
                },
                {
                    "name": "_tokenName",
                    "type": "string"
                },
                {
                    "name": "_decimals",
                    "type": "uint8"
                },
                {
                    "name": "_symbol",
                    "type": "string"
                },
                {
                    "name": "_parameters",
                    "type": "uint256[]"
                },
                {
                    "name": "_registryName",
                    "type": "string"
                }
            ],
            "name": "buildEnvAndToken",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "canonParam",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "canonRegistry",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "canonPLCR",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "_id",
                    "type": "uint256"
                },
                {
                    "name": "_creator",
                    "type": "address"
                }
            ],
            "name": "getEnvInstances",
            "outputs": [
                {
                    "name": "_plcr",
                    "type": "address"
                },
                {
                    "name": "_param",
                    "type": "address"
                },
                {
                    "name": "_reg",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "name": "envInstances",
            "outputs": [
                {
                    "name": "creator",
                    "type": "address"
                },
                {
                    "name": "plcrInstance",
                    "type": "address"
                },
                {
                    "name": "paramInstance",
                    "type": "address"
                },
                {
                    "name": "regInstance",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_token",
                    "type": "address"
                },
                {
                    "name": "_registryName",
                    "type": "string"
                },
                {
                    "name": "_parameters",
                    "type": "uint256[]"
                }
            ],
            "name": "buildEnv",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "proxyFactory",
            "outputs": [
                {
                    "name": "",
                    "type": "address"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "constant": true,
            "inputs": [],
            "name": "getEnvCount",
            "outputs": [
                {
                    "name": "",
                    "type": "uint256"
                }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
        },
        {
            "inputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
        },
        {
            "anonymous": false,
            "inputs": [
                {
                    "indexed": false,
                    "name": "origin",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "param",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "reg",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "token",
                    "type": "address"
                },
                {
                    "indexed": false,
                    "name": "plcr",
                    "type": "address"
                }
            ],
            "name": "onCreateEnvironment",
            "type": "event"
        }
    ]
}

export default contract;

