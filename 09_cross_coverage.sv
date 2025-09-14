

// file name : 09_cross_coverage.sv
// module : cross_cov_tb

/*
__________________________________________________________________________________________________

cross coverage:
    1. cross combines two or more coverpoints into a cross coverage point.
    2. Each cross bin represents a unique combination of values from each coverpoint bin.
    3. You can ignore or illegalize specific cross bins using ignore_bins or illegal_bins.
    4. Cross coverage is critical for checking interactions between multiple signals or fields.
    5. Helpful for protocol or state-machine verification where multiple fields influence behavior.

    syntax :

        cp1: coverpoint A {         // assume a is 2bit
            bins b1 = {0,1};
            bins b2 = {2,3};
        }
        
        cp2: coverpooint B {        // assume b is 1bit
            bins b1 = {0,1};
        }

        cross_cov: cross cp1, cp2;

______________________________________________________________________________________________________________
*/

`timescale 1ns/1ps

module cross_cov_tb;

  reg clk = 0;
  always #5 clk = ~clk;

  reg [1:0] mode;
  reg [1:0] state;

  covergroup cg @(posedge clk);
    cp_mode : coverpoint mode {
      bins mode_vals[] = {0,1,2,3};
    }

    cp_state : coverpoint state {
      bins state_vals[] = {0,1,2,3};
    }

    // Cross bins between mode and state
    cross_mode_state : cross cp_mode, cp_state;
  endgroup

  cg c = new();

  initial begin
    // Stimulus to hit combinations
    mode = 0; state = 0; @(posedge clk);
    mode = 1; state = 2; @(posedge clk);
    mode = 2; state = 3; @(posedge clk);
    mode = 3; state = 1; @(posedge clk);
    mode = 2; state = 2; @(posedge clk);
    mode = 1; state = 3; @(posedge clk);

    $display("\n=== Cross Coverage Report ===");
    $display("Coverage: %0.2f %%", c.get_coverage());
    $finish;
  end

endmodule
