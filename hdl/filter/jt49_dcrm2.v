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
    Date: 15-Jan-2019
    
    */

// DC removal filter
// input is unsigned
// output is signed

module jt49_dcrm2(
    input                clk,
    input                cen,
    input                rst,
    input         [7:0]  din,
    output signed [7:0]  dout
);

localparam dw=10; // widht of the decimal portion

reg  signed [8+dw:0] integ, exact, error;
reg  signed [2*(9+dw)-1:0] mult;
wire signed [8+dw:0] plus1 = { {8+dw-1{1'b0}},1'b1};
reg  signed [8:0] pre_dout;
reg signed [8+dw:0] dout_ext;
reg signed [8:0] q;

always @(*) begin
    exact = integ+error;
    q = exact[8+dw:dw];
    pre_dout  = { 1'b0, din } - q;
    dout_ext = { pre_dout, {dw{1'b0}} };    
    mult  = ( dout_ext * plus1)>>>dw;
end

assign dout = pre_dout[7:0];

always @(posedge clk)
    if( rst ) begin
        integ <= {8+dw{1'b0}};
        error <= {8+dw{1'b0}};
    end else if( cen ) begin
        integ <= integ + mult;
        error <= exact-{q, {dw{1'b0}}};
    end

endmodule