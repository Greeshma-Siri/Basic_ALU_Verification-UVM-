class alu_transaction extends uvm_sequence_item;
    rand logic [7:0] a;
    rand logic [7:0] b;
    rand alu_op_t opcode;
    logic [7:0] result;
    logic zero;
    logic carry;
    
    // Constraints
    constraint valid_operands {
        soft a inside {[0:255]};
        soft b inside {[0:255]};
    }
    
    // UVM automation
    `uvm_object_utils_begin(alu_transaction)
        `uvm_field_int(a, UVM_ALL_ON)
        `uvm_field_int(b, UVM_ALL_ON)
        `uvm_field_enum(alu_op_t, opcode, UVM_ALL_ON)
        `uvm_field_int(result, UVM_ALL_ON)
        `uvm_field_int(zero, UVM_ALL_ON)
        `uvm_field_int(carry, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "alu_transaction");
        super.new(name);
    endfunction
endclass
