module load_to_use
(
	input pipe3_load_op,
	input pipe4_load_op,
	input [4:0] pipe3_dest,
	input [4:0] pipe4_dest,
	input [4:0] pipe2_read_dest1,
	input [4:0] pipe2_read_dest2,
	input pipe2_use_reg_op,
	output not_ready_to_go
);

assign not_ready_to_go = pipe3_load_op & pipe2_use_reg_op & (pipe3_dest==pipe2_read_dest1 || pipe3_dest==pipe2_read_dest2)
                       | pipe4_load_op & pipe2_use_reg_op & (pipe4_dest==pipe2_read_dest1 || pipe4_dest==pipe2_read_dest2);

endmodule
