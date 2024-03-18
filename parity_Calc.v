module parity_calc(P_DATA,Data_valid,PAR_TYP,CLK,RST,par_bit,FSM_en);
parameter Width = 8;
input CLK,RST,FSM_en;
input [Width-1:0] P_DATA;
input PAR_TYP,Data_valid;
output reg par_bit;
wire parity_comb;
always @(posedge CLK or negedge RST) begin
if (!RST) begin
  par_bit<=0;
end else begin
  if (Data_valid & FSM_en) begin
  par_bit<=parity_comb;
  end
end    
end
assign parity_comb =(PAR_TYP)?(^(P_DATA)):(~^(P_DATA));    
endmodule