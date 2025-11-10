class basic_alu_sequence extends uvm_sequence #(alu_transaction);
    `uvm_object_utils(basic_alu_sequence)
    
    function new(string name = "basic_alu_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        alu_transaction trans;
        
        // Test all operations
        foreach(alu_op_t::values[i]) begin
            trans = alu_transaction::type_id::create("trans");
            start_item(trans);
            if(!trans.randomize() with {
                opcode == alu_op_t::values[i];
            })
                `uvm_error("SEQ", "Randomization failed")
            finish_item(trans);
        end
    endtask
endclass

class random_alu_sequence extends uvm_sequence #(alu_transaction);
    rand int num_transactions;
    `uvm_object_utils(random_alu_sequence)
    
    function new(string name = "random_alu_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        alu_transaction trans;
        
        repeat(num_transactions) begin
            trans = alu_transaction::type_id::create("trans");
            start_item(trans);
            if(!trans.randomize())
                `uvm_error("SEQ", "Randomization failed")
            finish_item(trans);
        end
    endtask
endclass
