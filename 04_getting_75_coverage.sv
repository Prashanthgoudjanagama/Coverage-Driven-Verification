

// file name : 04_getting_75_coverage.sv
// module name: explicit_75



module explicit_75;
  bit [2:0] A;
  bit [2:0] B[$] = '{1,2,3,4,5,7}; //75% coverage

  covergroup cg;
    option.per_instance = 1;
    
    cp_A : coverpoint A { 
                bins b0[] = {[0:7]};
            }
    
  endgroup
  
  initial begin
      cg c = new();
      
      foreach(B[i])
        begin
          A = B[i];
          c.sample();
        end
  end
  
  initial begin
      # 500;
      $stop;
  end
endmodule : explicit_75
