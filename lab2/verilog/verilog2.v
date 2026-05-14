module lab2 (
    input  [6:0] A,
    output Z,
    output E,
    output G,
    output L,
    output I,
    output [3:0] O
);

    wire [2:0] sel = A[6:4];
    wire [1:0] X = A[3:2];
    wire [1:0] Y = A[1:0];
    wire [3:0] W = A[3:0];

    reg        rZ, rE, rG, rL, rI;
    reg  [3:0] rO;

    assign Z = rZ;
    assign E = rE;
    assign G = rG;
    assign L = rL;
    assign I = rI;
    assign O = rO;

    wire signed [1:0] sX = X;
    wire signed [1:0] sY = Y;

    always @(*) begin
        rZ = 1'b0;
        rE = 1'b0;
        rG = 1'b0;
        rL = 1'b0;
        rI = 1'b0;
        rO = 4'b0000;

        case (sel)

            3'b000: begin
                {rO[2], rO[1], rO[0]} = X + Y;
                rO[3] = 1'b0;
                rZ    = ({rO[2], rO[1], rO[0]} == 3'b000);
            end

            3'b001: begin
                rE = (X == Y);
                rG = (X >  Y);
                rL = (X <  Y);
            end

            3'b010: begin
                rO = W + 4'b0001;
                rZ = (rO == 4'b0000);
                rI = (W == 4'b1111);
            end

            3'b011: begin
                rO[3] = 1'b0;
                rO[2] = 1'b0;
                rO[1] = ~(A[3] ^ A[1]);
                rO[0] = ~(A[2] ^ A[0]);
                rZ    = (~rO[1] & ~rO[0]);
            end

            3'b100: begin
                rZ = (W == 4'b0000);
                if      (W <= 4'd3)  rO = 4'b0001;
                else if (W <= 4'd7)  rO = 4'b0010;
                else if (W <= 4'd11) rO = 4'b0100;
                else                 rO = 4'b1000;
            end

            3'b101: begin
                rO = X * Y;
                rZ = (rO == 4'b0000);
            end

            3'b110: begin
                rE = (sX == sY);
                rG = (sX >  sY);
                rL = (sX <  sY);
            end

            3'b111: begin
                rO[3] = W[3];
                rO[2] = W[3] ^ W[2];
                rO[1] = W[2] ^ W[1];
                rO[0] = W[1] ^ W[0];
            end

            default: begin
                rZ = 1'b0; rE = 1'b0; rG = 1'b0;
                rL = 1'b0; rI = 1'b0; rO = 4'b0000;
            end

        endcase
    end

endmodule