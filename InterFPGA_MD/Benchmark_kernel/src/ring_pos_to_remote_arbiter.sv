// modified from https://www.edaplayground.com/x/2TzD
import MD_pkg::*;

module ring_pos_to_remote_arbiter
(
    input clk,
    input rst,
    input i_arbiter_en, 
    input[NUM_REMOTE_DEST_NODES-1:0] i_request,
    
    output logic[NUM_REMOTE_DEST_NODES-1:0]  o_grant
);
  	
    logic[NUM_REMOTE_DEST_NODES-1:0] priority_oh_nxt;
    logic[NUM_REMOTE_DEST_NODES-1:0] priority_oh;

always_comb begin
    for (int grant_idx = 0; grant_idx < NUM_REMOTE_DEST_NODES; grant_idx++) begin
        o_grant[grant_idx] = 0;
        for (int priority_idx = 0; priority_idx < NUM_REMOTE_DEST_NODES; priority_idx++) begin
            logic is_granted;
            is_granted = i_request[grant_idx] & priority_oh[priority_idx];
          
            for (logic[REMOTE_NODE_IDX_WIDTH - 1:0] bit_idx = priority_idx[REMOTE_NODE_IDX_WIDTH - 1:0];
                bit_idx != grant_idx[REMOTE_NODE_IDX_WIDTH - 1:0]; bit_idx++) begin
                if (bit_idx < NUM_REMOTE_DEST_NODES) begin
                    is_granted &= !i_request[bit_idx];
                end
            end
            o_grant[grant_idx] |= is_granted;
        end
        o_grant[grant_idx] &= i_arbiter_en;
    end
end

    // rotate left
    assign priority_oh_nxt = {o_grant[NUM_REMOTE_DEST_NODES-2:0], o_grant[NUM_REMOTE_DEST_NODES-1]};

always_ff @(posedge clk) begin
    if (rst)
        priority_oh <= 1;
    else if (i_request != 0 && i_arbiter_en) begin
        priority_oh <= priority_oh_nxt;
    end
end
endmodule