# Smart Contract Assignment

งานมอบหมายสร้าง Smart Contract ด้วยภาษา Solidity บนเครือข่าย Ethereum (Sepolia Testnet) โดยประยุกต์ใช้ `struct` และ `mapping`

---

## 📋 Deployed Contracts (Sepolia Testnet)

| ข้อที่ | Smart Contract | Contract Address |
|:---:|:---|:---|
| 1 | **StudentGrades** | `0xa13670bD22C9557cE337DBb8D600C64C8320722D` |
| 2 | **ProductStore** | `0x1897086760d342256612c64151071C087c809Fa3` |
| 3 | **ConcertTicket** | `0xdB96a211C9dcfFD555C5A87Fa3604A9dFB76b1DC` |

---

## 📁 รายละเอียดไฟล์และโจทย์

### 1. [StudentGrades.sol](./StudentGrades.sol)
* **โจทย์:** สร้าง Smart Contract ที่เก็บคะแนนของนักศึกษา โดยใช้ `struct` เก็บชื่อและคะแนน และใช้ `mapping` เชื่อมโยงกับที่อยู่ (`address`) ของนักศึกษา
* **ความสามารถ:**
  - กำหนด `struct Student` เก็บชื่อ, คะแนน (0-100) และสถานะ
  - ใช้ `mapping(address => Student)` เก็บข้อมูลนักศึกษาตาม address
  - ฟังก์ชัน `setStudent`: อาจารย์/Owner บันทึกหรืออัปเดตคะแนน
  - ฟังก์ชัน `getStudent`: เรียกดูคะแนนตาม address
  - ฟังก์ชัน `getMyScore`: นักศึกษาเรียกดูคะแนนของตนเอง

### 2. [ProductStore.sol](./ProductStore.sol)
* **โจทย์:** สร้าง Smart Contract ที่สามารถเพิ่มสินค้า พร้อมชื่อ, ราคา และจำนวนคงเหลือ โดยใช้ `struct` และ `mapping` เพื่อเก็บข้อมูลสินค้า
* **ความสามารถ:**
  - กำหนด `struct Product` เก็บ ID, ชื่อ, ราคา และจำนวนสต็อกคงเหลือ
  - ใช้ `mapping(uint256 => Product)` เก็บข้อมูลสินค้าตาม ID
  - ฟังก์ชัน `addProduct`: เพิ่มสินค้าใหม่เข้าระบบ
  - ฟังก์ชัน `getProduct`: ดูข้อมูลสินค้าตาม ID
  - ฟังก์ชัน `updateStock`: อัปเดตจำนวนสต็อกสินค้าคงเหลือ

### 3. [ConcertTicket.sol](./ConcertTicket.sol)
* **โจทย์:** สร้าง Smart Contract ขายตั๋วคอนเสิร์ต โดยผู้ใช้สามารถซื้อตั๋วและตรวจสอบสถานะตั๋วของตนเองได้ โดยใช้ `struct` และ `mapping`
* **ความสามารถ:**
  - กำหนด `struct Ticket` เก็บจำนวนตั๋ว, สถานะการใช้งาน และเวลาที่ซื้อ
  - ใช้ `mapping(address => Ticket)` เก็บตั๋วตามกระเป๋าผู้ซื้อ
  - ฟังก์ชัน `buyTicket`: ผู้ใช้ส่ง ETH ซื้อตั๋วคอนเสิร์ต (มีการตรวจสอบจำนวนและคืนเงินทอน)
  - ฟังก์ชัน `checkMyTicket`: ผู้ใช้ตรวจสอบสถานะตั๋วของตนเอง
  - ฟังก์ชัน `getTicketStatus`: ตรวจสอบสถานะตั๋วตาม address
  - ฟังก์ชัน `getAvailableTickets`: ตรวจดูจำนวนตั๋วที่เหลือในระบบ
