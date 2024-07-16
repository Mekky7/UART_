module strt_chk (strt_chk_en,strt_glitch,CLK,RST,sampled_bit);
 input sampled_bit,CLK,RST,strt_chk_en;
 output reg strt_glitch; 
 always @(posedge CLK or negedge RST ) begin
   if (!RST) begin
    strt_glitch<=1;
   end else begin
    if (strt_chk_en) begin
    strt_glitch <= sampled_bit;
    end 
   end 
 end  
endmodule