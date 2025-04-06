<p align="center"><img src="https://www.teso.rs/img/services-icon-04.png" alt="FPGA CPU Logo" width="100"></p>
<h1 align="center"> FPGA Pong CPU </h1>

<div align="center">
  
[![Contributors](https://img.shields.io/github/contributors/Ac3CJ/FPGA-CPU-And-Pong-Game)](https://github.com/Ac3CJ/FPGA-CPU-And-Pong-Game/graphs/contributors)
[![GitHub stars](https://img.shields.io/github/stars/Ac3CJ/FPGA-CPU-And-Pong-Game?style=flat-square)](https://github.com/Ac3CJ/FPGA-CPU-And-Pong-Game/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Ac3CJ/FPGA-CPU-And-Pong-Game)](https://github.com/Ac3CJ/FPGA-CPU-And-Pong-Game/forks)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/conradgacay/)
[![Issues](https://img.shields.io/github/issues/Ac3CJ/FPGA-CPU-And-Pong-Game)](https://github.com/Ac3CJ/FPGA-CPU-And-Pong-Game/issues)
![License](https://img.shields.io/badge/license-MIT-blue)
  
</div>

This project showcases a fully custom-designed CPU implemented on an FPGA, capable of running a playable version of Pong with real-time VGA video output.

---

## Table of Contents

- [Introduction](#introduction)  
- [Features](#features)  
- [Architecture Overview](#architecture-overview)  
- [Game Design](#game-design)  
- [VGA Output](#vga-output)  
- [Setup](#setup)  
- [Usage](#usage)  
- [Development Flow](#development-flow)  
- [References](#references)  
- [FAQ](#faq)  
- [Contact](#contact)  
- [Authors](#authors)  
- [License](#license)

---

## Introduction

This project began with the design of a custom CPU from the ground up, using Verilog. Once the CPU architecture and instruction set were validated, a classic Pong game was programmed in assembly and run natively on the CPU. The output is visualized through a VGA interface, offering a real-time gaming experience on an external display.

---

## Features

- Fully custom CPU built in Verilog  
- Pong game written in custom assembly language  
- VGA video output (640x480 @ 60Hz)  
- Paddle control via switches/buttons  
- Score tracking and ball physics  
- Clock-accurate pixel rendering  

---

## Architecture Overview

- **Instruction Set**: RISC-style with basic arithmetic, branching, memory access, and I/O operations  
- **Registers**: General-purpose register file with accumulator support  
- **Clocking**: CPU and VGA run on derived clock signals  
- **Memory**: Dual-port RAM for instruction and data separation  
- **Peripherals**:
  - VGA controller  
  - Input handler (paddles)  
  - Game logic block  

---

## Game Design

- 2-player Pong with CPU-controlled or manual paddle options  
- Ball speed increases over time  
- Collision detection with screen edges and paddles  
- Simple scoring logic displayed via LEDs or VGA overlay  

---

## VGA Output

- **Resolution**: 640x480 @ 30Hz  
- **Color Depth**: 3-bit (R, G, B via GPIO)  
- **Sync Signals**: Horizontal and vertical sync generated in real-time  
- **Display**:
  - Background  
  - Ball  
  - Paddles  
  - Score  

---

## Setup

1. Flash the bitstream onto your FPGA board (e.g., Xilinx Basys3, DE10-Lite, etc.)  
2. Connect VGA output to a compatible display  
3. Connect switches or buttons for paddle control  
4. Power on the board  

> Note: Ensure that your board supports VGA output and has enough I/Os for video signals.

---

## Usage

- **Left Paddle**: Switch/Button A/B  
- **Right Paddle**: Switch/Button C/D  
- **Reset Game**: Press the Reset button on the FPGA board  
- Observe the game on the VGA-connected monitor.

---

## Development Flow

1. CPU design in Verilog  
2. Instruction set specification  
3. Assembly language development  
4. Pong game programming  
5. VGA driver integration  
6. System integration and timing validation  

**Tools used:**
- Quartus Prime
- SystemVerilog

---

## References

- [VGA Timing Guide](https://www.epanorama.net/documents/pc/vga_timing.html)  
- [Xilinx Basys3 Board](https://digilent.com/reference/programmable-logic/basys-3/start)  
- [FPGA Pong Tutorial (Reference)](https://projectf.io/posts/fpga-graphics/)  

---

## FAQ

### Q: What language is the game written in?  
A: It is all written in SystemVerilog

### Q: How is video handled?  
A: A VGA controller module generates the required sync and pixel timing signals. The framebuffer is drawn dynamically based on game state.

### Q: Can I use a different FPGA board?  
A: No, I do not recommend deviating from the FPGA board used

### Q: Does it support sound?  
A: Not currently, but the CPU design is modular, and sound generation can be added as a peripheral.

---

## Contact

Got a question or want to collaborate?

- Email: [cjg75@bath.ac.uk](mailto:cjg75@bath.ac.uk)  
- GitHub Issues: [Open an Issue](https://github.com/Ac3CJ/FPGA-CPU-And-Pong-Game/issues)

---

## Authors

- **Conrad Gacay** - [Ac3CJ](https://github.com/Ac3CJ)  

---

## License  

This project is licensed under the [MIT License](LICENSE).

---

<p align="center">🚀 Powered by Custom Silicon & Verilog 🎮</p>
