class alu_monitor extends uvm_monitor;
    virtual alu_if vif;
    uvm_analysis_port #(alu_transaction) item_collected_port;
    `uvm_component_utils(alu_monitor)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_if)::get(this, "", "alu_vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        alu_transaction trans;
        forever begin
            trans = alu_transaction::type_id::create("trans");
            collect_transaction(trans);
            item_collected_port.write(trans);
        end
    endtask
    
    virtual task collect_transaction(alu_transaction trans);
        @(vif.monitor_cb);
        trans.a = vif.monitor_cb.a;
        trans.b = vif.monitor_cb.b;
        trans.opcode = alu_op_t'(vif.monitor_cb.opcode);
        trans.result = vif.monitor_cb.result;
        trans.zero = vif.monitor_cb.zero;
        trans.carry = vif.monitor_cb.carry;
        `uvm_info("MONITOR", $sformatf("Captured transaction: result=%0d, zero=%0d, carry=%0d", 
                  trans.result, trans.zero, trans.carry), UVM_MEDIUM)
    endtask
endclass
