module relogio_digital(
    input logic clk,
    input logic [17:15] SW,
    input logic [5:0] SW_ajuste,
    input logic [3:0] KEY,
    output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);

    // Declaracao de variaveis
    logic [5:0] segundos, minutos, horas;
    logic [6:0] centesimos;
    logic [1:0] modo;
    logic ajuste, timer_ativo, cronometro_ativo;
    logic reset, set, start_stop;
    logic alarme;
	 logic start_stop_prev;

    assign modo = SW[16:15];
    assign ajuste = SW[17];
    assign reset = ~KEY[0];
    assign set = ~KEY[1];
    assign start_stop = ~KEY[3];

    // Divisor de clock para 100Hz 
    logic [31:0] contador_100hz;
    logic clk_100hz;

    always_ff @(posedge clk) begin
        if (contador_100hz == 32'd500000) begin
            contador_100hz <= 32'd0;
            clk_100hz <= ~clk_100hz;
        end else begin
            contador_100hz <= contador_100hz + 1;
        end
    end

    // Logica de contagem e ajuste
    always_ff @(posedge clk_100hz or posedge reset) begin
        if (reset) begin
            if (KEY[0] == 1'b0) begin // Reset geral se pressionado por mais de 2 segundos
                horas <= 6'd0;
                minutos <= 6'd0;
                segundos <= 6'd0;
                centesimos <= 7'd0;
                timer_ativo <= 1'b0;
                cronometro_ativo <= 1'b0;
            end else begin
                case (modo)
                    2'b00: begin // Relógio
                        // Nao faz nada
                    end
                    2'b01: begin // Cronômetro
                        centesimos <= 7'd0;
                        segundos <= 6'd0;
                        minutos <= 6'd0;
                    end
                    2'b10: begin // Timer
                        horas <= 6'd23;
                        minutos <= 6'd59;
                        segundos <= 6'd59;
                    end
                endcase
            end
        end else begin
            case (modo)
                2'b00: begin // Relógio
                    if (cronometro_ativo || timer_ativo) begin
                        centesimos <= centesimos + 1'b1;
                        if (centesimos == 7'd99) begin
                            centesimos <= 7'd0;
                            segundos <= segundos + 1'b1;
                        end
                        if (segundos == 6'd59) begin
                            segundos <= 6'd0;
                            minutos <= minutos + 1'b1;
                        end
                        if (minutos == 6'd59) begin
                            minutos <= 6'd0;
                            horas <= horas + 1'b1;
                        end
                    end
                end
                2'b01: begin // Cronômetro
                    if (cronometro_ativo) begin
                        centesimos <= centesimos + 1'b1;
                        if (centesimos == 7'd99) begin
                            centesimos <= 7'd0;
                            segundos <= segundos + 1'b1;
                        end
                        if (segundos == 6'd59) begin
                            segundos <= 6'd0;
                            minutos <= minutos + 1'b1;
                        end
                        if (minutos == 6'd59) begin
                            minutos <= 6'd0;
                            horas <= horas + 1'b1;
                        end
                    end
                end
                2'b10: begin // Timer
                    if (timer_ativo) begin
                        centesimos <= centesimos + 1'b1;
                        if (centesimos == 7'd99) begin
                            centesimos <= 7'd0;
                            segundos <= segundos + 1'b1;
                        end
                        if (segundos == 6'd59) begin
                            segundos <= 6'd0;
                            minutos <= minutos + 1'b1;
                        end
                        if (minutos == 6'd59) begin
                            minutos <= 6'd0;
                            horas <= horas + 1'b1;
                        end
                    end
                end
            endcase
        end
    end

	
	logic [6:0] hex7_temp, hex6_temp, hex5_temp, hex4_temp, hex3_temp, hex2_temp, hex1_temp, hex0_temp;
    // conversao display
    function logic [6:0] to_7seg(input logic [3:0] valor);
        case (valor)
            4'h0: return 7'b1000000;
            4'h1: return 7'b1111001;
            4'h2: return 7'b0100100;
            4'h3: return 7'b0110000;
            4'h4: return 7'b0011001;
            4'h5: return 7'b0010010;
            4'h6: return 7'b0000010;
            4'h7: return 7'b1111000;
            4'h8: return 7'b0000000;
            4'h9: return 7'b0010000;
            default: return 7'b1111111;
        endcase
    endfunction

    always_comb begin
        case (modo)
            2'b00: begin //relogio
                hex7_temp = to_7seg(horas / 10);
                hex6_temp = to_7seg(horas % 10);
                hex5_temp = to_7seg(minutos / 10);
                hex4_temp = to_7seg(minutos % 10);
                hex3_temp = to_7seg(segundos / 10);
                hex2_temp = to_7seg(segundos % 10);
                hex1_temp = to_7seg(centesimos / 10);
                hex0_temp = to_7seg(centesimos % 10);
            end
            2'b01: begin // cronometro
                hex7_temp = 7'b1111111;
                hex6_temp = 7'b1111111;
                hex5_temp = to_7seg(minutos / 10);
                hex4_temp = to_7seg(minutos % 10);
                hex3_temp = to_7seg(segundos / 10);
                hex2_temp = to_7seg(segundos % 10);
                hex1_temp = to_7seg(centesimos / 10);
                hex0_temp = to_7seg(centesimos % 10);
            end
            2'b10: begin // Timer
                hex7_temp = to_7seg(horas / 10);
                hex6_temp = to_7seg(horas % 10);
                hex5_temp = to_7seg(minutos / 10);
                hex4_temp = to_7seg(minutos % 10);
                hex3_temp = to_7seg(segundos / 10);
                hex2_temp = to_7seg(segundos % 10);
                hex1_temp = 7'b1111111;
                hex0_temp = 7'b1111111;
            end
            default: begin
                hex7_temp = 7'b1111111;
                hex6_temp = 7'b1111111;
                hex5_temp = 7'b1111111;
                hex4_temp = 7'b1111111;
                hex3_temp = 7'b1111111;
                hex2_temp = 7'b1111111;
                hex1_temp = 7'b1111111;
                hex0_temp = 7'b1111111;
            end
        endcase
    end

    // Logica para piscar os displays durante o ajuste
    logic [22:0] blink_counter;
    logic blink_state;

    always_ff @(posedge clk) begin
        if (blink_counter == 23'd5000000) begin
            blink_counter <= 23'd0;
            blink_state <= ~blink_state;
        end else begin
            blink_counter <= blink_counter + 1;
        end
    end

    always_comb begin
        HEX7 = hex7_temp;
        HEX6 = hex6_temp;
        HEX5 = hex5_temp;
        HEX4 = hex4_temp;
        HEX3 = hex3_temp;
        HEX2 = hex2_temp;
        HEX1 = hex1_temp;
        HEX0 = hex0_temp;

        if (ajuste) begin
            case (modo)
                2'b00: begin // Ajuste do relÃƒÂ³gio
                    if (horas == 6'd0 && minutos == 6'd0 && segundos == 6'd0) begin
                        HEX7 = blink_state ? hex7_temp : 7'b1111111;
                        HEX6 = blink_state ? hex6_temp : 7'b1111111;
                    end else if (minutos == 6'd0 && segundos == 6'd0) begin
                        HEX5 = blink_state ? hex5_temp : 7'b1111111;
                        HEX4 = blink_state ? hex4_temp : 7'b1111111;
                    end else begin
                        HEX3 = blink_state ? hex3_temp : 7'b1111111;
                        HEX2 = blink_state ? hex2_temp : 7'b1111111;
                    end
                end
                2'b10: begin // Ajuste do timer
                    if (horas == 6'd23 && minutos == 6'd59 && segundos == 6'd59) begin
                        HEX7 = blink_state ? hex7_temp : 7'b1111111;
                        HEX6 = blink_state ? hex6_temp : 7'b1111111;
                    end else if (minutos == 6'd59 && segundos == 6'd59) begin
                        HEX5 = blink_state ? hex5_temp : 7'b1111111;
                        HEX4 = blink_state ? hex4_temp : 7'b1111111;
                    end else begin
                        HEX3 = blink_state ? hex3_temp : 7'b1111111;
                        HEX2 = blink_state ? hex2_temp : 7'b1111111;
                    end
                end
            endcase
        end
    end

endmodule
