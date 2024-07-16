module serializer (P_DATA,Data_Valid,ser_en,ser_data,ser_done,CLK,RST);
parameter Width = 8;
input RST,CLK;
input [Width-1:0] P_DATA;
input Data_Valid,ser_en;
output reg ser_data;
output reg ser_done;
reg [2:0] ser_count;
reg [Width-1:0] temp;
always @(posedge CLK or negedge RST) begin
if (!RST) begin
ser_done<=0;
ser_count<=0;
ser_data<=0;
end else begin
if(Data_Valid && (ser_count==0))
begin
temp<=P_DATA;
end 
if (ser_en) begin
ser_count<=ser_count+1;
end
if(ser_count==7)
begin
 ser_count<=0;
 ser_done<=1;   
end else ser_done<=0;
end
ser_data<=temp[ser_count];    
end
endmodule