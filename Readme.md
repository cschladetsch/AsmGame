# NASM Project

## Overview
This project includes assembly code to generate a simple bitmap image using NASM (Netwide Assembler) on a Linux system or WSL (Windows Subsystem for Linux). The main goal is to create a bitmap (`output.bmp`) with basic pixel manipulation in assembly.

## File Description
- `main.asm`: Contains the NASM assembly code to generate the bitmap image.
- `br`: Bash script to assemble and link the assembly code.

## How to Run
1. Ensure NASM and ld are installed on your system.
2. Run the script to assemble and link the assembly code:
   ```bash
   ./br
   ```
3. Execute the generated binary to create the bitmap image:
   ```bash
   ./main
   ```

## Output
The output will be a bitmap image named `output.bmp` located in the same directory.

## Requirements
- NASM
- ld (Linker)
- A Linux environment or WSL

