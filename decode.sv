//

module decode (
        input  logic a,
        input  logic b,
        input  logic c,
        input  logic d,
        output logic o1,
        output logic o2,
        output logic o3);

    logic is_A;
    logic is_B;
    logic is_C;
    logic is_D;
    logic others;

    assign is_A   = ({a,b,c,d} == 4'b1011) || ({a,b,c,d} == 4'b0100);
    assign is_B   = ({a,b,c,d} == 4'b1100) || ({a,b,c,d} == 4'b1111);
    assign is_C   = ({a,b,c,d} == 4'b0111) || ({a,b,c,d} == 4'b0001);
    assign is_D   = ({a,b,c,d} == 4'b1101) || ({a,b,c,d} == 4'b1000);
//    assign others = {is_A, is_B, is_C, is_D} == '0;

    always_comb begin
        unique casez (1'b1)
            is_A : {o1, o2, o3}   = 3'b000;
            is_B : {o1, o2, o3}   = 3'b001;
            is_C : {o1, o2, o3}   = 3'b01X;
            is_D : {o1, o2, o3}   = 3'b1XX;
//            others : {o1, o2, o3} = 3'bXXX;
        endcase;
    end
    
endmodule


