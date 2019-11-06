# JT49 FPGA Clone of YM2149 hardware by Jose Tejada (@topapate)

You can show your appreciation through
* [Patreon](https://patreon.com/topapate), by supporting releases
* [Paypal](https://paypal.me/topapate), with a donation


YM2149 compatible Verilog core, with emphasis on FPGA implementation as part of JT12 in order to recreate the YM2203 part.

## Usage

There are two top level files you can use:
 - **jt49_bus**: presents the expected AY-3-8910 interface
 - **jt49**: presents a simplified interface, ideal to embed. This is the one used by jt12

## Resistor Load Modelling

The resistor load had an effect of gain compression on the chip. There is a parameter called **COMP** which can be used to model this effect. You can assign a value from 0 to 3.

Value | Dynamic Range | Equivalent resistor  
------|---------------|--------------------
 0    |  43.6 dB      | <1000 Ohm  
 1    |  29.1 dB      | ~8000 Ohm  
 2    |  21.8 dB      | ~40  kOhm (?)  
 3    |  13.4 dB      | ~99  kOhm  

## Non Linear Effects

- Saturation effects are not modelled
- Channel mixing effects by short circuiting the outputs are not modelled
