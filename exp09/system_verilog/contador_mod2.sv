module contador_mod2(
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [3:0] valor,
    output reg carry
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valor <= 4'd0;
            carry <= 1'b0;
        end else if (enable) begin
            if (valor == 4'd1) begin
                valor <= 4'd0;
                carry <= 1'b1;
            end else begin
                valor <= valor + 1'd1;
                carry <= 1'b0;
            end
        end else begin
            carry <= 1'b0;
        end
    end

endmodule
