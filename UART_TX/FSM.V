module FSM (CLK,RST,ser_done,Data_Valid,PAR_EN,ser_en,mux_sel,busy,FSM_en);
input CLK,RST;
input ser_done,Data_Valid,PAR_EN;
output reg busy,ser_en;
output reg [1:0] mux_sel;
localparam IDLE_STATE=0;
localparam START_STATE=1;
localparam TRANSMIT_STATE=2;
localparam PARITY_STATE=3;
localparam STOP_STATE=4;
output reg FSM_en;
reg [2:0] CS,NS;
always @( posedge CLK or negedge RST ) begin
if(!RST)
begin
CS<=IDLE_STATE;
end else begin
CS<=NS;   
end
end
always @(*) begin
case (CS)
IDLE_STATE:begin
FSM_en=1;
ser_en=0;
busy=0;
mux_sel=1;
if(Data_Valid)
begin
NS=START_STATE;
end else begin
NS=CS;   
end
end
START_STATE: begin
FSM_en=0;
ser_en=1;
mux_sel=0;
busy=1;
NS=TRANSMIT_STATE;
end
TRANSMIT_STATE: begin
FSM_en=0;
mux_sel=2;
busy=1;
if(!ser_done)
begin
NS=CS;
ser_en=1;    
end else begin
ser_en=0;
 if (PAR_EN) begin
    NS=PARITY_STATE;
 end else begin
    NS=STOP_STATE;
 end   
end
end
PARITY_STATE: begin
FSM_en=0;
ser_en=0;
mux_sel=3;
busy=1;
NS=STOP_STATE;
end
STOP_STATE: begin

ser_en=0;
mux_sel=1;
busy=1;
if (Data_Valid) begin
    NS=START_STATE;
    FSM_en=1;
end else begin
    NS=IDLE_STATE;
    FSM_en=0;
end
end
    default: begin
     NS=IDLE_STATE;
     ser_en=0;
     mux_sel=1;
     busy=0;
     FSM_en=0;
    end
endcase    
end
endmodule