module UART_TX(CLK,RST,PAR_TYP,PAR_EN,P_DATA,DATA_VALID,TX_OUT,Busy);
 parameter Width=8;
 input CLK,RST;
 input PAR_TYP,PAR_EN,DATA_VALID;
 input [Width-1:0] P_DATA;
 output TX_OUT,Busy;
wire ser_done,ser_en,FSM_en;
wire ser_data;
wire[1:0] mux_sel;
wire par_bit;
FSM block_one (CLK,RST,ser_done,DATA_VALID,PAR_EN,ser_en,mux_sel,Busy,FSM_en);
serializer block_two (P_DATA,DATA_VALID,ser_en,ser_data,ser_done,CLK,RST);
parity_calc block_three (P_DATA,DATA_VALID,PAR_TYP,CLK,RST,par_bit,FSM_en);
four_to_one_mux block_four (mux_sel,ser_data,par_bit,TX_OUT);
endmodule