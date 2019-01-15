`timescale 1ns / 1ps

module test;

reg clk, rst;

initial begin
    clk = 1'b0;
    forever clk = #12500 ~clk;
end

integer simcnt;

initial begin
    rst = 1'b1;
    #30000 rst=1'b0;
    $display("Reset over: simulation starts");
    for( simcnt=0; simcnt<500; simcnt=simcnt+1)
        #1000_000;
    $finish;
end

wire signed [7:0] dout;

reg [7:0] din;

always @(posedge clk)
    if( rst ) begin
        din <= 8'd0;
    end else begin
        din <= din + 8'd1;
    end

jt49_dcrm UUT(
    .clk  ( clk   ),
    .cen  ( 1'b1  ),
    .rst  ( rst   ),
    .din  ( din   ),
    .dout ( dout  )
);

`ifndef NCVERILOG
    initial begin
        $display("DUMP enabled");
        $dumpfile("test.lxt");
        $dumpvars;
        $dumpon;
    end
`else
    initial begin
        $display("NC Verilog: will dump all signals");
        $shm_open("test.shm");
        $shm_probe(UUT,"AS");
    end
`endif

endmodule