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

module jt49_clkdiv #(parameter width=12 )(   
    input           clk, // this is the divided down clock from the core
    input           cen,
    input           rst_n,
    input [width-1:0]  period,
    output          div
);

reg [width-1:0]count;
reg clkdiv;

initial clkdiv=0;

assign div = period==1 ? clk : clkdiv;

always @(posedge clk or negedge rst_n) begin
  if( !rst_n) begin
    count   <= 0;
    clkdiv  <= 0;
  end
  else if(cen) begin
    if( period==0 ) begin
      clkdiv<=0;
      count <=0;
    end
    else if( count >= period ) begin
        count   <= 0;
        clkdiv  <= ~clkdiv;
      end
      else count <= count+1;
  end
end
endmodule
