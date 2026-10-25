`timescale 1ns/1ps
module test;
reg clk=0,rst=1,cen=0;
reg [7:0] din=0;
wire [7:0] dout;
integer i, pulses=0;
always #5 clk=~clk;
jt49_mave #(.depth(4)) uut(.clk(clk),.cen(cen),.rst(rst),.din(din),.dout(dout));
task sample(input [7:0] v);
begin
    @(negedge clk);din=v;cen=1;
    @(negedge clk);cen=0;
    repeat(2) @(negedge clk);
end
endtask
initial begin
    $dumpfile("test.lxt");$dumpvars(0,test);
    repeat(4) @(negedge clk);rst=0;
    sample(8'd255);
    if(dout==15) pulses=pulses+1;
    for(i=0;i<24;i=i+1) begin
        sample(8'd0);
        if(dout==15) pulses=pulses+1;
        else if(dout!==0) $fatal(1,"FAIL impulse amplitude %0d",dout);
    end
    // The existing delay line spans 15 samples; normalization is /16.
    if(pulses!=15) $fatal(1,"FAIL impulse length %0d",pulses);
    repeat(24) sample(8'd255);
    if(dout!==239) $fatal(1,"FAIL unsigned full scale %0d",dout);
    repeat(24) sample(8'd128);
    if(dout!==120) $fatal(1,"FAIL half-scale DC %0d",dout);
    $display("PASS");$finish;
end
initial begin #100000; $fatal(1,"FAIL timeout"); end
endmodule
