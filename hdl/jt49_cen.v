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

module jt49_cen(
    input       clk,
    input       rst_n,
    input       cen,    // base clock enable signal
    input       sel,    // when low, divide by 2 once more
    output  reg cen16,
    output  reg cen256
);

reg [9:0] cencnt;
localparam eg = 3; //8;

always @(negedge clk, negedge rst_n) begin
    if(!rst_n)
        cencnt <= 10'd0;
    else begin 
        if(cen) cencnt <= cencnt+10'd1;
    end
end

always @(negedge clk) begin
    cen16  <= cen & toggle16;
    cen256 <= cen & toggle256;
end

wire toggle16 = sel ? cencnt[2:0]==3'd0 : cencnt[3:0]==4'd0;
wire toggle256= sel ? cencnt[eg-2:0]==7'd0 : cencnt[eg-1:0]==8'd0;


endmodule // jt49_cen