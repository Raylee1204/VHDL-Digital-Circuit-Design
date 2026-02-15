# Module 02: Arithmetic & Sequential Logic

本模組進入 **循序邏輯 (Sequential Logic)** 的領域。不同於組合邏輯輸出僅相依於當前輸入，循序邏輯具有 **記憶 (Memory)** 特性，其輸出取決於當前輸入與過去的狀態。本實驗實作了同步計數器、除頻器以及 BCD 算術電路，探討 **時脈邊緣 (Clock Edge)** 觸發的設計原則。

## 1. Binary Up/Down Counter (二進位計數器)

### 1.1 Theory
計數器是數位系統中最基礎的時序電路。本實作包含一個 **非同步重置 (Asynchronous Reset)** 與一個 **上/下數控制 (Up/Down Control)**。
* **Synchronous Design**: 所有狀態改變皆發生在時脈的正緣 (Rising Edge)。
* **Asynchronous Reset**: 當 Reset 訊號觸發時，計數器立即歸零，不需等待時脈訊號。這在系統初始化 (Power-on Reset) 中至關重要。

### 1.2 VHDL Implementation
使用 `PROCESS` 搭配 `EVENT` 或 `RISING_EDGE` 函數來描述正反器行為。

    -- Code Snippet: Up/Down Counter with Async Reset
    process(clk, reset)
    begin
        if (reset = '1') then
            count <= (others => '0');  -- Asynchronous Reset
        elsif rising_edge(clk) then
            if (up_down = '1') then
                count <= count + 1;
            else
                count <= count - 1;
            end if;
        end if;
    end process;

---

## 2. Clock Divider / Frequency Divider (除頻器)

### 2.1 Theory
在嵌入式系統中，常需將高頻的主時脈 (Master Clock) 降頻以驅動慢速周邊 (如 LED 閃爍)。
* **Divide-by-N**: 透過一個模數為 $N$ 的計數器，每數到 $N/2$ 或 $N$ 時反轉輸出訊號，產生頻率為 $f_{out} = \frac{f_{in}}{N}$ 的時脈。

### 2.2 Design Consideration (Critical)
在 FPGA 或 ASIC 設計中，直接使用計數器輸出的訊號作為下一級電路的 Clock (稱為 **Ripple Clock**) 是危險的，容易產生 Glitch 並造成 Timing Analysis 困難。
* **Best Practice**: 應產生一個 **Clock Enable** 訊號維持原本的高速 Clock Tree，而非創造新的 Clock Domain。*(本實驗為教學演示，採直接輸出波形方式)*

---

## 3. BCD Adder (二進位編碼十進位加法器)

### 3.1 Theory
BCD (Binary-Coded Decimal) 使用 4 個 bit 表示 0~9 的十進位數字。
* **Correction Logic (修正邏輯)**:
    當兩個 BCD 碼相加結果大於 9 (或產生 Carry) 時，二進位加法器會產生無效的 BCD 碼 (例如 1010 代表 10)。
    * **Algorithm**: 若 Sum > 9，則必須 **加 6 (0110)** 進行修正，以跳過 10~15 這 6 個無效狀態，並產生正確的進位。

### 3.2 Verification Scenario
驗證重點在於邊界條件：
* Case 1: $4 + 3 = 7$ (無修正)
* Case 2: $8 + 5 = 13$ (需修正：$1101 + 0110 = 10011$，即 BCD 的 1 和 3)

---

## 4. Verification (Waveform Simulation)

### 4.1 Counter Behavior
透過波形模擬觀察計數器的時序行為：
* **Reset Priority**: 驗證 Reset 拉高時，無論 Clock 為何，Output 立即歸零。
* **Edge Trigger**: 驗證數值的變化嚴格對齊 Clock 的 Rising Edge。

<img width="1280" height="373" alt="image" src="https://github.com/user-attachments/assets/cb1517da-e72c-482b-945e-1524172b6e76" />


> **Observation**:
> 如圖所示，計數器在 Reset 解除後開始運作。當 `Up/Down` 訊號改變時，計數方向在下一個 Clock Edge 正確切換，證明 setup/hold time 符合邏輯預期。
