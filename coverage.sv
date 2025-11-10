class alu_coverage extends uvm_subscriber #(alu_transaction);
    alu_transaction cov_trans;
    `uvm_component_utils(alu_coverage)
    
    covergroup alu_cg;
        option.per_instance = 1;
        
        // Operation coverage
        opcode_cp: coverpoint cov_trans.opcode {
            bins op_add = {ADD};
            bins op_sub = {SUB};
            bins op_and = {AND};
            bins op_or  = {OR};
            bins op_xor = {XOR};
            bins op_not = {NOT};
        }
        
        // Operand coverage
        a_cp: coverpoint cov_trans.a {
            bins zero = {0};
            bins max  = {255};
            bins others = {[1:254]};
        }
        
        b_cp: coverpoint cov_trans.b {
            bins zero = {0};
            bins max  = {255};
            bins others = {[1:254]};
        }
        
        // Cross coverage
        op_a_cross: cross opcode_cp, a_cp;
        op_b_cross: cross opcode_cp, b_cp;
        
        // Result coverage
        result_cp: coverpoint cov_trans.result {
            bins zero = {0};
            bins max  = {255};
            bins others = {[1:254]};
        }
        
        // Flag coverage
        zero_cp: coverpoint cov_trans.zero;
        carry_cp: coverpoint cov_trans.carry;
        
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        alu_cg = new;
    endfunction
    
    virtual function void write(alu_transaction t);
        cov_trans = t;
        alu_cg.sample();
    endfunction
endclass
