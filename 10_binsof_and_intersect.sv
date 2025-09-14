

// file name: 10_binsof_and_intersect.sv
// module name: binsof_intersect_tb


/*
__________________________________________________________
binsof intersect :
    1. binsof(): references existing bins of a coverpoint.
    2. intersect {}: filters only specific values or ranges from those bins.
    3. Can be used in:
        -> user-defined bins
        -> cross coverage bins
        -> conditional ignore or illegal bins
    4. Makes coverage more focused by only counting meaningful scenarios.

    syntax:
    ```
            cp_mode : coverpoint mode {
            bins all_modes[] = {[0:7]};
            }

            cp_state : coverpoint state {
            bins all_states[] = {[0:7]};
            }

            // Cross coverage
            cross_mode_state : cross cp_mode, cp_state {
            // user-defined cross bin using binsof + intersect
            bins special = binsof(cp_mode) intersect {3,4} &&
                            binsof(cp_state) intersect {[5:7]};
            }
    ```

__________________________________________________________
*/

`timescale 1ns/1ps

module binsof_intersect_tb;

  reg clk = 0;
  always #5 clk = ~clk;

  reg [2:0] mode;
  reg [2:0] state;

  covergroup cg @(posedge clk);
    cp_mode : coverpoint mode {
      bins all_modes[] = {[0:7]};
    }

    cp_state : coverpoint state {
      bins all_states[] = {[0:7]};
    }

    // Cross coverage
    cross_mode_state : cross cp_mode, cp_state {
      // user-defined cross bin using binsof + intersect
      bins special = binsof(cp_mode) intersect {3,4} &&  
                     binsof(cp_state) intersect {[5:7]};
    }
  endgroup

  initial begin
    cg c = new();

    // Stimulus to hit special bins
    mode = 3; state = 5; @(posedge clk);
    mode = 4; state = 6; @(posedge clk);
    mode = 3; state = 7; @(posedge clk);
    mode = 2; state = 5; @(posedge clk); // won't hit special
    mode = 3; state = 2; @(posedge clk); // won't hit special

    $display("Coverage: %0.2f %%", c.get_coverage());
    $finish;
  end

endmodule
