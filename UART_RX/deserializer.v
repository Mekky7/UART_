module deserilazer (
sampled_bit,CLK,RST,deser_en,P_DATA
);
input deser_en,sampled_bit;
input CLK,RST;
output reg [7:0] P_DATA;
reg [2:0] count;
always @(posedge CLK or negedge RST) begin
if (!RST) begin
    P_DATA<=0;
    count <= 0;
end else begin
    if(deser_en)
    begin
    P_DATA[count] <= sampled_bit;
    count <= count +1 ;
    end
end    
end  
endmodule