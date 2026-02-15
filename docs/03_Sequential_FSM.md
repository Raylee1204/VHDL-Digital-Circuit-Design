# Module 03: Sequential Logic, RTL Analysis & FSM

本模組深入探討 VHDL 描述風格 (Description Style) 對電路合成結果的影響，以及有限狀態機 (FSM) 的設計架構。
實驗重點在於透過 **RTL 視圖 (Register Transfer Level View)** 觀察不同程式碼寫法如何映射到實際的邏輯閘與正反器，並實作積時脈 (Gated Clock) 延時電路與 FSM 控制器。

## 1. Gated Clock Delay Circuit (積時脈延時電路)

本實驗設計一個由 3 級 DFF 串接而成的延時電路 (Shift Register)，並透過 Enable 訊號控制時脈輸入 (Clock Gating)。我們採用兩種不同的 VHDL 風格進行實作並比較結果。

### 1.1 Structural Description (結構化描述)
此方法模擬「畫電路圖」的過程。我們先定義一個標準的 `D_FlipFlop` 元件 (Component)，再於上層電路中利用 `PORT MAP` 將其串接，並手動描述 AND 閘來控制 Clock。

* **Implementation**: Explicitly instantiating DFF primitives.
* **RTL Observation**: 合成出的電路圖應精確顯示出 3 個 DFF 元件，且其 Clock端皆連接到同一個 AND 閘的輸出。

    -- Code Snippet: Structural Gated Clock
    Gated_Clk <= Sys_Clk AND En;
    
    U1: DFF PORT MAP (D => Input, Clk => Gated_Clk, Q => W1);
    U2: DFF PORT MAP (D => W1,    Clk => Gated_Clk, Q => W2);
    U3: DFF PORT MAP (D => W2,    Clk => Gated_Clk, Q => Output);

### 1.2 Behavioral Description (行為描述)
此方法直接描述電路的運作邏輯。利用 `PROCESS` 與 `RISING_EDGE` 描述暫存器行為，讓合成器 (Synthesizer) 自動推斷電路結構。

* **Implementation**: Using a single process with a variable/signal array.
* **RTL Observation**: 觀察合成器是否生成了與結構化描述相同的電路，或是利用了 FPGA 內部的 Clock Enable (CE) 腳位來取代 AND 閘 (這是現代工具常見的優化)。

---

## 2. Finite State Machine (FSM) Design

FSM 是數位控制器的核心。本實驗針對同一邏輯功能分別實作 Mealy 與 Moore 架構，觀察其輸出時序的差異。

### 2.1 Mealy Machine (米利機)
* **Logic**: $Output = F(Current\_State, Input)$
* **Characteristics**: 輸出隨輸入訊號 **即時改變 (Asynchronous to Clock)**。
* **Pros/Cons**: 反應速度快，但容易受輸入雜訊 (Glitch) 影響導致輸出不穩。

### 2.2 Moore Machine (莫爾機)
* **Logic**: $Output = F(Current\_State)$
* **Characteristics**: 輸出僅在狀態改變時更新，與輸入訊號無直接路徑。
* **Pros/Cons**: 輸出與時脈同步 (Synchronous)，訊號品質佳，但反應較 Mealy 慢一個時脈週期。

---

## 3. Verification & Analysis

本模組的驗證重點在於 **RTL 結構分析** 與 **波形時序比較**。

### 3.1 RTL Schematic Analysis (Gated Clock)
下圖比較了結構化 (左) 與行為化 (右) 描述的合成結果：

<img width="1331" height="291" alt="image" src="https://github.com/user-attachments/assets/30aa0b72-0d43-468f-a606-07bab8d89f0f" />

*(Figure: 左圖顯示明確的 AND 閘與 DFF；右圖顯示合成器優化後的暫存器結構)*

> **Analysis**: 
> 結構化寫法強制產生了 Clock Gating Logic，這在低功耗設計中很有用，但需注意 Glitch 風險。行為化寫法通常被映射為帶有 Clock Enable 的 Flip-Flop，時序較為安全。

### 3.2 FSM Waveform Comparison
下圖展示了 Mealy 與 Moore 機在相同輸入序列下的輸出反應：

<img width="1037" height="642" alt="image" src="https://github.com/user-attachments/assets/e0a9ef42-74aa-40e3-a530-9ecad9b12a10" />

<img width="1151" height="474" alt="image" src="https://github.com/user-attachments/assets/3a6e5637-fb63-4d13-8071-320c14aa4e8a" />

*(Figure: 上方為 Mealy 輸出，可見其在 Input 變化時立即轉態；下方為 Moore 輸出，嚴格對齊 Clock Edge)*
