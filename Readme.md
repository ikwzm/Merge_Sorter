Merge Sorter - VHDL
===================

# Overview

## Introduction

This repository provides the VHDL code for merge sorter.

## Documents (Japanese Language)

  1.  [introduction](./doc/ja/01_introduction.md)
  2.  [word package](./doc/ja/02_word_package.md)
  3.  [word compare](./doc/ja/03_word_compare.md)
  4.  [sorting network](./doc/ja/04_sorting_network.md)
  5.  [bitonic sorter](./doc/ja/05_bitonic_sorter.md)
  6.  [oddeven sorter](./doc/ja/06_oddeven_sorter.md)
  7.  [merge sort node(single word)](./doc/ja/07_merge_sort_node_single.md)
  8.  [merge sort node(multi  word)](./doc/ja/08_merge_sort_node_multi.md)
  9.  [merge sort tree](./doc/ja/09_merge_sort_tree.md)
  10. [merge sort core 1](./doc/ja/10_merge_sort_core_1.md)
  11. [merge sort core 2](./doc/ja/10_merge_sort_core_2.md)
  12. [merge sort core 3](./doc/ja/10_merge_sort_core_3.md)

## Licensing

Distributed under the BSD 2-Clause License.

# Simulation

An argsort with AXI I/F is provieded as a test example.

The VHDL code for argsort can be found at:

 * src/main/vhdl/examples/argsort_axi/

Also, the argsort test bench is located at:

 * src/test/vhdl/argsort_axi_test_bench.vhd
 * src/test/scenarios/argsort_axi/

## For GHDL

### Requirement

 * GHDL 0.35 or later
 * Ruby 2.5 or later

### Compiling Dummy_Plug

```
shell$ cd Dummy_Plug/sim/ghdl-0.35/dummy_plug
shell$ make
```

### Compiling PipeWork

```
shell$ cd PipeWork/sim/ghdl-0.35
shell$ make
```

### Run Test Bench

```
shell$ cd sim/ghdl-0.35/argsort_axi
shell$ make
```

## For Xilinx Vivado

### Requirement

  * Xilinx Vivado 2019.2

Caution. does not work with Vivado 2020.1

### Create Project

If you have already created a project, omit it
The Tcl script for generating the project is prepared in the following location

  * sim/vivado/argsort_axi/create_project.tcl
  * sim/vivado/argsort_axi/add_files.tcl

Running the Tcl script in Vivado as follows will generate the project.

  Vivado > Tools > Run Tcl Script.. > sim/vivado/argsort_axi/create_project.tcl

### Run Test Bench

Vivado > Open Project > sim/vivado/argsort_axi/argsort_axi.xpr

Flow Navigator > Run Simulation > Run behavioral Simulation

