//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Tx.sol";

contract TxFactory{
    address TxFactoryAddress;
    address TxContractAddress;
    uint256 id;

    mapping(address => address[]) public transactions;
    address[] public s_transactionsArray;

    event Created(address _contractAddress);

    constructor() {
        id = 0;
    }

    function createTxContract(
        string memory _item,
        uint256 _price,
        string memory _sellerPhysicalAddress,
        string memory _ipfsImage
    ) public payable {
        require(msg.value >= _price);
        id += 1;
        Tx newContract = (new Tx){value: _price}(
            _ipfsImage,
            _item,
            _price,
            _sellerPhysicalAddress,
            msg.sender,
            id,
            address(this)
        );
        emit Created(address(newContract));
    }

    function setTransaction(
        address _seller,
        address _txContractAddress
    ) public {
        transactions[_seller].push(_txContractAddress);
        s_transactionsArray.push(_txContractAddress);
    }

    function setBuyerTransaction(address _buyer, address _txContractAddress) public {
        transactions[_buyer].push(_txContractAddress);
    }

    function removeFromPublicArray(address _transactionAddress) public {
         address[] memory transactionsArray = s_transactionsArray;
        for (uint256 i = 0; i < transactionsArray.length; i++) {
            if (transactionsArray[i] == _transactionAddress) {
                s_transactionsArray[i] = transactionsArray[
                    transactionsArray.length - 1
                ];
                s_transactionsArray.pop();
            }
        }
    }

    function removeTx(
        address _transactionAddress,
        address _seller,
        address _buyer
    ) public {
        address[] memory sellerTransactions = transactions[_seller];
        for (uint256 i = 0; i < sellerTransactions.length; i++) {
            if (sellerTransactions[i] == _transactionAddress) {
                transactions[_seller][i] = sellerTransactions[
                    sellerTransactions.length - 1
                ];
                transactions[_seller].pop();
            }
        }
        address[] memory buyerTransactions = transactions[_buyer];
        for (uint256 i = 0; i < buyerTransactions.length; i++) {
            if (buyerTransactions[i] == _transactionAddress) {
                transactions[_buyer][i] = buyerTransactions[
                    buyerTransactions.length - 1
                ];
                transactions[_buyer].pop();
            }
        }
    }

    function getId() public view returns (uint256) {
        return id;
    }

    function getLengthOfTransactionArray() public view returns (uint) {
        return s_transactionsArray.length;
    }
    
    function getTransaction(
        uint256 _id
    ) public view returns (address _transactionAddress) {
        address[] memory transactionsArray = s_transactionsArray;
        for (uint256 i = 0; i < transactionsArray.length; i++) {
            if (Tx(transactionsArray[i]).getId() == _id) {
                _transactionAddress = s_transactionsArray[i];
            }
        }
    }
    function getTransactions() public view returns(address[] memory) {
        return s_transactionsArray;
    }
    function getUserAddresses(address _userAddress) public view returns(address[] memory) {
        return transactions[_userAddress];
    }
}