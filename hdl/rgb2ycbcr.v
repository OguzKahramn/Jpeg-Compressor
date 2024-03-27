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


module rgb2ycbcr (
    input            CLK_I       ,
    input            RST_N_I     ,
    input [23:0]     RGB_I       ,
    input            DATA_VALID_I,
    output [7:0]     Y_O         ,
    output [7:0]     CB_O        ,
    output [7:0]     CR_O        ,
    output           DATA_VALID_O    
  );

  // Coefficient values for converting RGB image to Y,Cb,Cr 
  parameter y0_coef  = 0            ;
  parameter y1_coef  = 0.299        ;
  parameter y2_coef  = 0.587        ;
  parameter y3_coef  = 0.114        ;
  parameter cb0_coef = 128          ;
  parameter cb1_coef = -0.169       ;
  parameter cb2_coef = -0.331       ;
  parameter cb3_coef = 0.5          ;
  parameter cr0_coef = 128          ;
  parameter cr1_coef = 0.5          ;
  parameter cr2_coef = -0.419       ;
  parameter cr3_coef = -0.081       ;

  // Q8.16 Fixed point decleration and scaling the ceofficients
  parameter COEF_WIDTH = 24         ;
  parameter COEF_FRACTIONAL_BITS=15 ;
  parameter INPUT_WIDTH = 8         ;

  localparam SCALED_Y0_C = y0_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_Y1_C = y1_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_Y2_C = y2_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_Y3_C = y3_coef * (1 << COEF_FRACTIONAL_BITS);

  localparam SCALED_CB0_C = cb0_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_CB1_C = cb1_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_CB2_C = cb2_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_CB3_C = cb3_coef * (1 << COEF_FRACTIONAL_BITS);

  localparam SCALED_CR0_C = cr0_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_CR1_C = cr1_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_CR2_C = cr2_coef * (1 << COEF_FRACTIONAL_BITS);
  localparam SCALED_CR3_C = cr3_coef * (1 << COEF_FRACTIONAL_BITS);



  localparam MULTIPLIED_WIDTH = INPUT_WIDTH + COEF_WIDTH - 1;

  reg signed [MULTIPLIED_WIDTH-1:0] y_r, cb_r, cr_r ;
  reg        data_valid_r                           ;


  // _______________________________ ASYNC ASSIGNMENTS _______________________________ 

  assign Y_O  =  y_r[23:15]           ;
  assign CB_O = cb_r[23:15]           ;
  assign CR_O = cr_r[23:15]           ;
  assign DATA_VALID_O = data_valid_r  ;

  // _______________________________ MAIN LOGIC _______________________________ 
  
  always @(posedge CLK_I) begin
    if(!RST_N_I)begin
      y_r           <= 0 ;
      cb_r          <= 0 ;
      cr_r          <= 0 ;
      data_valid_r  <= 1'd0 ;
    end
    else begin
      if(DATA_VALID_I) begin
        y_r           <= ( SCALED_Y0_C) + (SCALED_Y1_C  * RGB_I[23:16] + SCALED_Y2_C  * RGB_I[15:8] + SCALED_Y3_C  * RGB_I[7:0]);
        cb_r          <= (SCALED_CB0_C) + (SCALED_CB1_C * RGB_I[23:16] + SCALED_CB2_C * RGB_I[15:8] + SCALED_CB3_C * RGB_I[7:0]);
        cr_r          <= (SCALED_CR0_C) + (SCALED_CR1_C * RGB_I[23:16] + SCALED_CR2_C * RGB_I[15:8] + SCALED_CR3_C * RGB_I[7:0]);
        data_valid_r  <= 1'd1;
      end
      else begin
        data_valid_r  <= 1'd0;
      end
    end
  end

endmodule