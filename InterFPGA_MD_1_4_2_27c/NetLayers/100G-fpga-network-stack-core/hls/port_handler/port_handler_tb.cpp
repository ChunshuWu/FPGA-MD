/************************************************
BSD 3-Clause License

Copyright (c) 2019, HPCN Group, UAM Spain (hpcn-uam.es)
All rights reserved.


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

************************************************/


#include "port_handler.hpp"
#include <map>
#include <string>
#include "../TOE/testbench/pcap2stream.hpp"


int main(int argc, char **argv) {

    stream<axiWord>         inputStream("inputStream");
    stream<axiWordOut>      outputStream("outputStream");
    ap_uint<16>             portRangeMin = 5030;
    ap_uint<16>             portRangeMax = 5064;
    axiWordOut              currWord;

    if (argc < 2) {
        cerr << "[ERROR] missing arguments " __FILE__  << " <INPUT_PCAP_FILE>" << endl;;
        return -1;
    }
    char  *input_file;
    input_file  = argv[1];

    pcap2stream(input_file, 0, inputStream);    // Fill the inputStream with the packets in the pcap file

    while (!inputStream.empty()){
        port_handler(
                inputStream,
                outputStream,
                portRangeMin,
                portRangeMax);
    }


    unsigned int packetCounter = 0;
    while(!outputStream.empty()){
        outputStream.read(currWord);
        //cout << "Packet [" << setw(5)  << dec << packetCounter << "] dest " << currWord.dest << endl;
        if (currWord.last)
            packetCounter++;
    }

    return 0;

}
