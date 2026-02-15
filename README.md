# VHDL Digital Circuit Design: From Logic Gates to System Controllers

![Language](https://img.shields.io/badge/language-VHDL-red) ![Platform](https://img.shields.io/badge/platform-Intel%20FPGA%20(DE10--Lite)-blue) ![Role](https://img.shields.io/badge/role-Teaching%20Assistant-orange)

## 📖 Project Overview
本專案為 **中央大學資工系 (NCU CSIE)** 數位邏輯設計課程的實作教材庫。
作為課程助教 (Teaching Assistant)，我整理了從基礎組合邏輯到進階系統控制器的完整開發路徑。本專案不僅包含標準的 VHDL 實作，更引入了 **MIAT 實驗室** 的 **GRAFCET (IEC 60848)** 系統設計方法論，展示如何將離散事件系統 (Discrete Event System) 轉化為可合成的硬體電路。

This repository serves as a comprehensive VHDL implementation archive for the Digital Logic Design curriculum. It bridges the gap between textbook theory and physical RTL synthesis, featuring a robust system design methodology for complex industrial controllers.

## 🚀 Key Technical Highlights
* **RTL Synthesis Analysis**: 比較 **行為描述 (Behavioral)** 與 **結構描述 (Structural)** 對邏輯合成結果 (RTL View) 的影響。
* **FSM & Timing**: 深入探討 **Mealy vs Moore** 狀態機的時序差異，以及 **Gated Clock** 對電路穩定性的影響。
* **System Methodology**: 應用 **GRAFCET** 圖形化建模工具設計化學預拌槽控制器，解決平行處理 (Concurrency) 與同步 (Synchronization) 問題。

---

## 📂 Module Architecture

| Module | Topic & Design Pattern | Implementation Focus | Documentation |
| :--- | :--- | :--- | :--- |
| **01. Combinational** | **Parallel Logic & Signal Flow**<br>Concurrent Statements | Decoder, Priority Encoder, MUX/DEMUX | [📝 Deep Dive: Logic Synthesis](docs/01_Combinational_Logic.md) |
| **02. Arithmetic** | **Sequential Logic & Arithmetic**<br>Synchronous Design, Reset Strategy | Up/Down Counter, Clock Divider, BCD Adder | [📝 Deep Dive: Sequential Circuits](docs/02_Arithmetic_Counters.md) |
| **03. FSM & Timing** | **State Machines & Clocking**<br>Mealy vs Moore, Gated Clock Risks | Shift Register Delay, Sequence Detector | [📝 Deep Dive: FSM & RTL Analysis](docs/03_Sequential_FSM.md) |
| **04. System Controller** | **GRAFCET Methodology**<br>Discrete Event System (DES) | Chemical Mixer Controller (MIAT Design) | [📝 Deep Dive: GRAFCET System Design](docs/04_System_Controller_GRAFCET.md) |

---

## 🛠️ Development Environment
* **FPGA Board**: Terasic DE10-Lite (Intel MAX 10 10M50DAF484C7G)
* **EDA Tool**: Intel Quartus Prime Lite / ModelSim
* **Language**: VHDL-93 / VHDL-2008 Standard



---
*Author: Ping-Jui, Lee (Raylee)*
*Department of Computer Science & Information Engineering, National Central University*
