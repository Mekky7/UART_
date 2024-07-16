module FSM (RX_IN,PAR_EN,dat_samp_en,edge_cnt,bit_cnt,enable,
par_chk_en,par_err,strt_chk_en,strt_glitch,stp_chk_en,stp_err,Prescale,
deser_en,data_valid,
CLK,RST,reset_count,par_deassert);
input CLK,RST;
input RX_IN,PAR_EN;
input  [2:0] bit_cnt;
input  [4:0] edge_cnt;
input par_err,strt_glitch,stp_err;
output reg dat_samp_en,enable;
output reg par_chk_en,strt_chk_en,stp_chk_en;
output reg deser_en,data_valid;
output reg reset_count;
output reg par_deassert;
input [5:0] Prescale;
localparam IDLE =0;
localparam START= 1;
localparam DATA=2;
localparam PARITY=3;
localparam STOP=4;  
reg [2:0] cs,ns;
reg temp;
always @(posedge CLK or negedge RST) begin
  if(!RST)
  begin
   cs<=IDLE; 
  end else begin
    cs <= ns;
  end  
end

always @(*) begin 
reset_count=1;
par_deassert=0;
 case (cs)
 IDLE:begin
 par_chk_en=0;
 strt_chk_en=0;
 stp_chk_en=0;
 dat_samp_en=0;
 enable=0;
 deser_en=0;
 par_deassert=1;
 if(!RX_IN)
 begin
 ns =START;
 enable=1;
 dat_samp_en=1;
 strt_chk_en=0;
 end else begin
   ns =cs;
 enable=0;
 dat_samp_en=0;
 strt_chk_en=0;
 end 
 end 
 START: begin
 par_deassert=1;
 par_chk_en=0;
 strt_chk_en=0;
 stp_chk_en=0;
 dat_samp_en=1;
 enable=1;
 deser_en=0;
 if(((Prescale==8)&&(edge_cnt==6))||((Prescale==16)&&(edge_cnt==10))
 ||((Prescale==32)&&(edge_cnt==18))) begin
  strt_chk_en=1;
 end else begin
   strt_chk_en=0;
 end

if(((Prescale==8)&&(edge_cnt==7))||((Prescale==16)&&(edge_cnt==15))
 ||((Prescale==32)&&(edge_cnt==31))) begin
  if(strt_glitch)
  begin
    ns = IDLE;
  end else begin
    ns = DATA ;
  end
 end else begin
    ns =cs ;
 end
 end

DATA: begin
  reset_count=0;
 par_chk_en=0;
 strt_chk_en=0;
 stp_chk_en=0;
 dat_samp_en=1;
 enable=1;
 deser_en=0;
 if(((Prescale==8)&&(edge_cnt==6))||((Prescale==16)&&(edge_cnt==10))
 ||((Prescale==32)&&(edge_cnt==18))) begin
  deser_en=1;
 end else begin
   deser_en=0;
 end 
if((((Prescale==8)&&(edge_cnt==7))||((Prescale==16)&&(edge_cnt==15))
 ||((Prescale==32)&&(edge_cnt==31)))&&(bit_cnt==7)) 
 begin
  if(PAR_EN)
  begin
   ns = PARITY; 
  end else begin
    ns = STOP ;
  end
 end else begin
  ns = cs;
 end 
end

PARITY : begin
  par_chk_en=0;
  strt_chk_en=0;
  stp_chk_en=0;
  dat_samp_en=1;
  enable=1;
  deser_en=0;
if(((Prescale==8)&&(edge_cnt==7))||((Prescale==16)&&(edge_cnt==11))
 ||((Prescale==32)&&(edge_cnt==19))) begin
   par_chk_en=1;
 end else begin
   par_chk_en=0;
 end

 if(((Prescale==8)&&(edge_cnt==7))||((Prescale==16)&&(edge_cnt==15))
 ||((Prescale==32)&&(edge_cnt==31))) begin
    ns = STOP;
 end else begin
    ns =cs ;
 end

end
 
STOP : begin
  par_chk_en=0;
  strt_chk_en=0;
  stp_chk_en=0;
  dat_samp_en=1;
  enable=1;
  deser_en=0;
if(((Prescale==8)&&(edge_cnt==7))||((Prescale==16)&&(edge_cnt==15))
 ||((Prescale==32)&&(edge_cnt==31))) begin
   stp_chk_en=1;
 end else begin
   stp_chk_en=0;
 end
 if(((Prescale==8)&&(edge_cnt==7))||((Prescale==16)&&(edge_cnt==15))
 ||((Prescale==32)&&(edge_cnt==31))) begin
if(!RX_IN)begin
  ns= START;
end else begin
  ns = IDLE;    
end
 end else begin
    ns =cs ;
 end
end

  default: begin
     
   par_chk_en=0;
 strt_chk_en=0;
 stp_chk_en=0;
 dat_samp_en=0;
 enable=0;
 deser_en=0;
 ns =IDLE;
  end
 endcase 
assign temp =(PAR_EN & par_err);
assign data_valid = ~(temp||stp_err) ;
end

endmodule