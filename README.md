# 🚀 CPU_ver620

> **A five-stage pipelined CPU design attempt following the study of digital logic and processor architecture.**  
> **基于数字逻辑与处理器体系结构学习的五级流水线CPU设计尝试。**

![Project Logo](https://github.com/WrzY23/cpu_3_ver620/blob/main/design/5-stage-pipeline.jpg?raw=true)

---

## 📚 项目简介 | Project Overview

本项目实现了一个基于 MIPS 架构的五级流水线 CPU，旨在加深对数字逻辑与处理器体系结构的理解。  
This project implements a 5-stage pipelined CPU based on the MIPS architecture, aiming to deepen the understanding of digital logic and processor architecture.

---

## 🛠️ 主要特性 | Features

- **五级流水线 (5-stage pipeline):**  
  IF - ID - EX - MEM - WB
- **分支指令处理 (Branch Handling):**  
  分支指令的 PC 在 ID 阶段计算，后续可考虑加入分支预测。  
  PC for branch instructions is computed in the ID stage; branch prediction can be considered in the future.
- **冒险处理 (Hazard Handling):**  
  当前设计未包含冒险检测单元（Hazard Unit not included）。
- **模块化设计 (Modular Design):**  
  代码结构清晰，便于扩展与维护。

---

## 🏗️ 设计结构 | Design Structure

```
IF  ->  ID  ->  EX  ->  MEM  ->  WB
```
- **IF (Instruction Fetch)**
- **ID (Instruction Decode)**
- **EX (Execute)**
- **MEM (Memory Access)**
- **WB (Write Back)**

---

## 🚦 注意事项 | Notes

- 分支指令的 PC 在 ID 阶段计算，后续可考虑分支预测。
- 设计中未包含冒险检测单元（Hazard Unit）。

---

## 📂 文件结构 | File Structure

```
cpu_3_ver620/
├── design/                # 设计相关图片与文档
├── src/                   # 源代码
├── testbench/             # 测试平台
├── README.md              # 项目说明
└── ...
```

---

## 🏃‍♂️ 快速开始 | Getting Started

1. 克隆本仓库 / Clone this repo:
   ```bash
   git clone https://github.com/WrzY23/cpu_3_ver620.git
   ```
2. 使用 Vivado 或其他支持的 FPGA 开发环境打开项目。
3. 查看 `src/` 目录下的源代码，或运行 `testbench/` 下的测试平台。

---

## 🙏 致谢 | Acknowledgements

- 感谢所有开源社区的贡献者。
- Thanks to all contributors from the open-source community.

---

## 📧 联系方式 | Contact

如有建议或问题，欢迎通过 [GitHub Issues](https://github.com/WrzY23/cpu_3_ver620/issues) 提出。

---
