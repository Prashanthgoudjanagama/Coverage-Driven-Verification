

// file name: 03_explicit_or_user_defined_bins.sv
// module name : explicit


/*
___________________________________________________________

Explicit bins: 
    1. we declare with bins as scalar or vector.
    2. scalar bin : single bin for entire range.
        ```
           cp1: coverpoint data {
                    bins b1 = {[1:7]};
                }

        ```
    3. vector bin : unique bin for specified range.
        ```
            cp2: coverpoint data {
                    bins min[] = {[$:300]};
                    bins mid[] = {[301:500]};
                    bins max[] = {[501:$]};
            }
        ```

______________________________________________________________
*/

module explicit;
  bit [2:0] A;
  
  covergroup cg;
    option.per_instance = 1;
    
    X : coverpoint A {bins b0 = {0};
                      bins b1 = {1};
                      bins b2 = {2};
                      bins b3 = {3};
                      bins b4 = {4};
                      bins b5 = {5};
                      bins b6 = {6};
                      bins b7 = {7};
                      }
                  // vector/array of bins :- unique bins for the specified range
          
                 // { bins b[] = { [0:7] };		// vector/array of bins i.e same result as above i.e b[0] ... b[7]
					
				 //bins b[] = { [0:$] };		// $ means last possible value i.e 7 & same result as above i.e b[0] ... b[7]
						
				 //bins b[] = { [$:7] };		// $ means least possible value i.e 0 to 7 & same result as above i.e b[0] ... b[7]

				 //bins b = {0,1,2,3,4,5,6,7};	// scalar bin i.e single bin for the entire range 
                  //{bins b = { [0:7] };}			// scalar bin i.e single bin for the entire range 
				 //bins b = { [0:$] };			// scalar bin i.e single bin for the entire range
          
          
				 //bins b = { [$:7] };			// scalar bin i.e single bin for the entire range 

  endgroup : cg
  
  initial
    begin
      cg c = new();
      
      repeat(50)
        begin
          A = $urandom;
          c.sample();
        end
    end
  
  initial
    begin
      # 500;
      $stop;
    end
endmodule

