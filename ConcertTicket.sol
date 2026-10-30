// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ConcertTicket {
    // 1. กำหนด struct สำหรับเก็บข้อมูลและสถานะตั๋วของผู้ใช้
    struct Ticket {
        uint256 ticketCount;  // จำนวนตั๋วที่ถือครอง
        bool isValid;         // สถานะตั๋ว (ใช้งานได้/ถูกต้อง)
        uint256 purchasedAt;  // เวลาที่ทำรายการซื้อ
    }

    address public owner;
    string public concertName;
    uint256 public ticketPrice;      // ราคาตั๋วต่อใบ (หน่วยเป็น wei)
    uint256 public totalTickets;     // จำนวนตั๋วทั้งหมดที่มีขาย
    uint256 public ticketsSold;      // จำนวนตั๋วที่ขายไปแล้ว

    // 2. ใช้ mapping เพื่อเชื่อมโยง address ของผู้ซื้อกับ struct Ticket
    mapping(address => Ticket) public tickets;

    // Events
    event TicketPurchased(address indexed buyer, uint256 amount, uint256 totalCost);
    event TicketCancelled(address indexed buyer);

    constructor(
        string memory _concertName,
        uint256 _ticketPriceInWei,
        uint256 _totalTickets
    ) {
        owner = msg.sender;
        concertName = _concertName;
        ticketPrice = _ticketPriceInWei; // เช่น 0.001 ether (1000000000000000 wei)
        totalTickets = _totalTickets;
    }

    // ฟังก์ชันซื้อตั๋วคอนเสิร์ต (ส่ง ETH มาพร้อมกับคำสั่งเรียก)
    function buyTicket(uint256 _amount) public payable {
        require(_amount > 0, "Must buy at least 1 ticket");
        require(ticketsSold + _amount <= totalTickets, "Not enough tickets available");
        require(msg.value >= ticketPrice * _amount, "Insufficient payment");

        // อัปเดตข้อมูลตั๋วใน mapping
        tickets[msg.sender].ticketCount += _amount;
        tickets[msg.sender].isValid = true;
        tickets[msg.sender].purchasedAt = block.timestamp;

        ticketsSold += _amount;

        // คืนเงินทอนหากผู้ใช้โอนมาเกิน
        uint256 refund = msg.value - (ticketPrice * _amount);
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        emit TicketPurchased(msg.sender, _amount, ticketPrice * _amount);
    }

    // ฟังก์ชันตรวจสอบสถานะตั๋วของตัวเอง (msg.sender)
    function checkMyTicket()
        public
        view
        returns (
            uint256 ticketCount,
            bool isValid,
            uint256 purchasedAt
        )
    {
        Ticket memory t = tickets[msg.sender];
        require(t.isValid && t.ticketCount > 0, "You do not own any valid ticket");
        return (t.ticketCount, t.isValid, t.purchasedAt);
    }

    // ฟังก์ชันตรวจสอบสถานะตั๋วตาม address
    function getTicketStatus(address _user)
        public
        view
        returns (
            uint256 ticketCount,
            bool isValid,
            uint256 purchasedAt
        )
    {
        Ticket memory t = tickets[_user];
        return (t.ticketCount, t.isValid, t.purchasedAt);
    }

    // ดูจำนวนตั๋วคงเหลือในระบบ
    function getAvailableTickets() public view returns (uint256) {
        return totalTickets - ticketsSold;
    }

    // เจ้าของสัญญาถอนเงินรายได้จากการขายตั๋ว
    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
