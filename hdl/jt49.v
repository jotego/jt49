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

module jt49 ( // note that input ports are not multiplexed
    input           rst_n,
    input           clk,    // signal on positive edge
    input           cen,    // clock enable on negative edge
    input  [3:0]    adr,
    input           wr,  // write
    input  [7:0]    data_in,
    output reg [7:0] data_out,
    output reg [9:0] sound
);

reg [7:0] regarray[15:0];
reg [3:0] clkdiv16;
reg cen_ch; // clock enable for channels

wire [3:0] envelope;
wire [2:0] sqwave;
wire noise, envclk;
reg Amix, Bmix, Cmix;

always @(negedge clk)
    cen_ch <= cen & clkdiv16[3];

// internal modules operate at clk/16
jt49_clkdiv #(12) chA( 
    .clk        ( clk           ), 
    .rst_n      ( rst_n         ), 
    .cen        ( cen_ch        ),
    .period     ( {regarray[1][3:0], regarray[0][7:0] } ), 
    .div        ( sqwave[0]     )
);

jt49_clkdiv #(12) chB( 
    .clk        ( clk           ), 
    .rst_n      ( rst_n         ), 
    .cen        ( cen_ch        ),    
    .period     ( {regarray[3][3:0], regarray[2][7:0] } ),   
    .div        ( sqwave[1]     ) 
);

jt49_clkdiv #(12) chC( 
    .clk        ( clk           ), 
    .rst_n      ( rst_n         ), 
    .cen        ( cen_ch        ),
    .period     ( {regarray[5][3:0], regarray[4][7:0] } ), 
    .div        ( sqwave[2]     )
);

// the noise uses a x2 faster clock in order to produce a frequency
// of Fclk/16 when period is 1
jt49_noise ng( 
    .clk    ( clk               ), 
    .cen    ( cen_ch            ),
    .rst_n  ( rst_n             ), 
    .period ( regarray[6][4:0]  ), 
    .noise  ( noise             ) 
);

// envelope generator
jt49_clkdiv #(16) envclkdiv( 
    .clk    ( clkdiv16[2]       ), 
    .cen    ( cen               ),
    .rst_n  ( rst_n             ),
    .period ({regarray[14],regarray[13]}), 
    .div    ( envclk            ) 
);  

jt49_eg env(
    .clk    ( envclk            ),
    .cen    ( cen               ),
    .rst_n  ( rst_n             ) 
    .ctrl   ( regarray[4'hD][3:0] ),
    .gain   ( envelope          ), 
);

reg [3:0] logA, logB, logC;
wire [8:0] linA, linB, linC;

jt49_exp expA(
    .din    ( logA ),
    .dout   ( linA )
);

jt49_exp expB(
    .din    ( logB ),
    .dout   ( linB )
);

jt49_exp expC(
    .din    ( logC ),
    .dout   ( linC )
);

always @(posedge clk) if( cen ) begin
    Amix <= (noise|regarray[7][3]) ^ (sqwave[0]|regarray[7][0]);
    Bmix <= (noise|regarray[7][4]) ^ (sqwave[1]|regarray[7][1]);
    Cmix <= (noise|regarray[7][5]) ^ (sqwave[2]|regarray[7][2]);

    logA <= regarray[4'h8][4]? envelope&{4{Amix}} : regarray[10][3:0]&{4{Amix}};
    logB <= regarray[4'h9][4]? envelope&{4{Bmix}} : regarray[10][3:0]&{4{Bmix}};
    logC <= regarray[4'hA][4]? envelope&{4{Cmix}} : regarray[10][3:0]&{4{Cmix}};
    
    sound <= { 1'b0, linA } + { 1'b0, linB } + { 1'b0, linC };
end


// 16-count divider
always @(posedge clk)
    if( !rst_n) begin
        clkdiv16<=0;
    end else if(cen) begin
        clkdiv16<=clkdiv16+1;
    end

// register array
always @(posedge clk)
    if( !rst_n ) begin
        data_out <= 8'd0;
    end else if(cen) begin
        data_out <= regarray[ adr ];
        if( wr ) regarray[adr] <= data_in;
    end

endmodule
