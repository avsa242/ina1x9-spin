{
    --------------------------------------------
    Filename: sensor.power.ina1x9.spin
    Author: Jesse Burt
    Description: Driver for the TI INA1x9 analog DC current sensor (139, 169)
    Copyright (c) 2024
    Started Jan 14, 2024
    Updated Jan 14, 2024
    See end of file for terms of use.
    --------------------------------------------

    Requirements:
        * an ADC driver with the following interfaces:
            voltage() (ADC word scaled to microvolts)

    Usage:
        One of start(), bind(), attach() _must_ first be called from the parent object/application,
            with a pointer to the chosen ADC driver's OBJ symbol. That is how this driver is
            "attached" to the ADC.
        Example 'application.spin':

            OBJ

                adc:    ADC_DRIVER
                pwr:   "sensor.power.ina1x9"    ' this driver

            PUB main()

                pwr.init(@adc)                  ' point to the adc object

        The preprocessor symbol ADC_DRIVER must be set to the filename of your
        chosen ADC driver (the driver will default to using the MCP320x driver,
            if one isn't defined.)


        Example:

            #define ADC_DRIVER "signal.adc.mcp320x"
            #pragma exportdef(ADC_DRIVER)

        or on the command-line:

            flexspin -DADC_DRIVER=\"signal.adc.mcp320x\" -I$(SPIN1_STD_LIB_PATH) INA1X9-Demo.spin

            would build the demo utilizing the MCP320x driver as the chosen ADC
            (assuming SPIN1_STD_LIB_PATH is an environment variable set to the path of the
                spin-standard-library/library)


}

#include "sensor.power.common.spinh"            ' pull in code common to all sensor.power drivers

con

    INA_INTERNAL_RES    = 1_000 * MILLIOHM      ' INA1x9 internal resistance

    MILLIOHM            = 1_000


var

    long _instance                              ' pointer to ADC object
    long _shunt_r, _load_r, _shunt_load_r       ' resistance values
    long _avg                                   ' number of samples to average
    long _bias_i

#ifndef ADC_DRIVER
{ default to the MCP320x driver if one isn't specified }
#define ADC_DRIVER "signal.adc.mcp320x"
#endif

obj

    adc=    ADC_DRIVER                          ' "virtual" instance of the ADC driver
    math:   "math.unsigned64"                   ' unsigned 64-bit math routines


pub start = attach
pub bind = attach
pub attach(ptr): s
' Attach an ADC driver object instance
    _instance := ptr
    _avg := 1
    return cogid+1


pub stop()
' Stop the driver: reclaim variable space
    longfill(@_instance, 0, 5)


pub preset_adafruit_1164()
' Preset settings: Adafruit P/N 1164, INA169
'   R100 shunt resistance
'   10k load resistance
'   60V, 5A max
    shunt_resistance(100)
    load_resistance(10_000 * MILLIOHM)


pub preset_sparkfun_sen_12040()
' Preset settings: Sparkfun P/N SEN-12040, INA169
'   10R shunt resistance
'   10k load resistance
'   60V, 35mA max
    shunt_resistance(10)
    load_resistance(10_000 * MILLIOHM)


pub adc2amps(vo): i
' Convert ADC word to amperes
'   Returns: current in microamperes
' Is = (Vo * Rd) / (Rs * Rl)
    return math.multdiv(vo, INA_INTERNAL_RES, _shunt_load_r) + _bias_i


pub adc2volts(a): v
' not supported - for API compatibility only
    return 0


pub adc2watts(a): p
' not supported - for API compatibility only
    return 0


pub current_data(): i
' Get current measurement data
'   Returns: voltage as measured by the ADC
    i := 0
    repeat _avg                                 ' average some samples
        i += adc[_instance].voltage()
    i /= _avg

    return i


pub load_resistance(r)
' Set load resistance, in milli-Ohms
    _load_r := 1 #> r <# posx
    _shunt_load_r := (_shunt_r * _load_r) / 1000' load * shunt R, scaled down for micro-amperes


pub power_data(): p
' not supported - for API compatibility only
    return 0


pub samples_avg(smp=-2): s
' Set number of shunt ADC samples to take when averaging
'   Valid values: 1..POSX
'   NOTE: 1 effectively disables averaging
    _avg := 1 #> smp <# posx


pub set_current_bias(b)
' Set bias/offset value for current measurements, in microamperes
    _bias_i := b


pub shunt_resistance(r)
' Set shunt resistance, in milli-Ohms
    _shunt_r := 1 #> r <# posx
    _shunt_load_r := (_shunt_r * _load_r) / 1000' load * shunt R, scaled down for micro-amperes


pub voltage_data(): v
' not supported - for API compatibility only
    return 0


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

