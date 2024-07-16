module parity_calc (par_deassert,PAR_TYP,par_chk_en,CLK,RST,par_err,sampled_bit,P_DATA);
input  CLK,RST;
input  par_deassert,par_chk_en,sampled_bit,PAR_TYP;
input [7:0] P_DATA;
output reg par_err;
wire parity_bit_comb;
always @(posedge CLK or negedge RST) begin
if (!RST) begin
  par_err<=1;
end else begin
  if (par_chk_en) begin
  par_err<= parity_bit_comb^sampled_bit;
  end else if (par_deassert) begin
    par_err<=1;
  end
end    
end
assign parity_bit_comb =((!PAR_TYP)?(^(P_DATA)):(~^(P_DATA)));
endmodule