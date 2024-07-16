module stp_chk (sampled_bit,stp_chk_en,CLK,RST,stp_err);
   input CLK,RST,sampled_bit,stp_chk_en;
   output reg stp_err;
always @(posedge CLK or negedge RST ) begin
    if (!RST) begin
    stp_err<=1;
    end else begin
        if(stp_chk_en)
        begin
         stp_err <= !sampled_bit;   
        end else begin
         stp_err<=1;
        end
    end
    
end 
endmodule