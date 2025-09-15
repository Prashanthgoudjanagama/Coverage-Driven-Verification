

// file name : 13_reusable_cover_group.sv
// module name : reusable_cg_demo

/*
______________________________________________________
"reusable_cover_group":
    -> covergroup can be reused in multiple instances.
    -> By passing any argument to covergroup, we can create 
       multiple instances of same covergroup.   
______________________________________________________
*/

module reusable_cg_demo;

    bit clk;
    bit [3:0] data_a, data_b;

    // Clock generation
    initial forever #5 clk = ~clk;

    // --------- Reusable Covergroup Definition ---------
    // It accepts a reference to a signal using 'ref' argument
    covergroup cg_data (
        ref input bit [3:0] sig, 
        input int min,max, 
        input string instance_name
    ) @(posedge clk);

        option.name = instance_name;   // Name of the covergroup instance
        option.per_instance = 1;      // Each instance has its own coverage data
        option.goal = 100;            // Set coverage goal to 100%

        coverpoint sig {
            bins low  = {[min:max]};
        }

  endgroup
  

  initial begin
    // Create two reusable covergroup instances
    cg_data cov_a = new(data_a, 0, 3, "Covergroup_A");
    cg_data cov_b = new(data_b, 4, 7, "Covergroup_B");
    cg_data cov_c = new(data_a, 8, 11, "Covergroup_C");
    cg_data cov_d = new(data_b, 12, 15, "Covergroup_D");
    // Apply random data and sample coverage
    repeat (10) begin
      @(posedge clk);
      data_a = $urandom_range(0,3);
      data_b = $urandom_range(4,7);
      data_a = $urandom_range(8,11);
      data_b = $urandom_range(12,15);
      cov_a.sample();
      cov_b.sample();
      cov_c.sample();
      cov_d.sample();
    end

    $display("Coverage A: %0.2f%%", cov_a.get_coverage());
    $display("Coverage B: %0.2f%%", cov_b.get_coverage());
    $display("Coverage C: %0.2f%%", cov_c.get_coverage());
    $display("Coverage D: %0.2f%%", cov_d.get_coverage());
    $finish;
  end

endmodule
