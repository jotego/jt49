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

module jt49_noise(
  input clk, // this is the divided down clock from the core
  input rst_n,
  input cen,
  input [4:0]period,
  output noise
);

reg [5:0]count;
reg [16:0]poly17;
wire poly17_zero = poly17==0;
assign noise=poly17[16];
wire noise_clk;

always @(posedge noise_clk or negedge rst_n) begin
  if( !rst_n) begin
    poly17<=0;
  end
  else if(cen) begin
     poly17<={ poly17[0] ^ poly17[2] ^ poly17_zero, poly17[16:1] };
  end
end

jt49_clkdiv #(5) ndiv( 
  .clk    ( clk       ), 
  .cen    ( cen       ),
  .rst_n  ( rst_n     ), 
  .period ( period    ), 
  .div    ( noise_clk ) 
);

endmodule