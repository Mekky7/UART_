module UART_TX_tb ();
reg [7:0] P_DATA;
reg PAR_EN,PAR_TYP,CLK,RST,DATA_VALID;
wire TX_OUT,Busy;
//////////////////////////
//internal_signals
reg [10:0] data_ref,temp;
reg [9:0]  temp_x,data_ref_x;
reg par_bit;
integer i;
/////////////////////////
//Module instantiation
UART_TX Dut(CLK,RST,PAR_TYP,PAR_EN,P_DATA,DATA_VALID,TX_OUT,Busy);

//clock generator:
initial begin
CLK=0;
forever begin
#1;
CLK=!CLK;
end
end
//RESET ASSERTION TASK:
task reset_assert();
begin
RST=0;
@(negedge CLK);
RST=1;
@(negedge CLK);
end
endtask

//TEST TIMING OF DATA_VALID AND BUSY TIMING
task DATA_VALID_test();
begin
DATA_VALID=1;
@(negedge CLK);
DATA_VALID=0;
if(Busy!=1)
begin
$display("error in data_valid_case(1)");
$stop;
end
repeat(11) @(negedge CLK);
if(Busy!=0)
begin
$display("error in data_valid_case(2)");
$stop;
end
end
endtask
//TEST_THE_TX_OUT_TASK:
task TX_OUT_test();
begin
if(PAR_TYP)
begin
par_bit=(^P_DATA);	
end else 
begin
par_bit=(~^P_DATA);
end
if(PAR_EN)
begin
DATA_VALID=1;
data_ref={2'b1,par_bit,P_DATA,1'b0};
for ( i=0 ;i<=10 ;i=i+1) begin
@(negedge CLK);
DATA_VALID=0;
temp[i]=TX_OUT;	
end
if(temp[10:0]!=data_ref[10:0])
begin
$display("error in the tx_out case(1)");
end
end else begin
DATA_VALID=1;
data_ref_x={1'b1,P_DATA,1'b0};
for(i=0 ;i<=9 ;i=i+1) begin
@(negedge CLK);
DATA_VALID=0;
temp_x[i]=TX_OUT;	
end	
if(temp_x!=data_ref_x)
begin
$display("error in the tx_out");
end
end
@(negedge CLK);
end
endtask
task tx_out_with_no_iidle_state();
begin
DATA_VALID=1;
data_ref={2'b1,par_bit,P_DATA,1'b0};
for ( i=0 ;i<=10 ;i=i+1) begin
@(negedge CLK);
P_DATA=98;
temp[i]=TX_OUT;	
end
if(temp_x!=data_ref_x)
begin
$display("error in the tx_out");
end
@(negedge CLK);
for ( i=0 ;i<=10 ;i=i+1) begin
@(negedge CLK);
DATA_VALID=0;
temp[i]=TX_OUT;	
end
if(temp_x!=data_ref_x)
begin
$display("error in the tx_out");
end
end
endtask
//stimulus generation:
initial begin
P_DATA=8'h5d;
PAR_EN=1;
PAR_TYP=0;
DATA_VALID=0;
reset_assert();
DATA_VALID_test();
TX_OUT_test();
P_DATA=8'h5d;
PAR_EN=0;
PAR_TYP=0;
TX_OUT_test();
P_DATA=8'h5d;
PAR_EN=1;
PAR_TYP=1;
TX_OUT_test();
P_DATA=$random;
PAR_EN=1;
PAR_TYP=1;
TX_OUT_test();
//the case in which no idle state: 
tx_out_with_no_iidle_state();
$display("done :)");
$stop;
end
endmodule