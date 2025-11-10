class alu_env extends uvm_env;
    alu_agent       agent;
    alu_scoreboard  scoreboard;
    alu_coverage    coverage;
    `uvm_component_utils(alu_env)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = alu_agent::type_id::create("agent", this);
        scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
        coverage = alu_coverage::type_id::create("coverage", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
        agent.monitor.item_collected_port.connect(coverage.analysis_export);
    endfunction
endclass
