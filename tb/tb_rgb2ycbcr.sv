`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////
// Company: <Company Name>
// Engineer: <Engineer Name>
//
// Create Date: <date>
// Design Name: <name_of_top-level_design>
// Module Name: <name_of_this_module>
// Target Device: <target device>
// Tool versions: <tool_versions>
// Description:
//    <Description here>
// Dependencies:
//    <Dependencies here>
// Revision:
//    <Code_revision_information>
// Additional Comments:
//    <Additional_comments>
////////////////////////////////////////////////////////////////////////////////


`define NULL 0   

module tb_rgb2ycbcr ();

logic CLK_I, RST_N_I;

reg [23:0] RGB_DATA;
reg        DATA_VALID_I;

wire [7:0] Y_O          ;
wire [7:0] CB_O         ;
wire [7:0] CR_O         ;
wire       DATA_VALID_O ;

localparam T = 10 ;
integer               data_file    ; // file handler
integer               scan_file    ; // file handler
logic  [23:0] captured_data;

always #(T/2) CLK_I = ! CLK_I ;

initial begin
  CLK_I <= 1;
  RST_N_I <= 0 ;
  #(T*10)     ;
  RST_N_I <= 1 ;
end

initial begin
  data_file = $fopen("/home/oguzk/Desktop/Image-Processing/Jpeg-Compressor/sw/rgb_values.txt", "r");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end

always @(posedge CLK_I) begin
  if(!RST_N_I)begin
    captured_data <= 24'd0 ; 
    DATA_VALID_I  <= 1'd0  ;
    RGB_DATA      <= 24'd0 ;
  end
  else begin
  scan_file = $fscanf(data_file, "%X\n", captured_data); 
  $display("Captured data = %X\n",captured_data);
  if (!$feof(data_file)) begin
    RGB_DATA <= captured_data ;
    $display("Captured data = %X\n",captured_data);
    DATA_VALID_I <= 1'd1;
  end
  else begin
    DATA_VALID_I <= 1'd0;
  end
end
end

integer fd;
initial begin
  fd= $fopen("output.txt", "w");

  if(fd_close)begin
    $fclose(fd);
  end
end

always @(posedge CLK_I)begin
    if(DATA_VALID_O & RST_N_I)begin
      $fwrite(fd,"%X,%X,%X",Y_O, CB_O, CR_O);
      $fwrite(fd,"\n");
    end
end

reg [63:0] data_cnt_r ;
reg fd_close;

always @(posedge CLK_I) begin
  if(!RST_N_I)begin
    data_cnt_r <= 64'd0;
    fd_close <= 1'd0;
  end
  else begin
    if(DATA_VALID_O)begin
      data_cnt_r <=data_cnt_r + 64'd1;
    end

    if(data_cnt_r == 64'd102399)begin
      fd_close <= 1'd1;
    end
  end
end


rgb2ycbcr  DUT(
    .CLK_I        ( CLK_I         ),
    .RST_N_I      ( RST_N_I       ),
    .RGB_I        ( RGB_DATA      ),
    .DATA_VALID_I ( DATA_VALID_I  ),
    .Y_O          ( Y_O           ),
    .CB_O         ( CB_O          ),
    .CR_O         ( CR_O          ),
    .DATA_VALID_O ( DATA_VALID_O  )    
  );
endmodule