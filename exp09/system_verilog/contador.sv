module contador(
    input clk,
    input reset,
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 4'b0000;
    else if (count == 4'b1001) // Conta até 9
        count <= 4'b0000;
    else
        count <= count + 1;
end

endmodule