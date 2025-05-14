//Testbench for full pipeline - once you loaded up the instr.mem and and data.mem, one simply runs the clock 

//mips_pipeline_tb.v

module mips_pipeline_tb;
    reg clk;
    reg rst;

    MIPSpipeline uut (
        .clk(clk),
        .reset(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        rst = 1;
        #10 rst = 0;

        #200 $finish;
    end
    
    
endmodule