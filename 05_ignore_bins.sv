

// file name: 05_ignore_bins.sv
// module name : ignore_bins


/*
______________________________________________________
"ignore_bins":
    -> this bins are ignored from coverage.
______________________________________________________

*/

module ignore_illegal();
  bit [3:0] A;
  
  covergroup cg;
    option.per_instance = 1;
    
    cp1_A : coverpoint A { 
                ignore_bins ib = {[10:13]};
                bins b = {[0:9],14,15};
            }
  endgroup
  
  initial
    begin
      cg c = new();
      
      repeat(100)
        begin
          A = $urandom;
          c.sample();
        end
    end
  
  initial
    begin
      # 500 $stop;
    end
endmodule

//-----------------------------------------------------------------------------
//2.illegal_bins
/*
module ignore_illegal();
  bit [3:0] A;
  
  covergroup cg;
    option.per_instance = 1;
    
    X : coverpoint A {
      		   		   //illegal_bins ilb = {10,11,12,13};
                       illegal_bins ilb[] = {[2:7]};
                      }
  endgroup
  
  initial
    begin
      cg c = new();
      
      repeat(100)
        begin
          A = $urandom;
          c.sample();
        end
    end
  
  initial
    begin
      #500 $stop;
    end
endmodule
*/