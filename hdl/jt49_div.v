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

module jt49_div #(parameter width=12 )(   
    input           clk, // this is the divided down clock from the core
    input           cen,
    input           rst_n,
    input [width-1:0]  period,
    output reg      cen_div
);

reg [width-1:0]count;
reg div;

always @(negedge clk)
    cen_div <= div; // move it to the negative edge

wire [width-1:0] one = { {width-1{1'b0}}, 1'b1};

always @(posedge clk ) begin
  if( !rst_n) begin
    count <= one;
    div   <= 1'b0;
  end
  else if(cen) begin
    if( period=={width{1'b0}} ) begin
        count <= one;
        div   <= 1'b0;
    end
    else if( count == period ) begin
        count <= one;
        div   <= 1'b1;
    end
    else begin 
        count <= count + one;
        div   <= 1'b0;
    end
  end
end

endmodule
