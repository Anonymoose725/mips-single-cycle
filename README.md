# Single-Cycle MIPS Processor

A 32-bit **single-cycle MIPS processor** implemented in **Logisim Evolution**, with supporting MIPS assembly programs designed for the **MARS MIPS simulator**.

The processor implements the core components of a MIPS datapath—including the program counter, instruction memory, register file, ALU, data memory, control unit, and next-PC logic—and executes each instruction in a single clock cycle.

## Features

* 32-bit single-cycle MIPS datapath
* Clocked program counter
* Instruction ROM
* Register file
* 32-bit ALU
* Data RAM
* Instruction decoding and control logic
* Immediate sign extension
* Branch address calculation
* Jump and branch control flow
* Memory load/store operations
* Memory-mapped I/O demonstrated through MARS
* Supporting MIPS assembly implementation of buffered keyboard input/output

## Supported Instructions

The processor supports the following categories of MIPS instructions:

| Category     | Instructions              |
| ------------ | ------------------------- |
| Memory       | `lw`, `sw`                |
| Arithmetic   | `add`, `addi`, `sub`      |
| Logical      | `and`, `or`, `xor`, `not` |
| Control Flow | branch, jump              |

The datapath uses the instruction opcode and function fields to determine the appropriate control signals and ALU operation.

## Architecture

The processor follows the standard single-cycle MIPS architecture:

```text
                    ┌────────────────┐
                    │       PC       │
                    └───────┬────────┘
                            │
                            ▼
                    ┌────────────────┐
                    │  Instruction   │
                    │      ROM       │
                    └───────┬────────┘
                            │
                       32-bit instruction
                            │
              ┌─────────────┴─────────────┐
              │                           │
              ▼                           ▼
       ┌────────────┐              ┌─────────────┐
       │  Control   │              │  Register   │
       │    Unit    │              │    File     │
       └─────┬──────┘              └──────┬──────┘
             │                            │
             │                       Register values
             │                            │
             │                    ┌───────▼───────┐
             └───────────────────►│      ALU      │
                                  └───────┬───────┘
                                          │
                                  ┌───────▼───────┐
                                  │  Data Memory  │
                                  └───────┬───────┘
                                          │
                                          ▼
                                     Write Back

                     ┌──────────────────────────┐
                     │       Next-PC Logic      │
                     │  PC + 4 / Branch / Jump  │
                     └──────────────────────────┘
```

Because this is a **single-cycle** implementation, instruction fetch, decode, register access, execution, memory access, and write-back occur within one clock cycle.

## Repository Structure

```text
mips-single-cycle/
├── miniMIPS.circ
├── keyboard.asm
└── README.md
```

### `miniMIPS.circ`

The main Logisim Evolution circuit containing the processor datapath.

Major components include:

* Program Counter
* Instruction ROM
* Register File
* ALU
* Data RAM
* Control Unit
* Multiplexers
* Adders
* Immediate sign-extension logic
* Branch and jump logic

The instruction ROM contains a small test program that can be stepped through using the processor clock.

### `keyboard.asm`

A MIPS assembly program intended to run in the **MARS simulator**.

It demonstrates memory-mapped I/O by interacting with MARS's simulated keyboard and display rather than relying exclusively on MARS system calls.

The program provides routines including:

* `getchar` — reads a character from the simulated keyboard
* `putchar` — writes a character to the simulated display
* `gets` — reads a buffered string
* `puts` — outputs a null-terminated string

The assembly also demonstrates MIPS function calls, stack frames, saved registers, loops, branches, and byte-level memory operations.

## Memory-Mapped I/O

`keyboard.asm` demonstrates how hardware devices can be accessed through memory addresses.

The keyboard and display are represented by special memory-mapped registers in MARS. The program polls these registers to determine when input/output devices are ready and then reads or writes the corresponding data.

Conceptually:

```text
                    ┌──────────────┐
                    │     CPU      │
                    └──────┬───────┘
                           │
                    Memory-mapped address
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
       Simulated Keyboard        Simulated Display
```

This provides a practical example of how a processor communicates with peripherals without requiring a dedicated I/O instruction.

## Running the Processor

### Logisim Evolution

1. Install **Logisim Evolution**.
2. Open `miniMIPS.circ`.
3. Start the circuit's clock.
4. Use the clock controls to step through instructions.
5. Observe the PC, registers, ALU, memory, and control signals as instructions execute.

The circuit was developed using Logisim Evolution.

### MARS

To run the assembly program:

1. Open `keyboard.asm` in the **MARS MIPS simulator**.
2. Assemble the program.
3. Run the program using MARS's simulated keyboard/display tools.
4. Observe the interaction between the assembly program and the simulated I/O devices.

## Example Instruction Flow

For a load instruction such as:

```asm
lw $t0, 0($t1)
```

the processor performs the following operations during a single cycle:

```text
$t1
 │
 ▼
ALU + immediate
 │
 ▼
Data Memory address
 │
 ▼
Read data
 │
 ▼
Register File
 │
 ▼
$t0
```

For a store instruction:

```asm
sw $t0, 0($t1)
```

the ALU calculates the memory address while the value from `$t0` is sent to data memory.

For a branch instruction, the processor calculates both the sequential address (`PC + 4`) and the branch target, then selects the appropriate next PC based on the branch condition.

## Goals

This project was built to explore the relationship between:

* MIPS instruction set architecture
* Machine-code encoding
* Digital logic
* Datapath design
* Control signals
* Memory
* CPU state
* Assembly programming
* Memory-mapped I/O

The project provides a complete path from a MIPS instruction at the ISA level to its execution as a sequence of hardware operations in a simulated processor.

## Tools

* **Logisim Evolution** — processor design and simulation
* **MARS MIPS Simulator** — assembly development and simulated I/O
* **MIPS Assembly** — processor test programs and I/O routines

## Author

**Ethan**

Built as a hands-on exploration of computer architecture and MIPS processor design.
