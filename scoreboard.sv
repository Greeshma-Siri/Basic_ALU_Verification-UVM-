class alu_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(alu_transaction, alu_scoreboard) item_collected_export;
    alu_transaction transactions[$];
    int passed_tests = 0;
    int failed_tests = 0;
    `uvm_component_utils(alu_scoreboard)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction
    
    virtual function void write(alu_transaction trans);
        logic [7:0] expected_result;
        logic expected_zero, expected_carry;
        
        // Calculate expected values
        calculate_expected(trans, expected_result, expected_zero, expected_carry);
        
        // Compare with actual
        if (trans.result === expected_result && 
            trans.zero === expected_zero && 
            trans.carry === expected_carry) begin
            `uvm_info("SCOREBOARD", $sformatf("PASS: Op=%s, A=%0d, B=%0d, Result=%0d (expected %0d)", 
                      trans.opcode.name(), trans.a, trans.b, trans.result, expected_result), UVM_LOW)
            passed_tests++;
        end else begin
            `uvm_error("SCOREBOARD", $sformatf("FAIL: Op=%s, A=%0d, B=%0d, Got=%0d, Exp=%0d, Zero: got=%0d exp=%0d, Carry: got=%0d exp=%0d",
                      trans.opcode.name(), trans.a, trans.b, trans.result, expected_result,
                      trans.zero, expected_zero, trans.carry, expected_carry))
            failed_tests++;
        end
    endfunction
    
    virtual function void calculate_expected(alu_transaction trans, 
                                           output logic [7:0] result,
                                           output logic zero,
                                           output logic carry);
        case(trans.opcode)
            ADD: {carry, result} = trans.a + trans.b;
            SUB: {carry, result} = trans.a - trans.b; // carry acts as borrow
            AND: result = trans.a & trans.b;
            OR:  result = trans.a | trans.b;
            XOR: result = trans.a ^ trans.b;
            NOT: result = ~trans.a;
            default: result = 8'b0;
        endcase
        zero = (result == 8'b0);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD", $sformatf("Test Summary: PASSED=%0d, FAILED=%0d", 
                  passed_tests, failed_tests), UVM_NONE)
    endfunction
endclass
