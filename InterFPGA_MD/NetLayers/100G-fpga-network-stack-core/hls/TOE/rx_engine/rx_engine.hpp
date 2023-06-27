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

#ifndef _RX_ENGINE_H_
#define _RX_ENGINE_H_

#include "../toe.hpp"
#include "../memory_access/memory_access.hpp"

using namespace hls;

/** @ingroup rx_engine
 *  @TODO check if same as in Tx engine
 */
struct rxEng_TCP_MetaData
{
	ap_uint<32> 			seqNumb;
	ap_uint<32> 			ackNumb;
	ap_uint<16> 			winSize;
#if (WINDOW_SCALE)
	ap_uint<4>				recv_window_scale;
#endif
	ap_uint<16> 			length;
	ap_uint<1>				cwr;
	ap_uint<1>				ecn;
	ap_uint<1>				urg;
	ap_uint<1>				ack;
	ap_uint<1>				psh;
	ap_uint<1>				rst;
	ap_uint<1>				syn;
	ap_uint<1>				fin;
};

struct rxEngPktMetaInfo
{	
	rxEng_TCP_MetaData 	digest;
	fourTuple 			tuple;
#if WINDOW_SCALE
	ap_uint<256> 			tcpOptions;
	ap_uint<  4> 			tcpOffset;
#endif	
};


/** @ingroup rx_engine
 *
 */
struct rxFsmMetaData
{
	ap_uint<16>			sessionID;
	ap_uint<32>			srcIpAddress;
	ap_uint<16>			dstIpPort;
	rxEng_TCP_MetaData	meta; //check if all needed
	rxFsmMetaData() {}
	rxFsmMetaData(ap_uint<16> id, ap_uint<32> ipAddr, ap_uint<16> ipPort, rxEng_TCP_MetaData meta)
				:sessionID(id), srcIpAddress(ipAddr), dstIpPort(ipPort), meta(meta) {}
};

/** @defgroup rx_engine RX Engine
 *  @ingroup tcp_module
 *  RX Engine
 */
void rx_engine(	stream<axiWord>&					ipRxData,
				stream<sessionLookupReply>&			sLookup2rxEng_rsp,
				stream<sessionState>&				stateTable2rxEng_upd_rsp,
				stream<bool>&						portTable2rxEng_rsp,
				stream<rxSarEntry>&					rxSar2rxEng_upd_rsp,
				stream<rxTxSarReply>&				txSar2rxEng_upd_rsp,
#if (!RX_DDR_BYPASS)
				stream<mmStatus>&					rxBufferWriteStatus,
				stream<mmCmd>&						rxBufferWriteCmd,
#endif
				stream<axiWord>&					rxBufferWriteData,
				stream<sessionLookupQuery>&			rxEng2sLookup_req,
				stream<stateQuery>&					rxEng2stateTable_upd_req,
				stream<ap_uint<16> >&				rxEng2portTable_req,
				stream<rxSarRecvd>&					rxEng2rxSar_upd_req,
				stream<rxTxSarQuery>&				rxEng2txSar_upd_req,
				stream<rxRetransmitTimerUpdate>&	rxEng2timer_clearRetransmitTimer,
				stream<ap_uint<16> >&				rxEng2timer_clearProbeTimer,
				stream<ap_uint<16> >&				rxEng2timer_setCloseTimer,
				stream<openStatus>&					openConStatusOut,
				stream<extendedEvent>&				rxEng2eventEng_setEvent,
				stream<appNotification>&			rxEng2rxApp_notification,
				stream<txApp_client_status>& 		rxEng2txApp_client_notification,
#if (STATISTICS_MODULE)
				stream<rxStatsUpdate>&  			rxEngStatsUpdate,
#endif						
				stream<axiWord>&					rxEng_pseudo_packet_to_checksum,
				stream<ap_uint<16> >&				rxEng_pseudo_packet_res_checksum);


#endif
