
module decode_tb;

    reg  a;
    reg  b;
    reg  c;
    reg  d;
    wire o1;
    wire o2;
    wire o3;

    reg  clk;
    decode dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .o1(o1),
        .o2(o2),
        .o3(o3)
    );

    initial begin
        #10 {a,b,c,d} = 4'b0000;
        #10 {a,b,c,d} = 4'b0001;
        #10 {a,b,c,d} = 4'b0010;
        #10 {a,b,c,d} = 4'b0011;
        #10 {a,b,c,d} = 4'b0100;
        #10 {a,b,c,d} = 4'b0101;
        #10 {a,b,c,d} = 4'b0110;
        #10 {a,b,c,d} = 4'b0111;
        #10 {a,b,c,d} = 4'b1000;
        #10 {a,b,c,d} = 4'b1001;
        #10 {a,b,c,d} = 4'b1010;
        #10 {a,b,c,d} = 4'b1011;
        #10 {a,b,c,d} = 4'b1100;
        #10 {a,b,c,d} = 4'b1101;
        #10 {a,b,c,d} = 4'b1110;
        #10 {a,b,c,d} = 4'b1111;
    end

    always
        #5 clk = ! clk;

endmodule