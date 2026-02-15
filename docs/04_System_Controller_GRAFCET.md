# Module 04: System Controller Design via GRAFCET

本模組為本課程的期末整合實作，引進工業自動化標準 **GRAFCET (IEC 60848)** 作為系統設計工具。
不同於傳統 FSM 僅能描述單一狀態流，GRAFCET 能有效描述 **平行處理 (Concurrency)** 與 **多工同步 (Synchronization)**。本實驗以「化學預拌槽控制系統」為例，展示 **MIAT System Design Methodology** 如何將離散事件圖形轉換為可合成的 VHDL 電路。

## 1. System Overview: Chemical Mixer

### 1.1 Scenario Description
系統包含兩個進料閥 ($V1, V2$)、一個攪拌馬達 ($M$) 與一個排放閥。控制流程如下：
1.  **Initial**: 等待啟動訊號。
2.  **Feeding**: 開啟 $V1$ 注料，直到達到水位感測器 $H1$。
3.  **Adding**: 開啟 $V2$ 添加催化劑，直到水位 $H2$。
4.  **Mixing**: 關閉閥門，啟動馬達 $M$ 攪拌 $T$ 秒。
5.  **Draining**: 開啟排放閥直到槽空 ($L$ level)。

### 1.2 The GRAFCET Model
GRAFCET 由 **Steps (步驟)**、**Transitions (轉移條件)** 與 **Actions (動作)** 組成。
* **Divergence (分支)**: 根據條件選擇不同路徑 (OR Logic)。
* **Simultaneity (平行)**: 同時啟動多個步驟 (AND Logic)，例如同時進料與加熱。
<img width="496" height="335" alt="image" src="https://github.com/user-attachments/assets/b491cdad-532a-47a7-9ab4-479ac86fe27a" />

<img width="971" height="621" alt="image" src="https://github.com/user-attachments/assets/7d636143-28eb-4d78-9436-66938879b6c8" />

*(Figure: 化學預拌槽之 GRAFCET 功能圖，定義了系統的操作序列)*

---

## 2. MIAT Methodology: From Chart to VHDL

本實驗採用 **直接映射法 (Direct Mapping)**，將 GRAFCET 的邏輯結構直接轉換為 VHDL 代碼。這種方法具有極高的可讀性與維護性。

### 2.1 Step Variable Definition
我們不使用傳統的 `CASE` 語句 (Enumerated States)，而是為每一個 GRAFCET Step 定義獨立的訊號 (Boolean/Bit)，這允許系統同時處於多個 Step (平行處理)。

    -- Code Snippet: State Variables
    signal X_Init, X_Fill_V1, X_Fill_V2, X_Mix, X_Drain : std_logic;

### 2.2 Transition Logic (Evolution)
每個 Step 的狀態更新取決於：「前一個 Step 啟動」**AND**「轉移條件成立」。

    -- Code Snippet: Transition Logic (Next State Logic)
    process(clk, reset)
    begin
        if reset = '1' then
            X_Init <= '1'; X_Fill_V1 <= '0'; -- Reset state
        elsif rising_edge(clk) then
            -- Transition: Init -> Fill V1
            if X_Init = '1' and Start_Btn = '1' then
                X_Init <= '0';
                X_Fill_V1 <= '1';
            end if;
            
            -- Transition: Fill V1 -> Fill V2
            if X_Fill_V1 = '1' and Sensor_H1 = '1' then
                X_Fill_V1 <= '0';
                X_Fill_V2 <= '1';
            end if;
            
            -- (More transitions...)
        end if;
    end process;

### 2.3 Action Logic (Output)
輸出的控制邏輯與 Step 狀態直接關聯 (Moore-like behavior)。

    -- Code Snippet: Output Generation
    Valve_V1 <= '1' when X_Fill_V1 = '1' else '0';
    Valve_V2 <= '1' when X_Fill_V2 = '1' else '0';
    Motor_M  <= '1' when X_Mix = '1'     else '0';

---

## 3. Verification & Simulation

### 3.1 Test Scenario
驗證過程模擬了完整的配方流程：
1.  **Stimuli**: 手動觸發 `Start`，依序拉高水位感測器 `H1`, `H2` 訊號模擬注水過程，並提供 Timer 完成訊號。
2.  **Observation**: 觀察 `Valve_V1`, `Valve_V2`, `Motor` 是否依序動作，且狀態轉移無死鎖 (Deadlock)。

### 3.2 Waveform Result
<img width="1395" height="426" alt="image" src="https://github.com/user-attachments/assets/a2fa5ae5-7507-4f3b-ae9a-405a17648512" />

*(Figure: 系統模擬波形圖。可見當 Sensor_H1 觸發後，V1 自動關閉並切換至 V2 開啟)*

> **Conclusion**: 
> 透過 GRAFCET 方法論，我們成功將複雜的順序控制問題 (Sequential Control) 拆解為直觀的圖形邏輯。相比傳統 FSM，此方法在處理大型工控系統時，具有更清晰的邏輯結構與除錯便利性。

## 4. RTL Schematic
<img width="1103" height="708" alt="image" src="https://github.com/user-attachments/assets/b9611e51-d886-4786-9c5c-cf5f23bb3073" />

