module SAR_Logic #(parameter bits=8)(
    input wire clk,             // System clock
    input wire reset,           // Reset signal
    input wire start_conversion,// Start pulse from external logic
    input wire comparator_out,  // Output from the analog comparator (digital 0 or 1)
    output reg [bits-1:0] digital_out, // The final digital value (e.g., 8-bit)
    output wire conversion_done            // End of Conversion signal
);
    // Internal registers and wires for control and data
    reg [bits-1:0] sar_reg;       // The successive approximation register
    reg [bits-1:0] mask;          // A mask to target the current bit being tested
    reg [2:0] bit_index;       // To track the current bit position
    reg converting;            // FSM state indicator

    // FSM logic and sequential updates
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sar_reg <= 0;
            converting <= 0;
            bit_index <= 0;
            mask <= 0;
        end else begin
            if (start_conversion) begin
                converting <= 1;
                sar_reg <= 0; // or set MSB to 1 immediately depending on exact algorithm variation
                mask <= (1 << (bits-1)); // Start with MSB mask
                bit_index <= bits-1;
            end else if (converting) begin
                // The core SAR algorithm logic goes here, using comparator_out
                // and updating sar_reg based on the current mask.
                // This usually requires a few clock cycles per bit in practice.
                // A simplified representation:
                if (comparator_out == 1'b1) begin
                    // If Vin > Vdac, keep the current trial bit set
                    sar_reg <= sar_reg | mask;
                end
                // Move to the next bit
                mask <= (mask >> 1);
                bit_index <= bit_index - 1;

                if (bit_index == 0) begin
                    converting <= 0; // Conversion is done
                end
            end
        end
    end
    
    // Assign final output and EOC signal 
	 
    assign digital_out = sar_reg; // Output the final value when conversion ends
    assign conversion_done = ~converting;     // EOC is high when not converting
      
endmodule