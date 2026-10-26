# ไอคอนเปิด Pepperstone MT5

สคริปต์สร้างไอคอน (shortcut) ของ **Pepperstone MetaTrader 5** บน Desktop และใน Start Menu
โดยใช้ไอคอนของ Pepperstone ที่อยู่ในไฟล์ `terminal64.exe`

## วิธีใช้ (Windows)

1. ดาวน์โหลดโฟลเดอร์ `mt5-shortcut` ลงเครื่อง
2. ดับเบิลคลิก `create-shortcut.bat`
3. จะได้ไอคอน **Pepperstone MT5** บน Desktop และใน Start Menu

สคริปต์จะหา MT5 ให้อัตโนมัติจาก:
- `C:\Program Files\Pepperstone MetaTrader 5\terminal64.exe` (ที่ติดตั้งปกติ)
- รายการโปรแกรมที่ติดตั้งใน Registry
- โฟลเดอร์ใน Program Files ที่มีคำว่า `Pepperstone`

## ของแถม

- **คีย์ลัด** `Ctrl + Alt + M` เปิด MT5 ได้ทันที
- อยากปักไว้ที่ Taskbar: คลิกขวาไอคอนบน Desktop → **Pin to taskbar**

## ตัวเลือกเพิ่มเติม

ถ้าติดตั้ง MT5 ไว้ที่อื่น ให้ระบุ path เอง:

```bat
create-shortcut.bat -TerminalPath "D:\MT5\terminal64.exe"
```

| ตัวเลือก | ความหมาย |
|---|---|
| `-TerminalPath "..."` | ระบุตำแหน่ง `terminal64.exe` เอง |
| `-Name "ชื่อ"` | เปลี่ยนชื่อไอคอน (ค่าเริ่มต้น `Pepperstone MT5`) |
| `-Hotkey "CTRL+ALT+P"` | เปลี่ยนคีย์ลัด (ใส่ `""` เพื่อปิด) |
| `-NoStartMenu` | สร้างเฉพาะบน Desktop |
