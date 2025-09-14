

// file name: 12_with_keyword.sv
// module name:

/*
_________________________________________________________________________________________
What is with?
    1. The with keyword is used to filter or transform sampled values when creating bins.
    2. It is written after the bin set or coverpoint item.
    3. It lets you apply an expression on each sampled value during coverage collection.

    Syntax:
        ```
            bins <bin_name> = {<values>} with (<expression>);

        ```

    Example 1 — Filtering values with with:
            
        ```
            covergroup cg @(posedge clk);
                coverpoint data {
                    bins even_vals[] = {[0:15]} with (item % 2 == 0);
                }
            endgroup
        ```
    Example 2 — Cross with with:
        ```
            covergroup cg @(posedge clk);
                cp_a: coverpoint a;
                cp_b: coverpoint b;

                cross cp_a, cp_b {
                    bins sum_gt10 = binsof(cp_a) cross binsof(cp_b)
                                    with ( (cp_a + cp_b) > 10 );
                }
            endgroup

        ```
     Example 3 — with + iff together:
        ```
            covergroup cg @(posedge clk);
                coverpoint value {
                    bins high_values[] = {[0:255]} with (item > 200) iff (enable);
                }
            endgroup

        ```
    
_________________________________________________________________________________________
*/

module with_bins_demo;

  bit clk;
  bit [7:0] data;
  bit enable;

  // Clock generation
  initial forever #5 clk = ~clk;

  // Covergroup with 'with' keyword usage
  covergroup cg_with @(posedge clk);

    // Only even numbers are counted from 0–15
    coverpoint data {
      bins even_vals[] = {[0:15]} with (item % 2 == 0);
    }

    // Only values greater than 200 are counted when enable is 1
    coverpoint data_high {
      bins high_vals[] = {[0:255]} with (item > 200) iff (enable);
    }

  endgroup


  initial begin
    cg_with cov = new();

    enable = 0;

    // Apply some data patterns
    repeat (5) begin
      @(posedge clk);
      data = $urandom_range(0, 255);
      if ($time > 20) enable = 1;  // enable after some time
      cov.sample();  // sample coverage on each clock
    end

    $display("Coverage: %0.2f%%", cov.get_coverage());
    $finish;
  end

endmodule
