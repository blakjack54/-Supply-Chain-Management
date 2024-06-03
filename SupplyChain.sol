// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    struct Product {
        string name;
        address manufacturer;
        address currentOwner;
        uint256 timestamp;
    }

    uint256 public productCount;
    mapping(uint256 => Product) public products;
    mapping(uint256 => address[]) public productHistory;

    event ProductAdded(uint256 productId, string name, address manufacturer);
    event OwnershipTransferred(uint256 productId, address newOwner);

    function addProduct(string memory name) external {
        productCount++;
        products[productCount] = Product(name, msg.sender, msg.sender, block.timestamp);
        productHistory[productCount].push(msg.sender);
        emit ProductAdded(productCount, name, msg.sender);
    }

    function transferOwnership(uint256 productId, address newOwner) external {
        require(products[productId].currentOwner == msg.sender, "Not the current owner");
        products[productId].currentOwner = newOwner;
        productHistory[productId].push(newOwner);
        emit OwnershipTransferred(productId, newOwner);
    }

    function getProductHistory(uint256 productId) external view returns (address[] memory) {
        return productHistory[productId];
    }
}
