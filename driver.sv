class alu_driver extends uvm_driver #(alu_transaction);
    virtual alu_if vif;
    `uvm_component_utils(alu_driver)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_if)::get(this, "", "alu_vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        vif.driver_cb.a <= 0;
        vif.driver_cb.b <= 0;
        vif.driver_cb.opcode <= 0;
        
        forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask
    
    virtual task drive_transaction(alu_transaction trans);
        @(vif.driver_cb);
        vif.driver_cb.a <= trans.a;
        vif.driver_cb.b <= trans.b;
        vif.driver_cb.opcode <= trans.opcode;
        `uvm_info("DRIVER", $sformatf("Driving transaction: a=%0d, b=%0d, op=%s", 
                  trans.a, trans.b, trans.opcode.name()), UVM_MEDIUM)
    endtask
endclass
