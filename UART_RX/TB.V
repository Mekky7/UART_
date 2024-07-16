module uart_rx_tb();
    reg clk_tx, RST, PAR_TYP, PAR_EN, RX_IN;
    reg [5:0] Prescale;
    reg clk_rx;
    wire [7:0] P_DATA;
    wire DATA_VALID, par_err, stp_err;
    reg [7:0] temp_data;
    reg [5:0]see;
    reg parity_bit;
    integer i;
   
    top_RX_module DUT (
        .RX_IN(RX_IN),
        .Prescale(Prescale),
        .PAR_EN(PAR_EN),
        .PAR_TYP(PAR_TYP),
        .CLK(clk_rx),
        .RST(RST),
        .P_DATA(P_DATA),
        .DATA_VALID(DATA_VALID),
        .stp_err(stp_err),
        .par_err(par_err)
    );

    initial begin
        clk_rx = 0;
        forever begin
            #1 clk_rx = ~clk_rx;
        end
    end
    
    initial begin
        clk_tx = 0;
        Prescale=8;
        forever begin
         #Prescale clk_tx = ~clk_tx;
        end
    end

    initial begin
        Prescale=8;
        test_reset();
        test_prescale(Prescale);
         Prescale=16;
        test_prescale(Prescale);
         Prescale=32;
         test_prescale(Prescale);
        $stop;
    end

    task test_reset();
    begin
        $display("reset_assertion!");
        RST = 0;
        repeat (4) @(negedge clk_tx);
        if ((par_err == 0) || (!stp_err) || (DATA_VALID) || (P_DATA != 0)) begin
            $display("Reset_test failed :(");
            $stop;
        end else begin
            $display("Reset_test passed :)");
        end
        $display("reset_deassertion");
        RST=1;
        RX_IN=1;
        @(negedge clk_tx);
    end
    endtask
task test_prescale(input [5:0] prescale);
    begin
   @(negedge clk_tx);
   see=prescale;   
   temp_data=$random;
    RX_IN=0;
    PAR_EN=0;
    PAR_TYP=$random;
   @(negedge clk_tx);
    for (i=0; i<8;i=1+i) begin
    RX_IN=temp_data[i];
    @(negedge clk_tx);
    end
    RX_IN=1;
    repeat(Prescale-1) begin
        @(negedge clk_rx);
    end
    RX_IN=0;
    @(posedge DATA_VALID);
    if(P_DATA==temp_data)
    begin
     $display("test_1_prescale_of_ %0d passed :)",prescale); 
    end else begin
     $display("test_1_prescale_of_%0d failed :(",prescale);
    end
    temp_data=$random;
    RX_IN=0;
    repeat(2)begin
    @(negedge clk_tx);    
    end
    PAR_EN=1;
    PAR_TYP=$random;
    parity_bit=((!PAR_TYP)?(^(temp_data)):(~^(temp_data)));
    for (i=0; i<8;i=1+i) begin
    RX_IN=temp_data[i];
    @(negedge clk_tx);
    end
    RX_IN=parity_bit;
    @(negedge clk_tx);
    RX_IN=1;
    @(posedge DATA_VALID);
    if(P_DATA==temp_data)
    begin
     $display("test_2_prescale_of_ %0d passed :)",prescale); 
    end else begin
     $display("test_2_prescale_of_%0d failed :(",prescale);
    end
    @(negedge clk_tx);
end

    endtask

endmodule
