---

# 🎮 Tic Tac Toe in 8086 Assembly Language

## 📌 Overview

This project is a **DOS-based two-player Tic Tac Toe game** implemented in **8086 Assembly Language** using the **EMU8086 emulator**. The game runs in text mode and allows two players to take turns by entering positions from **1 to 9**.

---

## ✨ Features

* 👥 Two-player gameplay (X vs O)
* 🧩 Text-based 3×3 game board
* ✅ Input validation (invalid & duplicate moves prevented)
* 🏆 Win detection (rows, columns, diagonals)
* 🤝 Draw detection
* 🔄 Screen refresh after every move

---

## 🛠️ Technologies Used

* 🧠 8086 Assembly Language
* 🖥️ EMU8086 Emulator
* 📟 DOS & BIOS interrupts (`INT 21h`, `INT 10h`)

---

## ⚙️ How It Works

* 📦 The game board is stored in a **one-dimensional array**
* 🔁 Players alternate turns (`X` and `O`)
* 🧪 The game status is checked after each move
* 🛑 The game ends when a player wins or the board is full

---

## ▶️ How to Run

1. 🧾 Open the source code in **EMU8086**
2. ▶️ Compile and run the program
3. ⌨️ Enter a number (**1–9**) to place your move

---

## 🎓 Learning Outcomes

* 🧩 Understanding of **real-mode DOS programming**
* 🔌 Use of **interrupts for input/output**
* 🔄 Implementation of **loops, conditions, and procedures**
* 🧠 Application of **Computer Organization & Assembly Language** concepts

---

## 👨‍💻 Author

Syed Ali Hassan , 
Umair Qaiser

---

