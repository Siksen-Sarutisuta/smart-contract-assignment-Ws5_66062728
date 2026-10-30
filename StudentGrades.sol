// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentGrades {
    // 1. กำหนด struct เพื่อเก็บชื่อและคะแนนของนักศึกษา
    struct Student {
        string name;
        uint256 score;
        bool exists;
    }

    // เจ้าของสัญญา (อาจารย์/ผู้ดูแลระบบ)
    address public owner;

    // 2. ใช้ mapping เพื่อเชื่อมโยง address ของนักศึกษากับข้อมูล struct Student
    mapping(address => Student) public students;

    // Event สำหรับบันทึกประวัติการบันทึกคะแนน
    event StudentRecorded(address indexed studentAddress, string name, uint256 score);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // ฟังก์ชันสำหรับบันทึกหรืออัปเดตคะแนนนักศึกษา (เฉพาะ Owner)
    function setStudent(
        address _studentAddress,
        string memory _name,
        uint256 _score
    ) public onlyOwner {
        require(_studentAddress != address(0), "Invalid address");
        require(_score <= 100, "Score must be between 0 and 100");

        students[_studentAddress] = Student({
            name: _name,
            score: _score,
            exists: true
        });

        emit StudentRecorded(_studentAddress, _name, _score);
    }

    // ฟังก์ชันสำหรับดึงข้อมูลนักศึกษาตาม address
    function getStudent(address _studentAddress)
        public
        view
        returns (string memory name, uint256 score, bool exists)
    {
        Student memory s = students[_studentAddress];
        require(s.exists, "Student not found");
        return (s.name, s.score, s.exists);
    }

    // ฟังก์ชันสำหรับนักศึกษาเรียกดูคะแนนของตัวเอง
    function getMyScore() public view returns (string memory name, uint256 score) {
        Student memory s = students[msg.sender];
        require(s.exists, "You are not registered in the system");
        return (s.name, s.score);
    }
}
