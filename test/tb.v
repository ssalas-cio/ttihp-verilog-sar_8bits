`timescale 1ns / 1ps
module TestBench_SAR_Logic;

    // Parámetros
    parameter PERIOD = 200;
    parameter bits=8;
    // Señales del test bench
    reg clk=0; 
	reg reset, start_conversion, comparator_out;
    wire [bits-1:0] digital_out;	   
	//wire [bits-1:0] dac_in;	   
	wire conversion_done;

    // Instancia del contador a probar
    SAR_Logic #(.bits(bits))SAR_Logic(
        .clk(clk),
        .reset(reset),
        .start_conversion(start_conversion),  
	    .comparator_out(comparator_out),	 
		.digital_out(digital_out),
		//.dac_in(dac_in),   
		.conversion_done(conversion_done)
    );

   always 
	#((PERIOD)/2) clk = ~clk;	
	
	initial begin
    reset = 1;		  
	start_conversion = 0; 
	comparator_out=0;
	#200; 
	
	reset = 0;
	#200; 
	
	
	start_conversion = 1;
	#200; 
	start_conversion = 0;  
	#200; 
	
    comparator_out=1;
	#200;
	comparator_out=0;
	#200;			  
	comparator_out=1;
	#200;		   
	comparator_out=1;
	#200;				 
	comparator_out=1;
	#200;		 
	comparator_out=0;
	#200;		  
		comparator_out=1;
	#200;
	comparator_out=0;	  
		start_conversion = 1;
	#200;
	comparator_out=1;  
	start_conversion = 0;
	#200;
					   	
	comparator_out=0;
	#200;	
	comparator_out=1;
	#200;
		comparator_out=0;
	#200;  
		comparator_out=1;
	#200;
		comparator_out=0;
	#200;
	end
	
endmodule


