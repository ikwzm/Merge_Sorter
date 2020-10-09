Merge Sorter - VHDL
===================

# Overview

## Introduction

This repository provides the VHDL code for merge sorter.

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

