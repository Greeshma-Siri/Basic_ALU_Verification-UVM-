interface alu_if(input logic clk, reset_n);
    logic [7:0] a;
    logic [7:0] b;
    logic [2:0] opcode;
    logic [7:0] result;
    logic zero;
    logic carry;
    
    // Clocking blocks for driver/synchronization
    clocking driver_cb @(posedge clk);
        default input #1 output #1;
        output a, b, opcode;
        input result, zero, carry;
    endclocking
    
    clocking monitor_cb @(posedge clk);
        default input #1 output #1;
        input a, b, opcode, result, zero, carry;
    endclocking
endinterface
