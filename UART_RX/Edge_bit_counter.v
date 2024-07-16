module edge_bit_counter (
    CLK,
    RST,
    enable,
    bit_cnt,
    edge_cnt,
    Prescale,
    PAR_EN,reset_count
);
input PAR_EN;
input reset_count;
input [5:0] Prescale;
  input CLK, RST, enable;
  output reg [4:0] edge_cnt;
  output reg [2:0] bit_cnt;
  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      bit_cnt  <= 0;
      edge_cnt <= 0;
    end else begin
      if (enable) begin
        edge_cnt <= edge_cnt + 1;
           if(Prescale==8)begin
            if (edge_cnt == 7) begin
              bit_cnt <= bit_cnt + 1;
            edge_cnt <= 0; 
             if(bit_cnt == 10)
            bit_cnt<=0;
            end
            if(reset_count) begin
            bit_cnt<=0;
         
          end
          end
          else if(Prescale==16)begin
            if (edge_cnt == 15) begin
              bit_cnt <= bit_cnt + 1;
            edge_cnt <= 0; 
             if(bit_cnt == 10)
            bit_cnt<=0;
            end 
            if(reset_count) begin
            bit_cnt<=0;
         
          end
          end
          else if(Prescale==32)begin
            if (edge_cnt == 31) begin
              bit_cnt <= bit_cnt + 1;
            if(bit_cnt == 10)
            bit_cnt<=0;
            edge_cnt <= 0; 
            end
          if(reset_count) begin
            bit_cnt<=0;
         
          end
          end
      end else begin
        
        bit_cnt  <= 0;
      end
    end
  end
endmodule