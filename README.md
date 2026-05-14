# Simple Banking System (NASM Assembly)

A command-line banking system developed using NASM Assembly Language on Kali Linux. This project demonstrates fundamental low-level programming concepts including user interaction, arithmetic operations, branching, loops, and system calls.

---

## 🚀 Key Features

* **Check Balance:** View the current account balance.
* **Deposit Money:** Add funds to the account balance.
* **Withdraw Money:** Deduct funds from the account balance with validation.
* **Exit System:** Safely terminate the program.

---

## 🛠️ Tech Stack

* **Programming Language:** NASM Assembly Language
* **Operating System:** Kali Linux
* **Assembler:** NASM
* **Linker:** LD (GNU Linker)
* **Development Environment:** Linux Terminal / VS Code

---

## ⚙️ Installation & Execution

### **1. Clone the repository**
```bash
git clone https://github.com/yourusername/nasm-bank-system.git
```

### **2. Navigate to the project folder**
```bash
cd nasm-bank-system
```

### **3. Assemble the source code**
```bash
nasm -f elf64 bank.asm -o bank.o
```

### **4. Link the object file**
```bash
ld bank.o -o bank
```

### **5. Run the program**
```bash
./bank
```

---

## 📚 Concepts Demonstrated

* Assembly language programming
* Linux system calls
* Conditional branching and loops
* Arithmetic operations
* User input and output handling
* Modular programming structure

---

## 📸 Sample Output

```text
===== BANKING SYSTEM =====
1. Check Balance
2. Deposit
3. Withdraw
4. Exit

Enter your choice:
```
