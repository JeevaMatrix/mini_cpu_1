`timescale 1ns/1ns
`include "mini_cpu.v"

module mini_cpu_tb();

    reg clk1, clk2;
    integer k;
    mini_cpu DUT(clk1, clk2);

    initial begin 
        clk1 = 0; clk2 = 0;
        $dumpfile("mini_cpu.vcd");
        $dumpvars(0, mini_cpu_tb);
    end

    // Clock toggling
    always begin
        #5 clk1 = ~clk1;
        #5 clk1 = ~clk1;
        #5 clk2 = ~clk2;
        #5 clk2 = ~clk2;
    end

    initial begin
        // Clear all registers
        for(k=0; k<=31; k=k+1)
            DUT.Reg[k] = 0;

        // Load Independent Instructions
        DUT.Mem[0] = 32'h14010005; // ADDI R1, R0, 5
        DUT.Mem[1] = 32'h14020007; // ADDI R2, R0, 7



        DUT.pc = 0;

        #600; // Wait for pipeline to finish

        // Display final register values
        $display("R1 (ADDI) = %d", DUT.Reg[1]);  // 5
        $display("R2 (ADDI) = %d", DUT.Reg[2]);  // 7
        $finish;
    end

endmodule
