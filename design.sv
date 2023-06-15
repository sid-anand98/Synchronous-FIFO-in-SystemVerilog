`include "parameters.sv"

module fifo(data_in, wr_en, rd_en, data_out, full, empty, clk, rst);
    input [DATA_WIDTH-1:0] data_in;
    input wr_en, rd_en, rst, clk;
    output reg [DATA_WIDTH-1:0] data_out;
    output reg full, empty;

    integer i;
    logic [ADDR_WIDTH:0] rd_ptr;
    logic [ADDR_WIDTH:0] wr_ptr;
    logic [ADDR_BUS_WIDTH:0] wr_loc;
    logic [ADDR_BUS_WIDTH:0] rd_loc;
    logic [7:0]mem[31:0];

    assign wr_loc = wr_ptr[ADDR_BUS_WIDTH:0];
    assign rd_loc = rd_ptr[ADDR_BUS_WIDTH:0];

    always @(rd_ptr or wr_ptr) begin
        empty <= 1'b0;
        full <= 1'b0;

        if (rd_ptr[4:0] == wr_ptr[4:0]) begin
            if (rd_ptr[5] == wr_ptr[5]) begin
                empty <= 1'b1;
            end
            else begin
                full <= 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            for (i = 0; i <= 31; i = i + 1)
                mem[i] <= 8'dx;
            wr_ptr <= 0;
        end
        else if (wr_en && !full) begin
            mem[wr_loc] <= data_in;
            wr_ptr <= wr_ptr +1;
        end
        else wr_ptr <= wr_ptr;
    end

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 8'dx;
            rd_ptr <= 1'b0;
        end
        else if (rd_en && !empty) begin
            data_out <= mem[rd_loc];
            rd_ptr <= rd_ptr + 1;
        end
        else begin
            data_out <= 8'dx;
            rd_ptr <= rd_ptr;
        end
    end
endmodule
