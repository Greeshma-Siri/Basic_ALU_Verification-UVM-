module alu (
    input  logic       clk,
    input  logic       reset_n,
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic [2:0] opcode,
    output logic [7:0] result,
    output logic       zero,
    output logic       carry
);
    
    typedef enum logic [2:0] {
        ADD = 3'b000,
        SUB = 3'b001, 
        AND = 3'b010,
        OR  = 3'b011,
        XOR = 3'b100,
        NOT = 3'b101
    } alu_op_t;
    
    logic [8:0] temp_result; // Extra bit for carry
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            result <= 8'b0;
            zero   <= 1'b0;
            carry  <= 1'b0;
        end else begin
            case (alu_op_t'(opcode))
                ADD: begin
                    temp_result = a + b;
                    result <= temp_result[7:0];
                    carry  <= temp_result[8];
                end
                SUB: begin
                    temp_result = a - b;
                    result <= temp_result[7:0];
                    carry  <= (a < b); // Borrow
                end
                AND: begin
                    result <= a & b;
                    carry  <= 1'b0;
                end
                OR: begin
                    result <= a | b;
                    carry  <= 1'b0;
                end
                XOR: begin
                    result <= a ^ b;
                    carry  <= 1'b0;
                end
                NOT: begin
                    result <= ~a;
                    carry  <= 1'b0;
                end
                default: begin
                    result <= 8'b0;
                    carry  <= 1'b0;
                end
            endcase
            
            // Zero flag
            zero <= (result == 8'b0);
        end
    end
    
endmodule
