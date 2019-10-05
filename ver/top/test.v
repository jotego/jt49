`timescale 1ns / 1ps

module test;

reg clk, cen=1'b1, rst_n, restart;
wire [4:0] env;
reg  [3:0]ctrl;

initial begin
    clk = 1'b0;
    forever clk = #5 ~clk;
end // initial

initial begin
    rst_n = 1'b0;
    #50
    rst_n = 1'b1;
end // initial

reg [7:0] aux;

always @(posedge clk ) begin
    if(~rst_n) begin
        {ctrl,aux} <= 12'd0;
        restart <= 1'b0;
    end else begin
        {ctrl,aux} <= {ctrl,aux} + 12'd1;
        restart <= aux==8'd0;
    end
end

wire [9:0] sound;
reg  [7:0] data_in;
reg  [3:0] addr;
reg  wr_n;

reg [11:0] cmd_list [0:63];
integer cmd_cnt, cmd_wait, cmd_end=63;

initial begin : cmd_set
    integer cnt;
    for(cnt=0;cnt<64;cnt=cnt+1)
        cmd_list[cnt] = {4'hf,8'hff}; // wait

    cmd_list[ 0] = { 4'h0, 8'h01 };
    cmd_list[ 1] = { 4'h1, 8'h00 };  // set ch A freq 
    cmd_list[ 2] = { 4'h2, 8'h22 };
    cmd_list[ 3] = { 4'h3, 8'h02 };  // set ch B freq 
    cmd_list[ 4] = { 4'h4, 8'h23 };
    cmd_list[ 5] = { 4'h5, 8'h03 };  // set ch B freq 
    cmd_list[ 6] = { 4'hf, 8'hff };  // wait

    cmd_list[ 7] = { 4'h0, 8'h00 };
    cmd_list[ 8] = { 4'h1, 8'h00 };  // stop ch A freq 
    cmd_list[ 9] = { 4'h7, 8'h31 };  // A = noise
    cmd_list[10] = { 4'h6, 8'h03 };  // noise freq
    cmd_list[11] = { 4'hf, 8'hff };  // wait

    // envelope
    cmd_list[12] = { 4'hd, 8'h0e };  // zig zag
    cmd_list[13] = { 4'hc, 8'h00 };  // freq. of envelope MSB
    cmd_list[14] = { 4'hb, 8'h00 };  // freq. of envelope LSB
    cmd_list[15] = { 4'h8, 8'h10 };  // ch A controlled by eg

    cmd_list[17] = { 4'hd, 8'b0_000 };
    cmd_list[19] = { 4'hd, 8'b0_100 };

    cmd_list[21] = { 4'hd, 8'b1_000 };
    cmd_list[23] = { 4'hd, 8'b1_001 };
    cmd_list[25] = { 4'hd, 8'b1_010 };
    cmd_list[27] = { 4'hd, 8'b1_011 };

    cmd_list[29] = { 4'hd, 8'b1_100 };
    cmd_list[31] = { 4'hd, 8'b1_101 };
    cmd_list[33] = { 4'hd, 8'b1_110 };
    cmd_list[35] = { 4'hd, 8'b1_111 };

    cmd_list[37] = { 4'he, 8'hff };  // end
end

always @(posedge clk)
    if( !rst_n ) begin
        wr_n <= 1'b1;
        addr <= 4'd0;
        cmd_cnt  <= 0;
        cmd_wait <= 0;
    end
    else begin
        wr_n <= 1'b1;
        if( cmd_cnt!=cmd_end || cmd_wait != 0) begin
            if( cmd_wait == 0 ) begin
                if( cmd_list[cmd_cnt][11:8]== 4'hf ) begin
                    cmd_wait <= cmd_list[cmd_cnt][7:0] << 8;
                end
                else if( cmd_list[cmd_cnt][11:8]== 4'he ) begin
                    $display("Simulation finished through command\n");
                    $finish;
                end
                else begin
                    addr <= cmd_list[cmd_cnt][11:8];
                    data_in <= cmd_list[cmd_cnt][7:0];
                    wr_n <= 1'b0;
                end
                cmd_cnt <= cmd_cnt + 1;
            end
            else begin
                cmd_wait <= cmd_wait-1;
            end
        end
    end

jt49 uut( // note that input ports are not multiplexed
    .rst_n      ( rst_n     ),
    .clk        ( clk       ),    // signal on positive edge
    .clk_en     ( cen       ),    // clock enable on negative edge
    .addr       ( addr      ),
    .cs_n       ( 1'b0      ),
    .wr_n       ( wr_n      ),  // write
    .din        ( data_in   ),
    .sel        ( 1'b1      ),
//    .data_out   ( data_out  ),
    .sound      ( sound     )
);

initial begin
    $dumpfile("test.lxt");
    $dumpvars;
    $dumpon;
    #(10*16*256*256) 
    $display("WARNING: simulation too long");
    $finish;
end

endmodule