`timescale 1ns/1ps

module tb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Clock and reset signals
    logic clk;
    logic reset_n;
    
    // Instantiate the interface
    alu_if alu_vif(clk, reset_n);
    
    // Instantiate the DUT (ALU)
    alu dut (
        .clk    (clk),
        .reset_n(reset_n),
        .a      (alu_vif.a),
        .b      (alu_vif.b),
        .opcode (alu_vif.opcode),
        .result (alu_vif.result),
        .zero   (alu_vif.zero),
        .carry  (alu_vif.carry)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Reset generation
    initial begin
        reset_n = 0;
        #20 reset_n = 1;
    end
    
    // UVM test setup and run
    initial begin
        // Set the virtual interface in config DB
        uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top.env.agent*", "alu_vif", alu_vif);
        
        // Optional: Set verbosity
        uvm_top.set_report_verbosity_level_hier(UVM_MEDIUM);
        
        // Start the test
        run_test();
    end
    
    // Waveform dumping (for debugging)
    initial begin
        if ($test$plusargs("WAVE")) begin
            $dumpfile("alu_waves.vcd");
            $dumpvars(0, tb_top);
        end
    end
    
    // Simulation timeout
    initial begin
        #1000000; // 1ms timeout
        `uvm_fatal("TIMEOUT", "Simulation timeout reached")
        $finish;
    end
    
    // End simulation when UVM reports finish
    initial begin
        uvm_root root = uvm_root::get();
        root.run_test();
    end
    
endmodule
