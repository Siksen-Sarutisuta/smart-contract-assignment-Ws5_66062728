// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProductStore {
    // 1. กำหนด struct สำหรับเก็บข้อมูลสินค้า (ชื่อ, ราคา, จำนวนคงเหลือ)
    struct Product {
        uint256 id;
        string name;
        uint256 price;       // ราคา (เช่น หน่วยเป็น wei หรือบาท/เหรียญ)
        uint256 stock;       // จำนวนคงเหลือ
        bool exists;
    }

    address public owner;
    uint256 public productCount;

    // 2. ใช้ mapping เพื่อเก็บข้อมูลสินค้า โดยใช้ ID ของสินค้าเป็น key
    mapping(uint256 => Product) public products;

    // Event แจ้งเตือนเมื่อมีการเพิ่มสินค้า
    event ProductAdded(uint256 indexed id, string name, uint256 price, uint256 stock);
    event StockUpdated(uint256 indexed id, uint256 newStock);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // ฟังก์ชันสำหรับเพิ่มสินค้าใหม่
    function addProduct(
        string memory _name,
        uint256 _price,
        uint256 _stock
    ) public onlyOwner returns (uint256) {
        require(bytes(_name).length > 0, "Product name cannot be empty");
        
        productCount++;
        products[productCount] = Product({
            id: productCount,
            name: _name,
            price: _price,
            stock: _stock,
            exists: true
        });

        emit ProductAdded(productCount, _name, _price, _stock);
        return productCount;
    }

    // ฟังก์ชันสำหรับดูข้อมูลสินค้า
    function getProduct(uint256 _id)
        public
        view
        returns (
            uint256 id,
            string memory name,
            uint256 price,
            uint256 stock
        )
    {
        require(products[_id].exists, "Product does not exist");
        Product memory p = products[_id];
        return (p.id, p.name, p.price, p.stock);
    }

    // ฟังก์ชันอัปเดตจำนวนสต็อกสินค้า (เพิ่มเติม)
    function updateStock(uint256 _id, uint256 _newStock) public onlyOwner {
        require(products[_id].exists, "Product does not exist");
        products[_id].stock = _newStock;
        emit StockUpdated(_id, _newStock);
    }
}
