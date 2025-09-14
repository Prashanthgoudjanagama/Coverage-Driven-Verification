

// file name : 02_option_auto_bin_max.sv
// module : auto_bin_max


/*   
____________________________________________________________________________________________
Auto_bin max:
         ->default value = 64.
         -> without auto_bin_max
               X <= 64 -----> independent bins are created.
               X > 64 ------> grouping of bins 2^size / 64 = n group.
         -> with auto_bin_max
              total 2^size of bins are created.            
           
____________________________________________________________________________________________
*/

module auto_bin_max();
  bit [7:0] x;         //2^8 = 256 bins... 0-255
  bit [1:0] y;         //2^2 = 4 bins...  0-3
  
  covergroup cg;
    option.per_instance = 1;		// for detailed analysis of bins.
    
    cp_Y : coverpoint y;    //implicit scalar or auto bins size of 64 by defualt
    cp_X : coverpoint x {
                option.auto_bin_max = 256; // total 0-255 independent bins are created.
            }
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
  
  initial
    begin
      # 500;
      $stop;
    end
endmodule : auto_bin_max
               