class alu_test_base extends uvm_test;
    alu_env env;
    `uvm_component_utils(alu_test_base)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alu_env::type_id::create("env", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #1000; // Allow some time for testing
        phase.drop_objection(this);
    endtask
endclass

class basic_functional_test extends alu_test_base;
    `uvm_component_utils(basic_functional_test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        basic_alu_sequence seq;
        phase.raise_objection(this);
        seq = basic_alu_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass

class random_test extends alu_test_base;
    `uvm_component_utils(random_test)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        random_alu_sequence seq;
        phase.raise_objection(this);
        seq = random_alu_sequence::type_id::create("seq");
        assert(seq.randomize() with { num_transactions == 500; });
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass
