module top_RX_module(RX_IN,Prescale,PAR_EN,PAR_TYP,CLK,RST,P_DATA,DATA_VALID,stp_err,par_err);
input CLK,RST,PAR_TYP,PAR_EN,RX_IN;
input [5:0] Prescale;
output  [7:0] P_DATA;
output DATA_VALID,par_err,stp_err;
wire dat_samp_en,enable,par_chk_en,strt_chk_en,stp_chk_en;
wire strt_glitch,stp_err,sampled_bit,deser_en;
wire [4:0] edge_cnt;
wire [2:0] bit_cnt;
wire [5:0] Prescale;
wire  reset_count;
wire par_deassert;
parity_calc block_1  (par_deassert,PAR_TYP,par_chk_en,CLK,RST,par_err,sampled_bit,P_DATA);
strt_chk block_2 (strt_chk_en,strt_glitch,CLK,RST,sampled_bit);
FSM block_3 (RX_IN,PAR_EN,dat_samp_en,edge_cnt,bit_cnt,enable,
par_chk_en,par_err,strt_chk_en,strt_glitch,stp_chk_en,stp_err,Prescale,
deser_en,DATA_VALID,
CLK,RST,reset_count,par_deassert);
data_sampling block_4(RX_IN,sampled_bit,CLK,RST,
edge_cnt,dat_samp_en,Prescale);
deserilazer block_5 (sampled_bit,CLK,RST,deser_en,P_DATA);
edge_bit_counter block_6 (CLK,RST,enable,bit_cnt,edge_cnt,Prescale,PAR_EN,reset_count);
stp_chk block_7 (sampled_bit,stp_chk_en,CLK,RST,stp_err);
endmodule