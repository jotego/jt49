/*  This file is part of JT49.

    JT49 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Author: Jose Tejada Gomez
    Date: 9-Nov-2026
*/

`timescale 1ns/1ps

module test;
reg clk=0;
reg [2:0] comp=0;
reg [4:0] din=0;
wire [7:0] dout;
integer i;
// Golden values: COMP0..5 from upstream JT49 6f1247fe0282a70c86ea2b4d8aa901f5332c94db;
// COMP6 from Olivier Scherler's Nemesis PCB curve (JTCORES jtnemsis_jt49_exp.v).
reg [7:0] expected [0:223];
reg [7:0] previous;

always #5 clk=~clk;

jt49_exp u_dut(
    .clk  ( clk  ),
    .comp ( comp ),
    .din  ( din  ),
    .dout ( dout )
);

initial begin
    expected[  0]=8'd  0; expected[  1]=8'd  1; expected[  2]=8'd  1; expected[  3]=8'd  1;
    expected[  4]=8'd  2; expected[  5]=8'd  2; expected[  6]=8'd  3; expected[  7]=8'd  3;
    expected[  8]=8'd  4; expected[  9]=8'd  5; expected[ 10]=8'd  6; expected[ 11]=8'd  7;
    expected[ 12]=8'd  9; expected[ 13]=8'd 11; expected[ 14]=8'd 13; expected[ 15]=8'd 15;
    expected[ 16]=8'd 18; expected[ 17]=8'd 22; expected[ 18]=8'd 26; expected[ 19]=8'd 31;
    expected[ 20]=8'd 37; expected[ 21]=8'd 45; expected[ 22]=8'd 53; expected[ 23]=8'd 63;
    expected[ 24]=8'd 75; expected[ 25]=8'd 90; expected[ 26]=8'd107; expected[ 27]=8'd127;
    expected[ 28]=8'd151; expected[ 29]=8'd180; expected[ 30]=8'd214; expected[ 31]=8'd255;
    expected[ 32]=8'd  0; expected[ 33]=8'd  7; expected[ 34]=8'd  8; expected[ 35]=8'd 10;
    expected[ 36]=8'd 11; expected[ 37]=8'd 12; expected[ 38]=8'd 14; expected[ 39]=8'd 15;
    expected[ 40]=8'd 17; expected[ 41]=8'd 20; expected[ 42]=8'd 22; expected[ 43]=8'd 25;
    expected[ 44]=8'd 28; expected[ 45]=8'd 31; expected[ 46]=8'd 35; expected[ 47]=8'd 40;
    expected[ 48]=8'd 45; expected[ 49]=8'd 50; expected[ 50]=8'd 56; expected[ 51]=8'd 63;
    expected[ 52]=8'd 71; expected[ 53]=8'd 80; expected[ 54]=8'd 90; expected[ 55]=8'd101;
    expected[ 56]=8'd113; expected[ 57]=8'd127; expected[ 58]=8'd143; expected[ 59]=8'd160;
    expected[ 60]=8'd180; expected[ 61]=8'd202; expected[ 62]=8'd227; expected[ 63]=8'd255;
    expected[ 64]=8'd  0; expected[ 65]=8'd 18; expected[ 66]=8'd 20; expected[ 67]=8'd 22;
    expected[ 68]=8'd 24; expected[ 69]=8'd 26; expected[ 70]=8'd 29; expected[ 71]=8'd 31;
    expected[ 72]=8'd 34; expected[ 73]=8'd 37; expected[ 74]=8'd 41; expected[ 75]=8'd 45;
    expected[ 76]=8'd 49; expected[ 77]=8'd 53; expected[ 78]=8'd 58; expected[ 79]=8'd 63;
    expected[ 80]=8'd 69; expected[ 81]=8'd 75; expected[ 82]=8'd 82; expected[ 83]=8'd 90;
    expected[ 84]=8'd 98; expected[ 85]=8'd107; expected[ 86]=8'd116; expected[ 87]=8'd127;
    expected[ 88]=8'd139; expected[ 89]=8'd151; expected[ 90]=8'd165; expected[ 91]=8'd180;
    expected[ 92]=8'd196; expected[ 93]=8'd214; expected[ 94]=8'd233; expected[ 95]=8'd255;
    expected[ 96]=8'd  0; expected[ 97]=8'd 51; expected[ 98]=8'd 54; expected[ 99]=8'd 57;
    expected[100]=8'd 60; expected[101]=8'd 63; expected[102]=8'd 67; expected[103]=8'd 70;
    expected[104]=8'd 74; expected[105]=8'd 78; expected[106]=8'd 83; expected[107]=8'd 87;
    expected[108]=8'd 92; expected[109]=8'd 97; expected[110]=8'd103; expected[111]=8'd108;
    expected[112]=8'd114; expected[113]=8'd120; expected[114]=8'd127; expected[115]=8'd134;
    expected[116]=8'd141; expected[117]=8'd149; expected[118]=8'd157; expected[119]=8'd166;
    expected[120]=8'd175; expected[121]=8'd185; expected[122]=8'd195; expected[123]=8'd206;
    expected[124]=8'd217; expected[125]=8'd229; expected[126]=8'd241; expected[127]=8'd255;
    expected[128]=8'd  0; expected[129]=8'd  8; expected[130]=8'd 10; expected[131]=8'd 12;
    expected[132]=8'd 16; expected[133]=8'd 22; expected[134]=8'd 29; expected[135]=8'd 35;
    expected[136]=8'd 44; expected[137]=8'd 50; expected[138]=8'd 56; expected[139]=8'd 60;
    expected[140]=8'd 64; expected[141]=8'd 85; expected[142]=8'd 97; expected[143]=8'd103;
    expected[144]=8'd108; expected[145]=8'd120; expected[146]=8'd127; expected[147]=8'd134;
    expected[148]=8'd141; expected[149]=8'd149; expected[150]=8'd157; expected[151]=8'd166;
    expected[152]=8'd175; expected[153]=8'd185; expected[154]=8'd195; expected[155]=8'd206;
    expected[156]=8'd217; expected[157]=8'd229; expected[158]=8'd241; expected[159]=8'd255;
    expected[160]=8'd  0; expected[161]=8'd  0; expected[162]=8'd  1; expected[163]=8'd  2;
    expected[164]=8'd  3; expected[165]=8'd  3; expected[166]=8'd  4; expected[167]=8'd  5;
    expected[168]=8'd  6; expected[169]=8'd  7; expected[170]=8'd  8; expected[171]=8'd  9;
    expected[172]=8'd 11; expected[173]=8'd 14; expected[174]=8'd 16; expected[175]=8'd 18;
    expected[176]=8'd 23; expected[177]=8'd 27; expected[178]=8'd 31; expected[179]=8'd 35;
    expected[180]=8'd 43; expected[181]=8'd 51; expected[182]=8'd 60; expected[183]=8'd 68;
    expected[184]=8'd 84; expected[185]=8'd101; expected[186]=8'd117; expected[187]=8'd132;
    expected[188]=8'd161; expected[189]=8'd192; expected[190]=8'd224; expected[191]=8'd255;
    expected[192]=8'd  0; expected[193]=8'd  9; expected[194]=8'd 10; expected[195]=8'd 12;
    expected[196]=8'd 14; expected[197]=8'd 16; expected[198]=8'd 18; expected[199]=8'd 21;
    expected[200]=8'd 24; expected[201]=8'd 28; expected[202]=8'd 32; expected[203]=8'd 36;
    expected[204]=8'd 42; expected[205]=8'd 48; expected[206]=8'd 56; expected[207]=8'd 64;
    expected[208]=8'd 74; expected[209]=8'd 85; expected[210]=8'd 97; expected[211]=8'd112;
    expected[212]=8'd129; expected[213]=8'd144; expected[214]=8'd153; expected[215]=8'd162;
    expected[216]=8'd171; expected[217]=8'd181; expected[218]=8'd192; expected[219]=8'd203;
    expected[220]=8'd215; expected[221]=8'd228; expected[222]=8'd241; expected[223]=8'd255;
    previous = 8'hxx;
    for (i=0; i<224; i=i+1) begin
        @(negedge clk);
        comp = i >> 5;
        din  = i[4:0];
        #1;
        if (i != 0 && dout !== previous) begin
            $display("Output changed before rising edge at COMP%0d din=%0d", comp, din);
            $fatal(1);
        end
        @(posedge clk);
        #1;
        if (dout !== expected[i]) begin
            $display("COMP%0d din=%0d expected=%0d got=%0d", comp, din, expected[i], dout);
            $fatal(1);
        end
        previous = expected[i];
    end
    $display("All 224 JT49 curve entries passed with synchronous read timing");
    $finish;
end
endmodule
