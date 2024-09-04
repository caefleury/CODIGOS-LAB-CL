module controle_start_stop_rs(
    input wire clk,
    input wire start_button,  // KEY[1]
    input wire stop_button,   // KEY[2]
    output wire running
);

    wire S, R;
    reg Q;

    // Lógica para detectar borda de descida dos botões
    reg start_prev, stop_prev;
    always @(posedge clk) begin
        start_prev <= start_button;
        stop_prev <= stop_button;
    end

    // Geração dos sinais S e R
    assign S = start_prev & ~start_button;  // Borda de descida do botão start
    assign R = stop_prev & ~stop_button;    // Borda de descida do botão stop

    // Latch RS
    always @(posedge clk) begin
        if (S) begin
            Q <= 1'b1;
        end else if (R) begin
            Q <= 1'b0;
        end
    end

    // Saída do latch
    assign running = Q;

endmodule
