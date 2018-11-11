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

module jt49 ( // note that input ports are not multiplexed
    input           rst_n,
    input           clk,    // signal on positive edge
    input           cen,    // clock enable on negative edge
    input  [3:0]    addr,
    input           cs_n,
    input           wr_n,  // write
    input  [7:0]    data_in,
    output reg [7:0] data_out,
    output reg [9:0] sound
);

reg [7:0] regarray[15:0];
reg [3:0] clkdiv16;
reg cen_ch; // clock enable for channels

wire [4:0] envelope;
wire A,B,C;
wire noise, envclk;
reg Amix, Bmix, Cmix;

always @(negedge clk)
    cen_ch <= cen & clkdiv16[2];

// internal modules operate at clk/16
jt49_div #(12) u_chA( 
    .clk        ( clk           ), 
    .rst_n      ( rst_n         ), 
    .cen        ( cen_ch        ),
    .period     ( {regarray[1][3:0], regarray[0][7:0] } ), 
    .div        ( A             )
);

jt49_div #(12) u_chB( 
    .clk        ( clk           ), 
    .rst_n      ( rst_n         ), 
    .cen        ( cen_ch        ),    
    .period     ( {regarray[3][3:0], regarray[2][7:0] } ),   
    .div        ( B             ) 
);

jt49_div #(12) u_chC( 
    .clk        ( clk           ), 
    .rst_n      ( rst_n         ), 
    .cen        ( cen_ch        ),
    .period     ( {regarray[5][3:0], regarray[4][7:0] } ), 
    .div        ( C             )
);

// the noise uses a x2 faster clock in order to produce a frequency
// of Fclk/16 when period is 1
jt49_noise u_ng( 
    .clk    ( clk               ), 
    .cen    ( cen_ch            ),
    .rst_n  ( rst_n             ), 
    .period ( regarray[6][4:0]  ), 
    .noise  ( noise             ) 
);

// envelope generator
jt49_div #(16) u_envdiv( 
    .clk    ( clkdiv16[2]       ), 
    .cen    ( cen               ),
    .rst_n  ( rst_n             ),
    .period ({regarray[14],regarray[13]}), 
    .div    ( envclk            ) 
);  

reg eg_restart;

jt49_eg u_env(
    .clk    ( envclk            ),
    .cen    ( cen               ),
    .rst_n  ( rst_n             ),
    .restart( eg_restart        ),
    .ctrl   ( regarray[4'hD][3:0] ),
    .env    ( envelope          )
);

reg  [4:0] logA, logB, logC;
wire [7:0] linA, linB, linC;

jt49_exp u_expA(
    .din    ( logA ),
    .dout   ( linA )
);

jt49_exp u_expB(
    .din    ( logB ),
    .dout   ( linB )
);

jt49_exp u_expC(
    .din    ( logC ),
    .dout   ( linC )
);

wire [4:0] volA = { regarray[ 8][3:0], regarray[ 8][3] };
wire [4:0] volB = { regarray[ 9][3:0], regarray[ 9][3] };
wire [4:0] volC = { regarray[10][3:0], regarray[10][3] };
wire use_envA = regarray[ 8][4];
wire use_envB = regarray[ 9][4];
wire use_envC = regarray[10][4];

always @(posedge clk) if( cen ) begin
    Amix <= (noise|regarray[7][3]) ^ (A|regarray[7][0]);
    Bmix <= (noise|regarray[7][4]) ^ (B|regarray[7][1]);
    Cmix <= (noise|regarray[7][5]) ^ (C|regarray[7][2]);

    logA <= !Amix ? 5'd0 : (use_envA ? envelope : volA );
    logB <= !Bmix ? 5'd0 : (use_envB ? envelope : volB );
    logC <= !Cmix ? 5'd0 : (use_envC ? envelope : volC );
   
    sound <= { 2'b0, linA } + { 2'b0, linB } + { 2'b0, linC };
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
        eg_restart <= 1'b0;
        regarray[0]=8'd0; regarray[4]=8'd0; regarray[ 8]=8'd0; regarray[12]=8'd0;
        regarray[1]=8'd0; regarray[5]=8'd0; regarray[ 9]=8'd0; regarray[13]=8'd0;
        regarray[2]=8'd0; regarray[6]=8'd0; regarray[10]=8'd0; regarray[14]=8'd0;
        regarray[3]=8'd0; regarray[7]=8'd0; regarray[11]=8'd0; regarray[15]=8'd0;
    end else if( cen && !cs_n ) begin
        data_out <= regarray[ addr ];
        if( !wr_n ) regarray[addr] <= data_in;
        eg_restart <= addr == 4'hD;
    end

endmodule
