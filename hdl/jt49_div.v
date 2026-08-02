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

/* verilator coverage_off */
module jt49_div #(
    parameter W=12,
    parameter MUTE_NULL_PERIOD=1
)(
    (* direct_enable *) input cen,
    input           clk, // this is the divided down clock from the core
    input           rst_n,
    input [W-1:0]  period,
    output reg      div
);

reg [W-1:0]count;

wire [W-1:0] one = { {W-1{1'b0}}, 1'b1};
wire [W-1:0] effective_period =
    !MUTE_NULL_PERIOD && period == {W{1'b0}} ? one : period;

always @(posedge clk, negedge rst_n ) begin
  if( !rst_n) begin
    count <= one;
    div   <= 1'b0;
  end else if(cen) begin
    if( count>=effective_period ) begin
        count <= one;
        div   <= ~div;
    end else begin
        count <=  count + one ;
    end
    if(MUTE_NULL_PERIOD && period==0) div<=0;
  end
end

endmodule
