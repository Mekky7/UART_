module four_to_one_mux(mux_sel,ser_data,par_bit,TX_OUT);
localparam start_bit=1'b0;
localparam stop_bit =1'b1;
input [1:0] mux_sel;
input par_bit,ser_data;
output reg TX_OUT;
always @(*) begin
case (mux_sel)
0:TX_OUT=start_bit;
1:TX_OUT=stop_bit;
2:TX_OUT=ser_data;
3:TX_OUT=par_bit;  
endcase    
end
endmodule