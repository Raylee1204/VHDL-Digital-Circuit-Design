# Module 01: Combinational Logic Design

本模組探討基礎組合邏輯電路 (Combinational Logic) 的 VHDL 實作。
不同於軟體程式的順序執行，硬體描述語言 (HDL) 的核心在於 **並行性 (Concurrency)**。本實驗透過解碼器、編碼器與多工器，驗證信號流 (Dataflow) 與行為級 (Behavioral) 兩種描述風格的合成結果。

## 1. 3-to-8 Decoder with Enable (解碼器)

### 1.1 Theory
解碼器將 $N$ 位元的二進位輸入轉換為 $2^N$ 條獨熱編碼 (One-hot) 的輸出線。本實作包含一個 **Enable (E)** 控制腳位，用於級聯擴充 (Cascading)。

* **Logic Function**: 
    * 當 `Enable = 1` 時，根據輸入 `A` (3-bit) 決定哪一條 `Y` (8-bit) 為 High。
    * 當 `Enable = 0` 時，所有輸出強制為 Low。

### 1.2 VHDL Implementation Strategy
我們使用 **`WITH ... SELECT`** 語法 (Selected Signal Assignment) 來實作。這種寫法屬於 **Dataflow Description**，語法簡潔且直觀對應到硬體的 Look-Up Table (LUT) 結構。

```vhdl
-- Code Snippet: Decoder Logic using Selected Signal Assignment
with A select
    Y <= "00000001" when "000",
         "00000010" when "001",
         -- ... (other cases)
         "00000000" when others; -- Fail-safe mechanism
```

---

## 2. 8-to-3 Priority Encoder (優先權編碼器)

### 2.1 Theory
編碼器執行解碼器的逆運算。考慮到真實世界中，可能同時有多個輸入訊號被觸發，因此必須實作 **優先權 (Priority)** 機制：
* **Priority Logic**: 設定較高位元的輸入 (如 $I_7$) 擁有較高優先權。當 $I_7$ 為 High 時，無論低位元 ($I_0 \sim I_6$) 狀態為何，輸出皆對應 $I_7$ 的編碼。

### 2.2 VHDL Implementation Strategy
為了處理優先權判斷，使用 **`IF ... ELSIF`** 結構 (必須包含在 `PROCESS` 區塊內) 是最合適的，因為 `IF-ELSE` 語句本身即隱含了順序性的優先判斷。

* **Synthesis Note (合成筆記)**: 
    使用 `IF-ELSIF` 結構在邏輯合成時，通常會產生串接的 MUX 鏈 (Priority Chain)。若層數過多，可能會導致關鍵路徑 (Critical Path) 變長，影響電路的最高運作頻率。

---

## 3. Multiplexer (MUX) & Demultiplexer (DEMUX)

### 3.1 8-to-1 Multiplexer (多工器)
多工器如同「數據選擇開關」，根據選擇訊號 $S$ (3-bit)，從 8 個輸入通道中選擇一個導通至輸出 $Y$。
* **Application**: 常用於並列轉串列 (Parallel-to-Serial) 轉換器或 CPU 內部的匯流排仲裁 (Bus Arbitration)。

### 3.2 1-to-8 Demultiplexer (解多工器)
解多工器將單一數據源分配至 8 個不同的通道。
* **VHDL Style**: 我們使用 **`CASE`** 語句描述。由於 MUX/DEMUX 的選擇情境通常是**互斥 (Mutually Exclusive)** 的，使用 `CASE` 有助於合成器優化電路結構，避免產生不必要的 Latch。

---

## 4. Verification (Waveform Simulation)

本模組不依賴 Testbench 檔案，而是直接採用 EDA 工具的 **波形功能模擬 (Waveform Functional Simulation)** 功能進行驗證。不同於撰寫 Testbench 程式碼，本實驗直接利用 EDA 工具的 Waveform Editor 定義輸入訊號的時序 (Input Stimuli)，並觀察輸出的響應波形。

### 4.1 Verification Strategy
我們針對每個模組設計了特定的測試波形，以確保邏輯覆蓋率：
1.  **Truth Table Verification**: 遍歷所有可能的輸入組合 (例如 Decoder 的 000~111)，確認輸出符合真值表。
2.  **Control Signal Check**: 針對 `Enable` 訊號進行 Toggle 測試，確認其能正確啟用或關閉電路功能。

### 4.2 Simulation Result Analysis
下圖為實驗過程中的模擬結果截圖：

<img width="1218" height="578" alt="image" src="https://github.com/user-attachments/assets/9be72bc2-2edc-4f4d-8f8c-694a43576c0b" />

*(Figure: 透過 EDA 工具模擬之輸入/輸出波形圖)*

> **Observation**:
> 如圖所示，當輸入訊號依序變化時，輸出訊號在下一時脈週期或經過邏輯延遲後正確響應。例如在 Decoder 模擬中，當 `Enable` 拉高且輸入為特定位址時，對應的 Output bit 轉為 High，證明組合邏輯設計正確無誤。
