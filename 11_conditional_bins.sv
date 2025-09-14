

// file name: 11_conditional_bins.sv
// module name: conditional_cov

/*
__________________________________________________________
Conditional Bins:

    1. Conditional bins are bins that are counted only when a specified condition is true.
    2. They allow you to collect coverage only under certain conditions instead of for all samples.
    3. This helps filter coverage to meaningful scenarios.

    Syntax:

        bins <bin_name> = {<values>} iff (<condition>);


Key Points
    iff means "if and only if"
    <condition> is a boolean expression evaluated at sampling time.
    If <condition> is 0/false, the bin will not count even if the value matches.
__________________________________________________________
*/

module conditional_cov;

  bit clk;
  bit enable, reset;
  bit [1:0] mode;

  // Clock Generation
  always #5 clk = ~clk;

  // Covergroup with conditional bins
  covergroup cg_cond @(posedge clk);

    coverpoint mode {
      bins mode0 = {0} iff (enable == 1);   // counts only if enable is high
      bins mode1 = {1} iff (reset  == 0);   // counts only if reset is low
      bins mode2 = {2, 3};                  // always counts
    }

  endgroup


  // Stimulus
  initial begin
    cg_cond cg = new();

    $display("Starting Simulation...");
    enable = 0; reset = 1; mode = 0;

    repeat(2) @(posedge clk);
    enable = 1; mode = 0;  // should hit mode0
    @(posedge clk);

    reset  = 0; mode = 1;  // should hit mode1
    @(posedge clk);

    mode = 2;              // should hit mode2
    @(posedge clk);

    enable = 0; mode = 0;  // will NOT hit mode0 as enable=0
    @(posedge clk);

    $display("Coverage = %0.2f%%", cg.get_coverage());
    $stop;
  end

endmodule
