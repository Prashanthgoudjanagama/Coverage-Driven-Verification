

// File: 08_wildcard_bins.sv
// module: wildcard_cov_tb

/*
_____________________________________________

wildcard bins:
    1. it allows X and ? to target perticular range.
    2. syntax:
        ```
        bit [3:0] data;

        coverpoint data {
            wildcard bins low = (4'b00??);      // 0-3 bins
            wildcard bins mid = (4'b0?11);      // 3-7 bins
            wildcard bins low = (4'b1xxx);      // 8-16 bins
            wildcard bins low = (4'b1xxx);      // 8-16 bins
        }

        ```

_____________________________________________
*/
`timescale 1ns/1ps

module wildcard_cov_tb;

  // clock
  reg clk = 0;
  always #5 clk = ~clk;

  // a 4-bit signal we will cover
  reg [3:0] data;

  // covergroup with wildcard bins
  covergroup cg_data @(posedge clk);
    cp_data : coverpoint data {
      // Group all values with upper bits '10xx' (binary 8–11)
      wildcard bins upper10 = {4'b10??};

      // Group all values ending with '01' (1, 5, 9, 13)
      wildcard bins ends01 = {4'b??01};

      // Group values '0000' and '1111' specifically (explicit bins)
      bins corners[] = {4'b0000, 4'b1111};

      // Optional: default bin for other values
      // default; // uncomment to catch all other values automatically
    }
  endgroup


  initial begin
    cg_data cg = new();

    // Stimulus to hit multiple bins
    data = 4'b0000; @(posedge clk); // should hit corners
    data = 4'b1001; @(posedge clk); // 10?? + ??01
    data = 4'b1010; @(posedge clk); // 10??
    data = 4'b1101; @(posedge clk); // 10?? + ??01
    data = 4'b1111; @(posedge clk); // corners
    data = 4'b0101; @(posedge clk); // ??01 only
    data = 4'b0110; @(posedge clk); // hits none of the named bins

    // print coverage result
    $display("\n=== Coverage Report ===");
    $display("Coverage: %0.2f %%", cg.get_coverage());

    $finish;
  end

endmodule
