#ifndef DYNAWO_RECEIVER_H
#define DYNAWO_RECEIVER_H

#include <string>
#include <vector>
#include <zmqpp/zmqpp.hpp>

class DynawoReceiver {
    public:
        DynawoReceiver(int port, const std::string& topic);

        std::string receive_string();

        std::vector<double> receive_bytes();
    private:
        zmqpp::context context_;
        zmqpp::socket socket_;
        zmqpp::poller poller_;
        std::string topic_;
};

#endif // DYNAWO_RECEIVER_H
