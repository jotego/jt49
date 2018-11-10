/*  This file is part of JT49.

    JT49 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    JT49 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with JT49.  If not, see <http://www.gnu.org/licenses/>.
    
    Author: Jose Tejada Gomez. Twitter: @topapate
    Version: 1.0
    Date: 10-Nov-2018
    
    Based on sqmusic, by the same author
    
    */

`timescale 1ns / 1ps
module jt49_exp
    input      [3:0] din,
    output reg [8:0] dout 
);

always @(din)
    case (din) // each step is 1/sqrt(2) of the previous value, starting from the end
        4'd00: dout=9'd000;
        4'd01: dout=9'd003;
        4'd02: dout=9'd004;
        4'd03: dout=9'd005;
        4'd04: dout=9'd008;
        4'd05: dout=9'd011;
        4'd06: dout=9'd015;
        4'd07: dout=9'd021;
        4'd08: dout=9'd030;
        4'd09: dout=9'd043;
        4'd10: dout=9'd060;
        4'd11: dout=9'd085;
        4'd12: dout=9'd121;
        4'd13: dout=9'd171;
        4'd14: dout=9'd241;
        4'd15: dout=9'd341; // 341*3 = 1023, so the result fits in a 10-bit number
    endcase    
endmodule