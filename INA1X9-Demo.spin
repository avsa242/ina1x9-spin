{
    --------------------------------------------
    Filename: INA1X9-Demo.spin
    Author: Jesse Burt
    Description: Demo of the INA1x9 driver
        * INA169 connected to MCP3202 ADC
    Copyright (c) 2024
    Started Jan 14, 2024
    Updated Jan 14, 2024
    See end of file for terms of use.
    --------------------------------------------
}
CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq


OBJ

    cfg:    "boardcfg.flip"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    adc:    "signal.adc.mcp320x" | CS=0, SCK=1, MOSI=2, MISO=3
    sensor: "sensor.power.ina1x9"
    time:   "time"


PUB main()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( adc.start() )
        ser.strln(@"MCP320X driver started")
    else
        ser.strln(@"MCP320X driver failed to start - halting")
        repeat


    adc.defaults()
    adc.set_model(3202)                         ' 10bit: 3001, 2, 4, 8; 12bit: 3201, 2, 4, 8
    adc.set_adc_channel(0)                      ' select channel (# available is model-dependent)
    adc.set_ref_voltage(3_300_000)              ' set voltage ADC is supplied by (= ref. voltage)

    sensor.bind(@adc)                           ' attach the driver to the ADC object

    { use a set of presets depending on the module being used; these set the values of
        the resistors used on the board }
    sensor.preset_adafruit_1164()
    'sensor.preset_sparkfun_sen_12040()

    sensor.samples_avg(1)                       ' 1..posx; # of samples averaged to produce result
    sensor.set_current_bias(0)                  ' negx..posx; optional offset added to measurements

    demo()

#include "powerdemo.common.spinh"               ' pull in code common to all power sensor demos

DAT
{
Copyright (c) 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

