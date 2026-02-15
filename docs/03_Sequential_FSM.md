# Module 03: Finite State Machines (FSM) & Clocking

本模組深入探討數位系統的核心控制單元——有限狀態機 (FSM)，以及時脈電路的設計考量。實驗包含基礎的 D-Flip Flop 行為描述、積時脈 (Gated Clock) 的現象觀察，以及 Mealy 與 Moore 兩種狀態機架構的實作與比較。

## 1. D-Flip Flop & Gated Clock Analysis

### 1.1 D-Flip Flop (DFF) vs. Latch
在 VHDL 中，正確描述時序邏輯至關重要。
* **DFF (Edge-Triggered)**: 僅在時脈邊緣 (Rising/Falling Edge) 更新輸出。這是同步設計的基礎。
* **Latch (Level-Sensitive)**: 在致能訊號 (Enable) 為高電位時，輸出隨輸入變化。
    * *Design Note*: 在 FPGA/ASIC 設計中，應盡量避免非預期的 Latch (Infer Latch)，因為這會導致靜態時序分析 (STA) 困難。

### 1.2 Gated Clock (積時脈)
本實驗透過邏輯閘 (AND Gate) 控制時脈的傳遞：`Gated_Clk <= Clk AND Enable`。

* **Observation**: 雖然這能停止下游電路的運作以節省功耗，但若 `Enable` 訊號在 `Clk` 為 High 時切換，會產生 **Glitch (毛邊/窄脈衝)**，導致電路誤動作。
* **Professional Insight**: 
    在實際 IC 設計中，必須使用標準元件庫 (Standard Cell) 中的 **Integrated Clock Gating (ICG)** Cell 來取代手動邏輯閘，以確保時脈訊號的完整性 (Clock Integrity)。

    -- Code Snippet: Manual Gated Clock (For Educational Demo)
    gated_clk <= clk and enable;
    
    process(gated_clk)
    begin
        if rising_edge(gated_clk) then
            q <= d;
        end if;
    end process;

---

## 2. Finite State Machine (FSM) Design

FSM 是控制資料路徑 (Datapath) 的核心邏輯。標準的 VHDL FSM 寫法通常包含三個部分：
1.  **State Register**: 處理時脈與重置，更新 Current State。
2.  **Next State Logic**: 組合邏輯，根據 Input 計算 Next State。
3.  **Output Logic**: 組合邏輯，決定輸出值。

### 2.1 Moore Machine (莫爾機)
* **Definition**: 輸出 (Output) **僅取決於當前狀態 (Current State)**。
* **Characteristics**: 輸出訊號與時脈同步，較穩定，不會受到輸入訊號雜訊的直接干擾。
* **Simulation Behavior**: 輸出變化通常會比輸入訊號晚一個時脈週期 (Latency)。

    -- Code Snippet: Moore Output Logic
    process(current_state)
    begin
        case current_state is
            when S0 => output <= "00";
            when S1 => output <= "01"; -- Output depends ONLY on state
            -- ...
        end case;
    end process;

### 2.2 Mealy Machine (米利機)
* **Definition**: 輸出 (Output) 取決於 **當前狀態 (Current State) 與 當前輸入 (Input)**。
* **Characteristics**: 能比 Moore 機更快響應輸入變化 (少一個 Cycle)，但輸入端的雜訊 (Glitch) 可能會直接傳導到輸出端。

    -- Code Snippet: Mealy Output Logic
    process(current_state, input_signal)
    begin
        case current_state is
            when S0 => 
                if input_signal = '1' then
                    output <= "10"; -- Output depends on State AND Input
                else
                    output <= "00";
                end if;
            -- ...
        end case;
    end process;

---

## 3. Verification (Waveform & State Diagram)

### 3.1 State Transition Analysis
為了驗證 FSM 的邏輯覆蓋率，我們繪製了狀態轉移圖 (State Diagram) 並對照波形模擬結果。

![FSM State Diagram](../assets/fsm_state_diagram.png)
*(Figure: 設計之狀態轉移圖，定義了所有狀態與跳轉條件)*

### 3.2 Waveform Comparison (Mealy vs. Moore)
下圖展示了針對同一邏輯功能 (例如序列偵測器 "101")，Mealy 與 Moore 機的輸出時序差異。

![Mealy vs Moore](../assets/waveform_mealy_vs_moore.png)
*(Figure: 上方為 Mealy 輸出，可見其在 Input 變化瞬間即改變；下方為 Moore 輸出，嚴格對齊 Clock)*

> **Analysis**:
> Mealy 機的輸出在第 N 個週期即產生反應，展現了較低的延遲；而 Moore 機的輸出則穩定地在第 N+1 個週期的 Clock Edge 後才轉態，提供了較佳的訊號品質。在系統設計中，需根據 Timing Budget 權衡選擇。
