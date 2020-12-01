

module decode (
        input  logic [2 : 0] current_state,
        output logic         get_ready,
        output logic         get_set,
        output logic         get_going
    );

    always_comb begin
        {get_ready, get_set, get_going} = 3'b000;
        unique case(1'b1)
            current_state[0] : get_ready = '1;
            current_state[1] : get_set   = '1;
            current_state[2] : get_going = '1;
        endcase
    end

endmodule
