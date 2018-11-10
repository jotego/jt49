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

module jt49_eg(
  input           clk, // this is the divided down clock from the core
  input           cen,
  input           rst_n,
  input [3:0]     ctrl,
  output reg [3:0]gain
);

reg dir; // direction
reg stop;

wire CONT = ctrl[3];
wire ATT  = ctrl[2];
wire ALT  = ctrl[1];
wire HOLD = ctrl[0];

always @( posedge clk )
  if( !rst_n) begin
    gain  <=4'hF;
    dir   <=1'b0;
    stop  <=1'b0;
  end
  else if( cen ) begin
      if (!stop) begin
        if( !CONT && ((gain==0&&!dir) || (gain==4'hF&&dir))) begin
          stop <= 1'b1;
          gain <= 4'b0;
        end
        else begin
          if( HOLD && ( (gain==0&&!dir) || (gain==4'hF&&dir))) begin // HOLD
            stop <= 1'b1;
            gain <= ALT ? ~gain : gain;
          end 
          else begin
            gain <= dir ? gain+1 : gain-1;          
            if( ctrl[1:0]==2'b10 && ( (gain==1&&!dir) || (gain==4'hE&&dir))) 
              dir <= ~dir;  // ALTERNATE            
          end
        end
      end
    end
  end

endmodule
