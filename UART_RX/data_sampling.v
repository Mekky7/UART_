
module data_sampling (
    RX_IN,
    sampled_bit,
    CLK,
    RST,
    edge_cnt,
    dat_samp_en,
    Prescale
);
parameter oversampling = 1 ;
input  [5:0] Prescale ;
input CLK,RST;
input RX_IN,dat_samp_en;
input [4:0]edge_cnt;
output reg sampled_bit;
reg temp_1,temp_2,temp_3;
always @(posedge CLK or negedge RST) begin
  if (!RST) begin
    sampled_bit<=0;
  end else begin
    if(dat_samp_en)
    begin
if(!oversampling)
begin
 if (Prescale == 8) begin
  if(edge_cnt==4) sampled_bit <=RX_IN;
 end else begin
  if (Prescale == 16) begin
  if(edge_cnt==8) sampled_bit <=RX_IN;
 end
  else begin
  if (Prescale == 32) begin
    if(edge_cnt==16) sampled_bit <=RX_IN;
 end
    end
  end  
    end else begin
  if (Prescale == 8) begin
  if(edge_cnt==3) temp_1<=RX_IN;
  if(edge_cnt==4) temp_2<=RX_IN;
  if(edge_cnt==5) temp_3<=RX_IN;
 end else begin
  if (Prescale == 16) begin
  if(edge_cnt==7) temp_1<=RX_IN;
  if(edge_cnt==8) temp_2<=RX_IN;
  if(edge_cnt==9) temp_3<=RX_IN;
 end
  else begin
  if (Prescale == 32) begin
  if(edge_cnt==15) temp_1<=RX_IN;
  if(edge_cnt==16) temp_2<=RX_IN;
  if(edge_cnt==17) temp_3<=RX_IN;
 end
  end
 end
   case ({temp_1,temp_2,temp_3})
3'b000: sampled_bit <=0;
3'b001: sampled_bit <=0;
3'b010: sampled_bit <=0;
3'b011: sampled_bit <=1;
3'b100: sampled_bit <=0;
3'b101: sampled_bit <=1;
3'b110: sampled_bit <=1;
3'b111: sampled_bit <=1;
  default: begin
    sampled_bit<=0;
  end
endcase 
 
    end
  end
end
end
endmodule
