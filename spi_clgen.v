`include "spi_defines.v"
module spi_clgen (wb_clk_in,
		  wb_rst,
		  go,
		  tip,
		  last_clk,
		  divider,
		  sclk_out,
 		  cpol_0,
  		  cpol_1);
input				wb_clk_in;
input				wb_rst;
input				tip;
input				go;
input				last_clk;
input	[`SPI_DIVIDER_LEN-1:0]  divider;
output				sclk_out;
output				cpol_0;
output				cpol_1;

reg				sclk_out;
reg				cpol_0;
reg				cpol_1;

reg	[`SPI_DIVIDER_LEN-1:0]  cnt;

always@(posedge wb_clk_in or posedge wb_rst)
begin
   if(wb_rst)
      cnt <= {{`SPI_DIVIDER_LEN{1'b0}},1'b1};
   else if(tip)
   begin
      if(cnt == (divider + 1))
         cnt <= {{`SPI_DIVIDER_LEN{1'b0}},1'b1};
      else
	 cnt <= cnt + 1;
   end
   else if(cnt == 0)
      cnt <= {{`SPI_DIVIDER_LEN{1'b0}},1'b1};
end

always@(posedge wb_clk_in or posedge wb_rst)
begin
   if(wb_rst)
     begin
      sclk_out <= 1'b0;
     end
   else if(tip)
            begin
               if(cnt == (divider + 1))
           begin
		if(!last_clk || sclk_out)
             sclk_out <= ~sclk_out;
           end
            end
end

always@(posedge wb_clk_in or posedge wb_rst)
begin
   if(wb_rst)
     begin
       cpol_0 <= 1'b0;
       cpol_1 <= 1'b0;
     end
   else
     begin
         cpol_0 <= 0;
         cpol_1 <= 0;
         if(tip)
           begin
              if(~sclk_out)
                  begin
                     if(cnt == divider)
                       begin
                           cpol_0 <= 1;
                       end
                  end
           end
          if(tip)
         begin
            if(sclk_out)
                begin
                   if(cnt == divider)
                     begin
                        cpol_1 <= 1;
                     end
                end
         end
 end
end

endmodule

     
