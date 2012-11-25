//////////////////////////////////////////////////////////////////////
////                                                              ////
////  File name "wishbone.v"                                      ////
////                                                              ////
////  This file is part of the "10GE MAC" project                 ////
////  http://www.opencores.org/cores/xge_mac/                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - A. Tanguay (antanguay@opencores.org)                  ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 AUTHORS. All rights reserved.             ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "defines.v"

module stats(/*AUTOARG*/
  // Outputs
  stats_tx_pkts, stats_rx_pkts,
  // Inputs
  wb_clk_i, wb_rst_i, status_good_frame_tx_tog,
  status_good_frame_tx_size, status_good_frame_rx_tog,
  status_good_frame_rx_size
  );


input         wb_clk_i;
input         wb_rst_i;

input         status_good_frame_tx_tog;
input  [13:0] status_good_frame_tx_size;

input         status_good_frame_rx_tog;
input  [13:0] status_good_frame_rx_size;

output [31:0] stats_tx_pkts;

output [31:0] stats_rx_pkts;

/*AUTOREG*/
// Beginning of automatic regs (for this module's undeclared outputs)
reg [31:0]              stats_rx_pkts;
reg [31:0]              stats_tx_pkts;
// End of automatics


/*AUTOWIRE*/

reg           status_good_frame_tx_tog_d1;
reg           status_good_frame_rx_tog_d1;

reg [31:0]    next_stats_rx_pkts;
reg [31:0]    next_stats_tx_pkts;

always @(posedge wb_clk_i or posedge wb_rst_i) begin

    if (wb_rst_i == 1'b1) begin

        status_good_frame_tx_tog_d1 <= status_good_frame_tx_tog;
        status_good_frame_rx_tog_d1 <= status_good_frame_rx_tog;

        stats_tx_pkts <= 32'b0;
        stats_rx_pkts <= 32'b0;

    end
    else begin

        status_good_frame_tx_tog_d1 <= status_good_frame_tx_tog;
        status_good_frame_rx_tog_d1 <= status_good_frame_rx_tog;

        stats_tx_pkts <= next_stats_tx_pkts;
        stats_rx_pkts <= next_stats_rx_pkts;

    end

end

always @(/*AS*/stats_rx_pkts or stats_tx_pkts
         or status_good_frame_rx_tog or status_good_frame_rx_tog_d1
         or status_good_frame_tx_tog or status_good_frame_tx_tog_d1) begin

    next_stats_tx_pkts = stats_tx_pkts;
    next_stats_rx_pkts = stats_rx_pkts;

    if (status_good_frame_tx_tog_d1 != status_good_frame_tx_tog) begin
        next_stats_tx_pkts = stats_tx_pkts + 32'b1;
    end

    if (status_good_frame_rx_tog_d1 != status_good_frame_rx_tog) begin
        next_stats_rx_pkts = stats_rx_pkts + 32'b1;
    end

end

endmodule
