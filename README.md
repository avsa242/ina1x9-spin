# ina1x9-spin
-------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the INA1x9-series analog DC current sensors.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* Object-oriented: attach any compatible ADC driver from the top-level application
* Set circuit parameters: Rs (shunt) and Rl (load) resistance values
* Set optional sample averaging
* Set optional current bias/offset


## Requirements

P1/SPIN1:
* spin-standard-library
* sensor.power.common.spinh (provided by the spin-standard-library)
* an ADC driver to measure the shunt voltage (e.g., MCP320x)

P2/SPIN2:
* p2-spin-standard-library
* sensor.power.common.spin2h (provided by the p2-spin-standard-library)
* an ADC driver to measure the shunt voltage (e.g., MCP320x)


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.8.0)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.8.0)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.8.0)       | NuCode       | Build OK; runtime bad |
| P2        | SPIN2    | FlexSpin (6.8.0)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## HardwareCompatibility

* Tested with Adafruit PID# 1164 (INA169), connected via an MCP3202 ADC


## Limitations

* Very early in development - may malfunction, or outright fail to build
* Voltage and wattage functions return 0 since the sensor only has current measurement capability

