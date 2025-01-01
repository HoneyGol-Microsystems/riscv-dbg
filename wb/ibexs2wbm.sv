/* Converter between Ibex core interface and Wishbone interface */

`default_nettype none

// Ibex slave to Wishbone master converter.
module ibexs2wbm
  (ibex_core_if.slave    core,
   wishbone_p_if.master  wb);

   logic cyc;

   assign core.gnt    = core.req & ~wb.stall;
   assign core.rvalid = wb.ack;
   assign core.err    = wb.err;
   assign core.rdata  = wb.dat_i;
   assign wb.stb      = core.req;
   assign wb.adr      = core.addr;
   assign wb.dat_o    = core.wdata;
   assign wb.we       = core.we;
   assign wb.sel      = core.we ? core.be : '1;

   always_ff @(posedge wb.clk_i or posedge wb.rst_i)
     if (wb.rst_i)
       cyc <= 1'b0;
     else
       if (core.req)
         cyc <= 1'b1;
       else if (wb.ack || wb.err)
         cyc <= 1'b0;

   assign wb.cyc = core.req | cyc;
endmodule

`resetall