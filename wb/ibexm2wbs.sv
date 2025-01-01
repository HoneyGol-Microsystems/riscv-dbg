/* Converter between DM slave interface and Wishbone interface */

`default_nettype none

// Ibex master to Wishbone slave converter.
module ibexm2wbs
  (ibex_core_if.master    slave,
   wishbone_p_if.slave    wb);

   logic valid;

   assign valid       = wb.cyc & wb.stb;
   assign slave.req   = valid;
   assign slave.we    = wb.we;
   assign slave.addr  = wb.adr;
   assign slave.be    = wb.sel;
   assign slave.wdata = wb.dat_i;
   assign wb.dat_o    = slave.rdata;
   assign wb.stall    = ~slave.gnt;
   assign wb.err      = slave.err;

   always_ff @(posedge wb.clk_i or posedge wb.rst_i)
     if (wb.rst_i)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;
endmodule

`resetall