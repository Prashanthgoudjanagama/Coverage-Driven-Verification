

// file name: 06_illegal_bins.sv
// module name : illegal_bins


/*
______________________________________________________
"illegal_bins":
    -> this bins are same as ignore bins.
    -> but only defference is when bin is hit, we'll
       get error message in console (for every hit).
______________________________________________________

*/


module ignore_illegal();
  bit [3:0] A;
  
  covergroup cg;
    option.per_instance = 1;
    
    cp1_A : coverpoint A { 
        bins b1 = {[$:7]};
        bins b2 = {[11:$]};
        illegal_bins ilb = {[8:10]};
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
