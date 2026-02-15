# Module 01: Combinational Logic Design

本模組探討基礎組合邏輯電路 (Combinational Logic) 的 VHDL 實作。不同於軟體程式的順序執行，硬體描述語言 (HDL) 的核心在於 **並行性 (Concurrency)**。本實驗透過解碼器、編碼器與多工器，驗證信號流 (Dataflow) 與行為級 (Behavioral) 兩種描述風格的合成結果。

## 1. 3-to-8 Decoder with Enable (解碼器)

### 1.1 Theory
解碼器將 $N$ 位元的二進位輸入轉換為 $2^N$ 條獨熱編碼 (One-hot) 的輸出線。本實作包含一個 **Enable (E)** 控制腳位，用於級聯擴充 (Cascading)。

* **Logic Function**: 當 $E=1$ 時，根據輸入 $A$ (3-bit) 決定哪一條 $Y$ (8-bit) 為 High；當 $E=0$ 時，所有輸出均為 Low。

### 1.2 VHDL Implementation Strategy
我們使用 **`WITH ... SELECT`** 語法 (Selected Signal Assignment) 來實作，這種寫法簡潔且直觀對應到硬體的 Look-Up Table (LUT)。

```vhdl
-- Code Snippet: Decoder Logic
with A select
    Y <= "00000001" when "000",
         "00000010" when "001",
         ...
         "00000000" when others; -- Fail-safe
