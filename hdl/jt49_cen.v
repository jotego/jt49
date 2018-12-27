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
    input   clk,
    input   rst_n,
    input   cen,    // base clock enable signal
    input   sel,    // when low, divide by 2 once more
    output  reg cen2,
    output  reg cen4,
    output  reg cen8,
    output  reg cen16
);

reg cen0;

always @(negedge clk)
    if( !rst_n ) begin
        cen0  <= 1'b1;
        cen2  <= 1'b1;
        cen4  <= 1'b1;
        cen8  <= 1'b1;
        cen16 <= 1'b1;
    end else begin
        cen0  <= sel ? 1'b1 : (cen ? ~cen0 : cen0);
        cen2  <= (cen && cen0) ? ~cen2 : cen2;
        cen4  <= (cen && cen2) ? ~cen4  : cen4;
        cen8  <= (cen && cen4) ? ~cen8  : cen8;
        cen16 <= (cen && cen8) ? ~cen16 : cen16;
    end

endmodule // jt49_cen