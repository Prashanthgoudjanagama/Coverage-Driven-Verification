

// file name : 01_implicit_or_auto_bins.sv
// module : implicit_bin



// implicit or auto bins
  
/*   
____________________________________________________________________________________________
Auto_bins:
         ->default value = 64.
         -> auto_bins
               Bins <= 64 -----> independent bins are created.
               Bins > 64  -----> grouping of bins 2^size / 64 = n group of 64 bins.
____________________________________________________________________________________________
*/

module impicit();
  bit [3:0] x;         //2^4 = 16 bins... 0-15
  bit [1:0] y;         //2^2 = 4 bins...  0-3
  
  covergroup cg;
    option.per_instance = 1;		// for detailed analysis of bins.
    
    X : coverpoint x;     //implicit scalar or auto bins size of 64 by defualt
    Y : coverpoint y;
  endgroup : cg
  
  initial
    begin
      cg c = new();
      
      repeat(50)
        begin
          {x,y} = $urandom;
          c.sample();
        end
    end
endmodule

