

// file name :  07_transition_bins.sv
// module name : transition_bins


/*
_____________________________________________

eda link : https://edaplayground.com/x/Y9Dy

transition bins:
    1. to track the specific sequences.
    2. seq to seq change tackle by "=>"
    3. syntax:
        ```
        coverpoint A {
            bins b1 = (1=>2=>3=>8);
        }

        ```

_____________________________________________
*/

`timescale 1ns/1ps

module transition_cov_tb;

  // clock
  reg clk = 0;
  always #5 clk = ~clk; // 100 MHz-ish for simulation clarity

  // enumerated states for clarity
  typedef enum logic [1:0] { IDLE = 2'd0, BUSY = 2'd1, WAIT = 2'd2, DONE = 2'd3 } state_t;

  // DUT-like signal we will track
  state_t state;

  // covergroup with transition bins (sampled automatically on posedge clk)
  covergroup cg_state @(posedge clk);
    // coverpoint on the state signal with transition bins
    cp_state : coverpoint state {
      // simple 1-step transitions
      bins idle_to_busy  = (IDLE => BUSY);
      bins busy_to_wait  = (BUSY => WAIT);
      bins wait_to_done  = (WAIT => DONE);

      // a multi-step transition (back-to-back)
      bins full_cycle    = (IDLE => BUSY => WAIT => DONE);

      // default auto bins for other transitions (optional)
      // default; // uncomment to keep other transitions tracked automatically
    }
  endgroup

  

  // Test stimulus to hit transitions
  initial begin
    // instantiate the covergroup
    cg_state cg = new();

    // initialize
    state = IDLE;
    repeat (2) @(posedge clk); // let coverage start collecting

    // 1) IDLE -> BUSY (should hit idle_to_busy)
    @(posedge clk) state = BUSY;
    @(posedge clk) state = BUSY; // hold

    // 2) BUSY -> WAIT (should hit busy_to_wait)
    @(posedge clk) state = WAIT;
    @(posedge clk) state = WAIT;

    // 3) WAIT -> DONE (should hit wait_to_done)
    @(posedge clk) state = DONE;
    @(posedge clk) state = DONE;

    // 4) Now exercise the full cycle: IDLE->BUSY->WAIT->DONE
    @(posedge clk) state = IDLE;
    @(posedge clk) state = BUSY;
    @(posedge clk) state = WAIT;
    @(posedge clk) state = DONE;

    // 5) Other random transitions to show other bins:
    @(posedge clk) state = BUSY;
    @(posedge clk) state = IDLE;
    @(posedge clk) state = DONE;
    @(posedge clk) state = IDLE;

    // Wait a couple cycles then print coverage
    repeat (4) @(posedge clk);

    // Print covergroup coverage summary (tool-specific return format)
    // get_coverage() often returns a real percentage in many simulators.
    $display("\n=== Coverage Summary ===");
    $display("Coverage (cg): %0.2f %%", cg.get_coverage());

    // Optionally, you can print hit counts if your simulator supports introspection APIs.
    // Many tools provide coverage report viewers (recommended) rather than printing bins manually.

    $finish;
  end

endmodule
