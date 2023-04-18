/************************************************
Copyright (c) 2018, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software 
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.// Copyright (c) 2018 Xilinx, Inc.
************************************************/
#include "rx_sar_table.hpp"

using namespace hls;

/** @ingroup rx_sar_table
 * 	This data structure stores the RX(receiving) sliding window
 *  and handles concurrent access from the @ref rx_engine, @ref rx_app_if
 *  and @ref tx_engine
 *  @param[in]		rxEng2rxSar_upd_req
 *  @param[in]		rxApp2rxSar_upd_req
 *  @param[in]		txEng2rxSar_upd_req
 *  @param[out]		rxSar2rxEng_upd_rsp
 *  @param[out]		rxSar2rxApp_upd_rsp
 *  @param[out]		rxSar2txEng_upd_rsp
 */
void rx_sar_table(	stream<rxSarRecvd>&			rxEng2rxSar_upd_req,
					stream<rxSarAppd>&			rxApp2rxSar_upd_req,
					stream<ap_uint<16> >&		txEng2rxSar_req, 		//read only
					stream<rxSarEntry>&			rxSar2rxEng_upd_rsp,
					stream<rxSarAppd>&			rxSar2rxApp_upd_rsp,
					stream<rxSarEntry_rsp>&		rxSar2txEng_rsp)
{

	static rxSarEntry rx_table[MAX_SESSIONS];
	ap_uint<16> 			addr;
	rxSarRecvd 				in_recvd;
	rxSarAppd 				in_appd;
	rxSarEntry 				tmp_entry;
	rxSarEntry_rsp 			response2_metaloader;
	ap_uint<WINDOW_BITS> 	real_window_size;

#pragma HLS PIPELINE II=1

#pragma HLS RESOURCE variable=rx_table core=RAM_2P_BRAM
#pragma HLS DEPENDENCE variable=rx_table inter false

	// Read only access from the Tx Engine
	if(!txEng2rxSar_req.empty()) {
		txEng2rxSar_req.read(addr);
		tmp_entry = rx_table[addr];

		response2_metaloader.recvd 			= tmp_entry.recvd;
		// Copmpute windows size This works even for wrap around. The window scale is taken into account
		real_window_size = (tmp_entry.appd - tmp_entry.recvd(WINDOW_BITS-1,0)) - 1;
#if (WINDOW_SCALE)		
		response2_metaloader.windowSize  = real_window_size >> tmp_entry.rx_win_shift;
		response2_metaloader.rx_win_shift = tmp_entry.rx_win_shift;
#else
		response2_metaloader.windowSize  = real_window_size;
//		response2_metaloader.rx_win_shift = real_window_size;
#endif 		

		rxSar2txEng_rsp.write(response2_metaloader);
	}
	// Read or Write access from the Rx App I/F to update the application pointer
	else if(!rxApp2rxSar_upd_req.empty()) {
		rxApp2rxSar_upd_req.read(in_appd);
		if(in_appd.write) {
			rx_table[in_appd.sessionID].appd = in_appd.appd;
		}
		else {
			rxSar2rxApp_upd_rsp.write(rxSarAppd(in_appd.sessionID, rx_table[in_appd.sessionID].appd));
		}
	}
	// Read or Write access from the Rx Engine
	else if(!rxEng2rxSar_upd_req.empty()) {
		rxEng2rxSar_upd_req.read(in_recvd);
		if (in_recvd.write) {

			rx_table[in_recvd.sessionID].recvd = in_recvd.recvd;
			if (in_recvd.init) {
#if (WINDOW_SCALE)				
				rx_table[in_recvd.sessionID].rx_win_shift = in_recvd.rx_win_shift;
#endif				
				rx_table[in_recvd.sessionID].appd = in_recvd.recvd;
			}
		}
		else {
			rxSar2rxEng_upd_rsp.write(rx_table[in_recvd.sessionID]);
		}
	}
}
