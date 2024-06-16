`timescale 1ns / 1ps

//`include "constants.v"
//`include "counter.v"

module dcache_controller(// pipeline inputs
                        input clock,
                        input reset,
                        input ren, wen,
                        input [-1:0] addr,
                        input [-1:0] byteSelectVector,
                        input [-1:0] din,
                        
                        // cache inputs
                        input cacheHit,
                        input cacheDirtyBit,
                        input [-1:0] cacheDout,
                        
                        // memory inputs
                        input memReadReady, memWriteDone,
                        input [-1:0] memDout,
                        
                        // pipeline outputs
                        output stall,
                        output [-1:0] dout,

                        // cache outputs
                        output cacheEn, cacheWen, cacheMemWen,
                        output [-1:0] cacheBytesAccess,
                        output [-1:0] cacheBlockAddr,
                        output [-1:0] cacheDin,
                        
                        // memory outputs
                        output memRen, memWen,
                        output [-1:0] memBlockAddr,
                        output [-1:0] memDin);

  			   
wire cpu_req;

assign cpu_req = ren || wen;




//-----------------------FSM----------------------------------------//

parameter IDLE = 3'b000,
          MISS = 3'b001,
          MEMREAD = 3'b010,
          WRITEBACK = 3'b011,
          MEMCACHE = 3'b100;


reg [2:0 ]state, next_state;
//SEQUENTIAL LOGIC

always @(posedge clock or negedge reset)
begin
	if (reset == 1'b0) begin
        state <= IDLE;
	end
	else begin
        state <= next_state;
    end
    current_state <= next_state; // Update current_state output
end

//COMBINATIONAL LOGIC
always @(state, cpu_req, cacheHit, cacheDirtyBit, memWriteDone, memReadReady)
begin
	case (state)
	IDLE: begin
		if(cpu_req && !cacheHit) begin
            next_state = MISS;
        end
        else begin 
            next_state = IDLE;
        end
	end
	MISS: begin
        if(cacheDirtyBit == 1'b1) begin
            next_state = WRITEBACK;
        end
        else begin
        next_state = MEMREAD;
        end
	end
	MEMREAD: begin
        if(memReadReady==1) begin
            next_state = MEMCACHE;
        end
        else begin
        next_state = MEMREAD;
        end
	end
	WRITEBACK: begin
        if(memWriteDone==1) begin
            next_state = MEMREAD;
        end
        else begin
        next_state = WRITEBACK;
        end
	end
	MEMCACHE: begin
        next_state = IDLE;
	end
    default: next_state = IDLE;
    endcase
end

	
//COMBINATIONAL LOGIC FOR OUTPUTS

always @(state,cpu_req, cacheHit, cacheDirtyBit, memWriteDone, memReadReady)
begin
    stall = 1'b0;
    cacheEn = 1'b0;
    cacheWen = 1'b0; 
    cacheFullblockWen = 1'b0;
    memRen = 1'b0;
    memWen = 1'b0;
	case (state)
	MISS: begin
       stall = 1'b1;
	end
	MEMREAD: begin
        stall = 1'b1;
        memRen = 1'b1;
	end
	WRITEBACK: begin
       stall = 1'b1;
       memWen = 1'b1;
	end
	MEMCACHE: begin
       stall = 1'b1;
       cacheEn = 1'b1;
       cacheWen = 1'b1; 
       cacheFullblockWen = 1'b1;
	end
    endcase
end

                        
endmodule