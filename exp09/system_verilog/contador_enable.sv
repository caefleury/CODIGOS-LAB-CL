// Contador de milissegundos (unidades)
module contador_enable(
    input wire clk,        // Clock de 1kHz
    input wire reset,      // Sinal de reset
    input wire enable,     // Habilita a contagem
    output reg [3:0] valor, // Valor atual do contador
    output reg carry       // Sinal de carry (overflow)
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valor <= 4'd0;
            carry <= 1'b0;
        end else if (enable) begin
            if (valor == 4'd9) begin
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